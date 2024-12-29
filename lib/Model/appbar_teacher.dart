import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Classroom/classT.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:flutter_esclass_2/Home/homeT.dart';
import 'package:flutter_esclass_2/Login/login.dart';
import 'package:flutter_esclass_2/Profile/ProfileT.dart';
import 'package:flutter_esclass_2/Score/Score_T.dart';
import 'package:flutter_esclass_2/work/asign_work_T.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;



class appbarteacher extends StatefulWidget {
  final String thfname;
  final String thlname;
  final String username;

  const appbarteacher({
    super.key,
    required this.thfname,
    required this.thlname,
    required this.username,
  });

  @override
  _appbarteacherState createState() => _appbarteacherState();
}

class _appbarteacherState extends State<appbarteacher> {
  List<NotificationData_sumit> notifications = [];
  int unreadCount = 0;

  Future<void> showNotifications() async {
  Notification notificationService = Notification();
  List<NotificationData_sumit> fetchedNotifications = await notificationService.fetchNotifications(widget.username);

  // ใช้ setState เพื่ออัปเดตข้อมูล
  setState(() {
    notifications = fetchedNotifications;
  });

  // ใช้ Future.delayed เพื่อให้แน่ใจว่า alert dialog แสดงหลังจากข้อมูลถูกโหลด
  Future.delayed(Duration.zero, () {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('การแจ้งเตือน'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: notifications.length,
              itemBuilder: (BuildContext context, int index) {
                final notification = notifications[index];
                return ListTile(
                  leading: Icon(
                    Icons.notifications,
                    color: Colors.grey,
                  ),
                  title: Text('มีการส่งงานใหม่ของนักเรียน'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(notification.title),
                      Text('เวลา: ${notification.time}'),
                      Text('วิชา: ${notification.classroomName} (${notification.classroomYear}/${notification.classroomNumRoom})'),
                    ],
                  ),
                );
              },
            ),
          ),
          actions: [
            // ปุ่มปิด
            TextButton(
              onPressed: () async {
                // อัปเดตสถานะของการแจ้งเตือนทั้งหมดที่ยังไม่ได้อ่านเป็น 'Alreadyread'
                await markAllNotificationsAsRead();
                Navigator.of(context).pop(); // ปิด dialog
              },
              child: const Text('ปิด'),
            ),
          ],
        );
      },
    );
  });
}

Future<void> markAllNotificationsAsRead() async {
  const String url = 'https://www.edueliteroom.com/connect/update_notificationassubmit_status.php';
  
  // สร้างรายการของ notification_ids ที่ต้องการอัพเดต
  List<int> notificationIdsToUpdate = notifications
      .where((notification) => notification.readStatus == false) // กรองเฉพาะการแจ้งเตือนที่ยังไม่ได้อ่าน
      .map((notification) => notification.id) // ดึง id ของการแจ้งเตือน
      .toList();

  // ส่งคำขอ POST ไปยังเซิร์ฟเวอร์เพื่ออัพเดตสถานะ
  for (int id in notificationIdsToUpdate) {
    final response = await http.post(Uri.parse(url), body: {
      'notification_id': id.toString(), // ส่ง notification_id
      'status': 'Alreadyread', // ส่งสถานะที่ต้องการอัพเดต
    });

    if (response.statusCode == 200) {
      print("Notification ID $id marked as 'Alreadyread'.");
    } else {
      print("Failed to update notification ID $id.");
    }
  }

  // หลังจากอัพเดตเสร็จแล้ว
  fetchUnreadNotifications();
  print("All unread notifications marked as 'Alreadyread'.");
}


Future<void> fetchUnreadNotifications() async {
  Notification notificationService = Notification();
  List<NotificationData_sumit> fetchedNotifications =
          await notificationService.fetchNotifications(widget.username);
  List<NotificationData_sumit> unreadNotifications = fetchedNotifications
      .where((notification) => notification.readStatus == false) 
      .toList();

  
  int count = unreadNotifications.length;

  setState(() {
    notifications = fetchedNotifications;  
    unreadCount = count; 
  });
}

  

  @override
  void initState() {
    super.initState();
    fetchUnreadNotifications();
  }



  void navigateTo(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "${widget.thfname} ${widget.thlname}",
          style: const TextStyle(fontSize: 20),
        ),
        IconButton(
          onPressed: () => navigateTo(const Profile_T()),
          icon: Image.asset("assets/images/ครู.png"),
          iconSize: 30,
        ),
        Stack(
          children: [
            IconButton(
              style: IconButton.styleFrom(
                highlightColor: const Color.fromARGB(255, 170, 205, 238),
              ),
              onPressed: () {
                showNotifications();
              },
              icon: const Icon(Icons.notifications),
              tooltip: 'แจ้งเตือน',
            ),
            if (unreadCount > 0)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Text(
                    '$unreadCount',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        
        Container(
           height: 45,
           decoration: BoxDecoration(
              color: const Color.fromARGB(255, 71, 136, 190),
              borderRadius: BorderRadius.circular(20),
            ),
          child: Row(
            children: [
              IconButton(
                onPressed: () => navigateTo(main_home_T(
                  thfname: widget.thfname,
                  thlname: widget.thlname,
                  username: widget.username,
                )),
                icon: const Icon(Icons.home),
                tooltip: 'หน้าหลัก',
              ),
              IconButton(
                onPressed: () => navigateTo(ClassT(
                  thfname: widget.thfname,
                  thlname: widget.thlname,
                  username: widget.username,
                  classroomName: '',
                  classroomMajor: '',
                  classroomYear: '',
                  classroomNumRoom: '',
                )),
                icon: const Icon(Icons.class_outlined),
                tooltip: 'ห้องเรียน',
              ),

              IconButton(
                    style: IconButton.styleFrom(
                      highlightColor: const Color.fromARGB(255, 170, 205, 238),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AssignWork_class_T(thfname: widget.thfname, thlname: widget.thlname, username: widget.username, classroomMajor: '', classroomName: '', classroomYear: '', classroomNumRoom: '')),
                      );
                    },
                    icon: const Icon(Icons.edit_document),
                    tooltip: 'งานที่มอบหมาย',
                  ),

              IconButton(
                    style: IconButton.styleFrom(
                      highlightColor: const Color.fromARGB(255, 170, 205, 238),
                    ),
                    onPressed: () => navigateTo(Score_T_body(thfname: widget.thfname, thlname: widget.thlname, username: widget.username, classroomMajor: '', classroomName: '', classroomYear: '', classroomNumRoom: '')), 
                    icon: const Icon(Icons.list_alt),
                    tooltip: 'รายชื่อนักเรียน',
                  ),
            ],
          ),
        ),
                 
        IconButton(
          style: IconButton.styleFrom(
            hoverColor: const Color.fromARGB(255, 235, 137, 130),
          ),
          onPressed: () => navigateTo(const Login_class()),
          icon: const Icon(Icons.logout),
          tooltip: 'ออกจากระบบ',
        ),
      ],
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

