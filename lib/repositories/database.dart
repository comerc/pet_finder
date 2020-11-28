import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gql/ast.dart';
import 'package:graphql/client.dart';
import 'package:pet_finder/import.dart';

const _kEnableWebsockets = false;

// TODO: добавить сервисный слой, где абстрагировать query & mutation & subscription

class DatabaseRepository {
  DatabaseRepository({
    GraphQLClient client,
  }) : _client = client ?? _getClient();

  final GraphQLClient _client;
  StreamController<UnitModel> _fetchNewestUnitNotificationController;

  // TODO: реализовать fetchNewUnitNotification через subscription

  // Stream<String> get fetchNewUnitNotification {
  //   final operation = Operation(
  //     documentNode: _API.fetchNewUnitNotification,
  //     // variables: {},
  //     // extensions: null,
  //     // operationName: 'FetchNewTodoNotification',
  //   );
  //   return _client.subscribe(operation).map((FetchResult fetchResult) {
  //     return fetchResult.data['units'][0]['id'] as String;
  //   });
  // }

  Stream<UnitModel> get fetchNewestUnitNotification {
    if (_fetchNewestUnitNotificationController == null) {
      _fetchNewestUnitNotificationController = StreamController<UnitModel>();
      _fetchNewestUnitNotificationController.onCancel = () async {
        try {
          // ignore: unawaited_futures
          _fetchNewestUnitNotificationController.close();
        } finally {
          _fetchNewestUnitNotificationController = null;
        }
      };
    }
    return _fetchNewestUnitNotificationController.stream;
  }

  Future<MemberModel> upsertMember(MemberData data) {
    return _mutate<MemberModel>(
      documentNode: _API.upsertMember,
      variables: data.toJson(),
      root: 'insert_member_one',
      convert: MemberModel.fromJson,
    );
  }

  Future<WishModel> upsertWish(WishData data) {
    return _mutate<WishModel>(
      documentNode: _API.upsertWish,
      variables: data.toJson(),
      root: 'insert_wish_one',
      convert: WishModel.fromJson,
    );
  }

  Future<List<WishModel>> readWishes() {
    return _query<WishModel>(
      documentNode: _API.readWishes,
      // variables: {},
      root: 'wishes',
      convert: WishModel.fromJson,
    );
  }

  Future<List<UnitModel>> readUnits(
      {String categoryId, String query, @required int limit}) {
    assert(categoryId != null || query != null);
    assert(limit != null);
    return _query<UnitModel>(
      documentNode:
          (query == null) ? _API.readUnitsByCategory : _API.readUnitsByQuery,
      variables: {
        if (categoryId != null) 'category_id': categoryId,
        if (query != null) 'query': '%$query%',
        'limit': limit,
      },
      root: 'units',
      convert: UnitModel.fromJson,
    );
  }

  Future<List<UnitModel>> readNewestUnits({@required int limit}) {
    assert(limit != null);
    return _query<UnitModel>(
      documentNode: _API.readNewestUnits,
      variables: {
        'limit': limit,
      },
      root: 'units',
      convert: UnitModel.fromJson,
    );
  }

  Future<List<CategoryModel>> readCategories() {
    return _query<CategoryModel>(
      documentNode: _API.readCategories,
      // variables: {},
      root: 'categories',
      convert: CategoryModel.fromJson,
    );
  }

  Future<UnitModel> createUnit(UnitData data) async {
    final result = await _mutate<UnitModel>(
      documentNode: _API.createUnit,
      variables: data.toJson(),
      root: 'insert_unit_one',
      convert: UnitModel.fromJson,
    );
    _fetchNewestUnitNotificationController.add(result);
    return result;
  }

  Future<List<T>> _query<T>({
    DocumentNode documentNode,
    Map<String, dynamic> variables,
    String root,
    T Function(Map<String, dynamic> json) convert,
  }) async {
    final options = QueryOptions(
      documentNode: documentNode,
      variables: variables,
      fetchPolicy: FetchPolicy.noCache,
      errorPolicy: ErrorPolicy.all,
    );
    final queryResult =
        await _client.query(options).timeout(kGraphQLTimeoutDuration);
    if (queryResult.hasException) {
      throw queryResult.exception;
    }
    final dataItems =
        (queryResult.data[root] as List).cast<Map<String, dynamic>>();
    final items = <T>[];
    for (final dataItem in dataItems) {
      items.add(convert(dataItem));
    }
    return items;
  }

  Future<T> _mutate<T>({
    DocumentNode documentNode,
    Map<String, dynamic> variables,
    String root,
    T Function(Map<String, dynamic> json) convert,
  }) async {
    final options = MutationOptions(
      documentNode: documentNode,
      variables: variables,
      fetchPolicy: FetchPolicy.noCache,
      errorPolicy: ErrorPolicy.all,
    );
    final mutationResult =
        await _client.mutate(options).timeout(kGraphQLTimeoutDuration);
    if (mutationResult.hasException) {
      throw mutationResult.exception;
    }
    final dataItem = mutationResult.data[root] as Map<String, dynamic>;
    return convert(dataItem);
  }
}

