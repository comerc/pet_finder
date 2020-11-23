import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
// import 'package:pet_finder/import.dart';

part 'member.g.dart';

@JsonSerializable()
class MemberModel extends Equatable {
  MemberModel({
    this.id,
    this.displayName,
    this.imageUrl,
  });

  final String id;
  @JsonKey(nullable: true)
  final String displayName;
  @JsonKey(nullable: true)
  final String imageUrl;

  String get validImageUrl => imageUrl ?? 'https://robohash.org/$id?set=set4';

  String get validDisplayName => displayName ?? 'John Doe';

  @override
  List<Object> get props => [id, displayName, imageUrl];

  factory MemberModel.fromJson(Map<String, dynamic> json) =>
      _$MemberModelFromJson(json);

  Map<String, dynamic> toJson() => _$MemberModelToJson(this);
}
