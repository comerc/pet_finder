import 'package:json_annotation/json_annotation.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:pet_finder/import.dart';

part 'add_unit.g.dart';

class AddUnitCubit extends Cubit<AddUnitState> {
  AddUnitCubit(this.repository)
      : assert(repository != null),
        super(AddUnitState());

  final DatabaseRepository repository;

  Future<void> load({String categoryId}) async {
    // TODO: постраничный вывод
    if (state.status == AddUnitStatus.loading) return;
    emit(state.copyWith(
      status: AddUnitStatus.loading,
    ));
    try {
      await Future.delayed(Duration(seconds: 4));
      final breeds = await repository.readBreeds(categoryId: categoryId);
      emit(state.copyWith(
        breeds: breeds,
      ));
    } catch (error) {
      out('error');
      return Future.error(error);
    } finally {
      emit(state.copyWith(
        status: AddUnitStatus.ready,
      ));
    }
  }

  Future<void> submit(AddUnitDTO data) async {
    if (state.status == AddUnitStatus.loading) return;
    emit(state.copyWith(status: AddUnitStatus.loading));
    try {
      final unit = await repository.createUnit(data);
      out(unit.toJson());

      // TODO: показать ученикам!
    } catch (error) {
      out(error);
      return Future.error(error);
      // rethrow;
    } finally {
      emit(state.copyWith(status: AddUnitStatus.ready));
    }
  }
}

enum AddUnitStatus { initial, loading, ready }

@CopyWith()
class AddUnitState extends Equatable {
  AddUnitState({
    this.breeds,
    this.status = AddUnitStatus.initial,
  });

  final List<BreedModel> breeds;
  final AddUnitStatus status;

  @override
  List<Object> get props => [
        breeds,
        status,
      ];
}

@JsonSerializable()
class AddUnitDTO {
  AddUnitDTO({
    this.breedId,
    this.color,
    this.weight,
    this.story,
    // this.imageUrl,
    this.condition,
    this.birthday,
    this.address,
  });

  final String breedId;
  final String color;
  final int weight;
  final String story;
  // final String imageUrl;
  final ConditionValue condition;
  final DateTime birthday;
  final String address;

  Map<String, dynamic> toJson() => _$AddUnitDTOToJson(this);
}
