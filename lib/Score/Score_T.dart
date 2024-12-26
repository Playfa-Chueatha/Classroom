import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:flutter_esclass_2/Model/appbar_teacher.dart';
import 'package:flutter_esclass_2/Model/menu_t.dart';
import 'package:flutter_esclass_2/Score/Tab.dart';
import 'package:flutter_esclass_2/Score/checkinclassroom.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Score_T_body extends StatefulWidget {
  final String username;
  final String thfname;
  final String thlname;

  const Score_T_body ({super.key, required this.username, required this.thfname, required this.thlname});


  @override
  State<Score_T_body> createState() => _Score_T_bodyState();
}

class _Score_T_bodyState extends State<Score_T_body> {
  int unreadCount = 0;


  @override
  void initState() {
    super.initState();

    _getUnreadNotifications();
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
                        color: Color.fromARGB(255, 147, 185, 221),
                        borderRadius: BorderRadius.only(
                          topRight:Radius.circular(20),
                          bottomRight: Radius.circular(20)
                        ),
                      ),
                      child:Menuu_class(thfname: widget.thfname, thlname: widget.thlname, username: widget.username,),//menu.dart
                      ),
                      SizedBox(width: 50,),

                      Container(
                        height: 1000,
                        width: 1440,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)
                        ), 
                        child: TabScore(),  
                                         
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
