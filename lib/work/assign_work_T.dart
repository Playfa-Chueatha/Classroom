import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_esclass_2/Classroom/classT.dart';
import 'package:flutter_esclass_2/Home/homeT.dart';
import 'package:flutter_esclass_2/Login/login.dart';
import 'package:flutter_esclass_2/Score/Score_T.dart';
import 'package:flutter_esclass_2/work/asign_work_T_body.dart';

void  main()  => runApp(const AssignWork_class_T());

// const List<Widget> Menu = [
//   Text('หน้าหลัก'),
//   Text('ห้องเรียน'),
//   Text('งานที่มอบหมาย'),
//   Text('รายชื่อนักเรียน'),
// ];

class AssignWork_class_T extends StatelessWidget {
  const AssignWork_class_T({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assidn_work',
      home: Ass_work(),
    );
  }
}



class Ass_work extends StatefulWidget {
  const Ass_work({super.key});

  @override
  State<Ass_work> createState() => _ClassTState();
}

class _ClassTState extends State<Ass_work> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                backgroundColor: Color.fromARGB(255, 96, 152, 204),
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
      body: work_body_T(),
    );
  }
}
 

