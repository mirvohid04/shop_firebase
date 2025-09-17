import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_test/Page.dart';
import 'package:firebase_test/service/LoginService.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService _firestoreService=FirestoreService();
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 200,),
            Text(currentUser!=null?"${currentUser!.uid}":"",style: TextStyle(color: Colors.green,fontSize: 22),),

            IconButton(onPressed: (){
              //Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>TestPage()));
              print("${currentUser!.uid}");
            }, icon: Icon(Icons.favorite,size: 40,)),
            Text(""),


            
          ],

        ),
      ),
    );
  }
}
