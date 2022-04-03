import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:pet_finder/import.dart';

part 'unit.g.dart';

@JsonSerializable()
class UnitModel extends Equatable {
  UnitModel({
    required this.id,
    required this.title, // 70 symbols
    required this.color,
    required this.wool,
    this.weight,
    required this.size, // используется, когда weight is null; иначе калькулируется
    required this.story,
    required this.member,
    required this.imageUrl,
    this.birthday,
    required this.address, // 70 symbols
    // required this.location, // TODO: location
    required this.sex,
    required this.age, // используется, когда birthday is null; иначе калькулируется
  });

  final String id;
  final String title;
  final ColorModel color;
  final WoolValue wool;
  final int? weight;
  final SizeModel size;
  final String story;
  final MemberModel member;
  final String imageUrl;
  final DateTime? birthday;
  final String address;
  // final String location;
  final SexValue sex; //
  final AgeValue age; //

  @override
  List<Object?> get props => [
        id,
        title,
        color,
        wool,
        weight,
        size,
        story,
        member,
        imageUrl,
        birthday,
        address,
        // location,
        sex,
        age,
      ];

  static UnitModel fromJson(Map<String, dynamic> json) =>
      _$UnitModelFromJson(json);

  Map<String, dynamic> toJson() => _$UnitModelToJson(this);
}

// TODO: для обобщения Enum можно применить class MyClass<T extends Enum> {}

enum SexValue { male, female }

String getSexName(SexValue value) {
  final map = {
    SexValue.male: 'Male',
    SexValue.female: 'Female',
  };
  assert(SexValue.values.length == map.length);
  return map[value]!;
}

enum AgeValue {
  child, // до года
  adult,
  aged, // старше 7 лет
}

String getAgeName(AgeValue value) {
  final map = {
    AgeValue.child: 'Child',
    AgeValue.adult: 'Adult',
    AgeValue.aged: 'Aged',
  };
  assert(AgeValue.values.length == map.length);
  return map[value]!;
}

enum WoolValue {
  short,
  normal,
  long,
}

String getWoolName(WoolValue value) {
  final map = {
    WoolValue.short: 'Short',
    WoolValue.normal: 'Normal',
    WoolValue.long: 'Long',
  };
  assert(WoolValue.values.length == map.length);
  return map[value]!;
}
