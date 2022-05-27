import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
// import 'package:pet_finder/import.dart';

part 'member.g.dart';

@JsonSerializable()
class MemberModel extends Equatable {
  MemberModel({
    required this.id,
    this.displayName,
    this.imageUrl,
    required this.phone,
    required this.isWhatsApp,
    required this.isViber,
    // TODO: telegram
  });

  final String id;
  final String? displayName;
  final String? imageUrl;
  final String phone;
  final bool isWhatsApp;
  final bool isViber;

  // TODO: проксировать URL
  String get validImageUrl => imageUrl ?? id;
  String get validDisplayName => displayName ?? 'John Doe';

  @override
  List<Object?> get props => [id, displayName, imageUrl];

  static MemberModel fromJson(Map<String, dynamic> json) =>
      _$MemberModelFromJson(json);

  Map<String, dynamic> toJson() => _$MemberModelToJson(this);
}
