import 'dart:async';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:pet_finder/import.dart';

part 'app.g.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit(this.repository)
      : assert(repository != null),
        super(AppState());

  final DatabaseRepository repository;

  Future<void> load() async {
    if (state.status == AppStatus.loading) return;
    emit(state.copyWith(status: AppStatus.loading));
    try {
      emit(state.copyWith(
        profile: await repository.readProfile(),
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
    this.profile,
    this.categories = const [],
    this.newestUnits = const [],
    this.status = AppStatus.initial,
  });

  final ProfileModel profile;
  final List<CategoryModel> categories;
  final List<UnitModel> newestUnits;
  final AppStatus status;

  @override
  List<Object> get props => [
        profile,
        categories,
        newestUnits,
        status,
      ];
}
