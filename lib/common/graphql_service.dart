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
    T Function(Map<String, dynamic> json) convert,
  }) async {
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
    final jsons = (queryResult.data[root] as List).cast<Map<String, dynamic>>();
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
    T Function(Map<String, dynamic> json) convert,
  }) async {
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
    final json = mutationResult.data[root] as Map<String, dynamic>;
    return convert(json);
  }

  // Stream<T> subscribe<T>({
  //   DocumentNode documentNode,
  //   Map<String, dynamic> variables,
  //   T Function(dynamic json) convert,
  // }) {
  //   final operation = Operation(
  //     documentNode: documentNode,
  //     variables: variables,
  //     // extensions: null,
  //     // operationName: '',
  //   );
  //   return _client.subscribe(operation).map((FetchResult fetchResult) {
  //     return convert(fetchResult.data);
  //   });
  // }
}
