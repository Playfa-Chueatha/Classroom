import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Classroom/calssS.dart';
import 'package:flutter_esclass_2/Home/homeS.dart';
import 'package:flutter_esclass_2/Login/login.dart';
import 'package:flutter_esclass_2/Profile/ProfileS.dart';
import 'package:flutter_esclass_2/Score/Score_S.dart';
import 'package:flutter_esclass_2/work/asign_work_S.dart';

Widget appbarstudents(BuildContext context, String thfname, String thlname, String username) {
  // ignore: unused_element
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
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Profile_S()),
          );
        },
        icon: Image.asset("assets/images/นักเรียน.png"),
        iconSize: 30,
      ),
      IconButton(
        style: IconButton.styleFrom(
          highlightColor: const Color.fromARGB(255, 170, 205, 238),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Score_S()),
          );
        },
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
              onPressed: () => navigateTo(main_home_S(thfname: thfname, thlname: thlname, username: username)),              
              icon: const Icon(Icons.home),
              tooltip: 'หน้าหลัก',
            ),
            IconButton(
              style: IconButton.styleFrom(
                highlightColor: const Color.fromARGB(255, 170, 205, 238),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  class_S_body(thfname: thfname, thlname: thlname, username: username,classroomMajor: '', classroomName: '', classroomYear: '', classroomNumRoom: '',)),
                );
              },
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
                  MaterialPageRoute(builder: (context) => work_body_S(thfname: thfname, thlname: thlname, username: username)),
                );
              },
              icon: const Icon(Icons.edit_document),
              tooltip: 'งานที่ได้รับ',
            ),
            IconButton(
              style: IconButton.styleFrom(
                highlightColor: const Color.fromARGB(255, 170, 205, 238),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Score_S()),
                );
              },
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Login_class()),
          );
        },
        icon: const Icon(Icons.logout),
        tooltip: 'ออกจากระบบ',
      ),
      const SizedBox(width: 50),
    ],
  );
}