import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:pet_finder/import.dart';

part 'category.g.dart';

@JsonSerializable()
class CategoryModel extends Equatable {
  CategoryModel({
    required this.id,
    required this.name,
    required this.totalOf,
    required this.color,
    required this.breeds,
  });

  final String id;
  final String name;
  final String color;
  final int totalOf;
  final List<BreedModel> breeds;

  @override
  List<Object> get props => [id, name, color, totalOf, breeds];

  static CategoryModel fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}
