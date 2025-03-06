import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //    Expanded(
            //   child: ListView.separated(...), // <- Chat list view
            // ),
            //  _BottomInputField(), // <- Fixed bottom TextField widget
          ],
        ),
      ),
    );
  }
}
