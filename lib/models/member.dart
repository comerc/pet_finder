import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:pet_finder/import.dart';

part 'member.g.dart';

@JsonSerializable()
class MemberModel extends Equatable {
  MemberModel({
    this.id,
    this.name,
    this.avatarUrl,
  });

  final String id;
  final String name;
  @JsonKey(nullable: true)
  final String avatarUrl;

  String get avatarUrlOrRobohash =>
      avatarUrl ?? 'https://robohash.org/$id?set=set4';

  @override
  List<Object> get props => [id, name, avatarUrl];

  factory MemberModel.fromJson(Map<String, dynamic> json) =>
      _$MemberModelFromJson(json);

  Map<String, dynamic> toJson() => _$MemberModelToJson(this);
}
