import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Classroom/classT.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:flutter_esclass_2/Home/calendar_T.dart';
import 'package:flutter_esclass_2/Home/todolist_T.dart';
import 'package:flutter_esclass_2/Model/appbar_teacher.dart';
import 'package:flutter_esclass_2/Model/menu_t.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class main_home_T extends StatefulWidget {
  final String thfname;
  final String thlname;
  final String username;  // เพิ่มตัวแปร username
  const main_home_T({
    super.key,
    required this.thfname, 
    required this.thlname, 
    required this.username,
    });

  @override
  State<main_home_T> createState() => _main_home_TState();
}

class _main_home_TState extends State<main_home_T> {
  int unreadCount = 0;

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

  Future<Map<String, String>> fetchTeacherInfo() async {
    final response = await http.get(Uri.parse('https://www.edueliteroom.com/connect/get_user_teacher.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        'thfname': data['usert_thfname'] ?? "ไม่ระบุ",
        'thlname': data['usert_thlname'] ?? "ไม่ระบุ",
      };
    } else {
      throw Exception('ล้มเหลวในการโหลดข้อมูล');
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
            classroomMajor: '',
            classroomName:  '',
            classroomNumRoom: '',
            classroomYear: '',
          ),
        ],
      ),
      body: FutureBuilder<Map<String, String>>(
        future: fetchTeacherInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text("เกิดข้อผิดพลาดในการเชื่อมต่อ: ${snapshot.error}"),
            );
          } else {
            if (widget.thfname.isEmpty || widget.thlname.isEmpty) {
              return Center(
                child: Text("ชื่อหรือชื่อสกุลไม่ถูกต้อง"),
              );
            }
            return Scaffold(
              backgroundColor: Color.fromARGB(255, 195, 238, 250),
              body: SingleChildScrollView(
                child: Column(
                      children: [
                        SizedBox(height: screenHeight * 0.01),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [                    
                              Container(
                                height: screenHeight * 0.9,
                                width: screenWidth * 0.18,
                                alignment: Alignment.topCenter,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 195, 238, 250),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                ),
                                child: Menuu_class(thfname: widget.thfname, thlname: widget.thlname, username: widget.username,),
                              ),
                              Container(
                                height: screenHeight * 0.9,
                                width: screenWidth * 0.8,
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(5),
                                        child: SizedBox(
                                          height: screenHeight * 0.47,
                                          width: screenWidth * 1.45,
                                          child: CalendarHome_T(username: widget.username), 
                                        ),
                                      ),
                                      Container(
                                        height: screenHeight * 0.35,
                                        width: screenWidth * 1.4,
                                        margin: EdgeInsets.fromLTRB(10, 0, 10, 5),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Todocalss_T(username: widget.username),
                                      ),
                                    ],
                                  ),
                                
                              ),
                            ],
                          ),
                        
                      ],
                    ),
              )
                
            );
          }
        },
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