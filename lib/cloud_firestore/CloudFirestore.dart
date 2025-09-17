import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LikePage extends StatefulWidget {
  const LikePage({super.key});

  @override
  State<LikePage> createState() => _LikePageState();
}

class _LikePageState extends State<LikePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String postId = "post1"; // biz ishlatayotgan hujjat ID

  @override
  void initState() {
    super.initState();
    final docRef = _firestore.collection("posts").doc(postId);

    // Agar hujjat bo‘lmasa, likes = 0 qilib qo‘yamiz
    docRef.get().then((doc) {
      if (!doc.exists) {
        docRef.set({"likes": 0});
      }
    });
  }

  Future<void> incrementLike() async {
    final docRef = _firestore.collection("posts").doc(postId);

    await docRef.set({
      "likes": FieldValue.increment(1),
    }, SetOptions(merge: true));
  }

  Future<void> decrementLike() async {
    final docRef = _firestore.collection("posts").doc(postId);

    await docRef.set({
      "likes": FieldValue.increment(-1),
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Firestore Like System")),
      body: Center(
        child: StreamBuilder<DocumentSnapshot>(
          stream: _firestore.collection("posts").doc(postId).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }

            if (!snapshot.data!.exists) {
              return const Text("Post yuq");
            }

            var data = snapshot.data!;
            int likes = data["likes"] ?? 0;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Likes: $likes",
                    style: const TextStyle(fontSize: 24, color: Colors.green)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: incrementLike,
                  child: const Text("👍 Like"),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: decrementLike,
                  child: const Text("👎 Unlike"),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
