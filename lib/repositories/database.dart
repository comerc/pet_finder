import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:graphql/client.dart';
import 'package:pet_finder/import.dart';

const _kEnableWebsockets = true;

typedef CreateServiceCallback = GraphQLService Function();

class DatabaseRepository {
  DatabaseRepository({
    CreateServiceCallback? createService,
  }) : _createService = createService ?? createDefaultService;

  late GraphQLService _service;
  final CreateServiceCallback _createService;

  void initializeService() {
    _service = _createService();
  }

  StreamController<UnitModel>? _fetchNewestUnitNotificationController;

  Stream<UnitModel> get fetchNewestUnitNotification {
    if (_fetchNewestUnitNotificationController == null) {
      _fetchNewestUnitNotificationController = StreamController<UnitModel>();
      _fetchNewestUnitNotificationController!.onCancel = () async {
        try {
          // ignore: unawaited_futures
          _fetchNewestUnitNotificationController!.close();
        } finally {
          _fetchNewestUnitNotificationController = null;
        }
      };
    }
    return _fetchNewestUnitNotificationController!.stream;
  }

  Stream<String?> get fetchNewUnitNotification {
    return _service.subscribe(
      document: API.fetchNewUnitNotification,
      variables: {},
      toRoot: (dynamic rawJson) {
        return (rawJson == null)
            ? null
            // ignore: avoid_dynamic_calls
            : (rawJson['units'] == null)
                ? null
                // ignore: avoid_dynamic_calls
                : (rawJson['units'] == [])
                    ? null
                    // ignore: avoid_dynamic_calls
                    : rawJson['units'][0];
      },
      convert: (Map<String, dynamic> json) => json['id'] as String,
    );
  }

  Future<MemberModel?> upsertMember(MemberData data) {
    return _service.mutate(
      document: API.upsertMember,
      variables: data.toJson(),
      root: 'insert_member_one',
      convert: MemberModel.fromJson,
    );
  }

  Future<WishModel?> upsertWish(WishData data) {
    return _service.mutate(
      document: API.upsertWish,
      variables: data.toJson(),
      root: 'insert_wish_one',
      convert: WishModel.fromJson,
    );
  }

  Future<List<WishModel>> readWishes() {
    return _service.query(
      document: API.readWishes,
      variables: {},
      root: 'wishes',
      convert: WishModel.fromJson,
    );
  }

  Future<List<UnitModel>> readUnits({
    required CategoryValue category,
    required int offset,
    required int limit,
  }) {
    return _service.query(
      document: API.readUnits,
      variables: {
        'category': category.name,
        'offset': offset,
        'limit': limit,
      },
      root: 'units',
      convert: UnitModel.fromJson,
    );
  }

  // Future<List<UnitModel>> readUnits({
  //   String? categoryId,
  //   String? query,
  //   required int limit,
  // }) {
  //   assert(categoryId != null || query != null);
  //   return _service.query(
  //     document:
  //         (query == null) ? API.readUnitsByCategory : API.readUnitsByQuery,
  //     variables: {
  //       if (categoryId != null) 'category_id': categoryId,
  //       if (query != null) 'query': '%$query%',
  //       'limit': limit,
  //     },
  //     root: 'units',
  //     convert: UnitModel.fromJson,
  //   );
  // }

  // Future<List<UnitModel>> readNewestUnits({required int limit}) {
  //   return _service.query(
  //     document: API.readNewestUnits,
  //     variables: {
  //       'limit': limit,
  //     },
  //     root: 'units',
  //     convert: UnitModel.fromJson,
  //   );
  // }

  // Future<UnitModel?> createUnit(UnitData data) async {
  //   final result = await _service.mutate(
  //     document: API.createUnit,
  //     variables: data.toJson(),
  //     root: 'insert_unit_one',
  //     convert: UnitModel.fromJson,
  //   );
  //   if (result != null) {
  //     _fetchNewestUnitNotificationController?.add(result);
  //   }
  //   return result;
  // }
}

// публично для тестирования
GraphQLService createDefaultService() {
  return GraphQLService(
    client: createClient(),
    queryTimeout: kGraphQLQueryTimeout,
    mutationTimeout: kGraphQLMutationTimeout,
    fragments: API.fragments,
  );
}

// публично для тестирования
GraphQLClient createClient() {
  final httpLink = HttpLink(
    '${kDebugMode ? 'http' : 'https'}://$kGraphQLEndpoint',
  );
  // final authLink = AuthLink(
  //   getToken: () async {
  //     final idToken = await FirebaseAuth.instance.currentUser!.getIdToken(true);
  //     return 'Bearer $idToken';
  //   },
  // );
  // var link = authLink.concat(httpLink);
  Link link = httpLink;
  // if (_kEnableWebsockets) {
  //   final websocketLink = WebSocketLink(
  //     '${kDebugMode ? 'ws' : 'wss'}://$kGraphQLEndpoint',
  //     config: SocketClientConfig(
  //       initialPayload: () async {
  //         final idToken =
  //             await FirebaseAuth.instance.currentUser!.getIdToken(true);
  //         return {
  //           'headers': {'Authorization': 'Bearer $idToken'},
  //         };
  //       },
  //     ),
  //   );
  //   // split request based on type
  //   link = Link.split(
  //     (request) => request.isSubscription,
  //     websocketLink,
  //     link,
  //   );
  // }
  return GraphQLClient(
    cache: GraphQLCache(),
    link: link,
  );
}
