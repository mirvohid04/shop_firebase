import 'package:firebase_database/firebase_database.dart';

class ChatService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();


  final databaseReference = FirebaseDatabase.instance.ref("messages");

  void sendMessage(String messageContent, String userId) {
    databaseReference.push().set({
      'text': messageContent,
      'userId': userId,
      'timestamp': ServerValue.timestamp, // Firebase provides a server-side timestamp
    }).then((_) {
      print("Message sent successfully!");
    }).catchError((error) {
      print("Failed to send message: $error");
    });
  }

  Stream<Map<dynamic, dynamic>> getMessages() {
    return _db.child('messages').orderByChild('timestamp').limitToLast(50).onValue.map((DatabaseEvent event) {
      print(event.snapshot.value);
      return event.snapshot.value as Map<dynamic, dynamic>? ?? {};
    });
  }

  Future<void> deleteMessage(String messageId) async {
    await _db.child('messages').child(messageId).remove();
  }

}