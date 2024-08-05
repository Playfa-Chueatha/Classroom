
import 'package:flutter/material.dart';

class Even_class extends StatelessWidget {
  const Even_class({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Even(),
    );
  }
}
class Even extends StatefulWidget {
  const Even({super.key});

  @override
  State<Even> createState() => _EvenState();
}

class _EvenState extends State<Even> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Container(
        height: 400,
        width: 600,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 170, 205, 238),
          borderRadius: BorderRadius.circular(20)
        ),
        child: Column(
        children: [
          SizedBox(height: 10),
          Text('กิจกรรมที่กำลังมาถึง',style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),),

          SingleChildScrollView(
            scrollDirection: Axis.vertical,

          child: 
            Container(
            //แสดงกิจกรรมทั้งหมดที่นี่
            //รายละเอียด => วันที่/ถึงวันที่/ชื่อกิจกรรม/รายละเอียด/เวลา




            ),
          )
        ],
        )
      ),
    );
  }
}