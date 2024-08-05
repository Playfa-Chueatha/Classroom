import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Classroom/calssS_boday.dart';
import 'package:flutter_esclass_2/Home/homeS.dart';
import 'package:flutter_esclass_2/Login/login.dart';
import 'package:flutter_esclass_2/Model/Chat.dart';
import 'package:flutter_esclass_2/Profile/ProfileS.dart';
import 'package:flutter_esclass_2/Score/Score_S.dart';
import 'package:flutter_esclass_2/work/asign_work_S.dart';

void  main()  => runApp(const ClassS());


class ClassS extends StatefulWidget {
  const ClassS({super.key});

  @override
  State<ClassS> createState() => _ClassTState();
}

class _ClassTState extends State<ClassS> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: toggleS(),
    );
  }
}

class toggleS extends StatefulWidget {
  const toggleS({super.key});

  @override
  State<toggleS> createState() => _toggleTState();
}

class _toggleTState extends State<toggleS> {


  // List <bool> isSelected = [false,true,false,false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 195, 238, 250),
      appBar: AppBar(
        title: Text('Eduelite'),
        backgroundColor: Color.fromARGB(255, 152, 186, 218),
        actions: <Widget>[
          IconButton(
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Profile_S()),);            
            }, 
            icon: Image.asset("assets/images/นักเรียน.png"),
            iconSize: 30,
          ),
          Container(
            height: 45,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 71, 136, 190),
              borderRadius: BorderRadius.circular(20)

            ),
            child: Row(
              children: [
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
                backgroundColor: Color.fromARGB(255, 96, 152, 204),     
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
              ),
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Score_S()),);
            }, 
            icon: const Icon(Icons.list_alt),
            tooltip: 'คะแนนของฉัน',
          ),
              ],
            ),
          ),
          IconButton(
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Chat_classs()),);
            }, 
            icon: Icon(Icons.chat),
            tooltip: 'สนทนา',
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
      body: class_S_body(),
    );
  }
}