import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_test/models/user_model.dart';
import 'package:firebase_test/service/LoginService.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  final FirestoreService _firestoreService = FirestoreService();
  final User? currentUser = FirebaseAuth.instance.currentUser;
  UserModel userModel = UserModel();
  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 200),
            Text(
              currentUser != null ? "${currentUser!.uid}" : "",
              style: TextStyle(color: Colors.green, fontSize: 22),
            ),

            IconButton(
              onPressed: () {
                //Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>TestPage()));
                print("${currentUser!.uid}");
              },
              icon: Icon(Icons.favorite, size: 40),
            ),
            Text(userModel.firstName.toString()),
          ],
        ),
      ),
    );
  }

  Future _load() async {
    var sharedPreference = await SharedPreferences.getInstance();
    var json = await sharedPreference.getString("user");

    var map = jsonDecode(json!);
    print(map);
    userModel = UserModel.fromJson(map);
    setState(() {});
  }
}
