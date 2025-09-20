import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_test/Page.dart';
import 'package:firebase_test/cloud_firestore/CloudFirestore.dart';
import 'package:firebase_test/pages/HomePage.dart';
import 'package:firebase_test/pages/LoginPage.dart';
import 'package:firebase_test/pages/chat/ChatPage.dart';
import 'package:firebase_test/service/role_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

void main() async{

 WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home:LoginPage(),
    );
  }
}

class RolePage extends StatefulWidget {
  const RolePage({super.key});

  @override
  State<RolePage> createState() => _RolePageState();
}

class _RolePageState extends State<RolePage> {
  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Account tanlash")),
      body: Column(
        children: [
          RadioListTile<String>(
            title: const Text("User"),
            value: "user",
            groupValue: selectedRole,
            onChanged: (value) {
              setState(() {
                selectedRole = value;
              });
            },
          ),
          RadioListTile<String>(
            title: const Text("Admin"),
            value: "admin",
            groupValue: selectedRole,
            onChanged: (value) {
              setState(() {
                selectedRole = value;
              });
            },
          ),
          ElevatedButton(
            onPressed: () {
              if (selectedRole != null) {
                print("Tanlangan role: $selectedRole");

                if (selectedRole == "admin") {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const HomePage()));
                } else {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const ChatPage()));
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Avval account turini tanlang")),
                );
              }
            },
            child: const Text("Davom etish"),
          ),
        ],
      ),
    );
  }
}


