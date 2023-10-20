import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:team_hurricane_hockey/models/user.dart';
import 'package:tuple/tuple.dart';

class UserQuery {
  UserQuery._();
  static final UserQuery instance = UserQuery._();
  final firestore = FirebaseFirestore.instance;

  Future<Tuple2<UserData?, String?>> getUser(String userId) async {
    try {
      final result = await firestore.collection("users").doc(userId).get();
      if (result.exists) {
        if (result.data() != null) {
          final user = UserData.fromJson(result.data()!);
          return Tuple2(user, null);
        }
        return const Tuple2(null, "Oops something happened, try again");
      } else {
        return const Tuple2(null, "Oops something happened, try again");
      }
    } catch (e) {
      return Tuple2(null, e.toString());
    }
  }

  Future<bool> saveUser(UserData user) async {
    try {
      final check = await firestore.collection("users").doc(user.id).get();
      if (check.exists) {
        return true;
      } else {
        await firestore.collection("users").doc(user.id).set(user.toJson());
        final result = await firestore.collection("users").doc(user.id).get();
        if (result.exists) {
          return true;
        } else {
          return false;
        }
      }
    } catch (e) {
      return false;
    }
  }
}
