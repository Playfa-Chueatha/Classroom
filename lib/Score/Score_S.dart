import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Classroom/classS.dart';
import 'package:flutter_esclass_2/Home/homeS.dart';
import 'package:flutter_esclass_2/Login/login.dart';
import 'package:flutter_esclass_2/work/asign_work_S.dart';

class Score_S extends StatelessWidget {
  const Score_S({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Score',
      home: ScoreS(),
    );
  }
}

class ScoreS extends StatefulWidget {
  const ScoreS({super.key});

  @override
  State<ScoreS> createState() => _ScoreSState();
}

class _ScoreSState extends State<ScoreS> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ES Class'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 152, 186, 218),
        actions: <Widget>[
          IconButton(
            style: IconButton.styleFrom(
                highlightColor: Color.fromARGB(255, 170, 205, 238),     
              ),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const main_home_S()),);
              }, 
              icon: const Icon(Icons.home),
              tooltip: 'หน้าหลัก',      
          ),
          IconButton(
            style: IconButton.styleFrom(
                highlightColor: Color.fromARGB(255, 170, 205, 238),      
              ),
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ClassS()),
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
                  MaterialPageRoute(builder: (context) => const AssignWork_class_S()),);
            }, 
            icon: const Icon(Icons.edit_document),
            tooltip: 'งานที่ได้รับ',
          ),

          IconButton(
            style: IconButton.styleFrom(
                highlightColor: Color.fromARGB(255, 170, 205, 238),
                backgroundColor: Color.fromARGB(255, 96, 152, 204),      
              ),
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Score_S()),);
            }, 
            icon: const Icon(Icons.list_alt),
            tooltip: 'คะแนนของฉัน',
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
    );
  }
}