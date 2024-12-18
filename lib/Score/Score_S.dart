import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:flutter_esclass_2/Home/homeS.dart';
import 'package:flutter_esclass_2/Login/login.dart';
import 'package:flutter_esclass_2/Model/Chat.dart';
import 'package:flutter_esclass_2/Model/appbar_students.dart';
import 'package:flutter_esclass_2/Profile/ProfileS.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


class Score_S extends StatefulWidget {
  final String thfname;
  final String thlname;
  final String username;
  const Score_S({super.key, required this.thfname, required this.thlname, required this.username});

  @override
  State<Score_S> createState() => _Score_SState();
}

class _Score_SState extends State<Score_S> {
  int unreadCount = 0; 

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
    return Scaffold(
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


