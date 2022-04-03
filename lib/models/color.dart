import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
// import 'package:pet_finder/import.dart';

part 'color.g.dart';

@JsonSerializable()
class ColorModel extends Equatable {
  ColorModel({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  @override
  List<Object> get props => [id, name];

  static ColorModel fromJson(Map<String, dynamic> json) =>
      _$ColorModelFromJson(json);

  Map<String, dynamic> toJson() => _$ColorModelToJson(this);
}
