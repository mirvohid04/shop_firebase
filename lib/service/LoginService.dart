import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      return result.user;
    } catch (e) {
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }


  Future<Map<String, dynamic>> getUserData() async {
      final doc = await _firestore.collection("users").doc("user123").get();
     return doc.data() as Map<String, dynamic>;



  }

  Stream<User?> get userChanges => _auth.authStateChanges();
}
