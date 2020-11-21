import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:pet_finder/import.dart';

part 'profile_wish.g.dart';

@JsonSerializable()
class ProfileWishModel extends Equatable {
  ProfileWishModel({this.unitId});

  final String unitId;

  @override
  List<Object> get props => [
        unitId,
      ];

  factory ProfileWishModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileWishModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileWishModelToJson(this);
}
