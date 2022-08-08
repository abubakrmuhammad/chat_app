import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String _text;
  final String _username;
  final bool _isMe;

  const MessageBubble({
    required text,
    required username,
    required isMe,
    Key? key,
  })  : _text = text,
        _username = username,
        _isMe = isMe,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment:
          _isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          width: 140,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            color: _isMe ? Theme.of(context).primaryColor : Colors.grey[300],
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: const Radius.circular(20),
              bottomLeft: !_isMe ? Radius.zero : const Radius.circular(20),
              bottomRight: _isMe ? Radius.zero : const Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment:
                _isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 24,
                child: Text(
                  _username,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _isMe ? Colors.white : Colors.black,
                  ),
                  textAlign: _isMe ? TextAlign.end : TextAlign.start,
                ),
              ),
              Text(
                _text,
                style: TextStyle(
                  color: _isMe ? Colors.white : Colors.black,
                  fontSize: 16,
                ),
                textAlign: _isMe ? TextAlign.end : TextAlign.start,
              ),
            ],
          ),
        )
      ],
    );
  }
}
