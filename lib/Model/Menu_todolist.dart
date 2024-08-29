import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Data/Data_todolist.dart';
import 'package:flutter_esclass_2/Home/Even.dart';

class MenuTodolist extends StatefulWidget {
  const MenuTodolist({super.key});

  @override
  State<MenuTodolist> createState() => _MenuTodolistState();
}

class _MenuTodolistState extends State<MenuTodolist> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      width: 300,
      child: Even(),
    );
  }
}