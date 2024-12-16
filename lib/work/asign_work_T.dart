import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Classroom/setting_calss.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
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
import 'package:flutter_esclass_2/work/Detail_work_teacher.dart';
import 'package:flutter_esclass_2/work/auswer/auswerQ.dart';
import 'package:intl/intl.dart';
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
  List<Examset> examsets = [];
  List<Examset> futurexamsets = [];
  List<Examset> pastDeadlines = [];
  List<Examset> completeexamsets = [];
  bool isLoading = true;
  bool isLoadingExamset = true;
  final today = DateTime.now();
  Examset? selectedExam;
  List<bool> successChecks =[];
  bool isExpandedFuture = false;
  bool isExpandedPast = false;
  bool isExapandedcomplete = false;
  

  Future<List<Examset>> fetchExamsets(String classroomName, String classroomMajor, String classroomYear, String classroomNumRoom, String username) async {
  final response = await http.post(
    Uri.parse('https://www.edueliteroom.com/connect/fetch_examsets.php'),
    body: {
      'classroomName': classroomName,
      'classroomMajor': classroomMajor,
      'classroomYear': classroomYear,
      'classroomNumRoom': classroomNumRoom,
      'username': username,
    },
  );

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => Examset.fromJson(data)).toList();
  } else {
    throw Exception('ไม่สามารถโหลดงานที่มอบหมายได้');
  }
}

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

            List<Even_teacher> todayEvents = []; 
            List<Even_teacher> futureEvents = []; 

            for (var event in responseData['data']) {
              DateTime eventDate = DateTime.parse(event['event_usert_date']);
              DateTime today = DateTime.now();
              
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
            
            todayEvents.sort((a, b) => DateTime.parse(a.Date).compareTo(DateTime.parse(b.Date)));
            futureEvents.sort((a, b) => DateTime.parse(a.Date).compareTo(DateTime.parse(b.Date)));


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

  Future<void> loadExamsets() async {
  setState(() {
    isLoadingExamset = true;
  });

  try {
    examsets = await fetchExamsets(
      widget.classroomName,
      widget.classroomMajor,
      widget.classroomYear,
      widget.classroomNumRoom,
      widget.username,
    );
    await filterExamsets(examsets);
    successChecks = List<bool>.filled(futurexamsets.length, false);

  } catch (e) {
    print("Error fetching examsets: $e");
  } finally {
    setState(() {
      isLoadingExamset = false;
    });
  }
}


Future<void> filterExamsets(List<Examset> examsets) async {
  DateTime currentDate = DateTime.now();
  DateTime yesterdayDate = currentDate.subtract(Duration(days: 1));

  List<Examset> futureExamsetsTemp = [];
  List<Examset> pastDeadlinesTemp = [];
  List<Examset> completeexamsets = [];

  for (var examset in examsets) {
    DateTime deadlineDate = DateTime.parse(examset.deadline);
    
    
    if (examset.inspectionStatus == 'complete') {
      completeexamsets.add(examset); 
    } else {
      if (deadlineDate.isAfter(currentDate) || 
          (deadlineDate.year == currentDate.year &&
           deadlineDate.month == currentDate.month &&
           deadlineDate.day == currentDate.day)) {
        
        futureExamsetsTemp.add(examset);
      } else if (deadlineDate.isBefore(yesterdayDate)) {
       
        pastDeadlinesTemp.add(examset);
      }
    }
  }

  print('Complete Examsets: ${completeexamsets.length}');
  
  setState(() {
    futurexamsets = futureExamsetsTemp;
    pastDeadlines = pastDeadlinesTemp;
    successChecks = List<bool>.filled(futurexamsets.length + pastDeadlines.length, false);
    this.completeexamsets = completeexamsets;
  });
}

void showStatusConfirmationDialog(BuildContext context, String title, String message, 
    VoidCallback onConfirm) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // ปิด Dialog
          child: Text('ยกเลิก'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // ปิด Dialog
            onConfirm(); // เรียกฟังก์ชันเมื่อยืนยัน
          },
          child: Text('ยืนยัน'),
        ),
      ],
    ),
  );
}




Future<void> updateInspectionStatus(String autoId, bool isChecked) async {
  try {
    final response = await http.post(
      Uri.parse('https://www.edueliteroom.com/connect/examsets_Inspection_status.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'autoId': autoId,  
        'status': isChecked ? 'complete' : 'Incomplete',  
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] == true) {
        print("Status updated successfully.");
      } else {
        throw Exception(data['message']);
      }
    } else {
      throw Exception("Failed to update status.");
    }
  } catch (e) {
    print("Error updating status: $e");
  }
}


