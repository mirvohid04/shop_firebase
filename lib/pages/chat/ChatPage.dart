  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:flutter/material.dart';
  import '../../service/realtime_database/ChatService.dart';

  class ChatPage extends StatefulWidget {
    const ChatPage({super.key});

    @override
    _ChatPageState createState() => _ChatPageState();
  }

  class _ChatPageState extends State<ChatPage> {
    final TextEditingController _messageController = TextEditingController();
    final ChatService _chatService = ChatService();
    final ScrollController _scrollController = ScrollController();

    late String currentUserId;

    @override
    void initState() {
      super.initState();
      currentUserId = FirebaseAuth.instance.currentUser!.uid;
    }





    @override
    Widget build(BuildContext context) {
      Size size = MediaQuery.of(context).size;
      return Scaffold(
        appBar: AppBar(title: Text('Chat'), backgroundColor: Colors.blueGrey.shade400),
        body: Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/images/olti.jpg"),fit: BoxFit.cover)
          ),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: StreamBuilder<Map<dynamic, dynamic>>(
                    stream: _chatService.getMessages(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      } else {
                        if(snapshot.data==null){
                          return Text("Hozircha xabarlar mavjud emas");
                        }
                        return ListView.builder(
                          reverse: true,
          
          
                          controller: _scrollController,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            var entries = snapshot.data!.entries.toList();
                            entries.sort((a, b) =>
                                (b.value['timestamp'] as int).compareTo(a.value['timestamp'] as int));
                              var messageId = entries[index].key;
                            var message = entries[index].value['text'];
          
                            var senderId = entries[index].value['userId'];
                            bool isMe = senderId == currentUserId;
          
                            return InkWell(
                              onLongPress: (){
                                _chatService.deleteMessage(messageId);
                              },
                              child: Align(
                                alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical:1),
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxWidth: size.width*0.8,
          
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 6),
          
                                      decoration: BoxDecoration(
                                        color: isMe ? Colors.blue[300] : Colors.grey[300],
                                        borderRadius: BorderRadius.circular(12),
          
                                      ),
                                      child: Text(message.toString(),style: TextStyle(
                                        fontSize: 16,
                                        height: 1.2
                                      ),),),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 12),
                color: Colors.green,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        maxLines: 6,
                        minLines: 1,
          
                        decoration: InputDecoration(
                          hintText: 'Xabar yozing...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    IconButton(
                      icon: Icon(Icons.send, color: Colors.blue),
                      onPressed: () {
                        if (_messageController.text.isNotEmpty) {
                         _chatService.sendMessage( _messageController.text,  currentUserId,
                          );
                          _messageController.clear();
          
                            if (_scrollController.hasClients) {
                              _scrollController.animateTo(
                                0.0,
                                duration: Duration(milliseconds: 10),
                                curve: Curves.easeOut,
                              );
                            }
          
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
