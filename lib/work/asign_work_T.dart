import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Classroom/setting_calss.dart';
import 'package:flutter_esclass_2/Data/Data_assignwork.dart';
import 'package:flutter_esclass_2/Home/Even.dart';
import 'package:flutter_esclass_2/Home/homeT.dart';
import 'package:flutter_esclass_2/Login/login.dart';
import 'package:flutter_esclass_2/Model/Chat.dart';
import 'package:flutter_esclass_2/Model/Menu_listclassroom_T_inclass.dart';
import 'package:flutter_esclass_2/Model/appbar_teacher.dart';
import 'package:flutter_esclass_2/Model/menu_t.dart';
import 'package:flutter_esclass_2/Profile/ProfileT.dart';
import 'package:flutter_esclass_2/work/Menu_listclassroom_T_AssignWork.dart';
import 'package:flutter_esclass_2/work/add_worktype.dart';
import 'package:flutter_esclass_2/work/work_type/Detail_work.dart';
import 'package:flutter_esclass_2/work/work_type/auswerQ.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Classroom/classT.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AssignWork_class_T extends StatefulWidget {
  final String username;
  final String thfname;
  final String thlname;
  final String classroomName;
  final String classroomMajor;
  final String classroomYear;
  final String classroomNumRoom;
  const AssignWork_class_T ({
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
  State<AssignWork_class_T> createState() => _AssignWork_class_TState();
}

class _AssignWork_class_TState extends State<AssignWork_class_T> {
  late final Map<DateTime, List<Map<String, String>>> _events = {};
  List<Even_teacher> dataevent = [];
  bool isLoading = true; // Loading state



  Future<void> fetchEvents() async {
    final url = Uri.parse('https://www.edueliteroom.com/connect/event_teacher.php?usert_username=${widget.username}');
    
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        
        if (responseData['status'] == 'success') {
          setState(() {
            _events.clear();
            dataevent.clear();
            isLoading = false;

            List<Even_teacher> todayEvents = []; // Current day's events
            List<Even_teacher> futureEvents = []; // Future events

            for (var event in responseData['data']) {
              DateTime eventDate = DateTime.parse(event['event_usert_date']);
              DateTime today = DateTime.now();
              
              // Check if the event date is today (ignoring the time)
              if (eventDate.year == today.year && eventDate.month == today.month && eventDate.day == today.day) {
                todayEvents.add(Even_teacher(
                  Title: event['event_usert_title'],
                  Date: event['event_usert_date'],
                  Time: event['event_usert_time'],
                ));
              } else if (eventDate.isAfter(today)) {
                futureEvents.add(Even_teacher(
                  Title: event['event_usert_title'],
                  Date: event['event_usert_date'],
                  Time: event['event_usert_time'],
                ));
              }
            }
            
            // Sort today’s and future events by date
            todayEvents.sort((a, b) => DateTime.parse(a.Date).compareTo(DateTime.parse(b.Date)));
            futureEvents.sort((a, b) => DateTime.parse(a.Date).compareTo(DateTime.parse(b.Date)));

            // Combine today’s and future events
            dataevent = todayEvents + futureEvents;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          print('Error: ${responseData['message']}');
        }
      } else {
        print('Error: ${response.statusCode}'); 
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Network error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 195, 238, 250),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 152, 186, 218),
        title: Text('มอบหมายงาน ${widget.classroomName} ${widget.classroomYear}/${widget.classroomNumRoom} (${widget.classroomMajor})'),
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
                      alignment: Alignment.topCenter,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 195, 238, 250),
                        borderRadius: BorderRadius.only(
                          topRight:Radius.circular(20),
                          bottomRight: Radius.circular(20)
                        ),
                      ),
                      child: Scaffold(
                        backgroundColor: Color.fromARGB(255, 195, 238, 250),
                        body: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 550,
                              width: 350,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(300, 10, 10, 0),
                                    child: IconButton(
                                      tooltip: 'ตั้งค่าห้องเรียน',
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => SettingCalss(thfname: widget.thfname, thlname: widget.thlname, username: widget.username,classroomMajor: '',classroomName: '',classroomNumRoom: '',classroomYear: '',),
                                          ),
                                        );
                                      },
                                      icon: Icon(Icons.settings),
                                    ),
                                  ),
                                  
                                  SizedBox(
                                    height: 400,
                                    width: 350,
                                    child: List_classroom_Assignwork(thfname: widget.thfname, thlname: widget.thlname, username: widget.username,), // Menu_listclassroom.dart
                                  ),

                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                          
                            Container(
                              height: 300,
                              width: 350,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: 20),
                                  Text(
                                    'กิจกรรมที่กำลังมาถึง',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: dataevent.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(255, 195, 238, 250),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: ListTile(
                                            title: Text(dataevent[index].Title),
                                            subtitle: Text(
                                              'วันที่: ${dataevent[index].Date} เวลา: ${dataevent[index].Time} น.',
                                            ),
                                          ),
                                        ); 
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),

                      )
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
                            Padding(
                              padding: EdgeInsets.fromLTRB(550,5,5,5),
                              child:  IconButton(
                                onPressed: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>  Type_work(
                                        username: widget.username, 
                                        thfname: widget.thfname,
                                        thlname: widget.thlname,
                                        classroomName: widget.classroomName,
                                        classroomMajor: widget.classroomMajor,
                                        classroomNumRoom: widget.classroomNumRoom,
                                        classroomYear: widget.classroomYear,
                                      )),); //add_work.dart
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
                              //     Expanded(
                              //   child: ListView.builder(
                              //     itemCount: widget.assignmentsauswerq.length + widget.assignmentsupfile.length + widget.assignmentsonechoice.length + widget.assignmentsmanychoice.length,
                              //     itemBuilder: (context, index) {
                              //       if (index < widget.assignmentsauswerq.length) {
                              //         final auswerq = widget.assignmentsauswerq[index];
                              //         return Card(
                              //         color: Color.fromARGB(255, 255, 255, 255),
                              //         child: 
                              //         ListTile(
                              //           title: Text(auswerq.directionauswerq,style: TextStyle(fontSize: 16),),
                              //           subtitle: Column(
                              //             crossAxisAlignment: CrossAxisAlignment.start,
                              //             children: [
                              //               Text('คะแนนเต็ม: ${auswerq.fullMarksauswerq}'),
                              //               Text('กำหนดส่ง: ${auswerq.dueDateauswerq}'),
                              //                 Align(
                              //                   alignment: Alignment.centerRight,
                              //                   child: ElevatedButton(
                              //                     onPressed: () {
                                                    
                              //                     },
                              //                     child: Text('รายละเอียด'),
                              //                   ),
                              //                 )
                              //             ],
                              //           ),
                              //         )
                              //       );
                              //       } 


                              //       // upfile
                              //       else if (index < widget.assignmentsauswerq.length + widget.assignmentsupfile.length){
                              //         final upfile = widget.assignmentsupfile[index - widget.assignmentsauswerq.length];
                              //         return Card(
                              //         color: Color.fromARGB(255, 255, 255, 255),
                              //         child: 
                              //         ListTile(
                              //           title: Text(upfile.directionupfile,style: TextStyle(fontSize: 16),),
                              //           subtitle: Column(
                              //             crossAxisAlignment: CrossAxisAlignment.start,
                              //             children: [
                              //               Text('คะแนนเต็ม: ${upfile.fullMarksupfile}'),
                              //               Text('กำหนดส่ง: ${upfile.dueDateupfile}'),
                              //                 Align(
                              //                   alignment: Alignment.centerRight,
                              //                   child: ElevatedButton(
                              //                     onPressed: () {
                                                    
                              //                     },
                              //                     child: Text('รายละเอียด'),
                              //                   ),
                              //                 )
                              //             ],
                              //           ),
                              //         )
                              //       );
                              //       } 
                              //       //onechoice
                              //       else if (index < widget.assignmentsauswerq.length + widget.assignmentsupfile.length + widget.assignmentsonechoice.length){
                              //         final OneChoice = widget.assignmentsonechoice[index - widget.assignmentsauswerq.length - widget.assignmentsupfile.length];
                              //         return Card(
                              //         color: Color.fromARGB(255, 255, 255, 255),
                              //         child: 
                              //         ListTile(
                              //           title: Text(OneChoice.directionone,style: TextStyle(fontSize: 16),),
                              //           subtitle: Column(
                              //             crossAxisAlignment: CrossAxisAlignment.start,
                              //             children: [
                              //               Text('คะแนนเต็ม: ${OneChoice.fullMarkone}'),
                              //               Text('กำหนดส่ง: ${OneChoice.dueDateone}'),
                              //                 Align(
                              //                   alignment: Alignment.centerRight,
                              //                   child: ElevatedButton(
                              //                     onPressed: () {
                                                    
                              //                     },
                              //                     child: Text('รายละเอียด'),
                              //                   ),
                              //                 )
                              //             ],
                              //           ),
                              //         )
                              //       );
                              //       }  
                              //       else {
                              //         final ManyChoice = widget.assignmentsmanychoice[index - widget.assignmentsauswerq.length - widget.assignmentsupfile.length - widget.assignmentsonechoice.length];
                              //         return Card(
                              //         color: Color.fromARGB(255, 255, 255, 255),
                              //         child: 
                              //         ListTile(
                              //           title: Text(ManyChoice.directionmany,style: TextStyle(fontSize: 16),),
                              //           subtitle: Column(
                              //             crossAxisAlignment: CrossAxisAlignment.start,
                              //             children: [
                              //               Text('คะแนนเต็ม: ${ManyChoice.fullMarkmany}'),
                              //               Text('กำหนดส่ง: ${ManyChoice.dueDatemany}'),
                              //                 Align(
                              //                   alignment: Alignment.centerRight,
                              //                   child: ElevatedButton(
                              //                     onPressed: () {
                                                    
                              //                     },
                              //                     child: Text('รายละเอียด'),
                              //                   ),
                              //                 )
                              //             ],
                              //           ),
                              //         )
                              //       );
                              //       }        
                                    
                              //     },
                              //   ),
                              // ),
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
