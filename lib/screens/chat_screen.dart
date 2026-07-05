import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat_starting_project/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat_starting_project/constants.dart';
import '../components/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _firestore = FirebaseFirestore.instance;
  final TextEditingController _messageTextController = TextEditingController();
  final AuthService _auth = AuthService();

  @override
  void dispose() {
    _messageTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await _auth.signOut();
                if (!mounted) return;
                Navigator.pop(context);
              }),
        ],
        title: const Text('⚡ ️Chat'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: MessageStream(firestore: _firestore),
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _messageTextController,
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      final messageText = _messageTextController.text;
                      if (messageText.isNotEmpty) {
                        _firestore.collection('messages').add({
                          'text': messageText,
                          'sender': _auth.getCurrentUser?.email,
                          'date': FieldValue.serverTimestamp(),
                        });
                        _messageTextController.clear();
                      }
                    },
                    child: const Icon(Icons.send,
                        size: 30, color: kSendButtonColor),
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

class MessageStream extends StatelessWidget {
  const MessageStream({
    super.key,
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      // Order by date to show messages chronologically
      stream: _firestore.collection('messages').orderBy('date').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlue,
            ),
          );
        }
        if (snapshot.hasData) {
          // Reverse the data to show latest messages at the bottom
          final messages = snapshot.data!.docs.reversed;
          List<Widget> messageWidgets = [];

          for (var message in messages) {
            final data = message.data() as Map<String, dynamic>;
            final messageText = data['text'];
            final sender = data['sender'];

            final messageBubble = MessageBubble(
                message: messageText,
                sender: sender,
              isMe: AuthService().getCurrentUser!.email == sender
            );

            messageWidgets.add(messageBubble);
          }
          return ListView(
            reverse: true, // This puts the scroll at the bottom
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: messageWidgets,
          );
        } else {
          return const Center(
            child: Text('No messages yet.'),
          );
        }
      },
    );
  }
}