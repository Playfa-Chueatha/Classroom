import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Score/checkinclassroom.dart';
import 'package:flutter_esclass_2/Score/scorestudenst.dart';

class TabScore extends StatefulWidget {
  const TabScore({super.key});

  @override
  State<TabScore> createState() => _TabScoreState();
}

class _TabScoreState extends State<TabScore> {
  List<String> tabData = ['', '', '', '']; // ใช้เก็บข้อมูลจากแต่ละแท็บ

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Container(
        height: 500,
        width: 500,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(20),
        ),
        child: DefaultTabController(
          length: 2, // จำนวนแท็บที่ต้องการแสดง
          child: Column(
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
                    Center(child: Checkinclassroom()),
                    Center(child: Scorestudenst()),
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
