import 'dart:async';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:pet_finder/import.dart';

part 'showcase.g.dart';

class ShowcaseCubit extends Cubit<ShowcaseState> {
  ShowcaseCubit(
    DatabaseRepository repository, {
    required this.category,
    // required this.query,
  })  : _repository = repository,
        super(ShowcaseState());

  final DatabaseRepository _repository;
  final CategoryValue category;
  // final String query;

  Future<void> load() async {
    // TODO: постраничный вывод
    if (state.status == ShowcaseStatus.loading) return;
    emit(state.copyWith(status: ShowcaseStatus.loading));
    try {
      final units = await _repository.readUnits(
        category: category,
        // query: query,
        offset: 0,
        limit: kShowcaseUnitsLimit,
      );
      // emit(ShowcaseState());
      // await Future.delayed(Duration(milliseconds: 300));
      emit(
        state.copyWith(
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
    this.units = const [],
    this.status = ShowcaseStatus.initial,
  });

  final List<UnitModel> units;
  final ShowcaseStatus status;

  @override
  List<Object> get props => [
        units,
        status,
      ];
}
