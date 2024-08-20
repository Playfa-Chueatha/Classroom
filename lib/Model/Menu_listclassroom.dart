import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Classroom/setting_calss.dart';
import 'package:flutter_esclass_2/Data/data_calssroom.dart';

class List_student extends StatefulWidget {
  const List_student({super.key});

  @override
  State<List_student> createState() => _List_studentState();
}

class _List_studentState extends State<List_student> {
  @override
  Widget build(BuildContext context) {
    return Container(
              height: 190,
              width: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10)
              ),
              child: DataCalssroom(),//data_classroom.dart

    );
  }
}