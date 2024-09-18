

import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Classroom/classT.dart';
import 'package:flutter_esclass_2/Home/homeT.dart';
import 'package:flutter_esclass_2/Login/login.dart';
import 'package:flutter_esclass_2/Profile/ProfileT.dart';
import 'package:flutter_esclass_2/Score/Score_T.dart';
import 'package:flutter_esclass_2/work/asign_work_T.dart';

Widget appbarteacher(BuildContext context) {
  return Row(
    children: [
      IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const main_home_T()),
          );
        },
        icon: const Icon(Icons.person_outline),
      ),
      IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Profile_T()),
          );
        },
        icon: Image.asset("assets/images/ครู.png"),
        iconSize: 30,
      ),
      IconButton(
        style: IconButton.styleFrom(
          highlightColor: const Color.fromARGB(255, 170, 205, 238),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Score_T_body()),
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const main_home_T()),
                );
              },
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
                  MaterialPageRoute(builder: (context) => const ClassT()),
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
                  MaterialPageRoute(builder: (context) => const AssignWork_class_T(
                    assignmentsauswerq: [],
                    assignmentsupfile: [],
                    assignmentsonechoice: [],
                    assignmentsmanychoice: [],
                  )),
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
                  MaterialPageRoute(builder: (context) => const Score_T_body()),
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