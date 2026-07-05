import 'package:flutter/material.dart';
import '../constants.dart';

class MessageBubble extends StatelessWidget {
  final String? message, sender;
  final bool isMe;

  const MessageBubble({super.key, this.message, this.sender, required this.isMe});

  @override
  Widget build(BuildContext context) {
    const double radius = 30.0;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.only(
            topLeft: isMe ? const Radius.circular(radius) : Radius.zero,
            topRight: isMe ? Radius.zero : const Radius.circular(radius),
            bottomLeft: const Radius.circular(radius),
            bottomRight: const Radius.circular(radius),
          ),
          color: isMe ? Colors.lightBlueAccent : Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  sender ?? 'Unknown',
                  style: const TextStyle(fontSize: 12, color: kChatEmailColor),
                ),
                const SizedBox(height: 8),
                Text(
                  message ?? '',
                  style: TextStyle(
                    fontSize: 16,
                    color: isMe ? Colors.white : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}