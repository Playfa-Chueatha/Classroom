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
  final String classroomName;
  final String classroomMajor;
  final String classroomYear;
  final String classroomNumRoom;

  const appbarteacher({
    super.key,
    required this.thfname,
    required this.thlname,
    required this.username,
    required this.classroomName, 
    required this.classroomMajor, 
    required this.classroomYear, 
    required this.classroomNumRoom, 
  });

  @override
  _appbarteacherState createState() => _appbarteacherState();
}

class _appbarteacherState extends State<appbarteacher> {
  List<NotificationData_sumit> notifications = [];
  int unreadCount = 0;
  int selectedIndex = 0;

  Future<void> showNotifications() async {
  Notification notificationService = Notification();
  List<NotificationData_sumit> fetchedNotifications =
      await notificationService.fetchNotifications(widget.username);

  // ใช้ setState เพื่ออัปเดตข้อมูล
  setState(() {
    // จัดเรียง notifications: notread ด้านบน และเรียง id มากไปน้อย
    fetchedNotifications.sort((a, b) {
      if (a.readStatus == b.readStatus) {
        return b.id.compareTo(a.id); // เรียง id มากไปน้อย
      }
      return a.readStatus ? 1 : -1; // notread อยู่ด้านบน
    });
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
                return Container(
                  decoration: BoxDecoration(
                    color: notification.readStatus
                        ? Colors.white // สีพื้นหลังสำหรับ Alreadyread
                        : Colors.blue[50], // สีพื้นหลังสำหรับ notread
                    border: Border.all(
                      color: notification.readStatus
                          ? Colors.grey
                          : Colors.blue, // กรอบสีน้ำเงินสำหรับ notread
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading: Icon(
                      Icons.notifications,
                      color: notification.readStatus
                          ? Colors.grey
                          : Colors.blue, // ไอคอนสีน้ำเงินสำหรับ notread
                    ),
                    title: Text(
                      'มีการส่งงานใหม่ของนักเรียน',
                      style: TextStyle(
                        fontWeight: notification.readStatus
                            ? FontWeight.normal
                            : FontWeight.bold, // ตัวหนาสำหรับ notread
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(notification.title),
                        Text('เวลา: ${notification.time}'),
                        Text(
                          'วิชา: ${notification.classroomName} (${notification.classroomYear}/${notification.classroomNumRoom})',
                        ),
                      ],
                    ),
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



  void navigateTo(int index, Widget page) {
    setState(() {
      selectedIndex = index; // เปลี่ยนสถานะของปุ่มที่ถูกเลือก
    });
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
        onPressed: () => navigateTo(0, Profilet(username: widget.username)),
        icon: Image.asset("assets/images/ครู.png"),
        iconSize: 30,
      ),
      Stack(
        children: [
          IconButton(
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
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                constraints: const BoxConstraints(
                  minWidth: 18,
                  minHeight: 18,
                ),
                child: Text(
                  '$unreadCount',
                  style: const TextStyle(
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
            // ปุ่มหน้าหลัก
            IconButton(
              onPressed: () => navigateTo(1, main_home_T(
                thfname: widget.thfname,
                thlname: widget.thlname,
                username: widget.username,
              )),
              icon: Icon(
                Icons.home,
                color: selectedIndex == 1 ? Color.fromARGB(255, 250, 250, 250) : Colors.black,
              ),
              tooltip: 'หน้าหลัก',
            ),
            // ปุ่มห้องเรียน
            IconButton(
              onPressed: () => navigateTo(2, ClassT(
                thfname: widget.thfname,
                thlname: widget.thlname,
                username: widget.username,
                classroomMajor: widget.classroomMajor,
                classroomName: widget.classroomName,
                classroomNumRoom: widget.classroomNumRoom,
                classroomYear: widget.classroomYear,
              )),
              icon: Icon(
                Icons.class_outlined,
                color: selectedIndex == 2 ? Color.fromARGB(255, 250, 250, 250) : Colors.black,
              ),
              tooltip: 'ห้องเรียน',
            ),
            // ปุ่มงานที่มอบหมาย
            IconButton(
              onPressed: () => navigateTo(3, AssignWork_class_T(
                thfname: widget.thfname,
                thlname: widget.thlname,
                username: widget.username,
                exam: Examset(
                  autoId: 0,
                  direction: '',
                  fullMark: 0,
                  deadline: '',
                  time: '',
                  type: '',
                  closed: '',
                  inspectionStatus: '',
                  classroomId: 0,
                  usertUsername: '',
                ),
                classroomMajor: widget.classroomMajor,
                classroomName: widget.classroomName,
                classroomYear: widget.classroomYear,
                classroomNumRoom: widget.classroomNumRoom,
              )),
              icon: Icon(
                Icons.edit_document,
                color: selectedIndex == 3 ? Color.fromARGB(255, 250, 250, 250) : Colors.black,
              ),
              tooltip: 'งานที่มอบหมาย',
            ),
            // ปุ่มรายชื่อนักเรียน
            IconButton(
              onPressed: () => navigateTo(4, Score_T_body(
                thfname: widget.thfname,
                thlname: widget.thlname,
                username: widget.username,
                classroomMajor: widget.classroomMajor,
                classroomName: widget.classroomName,
                classroomNumRoom: widget.classroomNumRoom,
                classroomYear: widget.classroomYear,
                exam: Examset(
                  autoId: 0,
                  direction: '',
                  fullMark: 0,
                  deadline: '',
                  time: '',
                  type: '',
                  closed: '',
                  inspectionStatus: '',
                  classroomId: 0,
                  usertUsername: '',
                ),
              )),
              icon: Icon(
                Icons.list_alt,
                color: selectedIndex == 4 ? Color.fromARGB(255, 250, 250, 250) : Colors.black,
              ),
              tooltip: 'รายชื่อนักเรียน',
            ),
          ],
        ),
      ),
      IconButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Login_class()),
          );
        },
        icon: const Icon(Icons.logout),
        tooltip: 'ออกจากระบบ',
      ),
    ],
  );
}}


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

