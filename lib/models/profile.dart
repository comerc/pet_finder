import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:pet_finder/import.dart';

part 'profile.g.dart';

@CopyWith()
@JsonSerializable()
class ProfileModel extends Equatable {
  ProfileModel({this.wishes});

  final List<ProfileWishModel> wishes;

  @override
  List<Object> get props => [
        wishes,
      ];

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);
}
