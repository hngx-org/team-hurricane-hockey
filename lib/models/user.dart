class UserData {
  final String? image;
  final String? email;
  final String? id;
  final String? name;

  UserData({
    this.image,
    this.email,
    this.id,
    this.name,
  });

  UserData copyWith({
    String? image,
    String? email,
    String? id,
    String? name,
  }) =>
      UserData(
        image: image ?? this.image,
        email: email ?? this.email,
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        image: json["image"],
        email: json["email"],
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "email": email,
        "id": id,
        "name": name,
      };
}
