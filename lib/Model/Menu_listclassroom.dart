import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Classroom/setting_calss.dart';

class list_class extends StatelessWidget {
  const list_class({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: List_student(),
    );
  }
}

class List_student extends StatefulWidget {
  const List_student({super.key});

  @override
  State<List_student> createState() => _List_studentState();
}

class _List_studentState extends State<List_student> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: [
            Container(
              height: 190,
              width: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10)
              ),
              


                    //พื้นที่เอาไว้ใส่รายชื่อห้องเรียน

                      
                  ),
              
    
          ],
        )
      ),
    );
  }
}