import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:pet_finder/import.dart';

part 'wish.g.dart';

@JsonSerializable()
class WishModel extends Equatable {
  WishModel({
    this.unit,
    // this.updatedAt, // TODO: это лишнее
    this.value, // всегда true, поле надо для saveWish
  });

  final UnitModel unit;
  // final DateTime updatedAt;
  final bool value;

  @override
  List<Object> get props => [
        unit,
        // updatedAt,
        value,
      ];

  factory WishModel.fromJson(Map<String, dynamic> json) =>
      _$WishModelFromJson(json);

  Map<String, dynamic> toJson() => _$WishModelToJson(this);
}
