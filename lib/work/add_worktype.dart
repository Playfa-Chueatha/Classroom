import 'package:flutter/material.dart';

class Type_work extends StatefulWidget {
  const Type_work({super.key});

  @override
  State<Type_work> createState() => _Type_workState();
}

class _Type_workState extends State<Type_work> {
  @override
  Widget build(BuildContext context) {

  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

     return DefaultTabController(
      length: 4, // จำนวนแท็บ
      child: Container(
        height: screenHeight * 0.5,
        width: screenWidth * 0.5,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
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
                  Center(child: Text('เนื้อหาหน้า ถาม-ตอบ')),
                  Center(child: Text('เนื้อหาหน้า ตัวเลือกคำตอบเดียว')),
                  Center(child: Text('เนื้อหาหน้า ตัวเลือกหลายคำตอบ')),
                  Center(child: Text('เนื้อหาหน้า ส่งงานแบบอัพไฟล์')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}