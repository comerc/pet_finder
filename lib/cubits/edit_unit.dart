import 'dart:async';
import 'package:json_annotation/json_annotation.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:pet_finder/import.dart';

part 'edit_unit.g.dart';

class EditUnitCubit extends Cubit<EditUnitState> {
  EditUnitCubit(DatabaseRepository repository)
      : _repository = repository,
        super(EditUnitState());

  final DatabaseRepository _repository;

  Future<void> load() async {
    if (state.status == EditUnitStatus.loading) return;
    emit(state.copyWith(status: EditUnitStatus.loading));
    // await Future.delayed(Duration(seconds: 4));
    // emit(state.copyWith(status: EditUnitStatus.error));
    // throw Exception('oaoaoao');
    try {
      emit(
        state.copyWith(
          model: await _repository.readEditUnit(),
          status: EditUnitStatus.ready,
        ),
      );
    } on Exception {
      emit(state.copyWith(status: EditUnitStatus.error));
      rethrow;
    }
  }
}

enum EditUnitStatus { initial, loading, error, ready }

@CopyWith()
class EditUnitState extends Equatable {
  EditUnitState({
    this.model,
    this.status = EditUnitStatus.initial,
  });

  final EditUnitModel? model;
  final EditUnitStatus status;

  @override
  List<Object?> get props => [
        model,
        status,
      ];
}
