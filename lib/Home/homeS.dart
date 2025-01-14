import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:flutter_esclass_2/Home/calendar_S.dart';
import 'package:flutter_esclass_2/Home/homeT.dart';
import 'package:flutter_esclass_2/Home/todolist_S.dart';
import 'package:flutter_esclass_2/Home/todolist_T.dart';
import 'package:flutter_esclass_2/Login/login.dart';
import 'package:flutter_esclass_2/Model/appbar_students.dart';
import 'package:flutter_esclass_2/Model/menu_s.dart';
import 'package:flutter_esclass_2/Model/menu_t.dart';
import 'package:flutter_esclass_2/Profile/ProfileS.dart';
import 'package:flutter_esclass_2/Score/Score_S.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class main_home_S extends StatefulWidget {
  final String thfname;
  final String thlname;
  final String username;

  const main_home_S({
    super.key, 
    required this.thfname,
    required this.thlname, 
    required this.username,
    });


  @override
  State<main_home_S> createState() => _homeState();
}

class _homeState extends State<main_home_S> {
   int unreadCount = 0; 

  Future<Map<String, String>> fetchTeacherInfo() async {
    final response = await http.get(Uri.parse('https://www.edueliteroom.com/connect/get_user_students.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        'thfname': data['users_thfname'] ?? "ไม่ระบุ",
        'thlname': data['users_thlname'] ?? "ไม่ระบุ",
      };
    } else {
      throw Exception('ล้มเหลวในการโหลดข้อมูล');
    }
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
        title: Text('หน้าหลัก'),
        actions: [
          appbarstudents(
            thfname: widget.thfname,
            thlname: widget.thlname,
            username: widget.username,
            unreadCount: unreadCount, 
            classroomMajor: '',
            classroomName: '',
            classroomNumRoom: '',
            classroomYear: '',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child:  Column(
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
                        child:Menuu_class_s(thfname: widget.thfname, thlname: widget.thlname, username: widget.username), //menu.dart
                      ),

                      //ปฏิทิน
                      Container(
                        height: screenHeight * 0.9,
                        width: screenWidth * 0.8,
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              //calender
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: SizedBox(
                                  height: screenHeight * 0.47,
                                  width: screenWidth * 1.45,
                                  child: CalendarHome_S(username: widget.username), //calendar.dart
                                ),
                              ),

                              //todolist
                              Container(
                                height: screenHeight * 0.35,
                                width: screenWidth * 1.4,           
                                margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Todocalss_S(username: widget.username), //todolist_body.dart
                              ),
                            ],
                          )
                        ),
                      ),
                    ],
                )
              
            
          ],
        ))
      
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

