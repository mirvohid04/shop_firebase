import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_test/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirestoreService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<User?> registerWithEmail(String email, String password,String lastName, String firstName,) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;

      if (user != null) {

        await _firestore.collection("users").doc(user.uid).set({
          "uid": user.uid,
          "email": user.email,
          "firstName": firstName,
          "lastName": lastName,
          "createdAt": FieldValue.serverTimestamp(),
        });
      }

      return user;
    } catch (e) {
      return null;
    }
  }
  Future<User?> loginWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await getUserData(result.user!.uid);

      return result.user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> signOut() async {
    final SharedPreferences _sharedPreferences =await SharedPreferences.getInstance();
    _sharedPreferences.clear();
    await _auth.signOut();
  }


  Future getUserData(uid) async {
    final SharedPreferences _sharedPreferences =await SharedPreferences.getInstance();

    final doc = await _firestore.collection("users").doc(uid).get();

      var user = UserModel.fromJson(doc.data());
      var json= jsonEncode(user.toJson());
      _sharedPreferences.setString("user", json);



  }

  Stream<User?> get userChanges => _auth.authStateChanges();
}
