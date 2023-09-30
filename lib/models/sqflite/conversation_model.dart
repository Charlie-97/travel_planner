import 'package:travel_planner/models/sqflite/message.dart';

class ConversationModel {
  int? id;
  String? gptId;
  List<LocalMessage>? messages;
  LocalMessage? mostRecent;
  String? title;
  DateTime? updatedAt;

  ConversationModel({
    this.id,
    this.gptId,
    this.messages,
    this.mostRecent,
    this.title,
    this.updatedAt,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) => ConversationModel(
        id: json["id"],
        gptId: json["gpt_id"],
        messages: [],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "gpt_id": gptId,
        "title": title,
        "updated_at": updatedAt?.toIso8601String(),
      };
}
