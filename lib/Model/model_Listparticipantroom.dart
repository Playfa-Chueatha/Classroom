//รายชื่อนักเรียนที่ขอเข้าห้อง

import 'package:flutter/material.dart';

class Listparticipant{
  Listparticipant({
    required this.no2room,
    required this.no2student,
    required this.frist2name,
    required this.last2name,
    required this.n2name,
    required this.e2email
  });
  int no2room;
  int no2student;
  String frist2name;
  String last2name;
  String n2name;
  String e2email;
}

List <Listparticipant>  datastudent2 = [
  Listparticipant(
    no2room: 1, 
    no2student: 39832, 
    frist2name: 'เดชานนท์', 
    last2name: 'ยาสมุทร', 
    n2name: 'คอปเตอร์', 
    e2email: 'dechanon@gmail.com')
];


class Listparticipantroom extends StatefulWidget {
  const Listparticipantroom({super.key});

  @override
  State<Listparticipantroom> createState() => _ListparticipantroomState();
}

class _ListparticipantroomState extends State<Listparticipantroom> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      height: 350,
      width: 1300,
      decoration: BoxDecoration(
        color: Colors.white
      ),
      child: ListView.builder(
        itemCount: datastudent2.length,
        itemBuilder: (context,index){
          return Container(
            margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
            padding: EdgeInsets.fromLTRB(0,5,5,5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("เลขที่",style: TextStyle(fontSize: 24),),
                    Text("รหัสนักเรียน",style: TextStyle(fontSize: 24),),
                    Text("ชื่อ",style: TextStyle(fontSize: 24),),
                    Text("นามสกุล",style: TextStyle(fontSize: 24),),
                    Text("ชื่อเล่น",style: TextStyle(fontSize: 24),),
                    Text("อีเมล์",style: TextStyle(fontSize: 24),),
                    Text("การจัดการ",style: TextStyle(fontSize: 24),),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(" ${datastudent2[index].no2room}",style: TextStyle(fontSize: 20)),
                    Text(" ${datastudent2[index].no2student}",style: TextStyle(fontSize: 20)),
                    Text(" ${datastudent2[index].frist2name}",style: TextStyle(fontSize: 20)),
                    Text(" ${datastudent2[index].last2name}",style: TextStyle(fontSize: 20)),
                    Text(" ${datastudent2[index].n2name}",style: TextStyle(fontSize: 20)),
                    Text(" ${datastudent2[index].e2email}",style: TextStyle(fontSize: 20)),
                    IconButton(
                      onPressed: (){}, 
                      icon: Icon(Icons.check_circle_outline)),
                    IconButton(
                      onPressed: (){}, 
                      icon: Icon(Icons.cancel))
                  ],
                )
                
                
              ],
            ),
          );
        }),
    );
  }
}