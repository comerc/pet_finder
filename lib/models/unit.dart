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
    this.story,
    this.condition,
  });

  final String id;
  final String story;
  final ConditionValue condition;

  @override
  List<Object> get props => [id, story, condition];

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
