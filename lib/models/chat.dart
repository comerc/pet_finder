import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:pet_finder/import.dart';

part 'chat.g.dart';

@JsonSerializable()
class ChatModel extends Equatable {
  ChatModel({
    this.unit,
    this.companion,
    this.messages,
    // this.isUnitOwnerWritesNow,
    // this.isCompanionWritesNow,
    // this.updatedAt,
    // this.unitOwnerReadCount,
    // this.companionReadCount,
  });

  final UnitModel unit;
  final MemberModel companion;
  final List<MessageModel> messages;
  // final bool isUnitOwnerWritesNow;
  // final bool isCompanionWritesNow;
  // TODO: updatedAt - как в gmail, обновленные элементы в ChatList нужно переставлять на клиенте
  // final DateTime updatedAt;
  // final int unitOwnerReadCount;
  // final int companionReadCount;

  String get id => '${unit.id} ${companion.id}';

  @override
  List<Object> get props => [
        // id, // TODO: поле лишнее?
        unit,
        companion,
        messages,
      ];

  static ChatModel fromJson(Map<String, dynamic> json) =>
      _$ChatModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatModelToJson(this);
}
