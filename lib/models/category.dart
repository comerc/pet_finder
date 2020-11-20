import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:pet_finder/import.dart';

part 'category.g.dart';

@CopyWith()
@JsonSerializable()
class CategoryModel extends Equatable {
  CategoryModel({
    this.id,
    this.name,
    this.totalOf,
    this.color,
    this.breeds,
  });

  final String id;
  final String name;
  final String color;
  final int totalOf;
  final List<BreedModel> breeds;

  @override
  List<Object> get props => [id, name, color, totalOf, breeds];

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}
