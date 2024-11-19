import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Classroom/classT.dart';
import 'package:flutter_esclass_2/Home/homeT.dart';
import 'package:flutter_esclass_2/Login/login.dart';
import 'package:flutter_esclass_2/Profile/ProfileT.dart';
import 'package:flutter_esclass_2/Score/Score_T.dart';
import 'package:flutter_esclass_2/work/asign_work_T.dart';

Widget appbarteacher(BuildContext context, String thfname, String thlname, String username) {
  void navigateTo(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  return Row(
    children: [
      Text(
        "$thfname $thlname", // แสดงชื่อผู้ใช้จากฐานข้อมูล
        style: TextStyle(fontSize: 20),
      ),
      IconButton(
        onPressed: () => navigateTo(const Profile_T()),
        icon: Image.asset("assets/images/ครู.png"),
        iconSize: 30,
      ),
      IconButton(
        style: IconButton.styleFrom(
          highlightColor: const Color.fromARGB(255, 170, 205, 238),
        ),
        onPressed: () => navigateTo(Score_T_body(thfname: thfname, thlname: thlname, username: username,)), // ส่ง username
        icon: const Icon(Icons.announcement),
        tooltip: 'แจ้งเตือน',
      ),
      Container(
        height: 45,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 71, 136, 190),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            IconButton(
              style: IconButton.styleFrom(
                highlightColor: const Color.fromARGB(255, 170, 205, 238),
              ),
              onPressed: () => navigateTo(main_home_T(thfname: thfname, thlname: thlname, username: username)), // ส่ง username
              icon: const Icon(Icons.home),
              tooltip: 'หน้าหลัก',
            ),
            IconButton(
              style: IconButton.styleFrom(
                highlightColor: const Color.fromARGB(255, 170, 205, 238),
              ),
              onPressed: () => navigateTo(ClassT(thfname: thfname, thlname: thlname, username: username, classroomName: '', classroomMajor: '', classroomYear: '', classroomNumRoom: '',)), // ส่ง username
              icon: const Icon(Icons.class_outlined),
              tooltip: 'ห้องเรียน',
            ),
            IconButton(
              style: IconButton.styleFrom(
                highlightColor: const Color.fromARGB(255, 170, 205, 238),
              ),
              onPressed: () => navigateTo(AssignWork_class_T(
                assignmentsauswerq: [],
                assignmentsupfile: [],
                assignmentsonechoice: [],
                assignmentsmanychoice: [],
                username: username, // ส่ง username
                thfname: thfname, thlname: thlname, classroomMajor: '', classroomName: '', classroomYear: '', classroomNumRoom: '',
              )),
              icon: const Icon(Icons.edit_document),
              tooltip: 'งานที่ได้รับ',
            ),
            IconButton(
              style: IconButton.styleFrom(
                highlightColor: const Color.fromARGB(255, 170, 205, 238),
              ),
              onPressed: () => navigateTo(Score_T_body(thfname: thfname, thlname: thlname, username: username)), // ส่ง username
              icon: const Icon(Icons.list_alt),
              tooltip: 'รายชื่อนักเรียน',
            ),
          ],
        ),
      ),
      IconButton(
        style: IconButton.styleFrom(
          hoverColor: const Color.fromARGB(255, 235, 137, 130),
        ),
        onPressed: () => navigateTo(const Login_class()),
        icon: const Icon(Icons.logout),
        tooltip: 'ออกจากระบบ',
      ),
      const SizedBox(width: 50),
    ],
  );
}
