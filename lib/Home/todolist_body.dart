import 'package:flutter/material.dart';

class Todolist_class extends StatelessWidget {
  const Todolist_class({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: todo_calss(),
    );
  }
}
class todo_calss extends StatefulWidget {
  const todo_calss({super.key});

  @override
  State<todo_calss> createState() => _todo_calssState();
}

class _todo_calssState extends State<todo_calss> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Container(
        height: 400,
        width: 600,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 170, 205, 238),
          borderRadius: BorderRadius.circular(20)
        ),
        child: Column(
        children: [
          SizedBox(height: 10),
          Text('To do list to day',style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),),

          SingleChildScrollView(
            scrollDirection: Axis.vertical,

          child: 
            Container(
            //แสดงกิจกรรมเฉพาะวันที่เลือก
            //รายละเอียด => ชื่อกิจกรรม/รายละเอียด/เวลา/checkbox


            ),
          )
        ]
      )
      ),
    );
  }
}