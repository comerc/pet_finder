import 'package:pet_finder/imports.dart';

class UnitModel {
  UnitModel({
    required this.id,
    // required this.breed, //
    required this.title, //
    required this.color, //
    required this.wool,
    required this.weight, // -
    required this.story, //
    required this.member,
    required this.imageUrl,
    // required this.condition, //
    this.birthday, // может быть null - когда неизвестно
    required this.address, //
    // required this.location, // TODO: location
    required this.sex,
    required this.age, // используется, когда birthday is null; иначе калькулируется
  });

  final String id;
  // final BreedModel breed;
  final String title;
  final String color;
  final Wool wool;
  final int weight;
  final String story;
  final MemberModel member;
  final String imageUrl;
  // final ConditionValue condition;
  final DateTime? birthday;
  final String address;
  // final String location;
  final Sex sex;
  final Age age;
}

enum Sex { male, female }

enum Age {
  child, // до года
  adult,
  aged, // старше 7 лет
}

enum Wool {
  none,
  short,
  normal,
  long,
}
