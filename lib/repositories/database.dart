import 'package:graphql/client.dart';
import 'package:pet_finder/import.dart';

const _kEnableWebsockets = false;

class DatabaseRepository {
  DatabaseRepository({GraphQLClient client}) : _client = client ?? _getClient();

  final GraphQLClient _client;

  Future<ProfileModel> readProfile() async {
    final options = QueryOptions(
      documentNode: _API.readProfile,
      // variables: {},
      fetchPolicy: FetchPolicy.noCache,
      errorPolicy: ErrorPolicy.all,
    );
    final queryResult =
        await _client.query(options).timeout(kGraphQLTimeoutDuration);
    if (queryResult.hasException) {
      throw queryResult.exception;
    }
    return ProfileModel.fromJson(queryResult.data);
  }

  Future<List<UnitModel>> readUnits(
      {String categoryId, String query, int limit}) async {
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

  Future<List<BreedModel>> readBreeds({String categoryId}) async {
    final options = QueryOptions(
      documentNode: _API.readBreeds,
      variables: {'category_id': categoryId},
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

  Future<UnitModel> createUnit(AddUnitData data) async {
    await Future.delayed(Duration(seconds: 4));
    throw Exception('4321');
    out(data.toJson());
    final options = MutationOptions(
      documentNode: _API.createUnit,
      variables: data.toJson(),
      fetchPolicy: FetchPolicy.noCache,
      errorPolicy: ErrorPolicy.all,
    );
    final mutationResult =
        await _client.mutate(options).timeout(kGraphQLTimeoutDuration);
    if (mutationResult.hasException) {
      throw mutationResult.exception;
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
    getToken: () async => '',
    // getToken: () async => 'Bearer $kDatabaseToken', // TODO: [MVP] getToken
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
  // TODO: [MVP] добавить фильтр по member_id внутри permissions
  static final readProfile = gql(r'''
    query ReadProfile {
      wishes(
        order_by: {updated_at: desc}
      ) {
        unit_id
      }
    }
  '''); //..definitions.addAll(fragments.definitions);

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
        member_id: "577f9efd-0b9e-4743-8610-1fcbb89b192a",
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
    query ReadUnitsByCategory($category_id: category_key_enum!, $limit: Int!) {
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
    query ReadUnitsByQuery($query: String!, $category_id: category_key_enum, $limit: Int!) {
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
      }
    }
  ''')..definitions.addAll(fragments.definitions);

  static final readBreeds = gql(r'''
    query ReadBreeds($category_id: category_key_enum!) {
      breeds(
        where: {category_id: {_eq: $category_id}},
        order_by: {name: asc}) {
        ...BreedFields
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

  // TODO: [MVP] {"member_id":{"_eq":"X-Hasura-User-Id"}}
  // static final upsertWish = gql(r'''
  //   mutation UpsertWish($unit_id: uuid!, $value: Boolean!) {
  //     insert_wish_one(object: {unit_id: $unit_id, value: $value},
  //     on_conflict: {constraint: wish_pkey, update_columns: [value]}) {
  //       updated_at
  //     }
  //   }
  // ''');
}
