
import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Classroom/add_classroom.dart';
import 'package:flutter_esclass_2/Classroom/setting_calss.dart';
import 'package:flutter_esclass_2/Model/Menu_listclassroom.dart';
import 'package:flutter_esclass_2/Model/Menu_todolist.dart';
  

class Menuu_class extends StatefulWidget {
  const Menuu_class({super.key});

  @override
  State<Menuu_class> createState() => _MenuState();
}

class _MenuState extends State<Menuu_class> {
  // สมมติว่ามีข้อมูลกิจกรรมในปฏิทินเป็น List<Map<String, String>>
  final List<Map<String, String>> _events = [
    {'time': '10:00', 'event': 'ประชุมทีม', 'date': '2024-09-19'},
    {'time': '14:00', 'event': 'สัมมนา', 'date': '2024-09-20'},
    {'time': '16:00', 'event': 'นำเสนอโปรเจค', 'date': '2024-09-18'},
  ];

  List<Map<String, Object>> _getUpcomingEvents() {
    // ดึงวันที่ปัจจุบัน

    // แปลงข้อมูลกิจกรรมที่เก็บเป็น String ให้เป็น DateTime
    final eventsWithDate = _events.map((event) {
      final dateParts = event['date']?.split('-') ?? [];
      final timeParts = event['time']?.split(':') ?? [];

      // ตรวจสอบและแปลงค่า
      final date = DateTime(
        int.tryParse(dateParts[0]) ?? 0,
        int.tryParse(dateParts[1]) ?? 0,
        int.tryParse(dateParts[2]) ?? 0,
        int.tryParse(timeParts[0]) ?? 0,
        int.tryParse(timeParts[1]) ?? 0,
      );

      return {
        'time': event['time'] ?? '',
        'event': event['event'] ?? '',
        'dateTime': date,
      };
    }).toList();

    // จัดเรียงกิจกรรมตามวันที่และเวลา
    eventsWithDate.sort((a, b) {
      final dateTimeA = a['dateTime'] as DateTime;
      final dateTimeB = b['dateTime'] as DateTime;
      return dateTimeA.compareTo(dateTimeB);
    });

    // คืนค่าเป็น List<Map<String, String>> ที่จัดเรียงแล้ว
    return eventsWithDate.map((event) {
      return {
        'time': event['time']!,
        'event': event['event']!,
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 195, 238, 250),
      body: Column(
        children: [
          // listclassroom
          Container(
            height: 350,
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
                Padding(
                  padding: EdgeInsets.fromLTRB(300, 10, 10, 0),
                  child: IconButton(
                    tooltip: 'ตั้งค่าห้องเรียน',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingCalss(),
                        ),
                      );
                    },
                    icon: Icon(Icons.settings),
                  ),
                ),
                Text(
                  'ห้องเรียนของฉัน',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 5),
                Container(
                  height: 250,
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: List_student(), // Menu_listclassroom.dart
                ),
                SizedBox(height: 5),
              ],
            ),
          ),
          SizedBox(height: 20),

          // todolist
          Container(
            height: 300,
            width: 350,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: const [
                SizedBox(height: 20),
                Text(
                  'งานที่มอบหมาย',
                  style: TextStyle(fontSize: 20),
                ),
                // MenuTodolist()
              ],
            ),
          ),
          SizedBox(height: 20),

          // event
          Container(
            height: 300,
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
                  'กิจกรรมที่กำลังมาถึง',
                  style: TextStyle(fontSize: 20),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _getUpcomingEvents().length,
                    itemBuilder: (context, index) {
                      final event = _getUpcomingEvents()[index];
                      return ListTile(
                        title: Container(
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                            child: Text(
                              '${event['time']} - ${event['event']}',
                              style: const TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          ),
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
    );
  }
}
