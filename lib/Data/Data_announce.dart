import 'package:flutter/material.dart';

class announce extends StatefulWidget {
  const announce({super.key});

  @override
  State<announce> createState() => announceState();
}

class announceState extends State<announce> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 147, 185, 221),
      body: SizedBox(
        width: 250,
        height: 250,
      ),
    );
  }
}