@override
void initState() {
  super.initState();
  loadExamsets();
  successChecks = List<bool>.filled(futurexamsets.length, false);
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
                              height: 590,
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
                                    height: 500,
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
                              width: 500,
                              padding: EdgeInsets.all(20),
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 147, 185, 221),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Title and Toggle Button
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "งานที่มอบหมายทั้งหมด (${futurexamsets.length} งาน)",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          isExpandedFuture ? Icons.expand_less : Icons.expand_more,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isExpandedFuture = !isExpandedFuture;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),

                                 
                                  if (isExpandedFuture)
                                    isLoadingExamset
                                        ? Center(child: CircularProgressIndicator())
                                        : futurexamsets.isEmpty
                                            ? Center(child: Text("ไม่มีงานที่มอบหมาย"))
                                            : SizedBox(
                                                height: 500, 
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: futurexamsets.length,
                                                  itemBuilder: (context, index) {
                                                    final exam = futurexamsets[index];
                                                    return Card(
                                                      color: Colors.white,
                                                      margin: const EdgeInsets.symmetric(vertical: 8),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(15),
                                                      ),
                                                      elevation: 4,
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(16.0),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(' ${exam.time}'),
                                                                ElevatedButton(
                                                                  onPressed: () {
                                                                    const String title = 'ยืนยันการเปลี่ยนสถานะ';
                                                                    const String message = 'คุณต้องการเปลี่ยนสถานะเป็น "ตรวจงานครบแล้ว" ใช่หรือไม่?';

                                                                    showStatusConfirmationDialog(
                                                                      context,
                                                                      title,
                                                                      message,
                                                                      () async {
                                                                        await updateInspectionStatus(exam.autoId.toString(), true);

                                                                        setState(() {
                                                                          successChecks[index] = true; 
                                                                        });

                                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                                          SnackBar(content: Text('สถานะเปลี่ยนเป็น "ตรวจงานครบแล้ว"')),
                                                                        );
                                                                      },
                                                                    );
                                                                  },
                                                                  style: ElevatedButton.styleFrom(
                                                                    backgroundColor: Colors.green,
                                                                  ),
                                                                  child: Text('ตรวจงานครบแล้ว',style: TextStyle(color: Colors.black),),
                                                                ),
                                                              ],
                                                            ),
                                                            Text(' ${exam.autoId} Status: ${exam.inspectionStatus} '),
                                                            Text(
                                                              " ${exam.direction}",
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text("คะแนนเต็ม: ${exam.fullMark}"),
                                                                IconButton(
                                                                  onPressed: () {
                                                                    setState(() {
                                                                      selectedExam = exam;
                                                                    });
                                                                  },
                                                                  icon: Icon(Icons.search),
                                                                )
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        



                            //งานที่เลยกำหนด
                            Container(
                              width: 500,
                              padding: EdgeInsets.all(20),
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 147, 185, 221),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  
                                  
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "งานที่เลยกำหนดแล้วทั้งหมด (${pastDeadlines.length} งาน)",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          isExpandedPast ? Icons.expand_less : Icons.expand_more,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isExpandedPast = !isExpandedPast;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),

                                  // Content
                                  if (isExpandedPast)
                                    isLoadingExamset
                                        ? Center(child: CircularProgressIndicator())
                                        : pastDeadlines.isEmpty
                                            ? Center(child: Text("ไม่มีงานที่มอบหมาย"))
                                            : SizedBox( 
                                              height: 500, 
                                              child: ListView.builder(
                                                shrinkWrap: true,                                              
                                                itemCount: pastDeadlines.length,
                                                itemBuilder: (context, index) {
                                                  final exam = pastDeadlines[index];
                                                  if (successChecks.length < pastDeadlines.length) {
                                                    successChecks = List<bool>.filled(pastDeadlines.length, false);
                                                  }
                                                  return Card(  
                                                    color: Colors.white,  
                                                    margin: const EdgeInsets.symmetric(vertical: 8),  
                                                    shape: RoundedRectangleBorder(  
                                                      borderRadius: BorderRadius.circular(15),  
                                                    ),  
                                                    elevation: 4, 
                                                    child: Padding( 
                                                      padding: const EdgeInsets.all(16.0),  
                                                      child: Column(  
                                                        crossAxisAlignment: 
                                                            CrossAxisAlignment.start, 
                                                        children: [ 
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(' ${exam.time}'),
                                                              ElevatedButton(
                                                              onPressed: () {
                                                                const String title = 'ยืนยันการเปลี่ยนสถานะ';
                                                                const String message = 'คุณต้องการเปลี่ยนสถานะเป็น "ตรวจงานครบแล้ว" ใช่หรือไม่?';

                                                                showStatusConfirmationDialog(
                                                                  context,
                                                                  title,
                                                                  message,
                                                                  () async {
                                                                    await updateInspectionStatus(exam.autoId.toString(), true);

                                                                    setState(() {
                                                                      successChecks[index] = true; 
                                                                    });

                                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                                      SnackBar(content: Text('สถานะเปลี่ยนเป็น "ตรวจงานครบแล้ว"')),
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                              style: ElevatedButton.styleFrom(
                                                                backgroundColor: Colors.green,
                                                              ),
                                                              child: Text('ตรวจงานครบแล้ว',style: TextStyle(color: Colors.black),),
                                                            ),
                                                            ]),

                                                          Text(' ${exam.autoId} Status: ${exam.inspectionStatus} '),
                                                          Text(
                                                            " ${exam.direction} ",
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text("คะแนนเต็ม: ${exam.fullMark}"),
                                                              IconButton(
                                                                  onPressed: () {
                                                                    setState(() {
                                                                      selectedExam = exam;
                                                                    });
                                                                  },
                                                                  icon: Icon(Icons.search))
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),)
                                            ],
                                          ),
                                        ),

                                        //งานที่ตรวจสอบแล้วทั้งหมด
                                        Container(
                                          width: 500,
                                          padding: EdgeInsets.all(20),
                                          margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(255, 147, 185, 221),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    "งานที่ตรวจสอบแล้วทั้งหมด (${completeexamsets.length} งาน)",
                                                    style: TextStyle(fontSize: 20),
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      isExapandedcomplete ? Icons.expand_less : Icons.expand_more,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        isExapandedcomplete = !isExapandedcomplete;
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),

                                              // Content
                                              if (isExapandedcomplete)
                                                isLoadingExamset
                                                    ? Center(child: CircularProgressIndicator())
                                                    : completeexamsets.isEmpty
                                                        ? Center(child: Text("ไม่มีงานที่ตรวจสอบแล้ว"))
                                                        : SizedBox(
                                                            height: 500,
                                                            child: ListView.builder(
                                                              shrinkWrap: true,
                                                              itemCount: completeexamsets.length,
                                                              itemBuilder: (context, index) {
                                                                final exam = completeexamsets[index];
                                                                if (successChecks.length < completeexamsets.length) {
                                                                  successChecks = List<bool>.filled(
                                                                      completeexamsets.length, false);
                                                                }
                                                                return Card(
                                                                  color: Colors.white,
                                                                  margin: const EdgeInsets.symmetric(vertical: 8),
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(15),
                                                                  ),
                                                                  elevation: 4,
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.all(16.0),
                                                                    child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text(' ${exam.time}'),
                                                                           ElevatedButton(
                                                                              onPressed: () {
                                                                                const String title = 'ยืนยันการเปลี่ยนสถานะ';
                                                                                const String message = 'คุณต้องการเปลี่ยนสถานะเป็น "ยังตรวจงานไม่ครบ" ใช่หรือไม่?';

                                                                                showStatusConfirmationDialog(
                                                                                  context,
                                                                                  title,
                                                                                  message,
                                                                                  () async {
                                                                                    await updateInspectionStatus(exam.autoId.toString(), false);

                                                                                    setState(() {
                                                                                      successChecks[index] = false; // อัปเดตสถานะปุ่มในแอป
                                                                                    });

                                                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                                                      SnackBar(content: Text('สถานะเปลี่ยนเป็น "ยังตรวจงานไม่ครบ"')),
                                                                                    );
                                                                                  },
                                                                                );
                                                                              },
                                                                              style: ElevatedButton.styleFrom(
                                                                                backgroundColor: Colors.red,
                                                                              ),
                                                                              child: Text('ยังตรวจงานไม่ครบ',style: TextStyle(color: Colors.black),),
                                                                            ),

                                                                          ],
                                                                        ),
                                                                        Text(' ${exam.autoId} Status: ${exam.inspectionStatus} '),
                                                                        Text(
                                                                          " ${exam.direction} ",
                                                                          style: TextStyle(
                                                                            fontSize: 18,
                                                                            fontWeight: FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text("คะแนนเต็ม: ${exam.fullMark}"),
                                                                            IconButton(
                                                                              onPressed: () {
                                                                                setState(() {
                                                                                  selectedExam = exam;
                                                                                });
                                                                              },
                                                                              icon: Icon(Icons.search),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                            ],
                                          ),
                                        )                      
                                      ]
                                    ),
                                  ),
                                  SizedBox(width: 20,),

                            
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
                              child: selectedExam != null
                                    ? Padding(
                                        padding: EdgeInsets.all(20),
                                        child: Detail_work(
                                          exam: selectedExam!,
                                          thfname: widget.thfname,
                                          thlname: widget.thlname,
                                          username: widget.username,                                
                                        ),
                                      )
                                    : Center(child: Text("กรุณาเลือกงาน")),
                              
                              
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



