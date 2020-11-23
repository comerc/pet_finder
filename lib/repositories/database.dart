import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:graphql/client.dart';
import 'package:pet_finder/import.dart';

const _kEnableWebsockets = true;

class DatabaseRepository {
  DatabaseRepository({
    GraphQLClient client,
  }) : _client = client ?? _getClient();

  final GraphQLClient _client;

  // Stream<String> get fetchNewUnitNotification {
  //   final operation = Operation(
  //     documentNode: _API.fetchNewUnitNotification,
  //     variables: {'member_id': '4aa2c676-c388-4e68-9887-b03dcaa30539'},
  //     // extensions: null,
  //     // operationName: 'FetchNewTodoNotification',
  //   );
  //   return _client.subscribe(operation).map((FetchResult fetchResult) {
  //     return fetchResult.data['units'][0]['id'] as String;
  //   });
  // }

  Future<MemberModel> upsertMember() async {
    final user = FirebaseAuth.instance.currentUser;
    final data = MemberData(
      displayName: user.displayName,
      imageUrl: user.photoURL,
    );
    final options = MutationOptions(
      documentNode: _API.upsertMember,
      variables: data.toJson(),
      fetchPolicy: FetchPolicy.noCache,
      errorPolicy: ErrorPolicy.all,
    );
    final mutationResult =
        await _client.mutate(options).timeout(kGraphQLTimeoutDuration);
    if (mutationResult.hasException) {
      return Future.error(mutationResult.exception);
    }
    final json =
        mutationResult.data['insert_member_one'] as Map<String, dynamic>;
    return MemberModel.fromJson(json);
  }

  Future<WishModel> upsertWish(WishData data) async {
    final options = MutationOptions(
      documentNode: _API.upsertWish,
      variables: data.toJson(),
      fetchPolicy: FetchPolicy.noCache,
      errorPolicy: ErrorPolicy.all,
    );
    final mutationResult =
        await _client.mutate(options).timeout(kGraphQLTimeoutDuration);
    if (mutationResult.hasException) {
      return Future.error(mutationResult.exception);
    }
    final json = mutationResult.data['insert_wish_one'] as Map<String, dynamic>;
    return WishModel.fromJson(json);
  }

  Future<List<WishModel>> readWishes() async {
    final options = QueryOptions(
      documentNode: _API.readWishes,
      // variables: {},
      fetchPolicy: FetchPolicy.noCache,
      errorPolicy: ErrorPolicy.all,
    );
    final queryResult =
        await _client.query(options).timeout(kGraphQLTimeoutDuration);
    if (queryResult.hasException) {
      return Future.error(queryResult.exception);
    }
    final dataItems =
        (queryResult.data['wishes'] as List).cast<Map<String, dynamic>>();
    final items = <WishModel>[];
    for (final dataItem in dataItems) {
      items.add(WishModel.fromJson(dataItem));
    }
    return items;
  }

  Future<List<UnitModel>> readUnits(
      {String categoryId, String query, @required int limit}) async {
    assert(categoryId != null || query != null);
    assert(limit != null);
    final options = QueryOptions(
      documentNode:
          (query == null) ? _API.readUnitsByCategory : _API.readUnitsByQuery,
      variables: {
        if (categoryId != null) 'category_id': categoryId,
        if (query != null) 'query': '%$query%',
        'limit': limit,
      },
      fetchPolicy: FetchPolicy.noCache,
      errorPolicy: ErrorPolicy.all,
    );
    final queryResult =
        await _client.query(options).timeout(kGraphQLTimeoutDuration);
    if (queryResult.hasException) {
      return Future.error(queryResult.exception);
    }
    final dataItems =
        (queryResult.data['units'] as List).cast<Map<String, dynamic>>();
    final items = <UnitModel>[];
    for (final dataItem in dataItems) {
      items.add(UnitModel.fromJson(dataItem));
    }
    return items;
  }

  Future<List<UnitModel>> readNewestUnits({@required int limit}) async {
    assert(limit != null);
    final options = QueryOptions(
      documentNode: _API.readNewestUnits,
      variables: {
        'limit': limit,
      },
      fetchPolicy: FetchPolicy.noCache,
      errorPolicy: ErrorPolicy.all,
    );
    final queryResult =
        await _client.query(options).timeout(kGraphQLTimeoutDuration);
    if (queryResult.hasException) {
      return Future.error(queryResult.exception);
    }
    final dataItems =
        (queryResult.data['units'] as List).cast<Map<String, dynamic>>();
    final items = <UnitModel>[];
    for (final dataItem in dataItems) {
      items.add(UnitModel.fromJson(dataItem));
    }
    return items;
  }

