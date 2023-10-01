class LocalMessage {
  String? id;
  String? conversationId;
  String? message;
  String? sentBy;
  String? imageUrl;
  DateTime? createdAt;

  LocalMessage({
    this.id,
    this.conversationId,
    this.message,
    this.sentBy,
    this.createdAt,
    this.imageUrl,
  });

  factory LocalMessage.fromJson(Map<String, dynamic> json) => LocalMessage(
        id: json["id"],
        conversationId: json["conversation_id"],
        message: json["message"],
        sentBy: json["sent_by"],
        imageUrl: json["image_url"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "conversation_id": conversationId,
        "message": message,
        "sent_by": sentBy,
        "image_url": imageUrl,
        "created_at": createdAt?.toIso8601String(),
      };
}
