class Conversation {
  int? id;
  String? title;
  String? gptId;
  DateTime? updatedAt;

  Conversation({
    this.id,
    this.title,
    this.gptId,
    this.updatedAt,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
        id: json["id"],
        title: json["title"],
        gptId: json["gpt_id"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "gpt_id": gptId,
        "updated_at": updatedAt?.toIso8601String(),
      };
}
