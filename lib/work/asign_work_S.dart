import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:flutter_esclass_2/Home/Even.dart';
import 'package:flutter_esclass_2/Model/appbar_students.dart';
import 'package:flutter_esclass_2/Model/menu_t.dart';
import 'package:flutter_esclass_2/Model/menu_s.dart';
import 'package:flutter_esclass_2/work/Menu_listclassroom_S%20AssignWork.dart';
import 'package:flutter_esclass_2/work/Detail_work_students.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class work_body_S extends StatefulWidget {
  final String thfname;
  final String thlname;
  final String username;
  final String classroomName;
  final String classroomMajor;
  final String classroomYear;
  final String classroomNumRoom;
  const work_body_S({
    super.key, 
    required this.thfname, 
    required this.thlname, 
    required this.username, 
    required this.classroomName, 
    required this.classroomMajor, 
    required this.classroomYear, 
    required this.classroomNumRoom
  });
  

  @override
  State<work_body_S> createState() => _work_body_SState();
}

class _work_body_SState extends State<work_body_S> {     
  late final Map<DateTime, List<Map<String, String>>> _events = {};
  List<Examset> examsets = [];   
  bool isLoadingExamset = true;
  List<Examset> futurexamsets = [];
  List<Examset> pastDeadlines = [];
  bool isLoading = true; 
  Examset? selectedExam;





  Future<List<Examset>> fetchExamsets(String classroomName, String classroomMajor, String classroomYear, String classroomNumRoom, String username) async {
  final response = await http.post(
    Uri.parse('https://www.edueliteroom.com/connect/%20fetch_examsets_students.php'),
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

  for (var examset in examsets) {
    DateTime deadlineDate = DateTime.parse(examset.deadline);

    if (deadlineDate.isAfter(currentDate) || deadlineDate.isAtSameMomentAs(currentDate)) {
      futureExamsetsTemp.add(examset);
    } else if (deadlineDate.isBefore(yesterdayDate)) {
      pastDeadlinesTemp.add(examset);
    }
  }


  setState(() {
    futurexamsets = futureExamsetsTemp;
    pastDeadlines = pastDeadlinesTemp;
  });

}


Future<void> fetchEvents() async {
  final url = Uri.parse('https://www.edueliteroom.com/connect/event_students.php?users_username=${widget.username}');
  
  try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        
        if (responseData['status'] == 'success') {
          setState(() {
            _events.clear();
            dataevent.clear();
            isLoading = false;

            List<Even_teacher> todayEvents = []; // รายการสำหรับกิจกรรมในวันปัจจุบัน
            List<Even_teacher> futureEvents = []; // รายการสำหรับกิจกรรมในอนาคต

            for (var event in responseData['data']) {
              DateTime eventDate = DateTime.parse(event['event_users_date']);
              
              // ตรวจสอบกิจกรรมในวันปัจจุบัน
              if (eventDate.isAtSameMomentAs(DateTime.now())) {
                todayEvents.add(Even_teacher(
                  Title: event['event_users_title'],
                  Date: event['event_users_date'],
                  Time: event['event_users_time'],
                ));
              } 
              // ตรวจสอบกิจกรรมในอนาคต
              else if (eventDate.isAfter(DateTime.now())) {
                futureEvents.add(Even_teacher(
                  Title: event['event_users_title'],
                  Date: event['event_users_date'],
                  Time: event['event_users_time'],
                ));
              }
            }
            
            // รวมกิจกรรมในวันปัจจุบันและกิจกรรมในอนาคต
            dataevent = todayEvents + futureEvents;
            
            // เรียงลำดับกิจกรรมในอนาคต
            futureEvents.sort((a, b) => DateTime.parse(a.Date).compareTo(DateTime.parse(b.Date)));
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
void initState() {
  super.initState();
  loadExamsets();
  fetchEvents();
}





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 195, 238, 250),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 152, 186, 218),
        title: Text('Edueliteroom'),
        actions: [
          appbarstudents(context, widget.thfname, widget.thlname, widget.username),
        ],
        ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(height: 10,),
            Column(
              children: [
                SizedBox(height: 30),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
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
                                  
                                  
                                  SizedBox(
                                    height: 500,
                                    width: 350,
                                    child: List_classroom_Sinclass(thfname: widget.thfname, thlname: widget.thlname, username: widget.username) // Menu_listclassroom.dart
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
                    

                      //งานที่ได้รับ
                     Container(
                      height: 1000,
                      width: 600,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)
                        ),
                        
                        child: Column(
                          children: [
                           

                          
                            //งานที่มอบหมาย
                            Container(
                              height: 400,
                              width: 500,
                              padding: EdgeInsets.all(20),
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 50),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 147, 185, 221),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "งานที่มอบหมายทั้งหมด (${futurexamsets.length} งาน)",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  const SizedBox(height: 10),
                                  isLoadingExamset
                                      ? Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : futurexamsets.isEmpty
                                          ? Center(
                                              child: Text("ไม่มีงานที่มอบหมาย"),
                                            )
                                          : Expanded(
                                              child: ListView.builder(
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
                              height: 400,
                              width: 500,
                              padding: EdgeInsets.all(20),
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 50),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 147, 185, 221),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "งานที่เลยกำหนดแล้วทั้งหมด (${pastDeadlines.length} งาน)",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  const SizedBox(height: 10),
                                  isLoadingExamset
                                      ? Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : pastDeadlines.isEmpty
                                          ? Center(
                                              child: Text("ไม่มีงานที่มอบหมาย"),
                                            )
                                          : Expanded(
                                              child: ListView.builder(
                                                itemCount: pastDeadlines.length,
                                                itemBuilder: (context, index) {
                                                  final exam = pastDeadlines[index];
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
                                                          Text(
                                                            " ${exam.direction} ",
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),

                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text("คะแนนเต็ม: ${exam.fullMark}"),
                                                              IconButton(onPressed: (){
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
                                              ),
                                            ),
                                ],
                              ),
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
                              child: selectedExam != null
                                    ? Padding(
                                        padding: EdgeInsets.all(20),
                                        child: Detail_work_S(exam: selectedExam!,thfname: widget.thfname, thlname: widget.thlname,username: widget.username,),
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

