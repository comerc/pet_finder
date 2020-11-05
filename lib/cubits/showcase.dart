import 'dart:async';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:pet_finder/import.dart';

part 'showcase.g.dart';

class ShowcaseCubit extends Cubit<ShowcaseState> {
  ShowcaseCubit(this.repository)
      : assert(repository != null),
        super(ShowcaseState());

  final DatabaseRepository repository;

  Future<void> load({CategoryKey categoryId}) async {
    // const kLimit = 10;
    if (state.status == ShowcaseStatus.loading) return;
    emit(state.copyWith(
      status: ShowcaseStatus.loading,
    ));
    try {
      final items = await repository.readUnits(categoryId: categoryId);
      emit(ShowcaseState());
      await Future.delayed(Duration(milliseconds: 300));
      emit(state.copyWith(items: items));
    } on Exception {
      out('error');
    } finally {
      emit(state.copyWith(
        status: ShowcaseStatus.ready,
      ));
    }
  }
}

enum ShowcaseStatus { initial, loading, ready }

@CopyWith()
class ShowcaseState extends Equatable {
  ShowcaseState({
    this.items = const [],
    this.status = ShowcaseStatus.initial,
  });

  final List<UnitModel> items;
  final ShowcaseStatus status;

  @override
  List<Object> get props => [
        items,
        status,
      ];
}
