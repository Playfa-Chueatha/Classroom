import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Data/Data_assignwork.dart';
import 'package:flutter_esclass_2/Home/homeT.dart';
import 'package:flutter_esclass_2/Login/login.dart';
import 'package:flutter_esclass_2/Model/Chat.dart';
import 'package:flutter_esclass_2/Model/menu.dart';
import 'package:flutter_esclass_2/Profile/ProfileT.dart';
import 'package:flutter_esclass_2/Score/Score_T.dart';
import 'package:flutter_esclass_2/work/add_worktype.dart';
import 'package:flutter_esclass_2/work/work_type/Detail_work.dart';
import 'package:flutter_esclass_2/work/work_type/auswerQ.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Classroom/classT.dart';

class AssignWork_class_T extends StatefulWidget {
  final List<auswerq> assignmentsauswerq;
  final List<upfile> assignmentsupfile;
  final List<OneChoice> assignmentsonechoice;
  final List<Manychoice> assignmentsmanychoice;
  const AssignWork_class_T({super.key, required this.assignmentsauswerq, required this.assignmentsupfile, required this.assignmentsonechoice, required this.assignmentsmanychoice});
  

  @override
  State<AssignWork_class_T> createState() => _AssignWork_class_TState();
}

class _AssignWork_class_TState extends State<AssignWork_class_T> {

