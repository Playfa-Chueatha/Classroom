import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/test.dart';
import 'package:flutter_esclass_2/work/work_type/auswerQ.dart';
import 'package:flutter_esclass_2/work/work_type/many_choice.dart';
import 'package:flutter_esclass_2/work/work_type/one_choice.dart';
import 'package:flutter_esclass_2/work/work_type/upfile.dart';

class Type_work extends StatefulWidget {
  const Type_work({super.key});

  @override
  State<Type_work> createState() => _Type_workState();
}

class _Type_workState extends State<Type_work> {
   List<String> tabData = ['', '', '', ''];  // ใช้เก็บข้อมูลจากแต่ละแท็บ


  @override
  Widget build(BuildContext context) {

  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

     return DefaultTabController(
      length: 4, // จำนวนแท็บ
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
         appBar: AppBar(
            title: Text("มอบหมายงาน"),
            centerTitle: true,
            backgroundColor: Color.fromARGB(255, 195, 238, 250),
          ),
        body:    
      Container(
        height: screenHeight * 0.9,
        width: screenWidth * 1.0,
        padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
        margin: EdgeInsets.fromLTRB(50, 10, 50, 5),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 195, 238, 250),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TabBar(
              labelColor: Colors.black,
              indicatorColor: Colors.blue,
              tabs: [
                Tab(text: 'ถาม-ตอบ', icon: Image.asset('assets/images/problem.png',height: 40,)),
                Tab(text: 'ตัวเลือกคำตอบเดียว', icon: Image.asset('assets/images/testing.png',height: 40,)),
                Tab(text: 'ตัวเลือกหลายคำตอบ', icon: Image.asset('assets/images/choice.png',height: 40,)),
                Tab(text: 'ส่งงานแบบอัพไฟล์', icon: Image.asset('assets/images/upload.png',height: 40,)),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Center(child: Auswer_Question()),
                  Center(child: OneChoice_test()),
                  Center(child: many_choice()),
                  Center(child: upfilework()),
                ],
              ),
            ),
          ],
        ),
      ),
      )
    );
  }
}