GraphQLClient _getClient() {
  final httpLink = HttpLink(
    uri: 'https://$kGraphQLEndpoint',
  );
  final authLink = AuthLink(
    getToken: () async {
      // TODO: протухает ли токен?
      final idToken = await FirebaseAuth.instance.currentUser.getIdToken(true);
      return 'Bearer $idToken';
    },
  );
  var link = authLink.concat(httpLink);
  // TODO: не работает subscription
  if (_kEnableWebsockets) {
    final websocketLink = WebSocketLink(
      url: 'wss://$kGraphQLEndpoint',
      config: SocketClientConfig(
        inactivityTimeout: Duration(seconds: 15),
        initPayload: () async {
          // TODO: не происходит реинициализация websocket после logout-login
          // может помочь костыль: выход из приложения
          out('**** initPayload');
          final idTokenResult =
              await FirebaseAuth.instance.currentUser.getIdTokenResult(true);
          out(idTokenResult);
          return {
            'headers': {
              'Authorization': 'Bearer ${idTokenResult.token}'
            }, // TODO: headers
          };
        },
      ),
    );
    link = link.concat(websocketLink);
  }
  return GraphQLClient(
    cache: InMemoryCache(),
    link: link,
  );
}

mixin _API {
  // static final fetchNewUnitNotification = gql(r'''
  //   subscription FetchNewUnitNotification {
  //     units(
  //       order_by: {created_at: desc},
  //       limit: 1
  //     ) {
  //       id
  //     }
  //   }
  // ''');

  static final upsertMember = gql(r'''
    mutation UpsertMember($display_name: String $image_url: String) {
      insert_member_one(object: {display_name: $display_name, image_url: $image_url}, 
      on_conflict: {constraint: member_pkey, update_columns: [display_name, image_url]}) {
        ...MemberFields          
      }
    }
  ''')..definitions.addAll(fragments.definitions);

  static final upsertWish = gql(r'''
    mutation UpsertWish($unit_id: uuid!, $value: Boolean!) {
      insert_wish_one(object: {unit_id: $unit_id, value: $value},
      on_conflict: {constraint: wish_pkey, update_columns: [value]}) {
        unit {
          ...UnitFields
        }
      }
    }
  ''')..definitions.addAll(fragments.definitions);

  static final readWishes = gql(r'''
    query ReadWishes() {
      wishes(
        order_by: {updated_at: desc}
      ) {
        unit {
          ...UnitFields
        }
      }
    }
  ''')..definitions.addAll(fragments.definitions);

  static final createUnit = gql(r'''
    mutation CreateUnit(
      $breed_id: uuid!, 
      $color: String!, 
      $weight: Int!,
      $story: String!,
      $image_url: String!, 
      $condition: condition_enum!, 
      $birthday: date!,
      $address: String!,
    ) {
      insert_unit_one(object: {
        breed_id: $breed_id, 
        color: $color, 
        weight: $weight, 
        story: $story,
        image_url: $image_url, 
        condition: $condition, 
        birthday: $birthday,
        address: $address,
      }) {
        ...UnitFields
      }
    }
  ''')..definitions.addAll(fragments.definitions);

  static final readNewestUnits = gql(r'''
    query ReadNewestUnits($limit: Int!) {
      units(
        order_by: {updated_at: desc},
        limit: $limit
      ) {
        ...UnitFields
      }
    }
  ''')..definitions.addAll(fragments.definitions);

  static final readUnitsByCategory = gql(r'''
    query ReadUnitsByCategory($category_id: String!, $limit: Int!) {
      units(
        where: 
          {breed: {category_id: {_eq: $category_id}}}, 
        order_by: {updated_at: desc},
        limit: $limit
      ) {
        ...UnitFields
      }
    }
  ''')..definitions.addAll(fragments.definitions);

  static final readUnitsByQuery = gql(r'''
    query ReadUnitsByQuery($query: String!, $category_id: String, $limit: Int!) {
      units(
        where: 
          {_and:
            [
              {_or: 
                [
                  {breed: {name: {_ilike: $query}}}, 
                  {address: {_ilike: $query}},
                ]
              },
              {breed: {category_id: {_eq: $category_id}}},
            ]
          },
        order_by: {updated_at: desc},
        limit: $limit
      ) {
        ...UnitFields
      }
    }
  ''')..definitions.addAll(fragments.definitions);

  static final readCategories = gql(r'''
    query ReadCategories {
      categories(
        order_by: {order_index: asc}
      ) {
        id
        name
        color
        total_of
        breeds(
          order_by: {name: asc}) {
          ...BreedFields
        }
      }
    }
  ''')..definitions.addAll(fragments.definitions);

  static final fragments = gql(r'''
    fragment BreedFields on breed {
      # __typename
      id
      name
    }

    fragment MemberFields on member {
      # __typename
      id
      display_name
      image_url
    }

    fragment UnitFields on unit {
      # __typename
      id
      breed {
        ...BreedFields
      }
      color
      weight
      story
      member {
        ...MemberFields
      }
      image_url
      condition
      birthday
      address
      location
    }
  ''');
}
