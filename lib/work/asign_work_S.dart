import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
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
  List<Even_teacher> dataevent = [];
  List<Examset> futurexamsets = [];
  List<Examset> pastDeadlines = [];
  List<Examset> completeexamsets = [];
  bool isLoading = true; 
  Examset? selectedExam;
  List<bool> successChecks =[];
  bool isExpandedFuture = false;
  bool isExpandedPast = false;
  bool isExapandedcomplete = false;
  bool hasTodayEvent = false; // เช็คว่ามีงานวันนี้หรือไม่
  int unreadCount = 0;




  Future<List<Examset>> fetchExamsets(String classroomName, String classroomMajor,
    String classroomYear, String classroomNumRoom, String username) async {
  final response = await http.post(
    Uri.parse('https://www.edueliteroom.com/connect/fetch_examsets_students.php'),
    body: {
      'classroomName': classroomName,
      'classroomMajor': classroomMajor,
      'classroomYear': classroomYear,
      'classroomNumRoom': classroomNumRoom,
      'username': username,
    },
  );

print("classroomName: $classroomName");
print("classroomMajor: $classroomMajor");
print("classroomYear: $classroomYear");
print("classroomNumRoom: $classroomNumRoom");
print("username: $username");
// print("Response Status Code: ${response.statusCode}");
// print("Response Body: ${response.body}");




  if (response.statusCode == 200) {
    // ตรวจสอบ JSON Response
    final decodedResponse = json.decode(response.body);
    
    if (decodedResponse is Map<String, dynamic>) {
      // กรณีเป็น Object และมี error
      if (decodedResponse.containsKey('error')) {
        throw Exception("ข้อผิดพลาดจากเซิร์ฟเวอร์: ${decodedResponse['error']}");
      } else {
        throw Exception("รูปแบบข้อมูลไม่ถูกต้อง: ได้รับ Object แทนที่จะเป็น List");
      }
    } else if (decodedResponse is List) {
      // กรณีเป็น List ให้แปลงเป็น Examset
      return decodedResponse.map((data) => Examset.fromJson(data)).toList();
    } else {
      throw Exception("รูปแบบข้อมูลไม่ถูกต้อง");
    }
  } else {
    throw Exception('ไม่สามารถโหลดข้อมูลจากเซิร์ฟเวอร์ได้');
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
  List<Examset> completeExamsetsTemp = []; // เปลี่ยนชื่อจาก completeexamsets

  for (var examset in examsets) {
    DateTime deadlineDate = DateTime.tryParse(examset.deadline) ?? DateTime.now();
    
    if (examset.inspectionStatus == 'complete') {
      completeExamsetsTemp.add(examset); // ใช้ชื่อใหม่
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

  setState(() {
    futurexamsets = futureExamsetsTemp;
    pastDeadlines = pastDeadlinesTemp;
    completeexamsets = completeExamsetsTemp;
  });
}




void fetchEvents() async {
  final url = Uri.parse(
      'https://www.edueliteroom.com/connect/event_assignment_students.php?usert_username=${widget.username}');
  try {
    final response = await http.get(url);
    

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
    
      if (responseData['status'] == 'success') {
        setState(() {
          _events.clear();
          dataevent.clear();

          for (var event in responseData['data_assignment']) {
            try {
              // แปลงวันที่กำหนดส่งให้เป็น DateTime object
              DateTime eventDate = DateTime.parse(event['event_assignment_duedate']);
              final eventDateKey = DateTime(eventDate.year, eventDate.month, eventDate.day);

              // เพิ่มข้อมูลเหตุการณ์ทั้งหมดไปยัง dataevent
              dataevent.add(Even_teacher(
                Title: event['event_assignment_title'] ?? '',
                Date: event['event_assignment_duedate'] ?? '',
                Time: event['event_assignment_time'] ?? '',
                Class: event['classroom_name'] ?? '',
                Major: event['classroom_major'] ?? '',
                Year: event['classroom_year'] ?? '',
                Room: event['classroom_numroom'] ?? '',
                ClassID: event['event_assignment_classID'] ?? '',
              ));

              // จัดเก็บข้อมูลทั้งหมดสำหรับ UI
              if (_events[eventDateKey] == null) {
                _events[eventDateKey] = [];
              }
              _events[eventDateKey]!.add({
                'event': event['event_assignment_title'] ?? '',
                'date': event['event_assignment_duedate'] ?? '',
                'time': event['event_assignment_time'] ?? '',
                'classroom_name': event['classroom_name'] ?? '',
                'classroom_major': event['classroom_major'] ?? '',
                'classroom_year': event['classroom_year'] ?? '',
                'classroom_numroom': event['classroom_numroom'] ?? '',
                'classID': event['event_assignment_classID'] ?? '',
              });
            } catch (e) {
              print('Error parsing event date: $e');
            }
          }

          // อัปเดตเหตุการณ์ที่เลือกไว้สำหรับ UI
        });
      } else {
        // ใช้ Snackbar เพื่อแจ้งข้อผิดพลาดให้ผู้ใช้
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: ${responseData['message']}'),
        ));
      }
    } else {
      // แสดงข้อผิดพลาดเมื่อ HTTP status code ไม่ใช่ 200
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to fetch data: ${response.statusCode}'),
      ));
    }
  } catch (e) {
    print('Network error: $e');
    // แจ้งข้อผิดพลาดหากเกิดข้อผิดพลาดในการเชื่อมต่อ
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Network error: $e'),
    ));
  }
}
bool isToday(String eventDate) {
    final today = DateTime.now();
    final eventDateTime = DateTime.parse(eventDate); // Assuming the date is in ISO 8601 format (yyyy-MM-dd)
    return today.year == eventDateTime.year &&
           today.month == eventDateTime.month &&
           today.day == eventDateTime.day;
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

Future<void> _getUnreadNotifications() async {
    Notification notificationService = Notification();
    try {
      // ส่ง username ที่ได้รับมาจาก widget
      List<NotificationData> fetchedNotifications =
          await notificationService.fetchNotifications(widget.username);

      if (fetchedNotifications.isNotEmpty) {
        // นับจำนวนการแจ้งเตือนที่ยังไม่ได้อ่าน
        int count = fetchedNotifications
            .where((notification) => notification.user == 'notread')
            .length;
        setState(() {
          unreadCount = count;
        });
      } else {
        print("ไม่มีข้อมูลการแจ้งเตือน");
      }
    } catch (e) {
      print("เกิดข้อผิดพลาดในการดึงข้อมูลการแจ้งเตือน: $e");
    }
  }



@override
void initState() {
  super.initState();
  loadExamsets();
  fetchEvents();
  _getUnreadNotifications();
}





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 195, 238, 250),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 152, 186, 218),
        title: Text(
          'งานที่ได้รับ',
        ),
        actions: [
          appbarstudents(
            thfname: widget.thfname,
            thlname: widget.thlname,
            username: widget.username,
            unreadCount: unreadCount, 
          ),
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
                              height: 550,
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
                  height: 420,
                  width: 350,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        'งานที่มอบหมาย',
                        style: TextStyle(fontSize: 20),
                      ),

                      // If there is no event today, show the message
                      if (!hasTodayEvent) 
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const ListTile(
                            title: Text('- ไม่มีงานที่ต้องส่งในวันนี้ -'),
                          ),
                        ),

                      Expanded(
                        child: ListView.builder(
                          itemCount: dataevent.length,
                          itemBuilder: (context, index) {
                            final event = dataevent[index];
                            final isEventToday = isToday(event.Date); // Check if it's today

                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                color: isEventToday
                                    ? Colors.blue // Blue for today
                                    : const Color.fromARGB(255, 195, 238, 250), // Light color for other days
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ListTile(
                                title: Text(event.Title),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('วันที่สุดท้ายของการส่งงาน: ${event.Date}'),
                                    Text('วิชา: ${event.Class} (${event.Year}/${event.Room})'),
                                  ],
                                ) 
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
                                                            Text(' ${exam.time}'),
                                                            
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
                                                        
                                                          Text(' ${exam.time}'),
                                                          
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
                                                                        Text(' ${exam.time}'),
                                                                        
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

class Notification {
  final String apiUrl = 'https://www.edueliteroom.com/connect/notification_assingment.php';

  Future<List<NotificationData>> fetchNotifications(String username) async {
    try {
      // ส่งข้อมูล username ไปยัง API
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {'username': username},
      );


      if (response.statusCode == 200) {

        var data = json.decode(response.body);


        List<dynamic> notifications = data['notifications'];

        return notifications.map((item) => NotificationData.fromMap(item)).toList();
      } else {
        throw Exception('Failed to load notifications: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching notifications: $e');
      return [];
    }
  }
}