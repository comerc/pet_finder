import 'package:graphql/client.dart';
import 'package:gql/ast.dart';

class GraphQLService {
  GraphQLService({
    GraphQLClient client,
    this.timeout,
  }) : _client = client;

  final GraphQLClient _client;
  final Duration timeout;

  Future<List<T>> query<T>({
    DocumentNode documentNode,
    Map<String, dynamic> variables,
    String root,
    dynamic Function(dynamic rawJson) toRoot,
    T Function(Map<String, dynamic> json) convert,
  }) async {
    assert(toRoot != null || root != null && root.isNotEmpty);
    final options = QueryOptions(
      documentNode: documentNode,
      variables: variables,
      fetchPolicy: FetchPolicy.noCache,
      errorPolicy: ErrorPolicy.all,
    );
    final queryResult = await _client.query(options).timeout(timeout);
    if (queryResult.hasException) {
      throw queryResult.exception;
    }
    final rawJson =
        toRoot == null ? queryResult.data[root] : toRoot(queryResult.data);
    final jsons = (rawJson as List).cast<Map<String, dynamic>>();
    final result = <T>[];
    for (final json in jsons) {
      result.add(convert(json));
    }
    return result;
  }

  Future<T> mutate<T>({
    DocumentNode documentNode,
    Map<String, dynamic> variables,
    String root,
    dynamic Function(dynamic rawJson) toRoot,
    T Function(Map<String, dynamic> json) convert,
  }) async {
    assert(toRoot != null || root != null && root.isNotEmpty);
    final options = MutationOptions(
      documentNode: documentNode,
      variables: variables,
      fetchPolicy: FetchPolicy.noCache,
      errorPolicy: ErrorPolicy.all,
    );
    final mutationResult = await _client.mutate(options).timeout(timeout);
    if (mutationResult.hasException) {
      throw mutationResult.exception;
    }
    final rawJson = toRoot == null
        ? mutationResult.data[root]
        : toRoot(mutationResult.data);
    final json = rawJson as Map<String, dynamic>;
    return convert(json);
  }

  Stream<T> subscribe<T>({
    DocumentNode documentNode,
    Map<String, dynamic> variables,
    String root,
    dynamic Function(dynamic rawJson) toRoot,
    T Function(Map<String, dynamic> json) convert,
  }) {
    assert(toRoot != null || root != null && root.isNotEmpty);
    final operation = Operation(
      documentNode: documentNode,
      variables: variables,
      // extensions: null,
      // operationName: '',
    );
    return _client.subscribe(operation).map((FetchResult fetchResult) {
      final rawJson =
          toRoot == null ? fetchResult.data[root] : toRoot(fetchResult.data);
      final json = rawJson as Map<String, dynamic>;
      return convert(json);
    });
  }
}
