import 'dart:async';
import 'package:json_annotation/json_annotation.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:pet_finder/import.dart';

part 'app.g.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit(this.repository)
      : assert(repository != null),
        super(AppState()) {
    _fetchNewUnitNotificationSubscription =
        repository.fetchNewUnitNotification.listen(fetchNewUnitNotification);
  }

  final DatabaseRepository repository;
  StreamSubscription<String> _fetchNewUnitNotificationSubscription;

  @override
  Future<void> close() {
    _fetchNewUnitNotificationSubscription?.cancel();
    return super.close();
  }

  void fetchNewUnitNotification(String id) {
    out('**** $id');
    // emit(state.copyWith(newId: id));
  }

  Future<void> saveWish(WishData data) async {
    await repository.upsertWish(data);
  }

  Future<void> upsertMember(MemberData data) async {
    await repository.upsertMember(data);
  }

  Future<void> load() async {
    if (state.status == AppStatus.loading) return;
    emit(state.copyWith(status: AppStatus.loading));
    try {
      emit(state.copyWith(
        wishes: await repository.readWishes(),
        categories: await repository.readCategories(),
        newestUnits: await repository.readNewestUnits(limit: kNewestUnitsLimit),
      ));
    } on Exception {
      emit(state.copyWith(status: AppStatus.error));
      rethrow;
    }
    emit(state.copyWith(status: AppStatus.ready));
  }
}

enum AppStatus { initial, loading, error, ready }

@CopyWith()
class AppState extends Equatable {
  AppState({
    this.member,
    this.wishes = const [],
    this.categories = const [],
    this.newestUnits = const [],
    this.status = AppStatus.initial,
  });

  final MemberModel member;
  final List<WishModel> wishes;
  final List<CategoryModel> categories;
  final List<UnitModel> newestUnits;
  final AppStatus status;

  @override
  List<Object> get props => [
        member,
        wishes,
        categories,
        newestUnits,
        status,
      ];
}

@JsonSerializable(createFactory: false)
class MemberData {
  MemberData({this.displayName, this.imageUrl});

  final String displayName;
  final String imageUrl;

  Map<String, dynamic> toJson() => _$MemberDataToJson(this);
}

@JsonSerializable(createFactory: false)
class WishData {
  WishData({this.unitId, this.value});

  final String unitId;
  final bool value;

  Map<String, dynamic> toJson() => _$WishDataToJson(this);
}
