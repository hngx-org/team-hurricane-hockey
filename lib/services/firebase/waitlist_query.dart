import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:team_hurricane_hockey/models/waitlist_req.dart';

class WaitlistQuery {
  WaitlistQuery._();
  static final WaitlistQuery instance = WaitlistQuery._();
  final firestore = FirebaseFirestore.instance;

  Future<bool> checkIntoWaitlist(
    Waitlist userData,
    String id,
  ) async {
    try {
      await firestore.collection("waitlist").doc(id).set(userData.toJson());
      final result = await firestore.collection("waitlist").doc(id).get();

      if (result.exists) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> sendRequest(
    String id,
    String request,
    String gameId,
  ) async {
    try {
      await firestore.collection("waitlist").doc(id).update({
        "isAccepted": true,
        "accepterId": request,
        "gameId": gameId,
      });
      final result = await firestore.collection("waitlist").doc(id).get();

      if (result.exists) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> acceptRequest(
    String id,
    String request,
    String gameId,
  ) async {
    try {
      await firestore.collection("waitlist").doc(id).update({
        "isAccepted": true,
        "accepterId": request,
        "gameId": gameId,
      });
      final result = await firestore.collection("waitlist").doc(id).get();

      if (result.exists) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  deleteUserOnWaitlist(
    String id,
  ) async {
    try {
      await firestore.collection("waitlist").doc(id).delete();
    } catch (_) {}
  }

  Future<bool> removeFromWaitlist(String id) async {
    try {
      await firestore.collection("waitlist").doc(id).delete();
      final result = await firestore.collection("waitlist").doc(id).get();

      if (!result.exists) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
