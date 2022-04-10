import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:built_collection/built_collection.dart';
import 'package:pet_finder/import.dart';

part 'unit.g.dart';

@JsonSerializable()
class UnitModel extends Equatable {
  UnitModel({
    required this.id,
    required this.member,
    required this.images,
    required this.title, // 70 symbols
    required this.sex,
    this.birthday,
    required this.age, // используется, когда birthday is null; иначе калькулируется
    this.weight,
    required this.size, // используется, когда weight is null; иначе калькулируется
    required this.wool,
    required this.color,
    required this.story, // kufar - min 20, avito - без ограничений
    this.phone, // если парсинг объявлений с других сайтов
    required this.address, // 70 symbols
    // required this.location, // TODO: location
    // TODO: [MVP] пожаловаться, что неактуально + убирать закрытые при повторном парсинге
    // this.source // TODO: откуда спарсил
    required this.wishesCount, // TODO: [MVP] добавить хранимую пороцедуру для хранения денормализованного значения
  });

  final String id;
  final MemberModel member;
  final BuiltList<ImageModel> images;
  final String title;
  final SexValue sex;
  final DateTime? birthday;
  final AgeValue age;
  final int? weight;
  final SizeModel size;
  final WoolValue wool;
  final ColorModel color;
  final String story;
  final String? phone;
  final String address;
  // final String location;
  final int wishesCount;

  @override
  List<Object?> get props => [
        id,
        member,
        images,
        title,
        sex,
        birthday,
        age,
        weight,
        size,
        wool,
        color,
        story,
        address,
        // location,
        wishesCount,
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
