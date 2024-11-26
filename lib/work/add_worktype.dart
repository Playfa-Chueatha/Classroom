import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/test.dart';
import 'package:flutter_esclass_2/work/auswer/auswerQ.dart';
import 'package:flutter_esclass_2/work/manychoice/many_choice.dart';
import 'package:flutter_esclass_2/work/onechoice/one_choice.dart';
import 'package:flutter_esclass_2/work/upfile/upfile.dart';

class Type_work extends StatefulWidget {
  final String username;
  final String thfname;
  final String thlname;
  final String classroomName;
  final String classroomMajor;
  final String classroomYear;
  final String classroomNumRoom;
  const Type_work({
    super.key, 
    required this.username,
    required this.thfname, 
    required this.thlname, 
    required this.classroomName, 
    required this.classroomMajor, 
    required this.classroomYear, 
    required this.classroomNumRoom
  });

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
            title: Text("มอบหมายงาน ${widget.classroomName} ${widget.classroomYear}/${widget.classroomNumRoom} (${widget.classroomMajor})"),
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
                  Center(child: Auswer_Question(
                    username: widget.username, 
                    thfname: widget.thfname,
                    thlname: widget.thlname,
                    classroomName: widget.classroomName,
                    classroomMajor: widget.classroomMajor,
                    classroomNumRoom: widget.classroomNumRoom,
                    classroomYear: widget.classroomYear,
                  )
                  ),
                  Center(child: OneChoice_test(
                    username: widget.username, 
                    thfname: widget.thfname,
                    thlname: widget.thlname,
                    classroomName: widget.classroomName,
                    classroomMajor: widget.classroomMajor,
                    classroomNumRoom: widget.classroomNumRoom,
                    classroomYear: widget.classroomYear,
                  )),
                  Center(child: many_choice(
                    username: widget.username, 
                    thfname: widget.thfname,
                    thlname: widget.thlname,
                    classroomName: widget.classroomName,
                    classroomMajor: widget.classroomMajor,
                    classroomNumRoom: widget.classroomNumRoom,
                    classroomYear: widget.classroomYear,
                  )),
                  Center(child: upfilework(
                    username: widget.username, 
                    thfname: widget.thfname,
                    thlname: widget.thlname,
                    classroomName: widget.classroomName,
                    classroomMajor: widget.classroomMajor,
                    classroomNumRoom: widget.classroomNumRoom,
                    classroomYear: widget.classroomYear,
                  )),
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