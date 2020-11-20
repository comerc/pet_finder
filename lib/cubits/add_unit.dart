import 'package:json_annotation/json_annotation.dart';
// import 'package:copy_with_extension/copy_with_extension.dart';
// import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:pet_finder/import.dart';

part 'add_unit.g.dart';

class AddUnitCubit extends Cubit<void> {
  AddUnitCubit(this.repository)
      : assert(repository != null),
        super(null);

  final DatabaseRepository repository;

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

// enum AddUnitStatus { initial, loading, error, ready }

// @CopyWith()
// class AddUnitState extends Equatable {
//   AddUnitState({
//     this.breeds,
//     this.status = AddUnitStatus.initial,
//   });

//   final List<BreedModel> breeds;
//   // final AddUnitStatus status;

//   @override
//   List<Object> get props => [
//         breeds,
//         status,
//       ];
// }

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
