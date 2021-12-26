import 'dart:async';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:pet_finder/import.dart';

part 'showcase.g.dart';

class ShowcaseCubit extends Cubit<ShowcaseState> {
  ShowcaseCubit(
    DatabaseRepository repository, {
    required this.categoryId,
    required this.query,
  })  : _repository = repository,
        super(ShowcaseState());

  final DatabaseRepository _repository;
  final String categoryId;
  final String query;

  Future<void> load() async {
    // TODO: постраничный вывод
    if (state.status == ShowcaseStatus.loading) return;
    emit(state.copyWith(status: ShowcaseStatus.loading));
    try {
      // final categories = await repository.readCategories();
      final units = await _repository.readUnits(
        categoryId: categoryId,
        query: query,
        limit: kShowcaseUnitsLimit,
      );
      // emit(ShowcaseState());
      // await Future.delayed(Duration(milliseconds: 300));
      emit(
        state.copyWith(
          // categories: categories,
          units: units,
          status: ShowcaseStatus.ready,
        ),
      );
    } on Exception {
      emit(state.copyWith(status: ShowcaseStatus.error));
      rethrow;
    }
  }
}

enum ShowcaseStatus { initial, loading, error, ready }

@CopyWith()
class ShowcaseState extends Equatable {
  ShowcaseState({
    // this.categories = const [],
    this.units = const [],
    this.status = ShowcaseStatus.initial,
  });

  // final List<CategoryModel> categories;
  final List<UnitModel> units;
  final ShowcaseStatus status;

  @override
  List<Object> get props => [
        // categories,
        units,
        status,
      ];
}
