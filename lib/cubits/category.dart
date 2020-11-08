import 'dart:async';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:pet_finder/import.dart';

part 'category.g.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit(this.repository)
      : assert(repository != null),
        super(CategoryState());

  final DatabaseRepository repository;

  Future<void> load({String categoryId}) async {
    // const kLimit = 10;
    if (state.status == CategoryStatus.loading) return;
    emit(state.copyWith(
      status: CategoryStatus.loading,
    ));
    try {
      final units = await repository.readUnits(
        categoryId: categoryId,
        limit: kCategoryUnitsLimit,
      );
      emit(CategoryState());
      await Future.delayed(Duration(milliseconds: 300));
      emit(state.copyWith(units: units));
    } on Exception {
      out('error');
    } finally {
      emit(state.copyWith(
        status: CategoryStatus.ready,
      ));
    }
  }
}

enum CategoryStatus { initial, loading, ready }

@CopyWith()
class CategoryState extends Equatable {
  CategoryState({
    this.units = const [],
    this.status = CategoryStatus.initial,
  });

  final List<UnitModel> units;
  final CategoryStatus status;

  @override
  List<Object> get props => [
        units,
        status,
      ];
}
