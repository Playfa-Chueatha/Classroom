import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Classroom/calssT_boday.dart';
import 'package:flutter_esclass_2/Home/homeT.dart';
import 'package:flutter_esclass_2/Login/login.dart';
import 'package:flutter_esclass_2/Score/Score_T.dart';
import 'package:flutter_esclass_2/work/assign_work_T.dart';

void  main()  => runApp(const ClassT());

// const List<Widget> Menu = [
//   Text('หน้าหลัก'),
//   Text('ห้องเรียน'),
//   Text('งานที่มอบหมาย'),
//   Text('รายชื่อนักเรียน'),
// ];

class ClassT extends StatefulWidget {
  const ClassT({super.key});

  @override
  State<ClassT> createState() => _ClassTState();
}

class _ClassTState extends State<ClassT> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Class_T(),
    );
  }
}

class Class_T extends StatefulWidget {
  const Class_T({super.key});

  @override
  State<Class_T> createState() => _toggleTState();
}

class _toggleTState extends State<Class_T> {



  // List <bool> isSelected = [false,true,false,false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 195, 238, 250),
      appBar: AppBar(
        title: Text('ES Class'),
        backgroundColor: Color.fromARGB(255, 152, 186, 218),
        actions: <Widget>[
          IconButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const main_home_T()),);
              }, 
              icon: const Icon(Icons.home),
              style: IconButton.styleFrom(
                highlightColor: Color.fromARGB(255, 170, 205, 238),      
              ),
              tooltip: 'หน้าหลัก',      
          ),
          IconButton(
            style: IconButton.styleFrom(
              highlightColor: Color.fromARGB(255, 170, 205, 238),
              backgroundColor: Color.fromARGB(255, 96, 152, 204)
            ),
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ClassT()),
              );
            }, 
            icon: const Icon(Icons.class_outlined),
            tooltip: 'ห้องเรียน',
          ),

          IconButton(
            style: IconButton.styleFrom(
                highlightColor: Color.fromARGB(255, 170, 205, 238),      
              ),
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AssignWork_class_T()),);
            }, 
            icon: const Icon(Icons.edit_document),
            tooltip: 'งานที่มอบหมาย',
          ),

          IconButton(
            style: IconButton.styleFrom(
                highlightColor: Color.fromARGB(255, 170, 205, 238),      
              ),
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ScoreT()),);
            }, 
            icon: const Icon(Icons.list_alt),
            tooltip: 'รายชื่อนักเรียน',
          ),
          IconButton(
            style: IconButton.styleFrom(
              hoverColor: const Color.fromARGB(255, 235, 137, 130)
            ),
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Login_class()),);
            }, 
            icon: Icon(Icons.logout),
            tooltip: 'ออกจากระบบ',
          ),
          SizedBox(width: 50)
        ],
      ),
     

     body: Class_T_body(),
    );
  }
}