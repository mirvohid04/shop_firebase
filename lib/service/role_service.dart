import 'dart:convert';

import 'package:flutter/services.dart';

class UserService {
  Future<void> loadUsers() async {
    String jsonString = await rootBundle.loadString('assets/users.json');
    Map<String, dynamic> data = jsonDecode(jsonString);

    data.forEach((uid, userData) {
      print("UID: $uid, Email: ${userData['email']}, Role: ${userData['role']}");
    });
  }
}
