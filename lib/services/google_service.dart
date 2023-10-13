import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:tuple/tuple.dart';

class AuthRepository {
  AuthRepository._();
  static final AuthRepository instance = AuthRepository._();

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Tuple3<User?, String?, String?>> googleAuth() async {
    try {
      User? user;
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        await _auth.signInWithCredential(credential);
        user = _auth.currentUser;

        if (user != null) {
          return Tuple3(user, "success", googleSignInAuthentication.accessToken);
        }
        return const Tuple3(null, "Oops something went wrong", null);
      }

      return const Tuple3(null, "Oops something went wrong", null);
    } catch (e) {
      debugPrint(e.toString());
      return Tuple3(null, e.toString(), null);
    }
  }

  Future<Tuple2<GoogleSignInAccount?, String?>> logOut() async {
    try {
      final s = await _googleSignIn.signOut();
      await _auth.signOut();
      if (s == null) {
        /// Sign out is successful if you receive a null value from the google sign in account
        return const Tuple2(null, null);
      }
      return Tuple2(s, "Oops something went wrong");
    } catch (e) {
      return Tuple2(null, e.toString());
    }
  }
}
