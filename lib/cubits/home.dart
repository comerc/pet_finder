import 'dart:async';
import 'package:json_annotation/json_annotation.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:pet_finder/import.dart';

part 'home.g.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(DatabaseRepository repository)
      : assert(repository != null),
        _repository = repository,
        super(HomeState()) {
    _fetchNewUnitNotificationSubscription =
        repository.fetchNewestUnitNotification.listen(fetchNewUnitNotification);
  }

  final DatabaseRepository _repository;
  StreamSubscription<UnitModel> _fetchNewUnitNotificationSubscription;

  @override
  Future<void> close() async {
    await _fetchNewUnitNotificationSubscription.cancel();
    return super.close();
  }

  void fetchNewUnitNotification(UnitModel unit) {
    emit(state.copyWith(newestUnits: [unit, ...state.newestUnits]));
  }

  Future<void> load() async {
    if (state.status == HomeStatus.loading) return;
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      emit(state.copyWith(
        categories: await _repository.readCategories(),
        newestUnits:
            await _repository.readNewestUnits(limit: kNewestUnitsLimit),
      ));
    } on Exception {
      emit(state.copyWith(status: HomeStatus.error));
      rethrow;
    }
    emit(state.copyWith(status: HomeStatus.ready));
  }
}

enum HomeStatus { initial, loading, error, ready }

@CopyWith()
class HomeState extends Equatable {
  HomeState({
    this.categories = const [],
    this.newestUnits = const [],
    this.status = HomeStatus.initial,
  });

  final List<CategoryModel> categories;
  final List<UnitModel> newestUnits;
  final HomeStatus status;

  @override
  List<Object> get props => [
        categories,
        newestUnits,
        status,
      ];
}
