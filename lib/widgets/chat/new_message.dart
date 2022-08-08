import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  String _messageEntered = '';
  final _textController = TextEditingController();

  void _sendMessage() {
    FirebaseFirestore.instance.collection('chat').add({
      'text': _messageEntered,
      'createdAt': Timestamp.now(),
    });

    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration:
                  const InputDecoration(labelText: 'Enter a message...'),
              onChanged: (value) {
                setState(() {
                  _messageEntered = value.trim();
                });
              },
            ),
          ),
          IconButton(
            onPressed: _messageEntered.isEmpty
                ? null
                : () {
                    _sendMessage();
                  },
            icon: const Icon(Icons.send),
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
