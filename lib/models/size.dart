import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
// import 'package:pet_finder/import.dart';

part 'size.g.dart';

@JsonSerializable()
class SizeModel extends Equatable {
  SizeModel({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  @override
  List<Object> get props => [id, name];

  static SizeModel fromJson(Map<String, dynamic> json) =>
      _$SizeModelFromJson(json);

  Map<String, dynamic> toJson() => _$SizeModelToJson(this);
}
