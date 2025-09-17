import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _HomePageState();
}

class _HomePageState extends State<TestPage> {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPassCtrl = TextEditingController();
  final TextEditingController _newPassCtrl = TextEditingController();
  final TextEditingController _confirmPassCtrl = TextEditingController();

  bool _loading = false;
  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _oldPassCtrl.dispose();
    _newPassCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (currentUser == null) {
      _showSnack("Foydalanuvchi topilmadi");
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    final email = currentUser!.email!;
    final oldPassword = _oldPassCtrl.text.trim();
    final newPassword = _newPassCtrl.text.trim();

    setState(() => _loading = true);

    try {
      // 1) Reauthenticate
      final credential = EmailAuthProvider.credential(
        email: email,
        password: oldPassword,
      );
      await currentUser!.reauthenticateWithCredential(credential);

      // 2) Update password
      await currentUser!.updatePassword(newPassword);

      _showSnack("Parol muvaffaqiyatli yangilandi");
      _oldPassCtrl.clear();
      _newPassCtrl.clear();
      _confirmPassCtrl.clear();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        _showSnack("Eski parol noto'g'ri");
      } else if (e.code == 'weak-password') {
        _showSnack("Yangi parol juda zaif (kamida 6 belgidan ko'p bo'lsin)");
      } else if (e.code == 'requires-recent-login') {
        _showSnack("Xavfsizlik uchun qayta login qilish talab etiladi");
        // bu holatda foydalanuvchini login sahifasiga yo'naltirish kerak
      } else {
        _showSnack("Xatolik: ${e.message}");
      }
    } catch (e) {
      _showSnack("Noma'lum xato: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _sendResetEmail() async {
    final email = currentUser?.email;
    if (email == null) {
      _showSnack("Email topilmadi");
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _showSnack("Parolni tiklash havolasi $email ga yuborildi");
    } on FirebaseAuthException catch (e) {
      _showSnack("Xato: ${e.message}");
    } catch (e) {
      _showSnack("Noma'lum xato: $e");
    }
  }

  void _showSnack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                currentUser?.email ?? "Foydalanuvchi topilmadi",
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Old password
                    TextFormField(
                      controller: _oldPassCtrl,
                      obscureText: _obscureOld,
                      decoration: InputDecoration(
                        labelText: "Eski parol",
                        suffixIcon: IconButton(
                          icon: Icon(
                              _obscureOld ? Icons.visibility : Icons.visibility_off),
                          onPressed: () => setState(() => _obscureOld = !_obscureOld),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return "Eski parolni kiriting";
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // New password
                    TextFormField(
                      controller: _newPassCtrl,
                      obscureText: _obscureNew,
                      decoration: InputDecoration(
                        labelText: "Yangi parol",
                        suffixIcon: IconButton(
                          icon: Icon(
                              _obscureNew ? Icons.visibility : Icons.visibility_off),
                          onPressed: () => setState(() => _obscureNew = !_obscureNew),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return "Yangi parolni kiriting";
                        if (v.length < 6) return "Parol kamida 6 belgidan iborat bo'lishi kerak";
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // Confirm new password
                    TextFormField(
                      controller: _confirmPassCtrl,
                      obscureText: _obscureConfirm,
                      decoration: InputDecoration(
                        labelText: "Yangi parolni tasdiqlang",
                        suffixIcon: IconButton(
                          icon: Icon(_obscureConfirm ? Icons.visibility : Icons.visibility_off),
                          onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return "Iltimos, tasdiqlang";
                        if (v != _newPassCtrl.text) return "Parollar mos emas";
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    _loading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                      onPressed: _changePassword,
                      child: const Text("Parolni o'zgartirish"),
                    ),

                    TextButton(
                      onPressed: _sendResetEmail,
                      child: const Text("Parolni unutdingizmi? (Reset email yuborish)"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
