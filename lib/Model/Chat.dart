
import 'package:flutter/material.dart';

class Chat extends StatelessWidget {
  const Chat({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat',
      home: Chat_classs(),
    );
  }
}
class Chat_classs extends StatefulWidget {
  const Chat_classs({super.key});

  @override
  State<Chat_classs> createState() => _Chat_classsState();
}

class _Chat_classsState extends State<Chat_classs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}