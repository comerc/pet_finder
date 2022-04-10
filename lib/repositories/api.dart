import 'package:graphql/client.dart';

// TODO: https://github.com/apollographql/apollo-tooling/issues/1365

mixin API {
  static final readWishes = gql(r'''
    query MyQuery {
      unit(order_by: {}) {
        sex
      }
    }
  ''');
}