  int counter = 0;

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 195, 238, 250),
      appBar: AppBar(
        title: Text('Eduelite'),
        backgroundColor: Color.fromARGB(255, 152, 186, 218),
        actions: <Widget>[
          IconButton(
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Profile_T()),);            
            }, 
            icon: Image.asset("assets/images/ครู.png"),
            iconSize: 30,
          ),
          Container(
            height: 45,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 71, 136, 190),
              borderRadius: BorderRadius.circular(20)

            ),
            child: Row(
              children: [
                IconButton(
            style: IconButton.styleFrom(
                highlightColor: Color.fromARGB(255, 170, 205, 238)      
              ),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => main_home_T()),);
              }, 
              icon: const Icon(Icons.home),
              tooltip: 'หน้าหลัก',      
          ),
          IconButton(
            style: IconButton.styleFrom(
                highlightColor: Color.fromARGB(255, 170, 205, 238),   
              ),
            onPressed: (){
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
                highlightColor: Color.fromARGB(255, 170, 205, 238),  
                backgroundColor: Color.fromARGB(255, 96, 152, 204),    
              ),
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AssignWork_class_T(assignmentsauswerq: [], assignmentsupfile: [], assignmentsonechoice: [], assignmentsmanychoice: [],)),);
            }, 
            icon: const Icon(Icons.edit_document),
            tooltip: 'งานที่ได้รับ',
          ),

          IconButton(
            style: IconButton.styleFrom(
                highlightColor: Color.fromARGB(255, 170, 205, 238),      
              ),
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ScoreT()),);
            }, 
            icon: const Icon(Icons.list_alt),
            tooltip: 'รายชื่อนักเรียน',
          ),
              ],
            ),
          ),
          IconButton(
            style: IconButton.styleFrom(
              hoverColor: const Color.fromARGB(255, 235, 137, 130)
            ),
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Login_class()),);
            }, 
            icon: Icon(Icons.logout),
            tooltip: 'ออกจากระบบ',
          ),
          SizedBox(width: 50)
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection:Axis.vertical,
        child: Column(
          children: [
            SizedBox(height: 10,),
            Column(
              children: [
                SizedBox(height: 30),
                SingleChildScrollView(
                  scrollDirection:Axis.horizontal,
                  child: Row(
                    children: [
                      //menu
                      Container(
                      height: 1000,
                      width: 400,
                      alignment: Alignment.topCenter,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 147, 185, 221),
                        borderRadius: BorderRadius.only(
                          topRight:Radius.circular(20),
                          bottomRight: Radius.circular(20)
                        ),
                      ),
                      child: Menuu_class(),//menu.dart,
                      ),
                      SizedBox(width: 50,),


                      //งานที่มอบหมาย
                      Container(
                      height: 1000,
                      width: 600,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)
                        ),
                        
                        child: Column(
                          children: [

                            //ปุ่มกดมอบหมายงาน
                            Padding(
                              padding: EdgeInsets.fromLTRB(530, 20, 20, 10),
                              child: IconButton(
                                onPressed: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const Type_work()),); //add_work.dart
                                },
                                style: IconButton.styleFrom(
                                      backgroundColor: Color.fromARGB(255, 147, 185, 221),
                                      highlightColor: Color.fromARGB(255, 56, 105, 151),
                                    ),
                                    tooltip: 'มอบหมายงาน', 
                                icon: const Icon(Icons.add),iconSize: 30,color: Colors.black,
                              )
                            ),


                            //งานที่มอบหมาย
                            Container(
                              height: 400,
                              width: 500,
                              padding: EdgeInsets.all(20),
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 50),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 147, 185, 221),
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: Column(
                                children: [
                                  Text("งานที่มอบหมาย", style: TextStyle(fontSize: 20),),




                                  // ถาม- ตอบ
                                  Expanded(
                                child: ListView.builder(
                                  itemCount: widget.assignmentsauswerq.length + widget.assignmentsupfile.length + widget.assignmentsonechoice.length + widget.assignmentsmanychoice.length,
                                  itemBuilder: (context, index) {
                                    if (index < widget.assignmentsauswerq.length) {
                                      final auswerq = widget.assignmentsauswerq[index];
                                      return Card(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      child: 
                                      ListTile(
                                        title: Text(auswerq.directionauswerq,style: TextStyle(fontSize: 16),),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('คะแนนเต็ม: ${auswerq.fullMarksauswerq}'),
                                            Text('กำหนดส่ง: ${auswerq.dueDateauswerq}'),
                                              Align(
                                                alignment: Alignment.centerRight,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    
                                                  },
                                                  child: Text('รายละเอียด'),
                                                ),
                                              )
                                          ],
                                        ),
                                      )
                                    );
                                    } 


                                    // upfile
                                    else if (index < widget.assignmentsauswerq.length + widget.assignmentsupfile.length){
                                      final upfile = widget.assignmentsupfile[index - widget.assignmentsauswerq.length];
                                      return Card(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      child: 
                                      ListTile(
                                        title: Text(upfile.directionupfile,style: TextStyle(fontSize: 16),),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('คะแนนเต็ม: ${upfile.fullMarksupfile}'),
                                            Text('กำหนดส่ง: ${upfile.dueDateupfile}'),
                                              Align(
                                                alignment: Alignment.centerRight,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    
                                                  },
                                                  child: Text('รายละเอียด'),
                                                ),
                                              )
                                          ],
                                        ),
                                      )
                                    );
                                    } 
                                    //onechoice
                                    else if (index < widget.assignmentsauswerq.length + widget.assignmentsupfile.length + widget.assignmentsonechoice.length){
                                      final OneChoice = widget.assignmentsonechoice[index - widget.assignmentsauswerq.length - widget.assignmentsupfile.length];
                                      return Card(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      child: 
                                      ListTile(
                                        title: Text(OneChoice.directionone,style: TextStyle(fontSize: 16),),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('คะแนนเต็ม: ${OneChoice.fullMarkone}'),
                                            Text('กำหนดส่ง: ${OneChoice.dueDateone}'),
                                              Align(
                                                alignment: Alignment.centerRight,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    
                                                  },
                                                  child: Text('รายละเอียด'),
                                                ),
                                              )
                                          ],
                                        ),
                                      )
                                    );
                                    }  
                                    else {
                                      final ManyChoice = widget.assignmentsmanychoice[index - widget.assignmentsauswerq.length - widget.assignmentsupfile.length - widget.assignmentsonechoice.length];
                                      return Card(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      child: 
                                      ListTile(
                                        title: Text(ManyChoice.directionmany,style: TextStyle(fontSize: 16),),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('คะแนนเต็ม: ${ManyChoice.fullMarkmany}'),
                                            Text('กำหนดส่ง: ${ManyChoice.dueDatemany}'),
                                              Align(
                                                alignment: Alignment.centerRight,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    
                                                  },
                                                  child: Text('รายละเอียด'),
                                                ),
                                              )
                                          ],
                                        ),
                                      )
                                    );
                                    }        
                                    
                                  },
                                ),
                              ),
                                ],
                              )
                              
                            ),

                            //งานที่เลยกำหนด
                            Container(
                              height: 400,
                              width: 500,
                              padding: EdgeInsets.all(20),
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 147, 185, 221),
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: Column(
                                children: [
                                  Text("งานที่เลยกำหนดแล้ว", style: TextStyle(fontSize: 20),),
                                  
                                  
                                ],
                              )
                            ),
                          ]
                        ),
                      ),
                      SizedBox(width: 50,),



                      //งายที่มอบหมาย รายละเอียด
                      Container(
                        height: 1000,
                        width: 800,
                        alignment: Alignment.topCenter,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 152, 186, 218),
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 50,),
                            Text("รายละเอียดงาน", style: TextStyle(fontSize: 30),),
                            Container(
                              alignment: Alignment.center,
                              height: 900,
                              width: 700,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: Detail_work(),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 20)
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      )
    );
  }
}
