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
  });

  final String id;
  final String name;
  final int totalOf;

  @override
  List<Object> get props => [id, name, totalOf];

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}

enum CategoryValue {
  hamster,
  bunny,
  cat,
  dog,
}
