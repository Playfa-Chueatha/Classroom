
import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Classroom/setting_calss.dart';
import 'package:flutter_esclass_2/Model/Menu_listclassroom.dart';

class Menuu_class extends StatelessWidget {
  const Menuu_class({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Menu(),
    );
  }
}

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 195, 238, 250),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
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
              SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(width: 300),
                  IconButton(
                    tooltip: 'ตั้งค่าห้องเรียน',
                    onPressed: (){
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => const SettingCalss()),);   

                    }, 
                    icon: Icon(Icons.settings))
                ],
              ),
              Text('ห้องเรียนของฉัน',style: TextStyle(fontSize: 20),),
              SizedBox(height: 10),
              Container(
                height: 190,
                width: 300,
                child:  List_student(),
              ),
              SizedBox(height: 5),


              //ปุ่มคั้งค่าห้องเรียน
              
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
            children: [
              SizedBox(height: 20),
              Text('To do list',style: TextStyle(fontSize: 20),),
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
            children: [
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