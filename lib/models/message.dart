import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
// import 'package:pet_finder/import.dart';

part 'message.g.dart';

@JsonSerializable()
class MessageModel extends Equatable {
  MessageModel({
    required this.id,
    required this.text,
    required this.author,
    required this.isRead,
    required this.createdAt,
  });

  final String id;
  final String text;
  final MessageAuthor author;
  final bool isRead;
  final DateTime createdAt;

  @override
  List<Object> get props => [id, text, author, isRead, createdAt];

  static MessageModel fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageModelToJson(this);
}

enum MessageAuthor {
  @JsonValue('unit_owner')
  unitOwner,
  companion,
}
