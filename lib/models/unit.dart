import 'package:pet_finder/imports.dart';

class UnitModel {
  UnitModel({
    required this.id,
    // required this.breed, //
    required this.title, //
    required this.color, //
    required this.weight, //
    required this.story, //
    required this.member,
    required this.imageUrl,
    // required this.condition, //
    required this.birthday, //
    required this.address, //
    // required this.location, // TODO: location
  });

  final String id;
  // final BreedModel breed;
  final String title;
  final String color;
  final int weight;
  final String story;
  final MemberModel member;
  final String imageUrl;
  // final ConditionValue condition;
  final DateTime birthday;
  final String address;
  // final String location;
}
