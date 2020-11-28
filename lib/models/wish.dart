import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:pet_finder/import.dart';

part 'wish.g.dart';

@JsonSerializable()
class WishModel extends Equatable {
  WishModel({
    this.unit,
  });

  final UnitModel unit;

  @override
  List<Object> get props => [
        unit,
      ];

  static WishModel fromJson(Map<String, dynamic> json) =>
      _$WishModelFromJson(json);

  Map<String, dynamic> toJson() => _$WishModelToJson(this);
}
