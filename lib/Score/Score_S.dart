import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Home/homeS.dart';
import 'package:flutter_esclass_2/Login/login.dart';
import 'package:flutter_esclass_2/Model/Chat.dart';
import 'package:flutter_esclass_2/Model/appbar_students.dart';
import 'package:flutter_esclass_2/Profile/ProfileS.dart';


class Score_S extends StatefulWidget {
  const Score_S({super.key});

  @override
  State<Score_S> createState() => _Score_SState();
}

class _Score_SState extends State<Score_S> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 152, 186, 218),
        title: Text('Edueliteroom'),
        actions: [
          appbarstudents(context)
        ],
        ),
    );
  }
}