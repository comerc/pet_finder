import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:built_collection/built_collection.dart';
import 'package:pet_finder/import.dart';

part 'edit_unit.g.dart';

@JsonSerializable()
class EditUnitModel extends Equatable {
  EditUnitModel({
    required this.sizes,
    required this.colors,
  });

  // final SexValue sex;
  // final AgeValue age;
  final List<SizeModel> sizes;
  // final WoolValue wool;
  final List<ColorModel> colors;

  @override
  List<Object?> get props => [
        sizes,
        colors,
      ];

  static EditUnitModel fromJson(Map<String, dynamic> json) =>
      _$EditUnitModelFromJson(json);

  // Map<String, dynamic> toJson() => _$EditUnitModelToJson(this);
}
