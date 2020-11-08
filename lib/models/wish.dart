import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:pet_finder/import.dart';

part 'wish.g.dart';

@CopyWith()
@JsonSerializable()
class WishModel extends Equatable {
  WishModel({
    this.member,
    this.unit,
    this.value,
  });

  final MemberModel member;
  final UnitModel unit;
  final bool value;

  String get id => '${member.id} ${unit.id}';

  @override
  List<Object> get props => [
        // id, // TODO: поле лишнее?
        member,
        unit,
        value,
      ];

  factory WishModel.fromJson(Map<String, dynamic> json) =>
      _$WishModelFromJson(json);

  Map<String, dynamic> toJson() => _$WishModelToJson(this);
}