  Future<List<CategoryModel>> readCategories() async {
    final options = QueryOptions(
      documentNode: _API.readCategories,
      // variables: {},
      fetchPolicy: FetchPolicy.noCache,
      errorPolicy: ErrorPolicy.all,
    );
    final queryResult =
        await _client.query(options).timeout(kGraphQLTimeoutDuration);
    if (queryResult.hasException) {
      return Future.error(queryResult.exception);
    }
    final dataItems =
        (queryResult.data['categories'] as List).cast<Map<String, dynamic>>();
    final items = <CategoryModel>[];
    for (final dataItem in dataItems) {
      items.add(CategoryModel.fromJson(dataItem));
    }
    return items;
  }

  // Future<List<BreedModel>> readBreeds({String categoryId}) async {
  //   final options = QueryOptions(
  //     documentNode: _API.readBreeds,
  //     variables: {'category_id': categoryId},
  //     fetchPolicy: FetchPolicy.noCache,
  //     errorPolicy: ErrorPolicy.all,
  //   );
  //   final queryResult =
  //       await _client.query(options).timeout(kGraphQLTimeoutDuration);
  //   if (queryResult.hasException) {
  //     return Future.error(queryResult.exception);
  //   }
  //   final dataItems =
  //       (queryResult.data['breeds'] as List).cast<Map<String, dynamic>>();
  //   final items = <BreedModel>[];
  //   for (final dataItem in dataItems) {
  //     items.add(BreedModel.fromJson(dataItem));
  //   }
  //   return items;
  // }

  Future<UnitModel> createUnit(UnitData data) async {
    // await Future.delayed(Duration(seconds: 4));
    // throw Exception('4321');
    final options = MutationOptions(
      documentNode: _API.createUnit,
      variables: data.toJson(),
      fetchPolicy: FetchPolicy.noCache,
      errorPolicy: ErrorPolicy.all,
    );
    final mutationResult =
        await _client.mutate(options).timeout(kGraphQLTimeoutDuration);
    if (mutationResult.hasException) {
      return Future.error(mutationResult.exception);
    }
    final dataItem =
        mutationResult.data['insert_unit_one'] as Map<String, dynamic>;
    return UnitModel.fromJson(dataItem);
  }
}

GraphQLClient _getClient() {
  final httpLink = HttpLink(
    uri: 'http://cats8.herokuapp.com/v1/graphql',
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
      url: 'ws://cats8.herokuapp.com/v1/graphql',
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
  //   subscription FetchNewUnitNotification($member_id: String!) {
  //     wishes(
  //       where: {
  //         member_id: {_neq: $member_id},
  //         # is_public: {_eq: true},
  //       },
  //       order_by: {created_at: desc},
  //       limit: 1,
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

  // TODO: [MVP] {"member_id":{"_eq":"X-Hasura-User-Id"}}
  static final upsertWish = gql(r'''
    mutation UpsertWish($unit_id: uuid!, $value: Boolean!) {
      insert_wish_one(object: {unit_id: $unit_id, value: $value},
      on_conflict: {constraint: wish_pkey, update_columns: [value]}) {
        unit {
          ...UnitFields
        }
        updated_at
      }
    }
  ''')..definitions.addAll(fragments.definitions);

  // TODO: [MVP] добавить фильтр по member_id внутри permissions
  // static final readProfile = gql(r'''
  //   query ReadProfile {
  // wishes(
  //   order_by: {updated_at: desc}
  // ) {
  //   unit_id
  // }
  //   }
  // '''); //..definitions.addAll(fragments.definitions);

  static final readWishes = gql(r'''
    query ReadWishes() {
      wishes(
        order_by: {updated_at: desc}
      ) {
        unit {
          ...UnitFields
        }
        updated_at
      }
    }
  ''')..definitions.addAll(fragments.definitions);

  // TODO: [MVP] member_id
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
        # member_id: "577f9efd-0b9e-4743-8610-1fcbb89b192a",
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

  // static final deleteTodo = gql(r'''
  //   mutation DeleteTodo($id: Int!) {
  //     delete_todos_by_pk(id: $id) {
  //       id
  //     }
  //   }
  // ''');

  // static final fetchNewTodoNotification = gql(r'''
  //   subscription FetchNewTodoNotification($user_id: String!) {
  //     todos(
  //       where: {
  //         user_id: {_eq: $user_id},
  //         # is_public: {_eq: true},
  //       },
  //       order_by: {created_at: desc},
  //       limit: 1,
  //     ) {
  //       id
  //     }
  //   }
  // ''');

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

  // static final readBreeds = gql(r'''
  //   query ReadBreeds($category_id: String!) {
  //     breeds(
  //       where: {category_id: {_eq: $category_id}},
  //       order_by: {name: asc}) {
  //       ...BreedFields
  //     }
  //   }
  // ''')..definitions.addAll(fragments.definitions);

  static final fragments = gql(r'''
    fragment BreedFields on breed {
      # __typename
      id
      name
      # category_id
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
