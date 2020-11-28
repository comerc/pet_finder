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
    final hasRoot = root != null && root.isNotEmpty;
    final hasToRoot = toRoot != null;
    assert((hasRoot || hasToRoot) && !(hasRoot && hasToRoot),
        'Assign "root" or "toRoot"');
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
    final rawJson = hasRoot ? queryResult.data[root] : toRoot(queryResult.data);
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
    final hasRoot = root != null && root.isNotEmpty;
    final hasToRoot = toRoot != null;
    assert((hasRoot || hasToRoot) && !(hasRoot && hasToRoot),
        'Assign "root" or "toRoot"');
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
    final rawJson =
        hasRoot ? mutationResult.data[root] : toRoot(mutationResult.data);
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
    final hasRoot = root != null && root.isNotEmpty;
    final hasToRoot = toRoot != null;
    assert((hasRoot || hasToRoot) && !(hasRoot && hasToRoot),
        'Assign "root" or "toRoot"');
    final operation = Operation(
      documentNode: documentNode,
      variables: variables,
      // extensions: null,
      // operationName: '',
    );
    return _client.subscribe(operation).map((FetchResult fetchResult) {
      final rawJson =
          hasRoot ? fetchResult.data[root] : toRoot(fetchResult.data);
      final json = rawJson as Map<String, dynamic>;
      return convert(json);
    });
  }
}
