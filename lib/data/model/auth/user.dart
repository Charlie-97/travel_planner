class AppUser {
  String? createdAt;
  int? credits;
  String? email;
  String? id;
  String? name;
  String? updatedAt;

  AppUser({
    this.createdAt,
    this.credits,
    this.email,
    this.id,
    this.name,
    this.updatedAt,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        createdAt: json["created_at"],
        credits: json["credits"],
        email: json["email"],
        id: json["id"],
        name: json["name"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "created_at": createdAt,
        "credits": credits,
        "email": email,
        "id": id,
        "name": name,
        "updated_at": updatedAt,
      };
}
