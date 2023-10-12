class Waitlist {
  final String? image;
  final String? email;
  final String? id;
  final String? name;
  final String? gameId;
  final bool? isReady;
  final bool? isAccepted;
  final String? accepterId;

  Waitlist({
    this.image,
    this.email,
    this.id,
    this.name,
    this.gameId,
    this.isReady,
    this.isAccepted,
    this.accepterId,
  });

  factory Waitlist.fromJson(Map<String, dynamic> json) => Waitlist(
        image: json["image"],
        email: json["email"],
        id: json["id"],
        name: json["name"],
        gameId: json["gameId"],
        isReady: json["isReady"],
        isAccepted: json["isAccepted"],
        accepterId: json["accepterId"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "email": email,
        "id": id,
        "name": name,
        "gameId": gameId,
        "isReady": isReady,
        "isAccepted": isAccepted,
        "accepterId": accepterId,
      };
}
