import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:pet_finder/import.dart';

part 'unit.g.dart';

@JsonSerializable()
class UnitModel extends Equatable {
  UnitModel({
    required this.id,
    required this.breed, //
    required this.color, //
    required this.weight, //
    required this.story, //
    required this.member,
    required this.imageUrl,
    required this.condition, //
    required this.birthday, //
    required this.address, //
    // required this.location, // TODO: location
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
  // final String location;

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
        // location,
      ];

  static UnitModel fromJson(Map<String, dynamic> json) =>
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
  return map[value]!;
}

String getConditionDescription(ConditionValue value) {
  final map = {
    ConditionValue.mating: 'Mating Description',
    ConditionValue.adoption: 'Adoption Description',
    ConditionValue.disappear: 'Disappear Description',
  };
  assert(ConditionValue.values.length == map.length);
  return map[value]!;
}

Color getConditionBackgroundColor(ConditionValue value) {
  final map = {
    ConditionValue.mating: Colors.blue[100],
    ConditionValue.adoption: Colors.orange[100],
    ConditionValue.disappear: Colors.red[100],
  };
  assert(ConditionValue.values.length == map.length);
  return map[value]!;
}

Color getConditionForegroundColor(ConditionValue value) {
  final map = {
    ConditionValue.mating: Colors.blue,
    ConditionValue.adoption: Colors.orange,
    ConditionValue.disappear: Colors.red,
  };
  assert(ConditionValue.values.length == map.length);
  return map[value]!;
}
