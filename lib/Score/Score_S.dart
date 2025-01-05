import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:flutter_esclass_2/Home/homeS.dart';
import 'package:flutter_esclass_2/Login/login.dart';
import 'package:flutter_esclass_2/Model/Chat.dart';
import 'package:flutter_esclass_2/Model/appbar_students.dart';
import 'package:flutter_esclass_2/Profile/ProfileS.dart';
import 'package:flutter_esclass_2/Score/Menu_listclassroom_S_score.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


class Score_S extends StatefulWidget {
  final String thfname;
  final String thlname;
  final String username;
  final String classroomName;
  final String classroomMajor;
  final String classroomYear;
  final String classroomNumRoom;
  const Score_S({
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
  State<Score_S> createState() => _Score_SState();
}

class _Score_SState extends State<Score_S> {
  late final Map<DateTime, List<Map<String, String>>> _events = {};
  int unreadCount = 0; 
  List<Even_teacher> dataevent = [];
  bool hasTodayEvent = false; 

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

  bool isToday(String eventDate) {
    final today = DateTime.now();
    final eventDateTime = DateTime.parse(eventDate); 
    return today.year == eventDateTime.year &&
           today.month == eventDateTime.month &&
           today.day == eventDateTime.day;
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
  @override
  void initState() {
    super.initState();
    fetchEvents();
    _getUnreadNotifications();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 195, 238, 250),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 152, 186, 218),
        title: Text('หน้าหลัก'),
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
            SizedBox(height: 10),
            Column(
              children: [
                SizedBox(height: 30),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
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
                                    child: MenuListclassroomSScore(thfname: widget.thfname, thlname: widget.thlname, username: widget.username) // Menu_listclassroom.dart
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
                      SizedBox(width: 50,),
                      Container(
                        height: 1000,
                        width: 1440,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)
                        ), 
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: Text(' ${widget.classroomName} ${widget.classroomYear}/${widget.classroomNumRoom} (${widget.classroomMajor})',style: TextStyle(fontSize: 20),),
                            )

                          ],
                        ),

                      )

                        




                            ],

                          ),

                        ),]
                      ),


                      







                    ],
                  ),
                )

            
          


        );
    

  }
}



//------------------------------------------------------
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





