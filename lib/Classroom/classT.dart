
import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Classroom/add_announce.dart';
import 'package:flutter_esclass_2/Classroom/setting_calss.dart';
import 'package:flutter_esclass_2/Data/Data_announce.dart';
import 'package:flutter_esclass_2/Home/homeT.dart';
import 'package:flutter_esclass_2/Login/login.dart';
import 'package:flutter_esclass_2/Model/Chat.dart';
import 'package:flutter_esclass_2/Model/appbar_teacher.dart';
import 'package:flutter_esclass_2/Model/menu_t.dart';
import 'package:flutter_esclass_2/Profile/ProfileT.dart';
import 'package:flutter_esclass_2/work/add_worktype.dart';
import 'package:flutter_esclass_2/work/asign_work_T.dart';
import 'package:flutter_esclass_2/work/work_type/Detail_work.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class ClassT extends StatefulWidget {
  final String thfname;
  final String thlname;
  final String username;
  final String classroomName;
  final String classroomMajor;
  final String classroomYear;
  final String classroomNumRoom;

  const ClassT({
    super.key,
    required this.thfname,
    required this.thlname,
    required this.username, 
    required this.classroomName,
    required this.classroomMajor,
    required this.classroomYear,
    required this.classroomNumRoom,
  });

  @override
  State<ClassT> createState() => ClassTState();
}

class ClassTState extends State<ClassT> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 195, 238, 250),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 152, 186, 218),
        title: Text('Edueliteroom'),
        actions: [
          appbarteacher(context, widget.thfname, widget.thlname, widget.username),
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
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 147, 185, 221),
                        borderRadius: BorderRadius.only(
                          topRight:Radius.circular(20),
                          bottomRight: Radius.circular(20)
                        ),
                      ),
                    child:Menuu_class(username: widget.username),//menu.dart,
                      ),
                      SizedBox(width: 50,),


                      //ประกาศ
                      Container(
                      height: 1000,
                      width: 750,
                      // alignment: Alignment.topCenter,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)
                        ),
                        
                        child: Column(
                          children: [
                            SizedBox(height: 20,),
                            SizedBox(
                              height: 50,
                              width: 700,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${widget.classroomName} ${widget.classroomYear}/${widget.classroomNumRoom} (${widget.classroomMajor})', style: TextStyle(fontSize: 20)),
                                  IconButton(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    icon: const Icon(Icons.add),
                                    iconSize: 30,
                                    onPressed: (){
                                      showDialog(
                                    context: context, 
                                    builder: (BuildContext context) => AnnounceClass(username: widget.username, classroomMajor: widget.classroomMajor, classroomName: widget.classroomName, classroomNumRoom: widget.classroomNumRoom, classroomYear: widget.classroomYear, thfname: '',thlname: '',));
                                    },
                                    style: IconButton.styleFrom(
                                      backgroundColor: Color.fromARGB(255, 147, 185, 221),
                                      highlightColor: Color.fromARGB(255, 56, 105, 151),
                                    ),
                                    tooltip: 'เพิ่มประกาศ', 
                                  )
                                ],
                              ),
                            ),


                            Text("ประกาศ", style: TextStyle(fontSize: 40),),
                            SizedBox(height: 20),
                            Container(
                              height: 800,
                              width: 700,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: announce(),  //Data_announce.dart
                            ),
                        

                          ]
                        ),
                      ),
                      SizedBox(width: 50,),


                      //งายที่มอบหมาย
                      Container(
                        height: 1000,
                        width: 650,
                        margin: EdgeInsets.all(20),
                        alignment: Alignment.topCenter,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 152, 186, 218),
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(width: 560,height: 80),
                                IconButton(
                                  onPressed: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const Type_work()),);
                                }, 
                                  
                                  tooltip: 'มอบหมายงาน',
                                  icon: Icon(Icons.add_circle_outline_sharp,size: 50))
                              ],
                            ),                            
                            Text("งานที่มอบหมาย", style: TextStyle(fontSize: 30),),
                            Container(
                              alignment: Alignment.center,
                              height: 400,
                              width: 600,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)
                              ),
                            ),
                            SizedBox(height: 30),
                            Text("งานที่เลยกำหนดแล้ว", style: TextStyle(fontSize: 30),),
                            Container(
                              alignment: Alignment.center,
                              height: 400,
                              width: 600,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)
                              ),
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
        ),),
    );
  }
}