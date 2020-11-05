import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:pet_finder/import.dart';

part 'unit.g.dart';

@CopyWith()
@JsonSerializable()
class UnitModel extends Equatable {
  UnitModel({
    this.id,
    this.breed,
    this.color,
    this.weight,
    this.story,
    this.member,
    this.imageUrl,
    this.condition,
    this.birthday,
    this.address,
    this.location,
  });

  final String id;
  final BreedModel breed;
  final String color;
  final int weight;
  final String story;
  final MemberModel member;
  final String imageUrl;
  final ConditionValue condition;
  final DateTime birthday;
  final String address;
  final String location;

  @override
  List<Object> get props => [
        id,
        breed,
        color,
        weight,
        story,
        member,
        imageUrl,
        condition,
        birthday,
        address,
        location,
      ];

  factory UnitModel.fromJson(Map<String, dynamic> json) =>
      _$UnitModelFromJson(json);

  Map<String, dynamic> toJson() => _$UnitModelToJson(this);
}

enum ConditionValue {
  mating,
  adoption,
  disappear,
}

String getConditionName(ConditionValue value) {
  final map = {
    ConditionValue.mating: 'Mating',
    ConditionValue.adoption: 'Adoption',
    ConditionValue.disappear: 'Disappear',
  };
  assert(ConditionValue.values.length == map.length);
  return map[value];
}
