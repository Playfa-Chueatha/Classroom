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
  bool hasTodayEvent = false; 
  int unreadCount = 0;




  // ฟังก์ชันเพื่อแปลง JSON จาก PHP เป็น List<Examset>
Future<Map<String, List<Examset>>> fetchExamsets(String classroomName, String classroomMajor,
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

  print(response.body);

  if (response.statusCode == 200) {
    final decodedResponse = json.decode(response.body);
    print("Response from server: ${response.body}"); 

    if (decodedResponse is Map<String, dynamic>) {
      if (decodedResponse.containsKey('error')) {
        throw Exception("ข้อผิดพลาดจากเซิร์ฟเวอร์: ${decodedResponse['error']}");
      }

      // แปลงข้อมูล completed_examsets และ future_examsets
      List<Examset> completedExamsets = [];
      List<Examset> futureExamsets = [];

      if (decodedResponse['completed_examsets'] != null) {
        completedExamsets = List<Examset>.from(
          decodedResponse['completed_examsets'].map((examset) => Examset.fromJson(examset))
        );
      }

      if (decodedResponse['future_examsets'] != null) {
        futureExamsets = List<Examset>.from(
          decodedResponse['future_examsets'].map((examset) => Examset.fromJson(examset))
        );
      }

      // ส่งค่ากลับ
      return {
        'completed_examsets': completedExamsets,
        'future_examsets': futureExamsets,
      };
    } else {
      throw Exception("รูปแบบข้อมูลที่ได้รับไม่ถูกต้อง");
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
    final response = await http.post(
      Uri.parse('https://www.edueliteroom.com/connect/fetch_examsets_students.php'),
      body: {
        'classroomName': widget.classroomName,
        'classroomMajor': widget.classroomMajor,
        'classroomYear': widget.classroomYear,
        'classroomNumRoom': widget.classroomNumRoom,
        'username': widget.username,
      },
    );

    // ตรวจสอบ status code และเนื้อหาของ response
    if (response.statusCode == 200) {
      try {
        final decodedResponse = json.decode(response.body);

        if (decodedResponse['error'] != null) {
          throw Exception("Error from server: ${decodedResponse['error']}");
        }

        List<Examset> completedExamsets = List<Examset>.from(
          decodedResponse['completed_examsets'].map((examset) => Examset.fromJson(examset))
        );

        List<Examset> futureExamsets = List<Examset>.from(
          decodedResponse['future_examsets'].map((examset) => Examset.fromJson(examset))
        );

        await filterExamsets(futureExamsets, completedExamsets);

      } catch (e) {
        throw Exception("Error parsing JSON: $e");
      }
    } else {
      print("Failed to load data. Status code: ${response.statusCode}");
      print("Response body: ${response.body}");
    }
  } catch (e) {
    print("Error fetching examsets: $e");
  } finally {
    setState(() {
      isLoadingExamset = false;
    });
  }
}


Future<void> filterExamsets(List<Examset> futureExamsets, List<Examset> completedExamsets) async {
  DateTime currentDate = DateTime.now();
  DateTime yesterdayDate = currentDate.subtract(Duration(days: 1));

  // ตัวแปรที่จะเก็บข้อมูลที่กรองแล้ว
  List<Examset> futureExamsetsTemp = [];
  List<Examset> pastDeadlinesTemp = [];

  // ลูปผ่าน futureExamsets เพื่อกรองข้อมูลตามเงื่อนไข
  for (var examset in futureExamsets) {
    DateTime deadlineDate = DateTime.tryParse(examset.deadline) ?? DateTime.now();

    if (examset.inspectionStatus != 'complete') {
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

  // อัปเดตตัวแปรที่เก็บค่าหลังจากกรองแล้ว
  setState(() {
    futurexamsets = futureExamsetsTemp;
    pastDeadlines = pastDeadlinesTemp;
    completeexamsets = completedExamsets;  // ใช้ค่าจาก completedExamsets ที่ได้รับจากฟังก์ชัน fetchExamsets
  });
}






Future<void> fetchEvents() async {
    final url = Uri.parse('https://www.edueliteroom.com/connect/event_assignment_students.php?usert_username=${widget.username}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['status'] == 'success') {
          setState(() {
            dataevent.clear();
            isLoading = false;
            hasTodayEvent = false;

            for (var event in responseData['data_assignment']) {
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
            }

            // Sort events: Today first, then future events
            dataevent.sort((a, b) {
              final dateA = DateTime.parse(a.Date);
              final dateB = DateTime.parse(b.Date);
              return dateA.compareTo(dateB);
            });

            // Check if today has any events
            for (var event in dataevent) {
              if (isToday(event.Date)) {
                hasTodayEvent = true;
                break;
              }
            }
          });
        } else {
          setState(() {
            isLoading = false;
          });
          print('Error: ${responseData['message']}');
        }
      } else {
        setState(() {
          isLoading = false;
        });
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Network error: $e');
    }
  }




  bool isToday(String eventDate) {
    final today = DateTime.now();
    final eventDateTime = DateTime.parse(eventDate); // Assuming the date is in ISO 8601 format (yyyy-MM-dd)
    return today.year == eventDateTime.year &&
           today.month == eventDateTime.month &&
           today.day == eventDateTime.day;
  }

  bool isFuture(String date) {
    DateTime eventDate = DateTime.parse(date);
    DateTime currentDate = DateTime.now();
    
    
    return eventDate.isAfter(currentDate);
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 195, 238, 250),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 152, 186, 218),
        title: Text(
          'งานที่ได้รับ ${widget.classroomName.isNotEmpty ? widget.classroomName : ''} '
          '${widget.classroomYear.isNotEmpty ? '${widget.classroomYear}/' : ''}'
          '${widget.classroomNumRoom.isNotEmpty ? widget.classroomNumRoom : ''} '
          '${widget.classroomMajor.isNotEmpty ? '(${widget.classroomMajor})' : ''}',
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
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //menu
                      Container(
                      height: screenHeight * 0.9,
                      width: screenWidth * 0.18,
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
                              height: screenHeight * 0.4,
                              width: screenWidth * 0.35,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                                color: Colors.white
                              ),
                              child: Column(
                                children: [
                                  
                                  
                                  Container(
                                    height: screenHeight * 0.37,
                                    width: screenWidth * 0.3,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(20)
                                      )
                                    ),
                                    child: List_classroom_Sinclass(thfname: widget.thfname, thlname: widget.thlname, username: widget.username) // Menu_listclassroom.dart
                                  ),

                                ],
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02,),
                          
                            Container(
                                height: screenHeight * 0.475,
                                width: screenWidth * 0.35,
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
                                      'งานที่ได้รับ',
                                      style: TextStyle(fontSize: 20),
                                    ),

                                    
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
                                          final isEventToday = isToday(event.Date); 
                                          final isEventInFuture = isFuture(event.Date); 

                                          
                                          if (isEventToday || isEventInFuture) {
                                            return Container(
                                              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                              decoration: BoxDecoration(
                                                color: isEventToday
                                                    ? Colors.blue 
                                                    : const Color.fromARGB(255, 195, 238, 250), 
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
                                                ),
                                              ),
                                            );
                                          }
                                          return SizedBox(); 
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
                      height: screenHeight * 0.9,
                      width: screenWidth * 0.32,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)
                        ),
                        
                        child: SingleChildScrollView(
                          child: 
                        Column(
                          children: [
                           

                          
                            //งานที่มอบหมาย
                            Container(
                              width: screenWidth * 0.5,
                              margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 147, 185, 221),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Title and Toggle Button
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "งานที่ได้รับทั้งหมด (${futurexamsets.length} งาน)",
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
                                            ? Center(child: Text("ไม่มีงานทีได้รับ"))
                                            : SizedBox(
                                                height: 500, 
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: futurexamsets.length,
                                                  itemBuilder: (context, index) {

                                                    futurexamsets.sort((a, b) => DateTime.parse(b.time).compareTo(DateTime.parse(a.time)));
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
                              width: screenWidth * 0.5,
                              margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 147, 185, 221),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  
                                  
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "งานที่เลยกำหนดส่งแล้วทั้งหมด (${pastDeadlines.length} งาน)",
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
                                            ? Center(child: Text("ไม่มีงานที่เลยกำหนดส่ง"))
                                            : SizedBox( 
                                              height: 500, 
                                              child: ListView.builder(
                                                shrinkWrap: true,                                              
                                                itemCount: pastDeadlines.length,
                                                itemBuilder: (context, index) {

                                                  pastDeadlines.sort((a, b) => DateTime.parse(b.time).compareTo(DateTime.parse(a.time)));
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
                                          width: screenWidth * 0.5,
                                          margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                          padding: EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(255, 147, 185, 221),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    "งานที่ส่งแล้วแล้วทั้งหมด (${completeexamsets.length} งาน)",
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
 

                                              // Content
                                              if (isExapandedcomplete)
                                                isLoadingExamset
                                                    ? Center(child: CircularProgressIndicator())
                                                    : completeexamsets.isEmpty
                                                        ? Center(child: Text("ยังไม่มีงานที่คุณส่งแล้ว"))
                                                        : SizedBox(
                                                            height: 500,
                                                            child: ListView.builder(
                                                              shrinkWrap: true,
                                                              itemCount: completeexamsets.length,
                                                              itemBuilder: (context, index) {

                                                                completeexamsets.sort((a, b) => DateTime.parse(b.time).compareTo(DateTime.parse(a.time)));
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
                        ),)
                      ),



                      //งายที่มอบหมาย รายละเอียด
                      Container(
                        height: screenHeight * 0.9,
                        width: screenWidth * 0.45,
                        margin: EdgeInsets.all(10),
                        alignment: Alignment.topCenter,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 152, 186, 218),
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: screenHeight * 0.05,),
                            Text("รายละเอียดงาน", style: TextStyle(fontSize: 30),),
                 
                            Container(
                              alignment: Alignment.center,
                              height: screenHeight * 0.75,
                              width: screenWidth * 0.4,
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
                    ],
                  ),
              ],
            )
          
        
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