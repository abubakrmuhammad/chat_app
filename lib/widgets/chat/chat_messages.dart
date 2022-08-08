import 'package:chat_app/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (chatSnapshot.hasData) {
          final messages = chatSnapshot.data!.docs;
          final currentUserId = FirebaseAuth.instance.currentUser?.uid;

          return ListView.builder(
            reverse: true,
            itemCount: messages.length,
            itemBuilder: (context, index) => MessageBubble(
              text: messages[index]['text'],
              username: messages[index]['username'],
              isMe: messages[index]['userId'] == currentUserId,
              key: ValueKey(messages[index].id),
            ),
          );
        }

        return const Center(child: Text('No messages'));
      },
    );
  }
}
