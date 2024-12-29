import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Classroom/setting_calss.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:flutter_esclass_2/Model/appbar_teacher.dart';
import 'package:flutter_esclass_2/Model/menu_t.dart';
import 'package:flutter_esclass_2/Score/Menu_listclassroom_T_score.dart';
import 'package:flutter_esclass_2/Score/Tab.dart';
import 'package:flutter_esclass_2/Score/checkinclassroom.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Score_T_body extends StatefulWidget {
  final String username;
  final String thfname;
  final String thlname;
  final String classroomName;
  final String classroomMajor;
  final String classroomYear;
  final String classroomNumRoom;

  const Score_T_body ({
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
  State<Score_T_body> createState() => _Score_T_bodyState();
}

class _Score_T_bodyState extends State<Score_T_body> {
  List<Even_teacher> dataevent = [];
  int unreadCount = 0;
  bool hasTodayEvent = false;
  bool isLoading = true;


  @override
  void initState() {
    super.initState();

    _getUnreadNotifications();
  }


  Future<void> fetchEvents() async {
    final url = Uri.parse('https://www.edueliteroom.com/connect/event_assignment.php?usert_username=${widget.username}');
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


  Future<void> _getUnreadNotifications() async {
    Notification notificationService = Notification();
    try {
      // ส่ง username ที่ได้รับมาจาก widget
      List<NotificationData_sumit> fetchedNotifications =
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 195, 238, 250),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 152, 186, 218),
        title: Text(
          'หน้าหลัก',
        ),
        actions: [
          appbarteacher(
            thfname: widget.thfname,
            thlname: widget.thlname,
            username: widget.username,
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
                                    height: 500,
                                    width: 350,
                                    child: List_classroom_Score(thfname: widget.thfname, thlname: widget.thlname, username: widget.username,), // Menu_listclassroom.dart
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
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: 20),
                                  Text(
                                    'งานที่มอบหมาย',
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




                      SizedBox(width: 50,),

                      Container(
                        height: 1000,
                        width: 1440,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)
                        ), 
                        child: TabScore(
                          classroomMajor: widget.classroomMajor,
                          classroomName: widget.classroomName,
                          classroomNumRoom: widget.classroomNumRoom,
                          classroomYear: widget.classroomYear,
                          thfname: widget.thfname,
                          thlname: widget.thlname,
                          username: widget.username,
                        ),  
                                         
                      ),
                      SizedBox(width: 30)
                      
                    ],
                  ),
                )
              ],
            )
          ],
        ),
       ),
    );
  }
}


class Notification {
  final String apiUrl = 'https://www.edueliteroom.com/connect/notification_submit.php';

  Future<List<NotificationData_sumit>> fetchNotifications(String username) async {
    try {
      // ส่งข้อมูล username ไปยัง API
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {'username': username},
      );


      if (response.statusCode == 200) {

        var data = json.decode(response.body);


        List<dynamic> notifications = data['notifications'];

        return notifications.map((item) => NotificationData_sumit.fromMap(item)).toList();
      } else {
        throw Exception('Failed to load notifications: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching notifications: $e');
      return [];
    }
  }
}
