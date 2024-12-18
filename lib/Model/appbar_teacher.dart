import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Classroom/classT.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:flutter_esclass_2/Home/homeT.dart';
import 'package:flutter_esclass_2/Login/login.dart';
import 'package:flutter_esclass_2/Profile/ProfileT.dart';
import 'package:flutter_esclass_2/Score/Score_T.dart';
import 'package:flutter_esclass_2/work/asign_work_T.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;



class appbarteacher extends StatefulWidget {
  final String thfname;
  final String thlname;
  final String username;

  const appbarteacher({
    super.key,
    required this.thfname,
    required this.thlname,
    required this.username,
  });

  @override
  _appbarteacherState createState() => _appbarteacherState();
}

class _appbarteacherState extends State<appbarteacher> {



  

    @override
  void initState() {
    super.initState();
  }



  void navigateTo(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "${widget.thfname} ${widget.thlname}",
          style: const TextStyle(fontSize: 20),
        ),
        IconButton(
          onPressed: () => navigateTo(const Profile_T()),
          icon: Image.asset("assets/images/ครู.png"),
          iconSize: 30,
        ),
        IconButton(
            onPressed: (){},
            icon: const Icon(Icons.notifications),
            tooltip: 'แจ้งเตือน',
          ),
        IconButton(
          onPressed: () => navigateTo(main_home_T(
            thfname: widget.thfname,
            thlname: widget.thlname,
            username: widget.username,
          )),
          icon: const Icon(Icons.home),
          tooltip: 'หน้าหลัก',
        ),
        IconButton(
          onPressed: () => navigateTo(ClassT(
            thfname: widget.thfname,
            thlname: widget.thlname,
            username: widget.username,
            classroomName: '',
            classroomMajor: '',
            classroomYear: '',
            classroomNumRoom: '',
          )),
          icon: const Icon(Icons.class_outlined),
          tooltip: 'ห้องเรียน',
        ),

        IconButton(
              style: IconButton.styleFrom(
                highlightColor: const Color.fromARGB(255, 170, 205, 238),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AssignWork_class_T(thfname: widget.thfname, thlname: widget.thlname, username: widget.username, classroomMajor: '', classroomName: '', classroomYear: '', classroomNumRoom: '')),
                );
              },
              icon: const Icon(Icons.edit_document),
              tooltip: 'งานที่ได้รับ',
            ),

         IconButton(
              style: IconButton.styleFrom(
                highlightColor: const Color.fromARGB(255, 170, 205, 238),
              ),
              onPressed: () => navigateTo(Score_T_body(thfname: widget.thfname, thlname: widget.thlname, username: widget.username)), 
              icon: const Icon(Icons.list_alt),
              tooltip: 'รายชื่อนักเรียน',
            ),
          
        IconButton(
          onPressed: () => navigateTo(const Login_class()),
          icon: const Icon(Icons.logout),
          tooltip: 'ออกจากระบบ',
        ),
      ],
    );
  }
}




