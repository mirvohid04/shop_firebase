import 'package:firebase_test/pages/LoginPage.dart';
import 'package:firebase_test/service/LoginService.dart';
import 'package:flutter/material.dart';

import 'HomePage.dart';

class Signpage extends StatefulWidget {
  const Signpage({super.key});

  @override
  State<Signpage> createState() => _SignpageState();
}

class _SignpageState extends State<Signpage> {
  final FirestoreService _firestoreService = FirestoreService();

  final _formKey = GlobalKey<FormState>();

  final _email = TextEditingController();
  final _password = TextEditingController();
  final _lastName= TextEditingController();
  final _firstName= TextEditingController();

      bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "O'tkazish>",
                      style: TextStyle(color: Color(0xff20B9E8), fontSize: 13),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Ilovaga kirish",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "Logosmart ilovasiga Xush kelibsiz!",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                  SizedBox(height: 30),
                  Text(
                    "Email",
                    style: TextStyle(color: Colors.grey.shade900, fontSize: 13),
                  ),
                  SizedBox(height: 4),

                  _buildTextField(_email, "Email"),
                  SizedBox(height: 20),
                  Text(
                    "Ism",
                    style: TextStyle(color: Colors.grey.shade900, fontSize: 13),
                  ),
                  SizedBox(height: 4),

                  _buildTextField(_firstName, "Ism"),
                  SizedBox(height: 20),
                  Text(
                    "Familiya",
                    style: TextStyle(color: Colors.grey.shade900, fontSize: 13),
                  ),
                  SizedBox(height: 4),

                  _buildTextField(_lastName, "Familiya"),
                  SizedBox(height: 20),
                  Text(
                    "Parol",
                    style: TextStyle(color: Colors.grey.shade900, fontSize: 13),
                  ),
                  SizedBox(height: 4),

                  _buildTextField(
                    _password,
                    "Parol",
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(height: size.height * 0.315),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            final user = await _firestoreService
                                .registerWithEmail(
                                  _email.text.trim(),
                                  _password.text.trim(),
                              _firstName.text.trim(),
                              _lastName.text.trim(),
                                );

                            if (user != null) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ),
                              );
                            }
                          } catch (e) {
                            print(e);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(e.toString()),
                              ), // ✅ endi aniq xabar chiqadi
                            );
                          }
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Color(0xff20B9E8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        "Kirish",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    hint, {
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
      cursorColor: Colors.grey.shade700,
      cursorHeight: 16,
      cursorWidth: 1.5,
      cursorRadius: Radius.zero,
      controller: controller,
      obscureText: obscureText,
      validator: (val) =>
          val == null || val.isEmpty ? "$hint to'ldirilishi shart" : null,
      decoration: InputDecoration(
        labelStyle: TextStyle(color: Colors.red),
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 13, horizontal: 12),
        suffixIcon: suffixIcon,
        suffixIconColor: Colors.grey.shade600,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.blue.shade200, width: 1.8),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.red.shade300, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.red.shade400, width: 1.8),
        ),
        errorStyle: TextStyle(
          fontSize: 11,
          height: 0.8,
          color: Colors.red.shade400,
        ),
      ),
    );
  }
}
