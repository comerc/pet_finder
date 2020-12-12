import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:graphql/client.dart';
import 'package:pet_finder/import.dart';

const _kEnableWebsockets = true;

typedef CreateServiceCallback = GraphQLService Function();

class DatabaseRepository {
  DatabaseRepository({
    CreateServiceCallback createService,
  }) : _createService = createService ?? _createDefaultService;

  static CreateServiceCallback get _createDefaultService {
    return () {
      return GraphQLService(
        client: _createClient(),
        timeout: kGraphQLTimeoutDuration,
        fragments: API.fragments,
      );
    };
  }

  GraphQLService _service;
  final CreateServiceCallback _createService;

  void initializeService() {
    _service = _createService();
  }

  StreamController<UnitModel> _fetchNewestUnitNotificationController;

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

  // TODO: реализовать fetchNewUnitNotification через subscription
  Stream<String> get fetchNewUnitNotification {
    return _service.subscribe<String>(
      document: API.fetchNewUnitNotification,
      // variables: {},
      // extensions: null,
      // operationName: 'FetchNewUnitNotification',
      toRoot: (dynamic rawJson) {
        return (rawJson == null)
            ? null
            : (rawJson['units'] == null)
                ? null
                : (rawJson['units'] == [])
                    ? null
                    : rawJson['units'][0];
      },
      convert: (Map<String, dynamic> json) => json['id'] as String,
    );
  }

  Future<MemberModel> upsertMember(MemberData data) {
    final result = _service.mutate<MemberModel>(
      document: API.upsertMember,
      variables: data.toJson(),
      root: 'insert_member_one',
      convert: MemberModel.fromJson,
    );
    return result;
  }

  Future<WishModel> upsertWish(WishData data) {
    return _service.mutate<WishModel>(
      document: API.upsertWish,
      variables: data.toJson(),
      root: 'insert_wish_one',
      convert: WishModel.fromJson,
    );
  }

  Future<List<WishModel>> readWishes() {
    return _service.query<WishModel>(
      document: API.readWishes,
      // variables: {},
      root: 'wishes',
      convert: WishModel.fromJson,
    );
  }

  Future<List<UnitModel>> readUnits(
      {String categoryId, String query, @required int limit}) {
    assert(categoryId != null || query != null);
    assert(limit != null);
    return _service.query<UnitModel>(
      document:
          (query == null) ? API.readUnitsByCategory : API.readUnitsByQuery,
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
    return _service.query<UnitModel>(
      document: API.readNewestUnits,
      variables: {
        'limit': limit,
      },
      root: 'units',
      convert: UnitModel.fromJson,
    );
  }

  Future<List<CategoryModel>> readCategories() {
    return _service.query<CategoryModel>(
      document: API.readCategories,
      // variables: {},
      root: 'categories',
      convert: CategoryModel.fromJson,
    );
  }

  Future<UnitModel> createUnit(UnitData data) async {
    final result = await _service.mutate<UnitModel>(
      document: API.createUnit,
      variables: data.toJson(),
      root: 'insert_unit_one',
      convert: UnitModel.fromJson,
    );
    _fetchNewestUnitNotificationController.add(result);
    return result;
  }
}

GraphQLClient _createClient() {
  final httpLink = HttpLink(
    'https://$kGraphQLEndpoint',
  );
  final authLink = AuthLink(
    getToken: () async {
      final idToken = await FirebaseAuth.instance.currentUser.getIdToken(true);
      return 'Bearer $idToken';
    },
  );
  var link = authLink.concat(httpLink);
  if (_kEnableWebsockets) {
    final websocketLink = WebSocketLink(
      'wss://$kGraphQLEndpoint',
      config: SocketClientConfig(
        initialPayload: () async {
          final idToken =
              await FirebaseAuth.instance.currentUser.getIdToken(true);
          return {
            'headers': {'Authorization': 'Bearer $idToken'},
          };
        },
      ),
    );
    // split request based on type
    link = Link.split(
      (request) => request.isSubscription,
      websocketLink,
      link,
    );
  }
  return GraphQLClient(
    cache: GraphQLCache(),
    link: link,
  );
}

mixin API {
  static final fetchNewUnitNotification = gql(r'''
    subscription FetchNewUnitNotification {
      units(
        order_by: {created_at: desc},
        limit: 1
      ) {
        id
      }
    }
  ''');

  static final upsertMember = gql(r'''
    mutation UpsertMember($display_name: String $image_url: String) {
      insert_member_one(object: {display_name: $display_name, image_url: $image_url}, 
      on_conflict: {constraint: member_pkey, update_columns: [display_name, image_url]}) {
        ...MemberFields          
      }
    }
  ''');

  static final upsertWish = gql(r'''
    mutation UpsertWish($unit_id: uuid!, $value: Boolean!) {
      insert_wish_one(object: {unit_id: $unit_id, value: $value},
      on_conflict: {constraint: wish_pkey, update_columns: [value]}) {
        unit {
          ...UnitFields
        }
      }
    }
  ''');

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
  ''');

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
  ''');

  static final readNewestUnits = gql(r'''
    query ReadNewestUnits($limit: Int!) {
      units(
        order_by: {updated_at: desc},
        limit: $limit
      ) {
        ...UnitFields
      }
    }
  ''');

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
  ''');

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
  ''');

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
  ''');

  static final fragments = gql(r'''
    fragment BreedFields on breed {
      id
      name
    }

    fragment MemberFields on member {
      id
      display_name
      image_url
    }

    fragment UnitFields on unit {
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
