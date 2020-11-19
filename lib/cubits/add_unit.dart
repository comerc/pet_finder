import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:pet_finder/import.dart';

part 'add_unit.g.dart';

class AddUnitCubit extends Cubit<AddUnitState> {
  AddUnitCubit(this.repository, {@required this.categoryId})
      : assert(repository != null),
        super(AddUnitState());

  final DatabaseRepository repository;
  final String categoryId;

  Future<void> load() async {
    if (state.status == AddUnitStatus.loading) return;
    emit(state.copyWith(status: AddUnitStatus.loading));
    try {
      // await Future.delayed(Duration(seconds: 4));
      // throw Exception('1234');
      final breeds = await repository.readBreeds(categoryId: categoryId);
      emit(state.copyWith(
        breeds: breeds,
      ));
    } on Exception {
      emit(state.copyWith(status: AddUnitStatus.error));
      rethrow;
    }
    emit(state.copyWith(status: AddUnitStatus.ready));
  }

  Future<void> add(AddUnitData data) async {
    if (data.condition == null) {
      throw ValidationException('Invalid condition');
    }
    if (data.breedId == null) {
      throw ValidationException('Invalid breed');
    }
    await repository.createUnit(data);
  }
}

enum AddUnitStatus { initial, loading, error, ready }

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

@JsonSerializable(createFactory: false)
class AddUnitData {
  AddUnitData({
    this.breedId,
    this.color,
    this.weight,
    this.story,
    this.imageUrl,
    this.condition,
    this.birthday,
    this.address,
  });

  final String breedId;
  final String color;
  final int weight;
  final String story;
  final String imageUrl;
  final ConditionValue condition;
  final DateTime birthday;
  final String address;

  Map<String, dynamic> toJson() => _$AddUnitDataToJson(this);
}
