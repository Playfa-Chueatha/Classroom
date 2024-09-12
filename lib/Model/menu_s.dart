
import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Classroom/add_classroom.dart';
import 'package:flutter_esclass_2/Classroom/setting_calss.dart';
import 'package:flutter_esclass_2/Model/Menu_listclassroom.dart';
import 'package:flutter_esclass_2/Model/Menu_todolist.dart';
  

class Menuu_class_s extends StatefulWidget {
  const Menuu_class_s({super.key});

  @override
  State<Menuu_class_s> createState() => _MenuState();
}

class _MenuState extends State<Menuu_class_s> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 195, 238, 250),
      body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [

        //listclassroom
        Container(
          height: 300,
          width: 350,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
            )
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: Text('ห้องเรียนของฉัน',style: TextStyle(fontSize: 20),),
              ),     
              Container(
                height: 190,
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20)
                  )
                ),
                child:  List_student(),//Menu_listclassroom.dart
              ),
              SizedBox(height: 5),
            ],
          ),
        ),
        SizedBox(height: 20),



        //todolist
        Container(
          height: 300,
          width: 350,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
            )
          ), 
          child: Column(
            children: const [
              SizedBox(height: 20),
              Text('งานที่มอบหมาย',style: TextStyle(fontSize: 20),),
              // MenuTodolist()
            ],
          ),  
        ),
        SizedBox(height: 20),



        //useronline
        Container(
          height: 300,
          width: 350,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
            )
          ), 
          child: Column(
            children: const [
              SizedBox(height: 20),
              Text('Users online',style: TextStyle(fontSize: 20),),
            ],
          ), 
        ),
      ]
      ),
      
      
      
    );
  }
}


