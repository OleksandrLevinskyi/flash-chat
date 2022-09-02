import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/widgets/message_bubble.dart';
import 'package:flutter/material.dart';

class MessageStream extends StatelessWidget {
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }

        final messages = snapshot.data.docs;
        final messageBubbles = messages.map((message) {
          final messageData = message.data() as Map;
          final text = messageData['text'];
          final sender = messageData['sender'];

          return MessageBubble(text, sender);
        }).toList();

        return Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}
