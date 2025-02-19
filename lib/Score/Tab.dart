import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Score/checkinclassroom.dart';
import 'package:flutter_esclass_2/Score/scorestudenst.dart';

class TabScore extends StatefulWidget {
  final String username;
  final String thfname;
  final String thlname;
  final String classroomName;
  final String classroomMajor;
  final String classroomYear;
  final String classroomNumRoom;
  const TabScore({
    super.key,
    required this.username, 
    required this.thfname, 
    required this.thlname, 
    required this.classroomName, 
    required this.classroomMajor, 
    required this.classroomYear, 
    required this.classroomNumRoom, 
  });

  @override
  State<TabScore> createState() => _TabScoreState();
}

class _TabScoreState extends State<TabScore> {
  List<String> tabData = ['', '', '', ''];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        height: screenHeight * 0.5,
        width: screenWidth * 0.5,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(20),
        ),
        child: DefaultTabController(
          length: 2, // จำนวนแท็บที่ต้องการแสดง
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TabBar(
                tabs: [
                  Tab(
                    text: 'เช็คชื่อเข้าเรียน',
                    icon: Image.asset('assets/images/problem.png', height: 40),
                  ),
                  Tab(
                    text: 'คะแนนของนักเรียน',
                    icon: Image.asset('assets/images/testing.png', height: 40),
                  ),
                ],
                labelColor: Colors.black,
                indicatorColor: Colors.blue,
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Center(child: Checkinclassroom(
                          classroomMajor: widget.classroomMajor,
                          classroomName: widget.classroomName,
                          classroomNumRoom: widget.classroomNumRoom,
                          classroomYear: widget.classroomYear,
                          thfname: widget.thfname,
                          thlname: widget.thlname,
                          username: widget.username,
                    )),
                    Center(child: Scorestudenstofrteacher(
                          classroomMajor: widget.classroomMajor,
                          classroomName: widget.classroomName,
                          classroomNumRoom: widget.classroomNumRoom,
                          classroomYear: widget.classroomYear,
                          thfname: widget.thfname,
                          thlname: widget.thlname,
                          username: widget.username,
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
