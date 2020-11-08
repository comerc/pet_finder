import 'package:graphql/client.dart';
import 'package:meta/meta.dart';
import 'package:pet_finder/import.dart';

const _kEnableWebsockets = false;

class DatabaseRepository {
  DatabaseRepository({GraphQLClient client}) : _client = client ?? _getClient();

  final GraphQLClient _client;

  Future<List<UnitModel>> readUnits({String categoryId, int limit}) async {
    assert(categoryId != null);
    assert(limit != null);
    final options = QueryOptions(
      documentNode: _API.readUnits,
      variables: {
        'category_id': categoryId,
        'limit': limit,
      },
      fetchPolicy: FetchPolicy.noCache,
      errorPolicy: ErrorPolicy.all,
    );
    final queryResult =
        await _client.query(options).timeout(kGraphQLTimeoutDuration);
    if (queryResult.hasException) {
      throw queryResult.exception;
    }
    final dataItems =
        (queryResult.data['units'] as List).cast<Map<String, dynamic>>();
    final items = <UnitModel>[];
    for (final dataItem in dataItems) {
      items.add(UnitModel.fromJson(dataItem));
    }
    return items;
  }

  Future<List<UnitModel>> readNewestUnits({int limit}) async {
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
      throw queryResult.exception;
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
      throw queryResult.exception;
    }
    final dataItems =
        (queryResult.data['categories'] as List).cast<Map<String, dynamic>>();
    final items = <CategoryModel>[];
    for (final dataItem in dataItems) {
      items.add(CategoryModel.fromJson(dataItem));
    }
    return items;
  }

  Future<List<BreedModel>> readBreeds() async {
    final options = QueryOptions(
      documentNode: _API.readBreeds,
      // variables: {},
      fetchPolicy: FetchPolicy.noCache,
      errorPolicy: ErrorPolicy.all,
    );
    final queryResult =
        await _client.query(options).timeout(kGraphQLTimeoutDuration);
    if (queryResult.hasException) {
      throw queryResult.exception;
    }
    final dataItems =
        (queryResult.data['breeds'] as List).cast<Map<String, dynamic>>();
    final items = <BreedModel>[];
    for (final dataItem in dataItems) {
      items.add(BreedModel.fromJson(dataItem));
    }
    return items;
  }
}

GraphQLClient _getClient() {
  final httpLink = HttpLink(
    uri: 'http://cats8.herokuapp.com/v1/graphql',
  );
  final authLink = AuthLink(
    getToken: () async => '',
    // getToken: () async => 'Bearer $kDatabaseToken', // TODO: getToken
  );
  var link = authLink.concat(httpLink);
  if (_kEnableWebsockets) {
    final websocketLink = WebSocketLink(
      url: 'ws://cats8.herokuapp.com/v1/graphql',
      config: SocketClientConfig(
        inactivityTimeout: const Duration(seconds: 15),
        initPayload: () async {
          out('initPayload');
          return {
            // 'headers': {'Authorization': 'Bearer $kDatabaseToken'}, TODO: headers
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

class _API {
  // static final createTodo = gql(r'''
  //   mutation CreateTodo($title: String) {
  //     insert_todos_one(object: {title: $title}) {
  //       ...TodosFields
  //     }
  //   }
  // ''')..definitions.addAll(fragments.definitions);

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

  static final readUnits = gql(r'''
    query ReadUnits($category_id: category_key_enum!, $limit: Int!) {
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

  static final readCategories = gql(r'''
    query ReadCategories {
      categories(
        order_by: {order_index: asc}
      ) {
        id
        name
        total_of
      }
    }
  ''')..definitions.addAll(fragments.definitions);

  static final readBreeds = gql(r'''
    query ReadBreeds {
      breeds(order_by: {name: asc}) {
        id
        name
        category_id
      }
    }
  ''')..definitions.addAll(fragments.definitions);

  static final fragments = gql(r'''
    fragment BreedFields on breed {
      # __typename
      id
      name
      category_id
    }

    fragment MemberFields on member {
      # __typename
      id
      name
      avatar_url
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

  // TODO: {"member_id":{"_eq":"X-Hasura-User-Id"}}
  // static final upsertWish = gql(r'''
  //   mutation UpsertWish($unit_id: uuid!, $value: Boolean!) {
  //     insert_wish_one(object: {unit_id: $unit_id, value: $value},
  //     on_conflict: {constraint: wish_pkey, update_columns: [value]}) {
  //       updated_at
  //     }
  //   }
  // ''');
}
