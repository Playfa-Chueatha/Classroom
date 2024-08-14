
import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Classroom/calssT_body.dart';
import 'package:flutter_esclass_2/Classroom/setting_calss.dart';
import 'package:flutter_esclass_2/Home/homeT.dart';
import 'package:flutter_esclass_2/Login/login.dart';
import 'package:flutter_esclass_2/Model/Chat.dart';
import 'package:flutter_esclass_2/Profile/ProfileT.dart';
import 'package:flutter_esclass_2/Score/Score_T.dart';
import 'package:flutter_esclass_2/work/assign_work_T.dart';


class ClassT extends StatefulWidget {
  const ClassT({super.key});

  @override
  State<ClassT> createState() => ClassTState();
}

class ClassTState extends State<ClassT> {



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
                MaterialPageRoute(builder: (context) => const Profile_T()),);            
            }, 
            icon: Image.asset("assets/images/ครู.png"),
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
                highlightColor: Color.fromARGB(255, 170, 205, 238)      
              ),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const main_home_T()),);
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
            tooltip: 'งานที่ได้รับ',
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
     

     body: Class_T_body(),
    );
  }
}