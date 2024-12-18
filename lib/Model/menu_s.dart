
import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Classroom/add_classroom.dart';
import 'package:flutter_esclass_2/Classroom/setting_calss.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:flutter_esclass_2/Model/Menu_listclassroom_S.dart';
import 'package:flutter_esclass_2/Model/Menu_todolist.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
  

class Menuu_class_s extends StatefulWidget {
  final String username;
  final String thfname;
  final String thlname;

  const Menuu_class_s({super.key, required this.username, required this.thfname, required this.thlname});

  @override
  State<Menuu_class_s> createState() => _MenuState();
}

class _MenuState extends State<Menuu_class_s> {
  late final Map<DateTime, List<Map<String, String>>> _events = {};
  List<Even_teacher> dataevent = [];
  bool isLoading = true; 
  bool hasTodayEvent = false; // เช็คว่ามีงานวันนี้หรือไม่


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
bool isToday(String eventDate) {
    final today = DateTime.now();
    final eventDateTime = DateTime.parse(eventDate); // Assuming the date is in ISO 8601 format (yyyy-MM-dd)
    return today.year == eventDateTime.year &&
           today.month == eventDateTime.month &&
           today.day == eventDateTime.day;
  }


  @override
  void initState() {
    super.initState();
    fetchEvents();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 195, 238, 250),
      body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [

        //listclassroom
        Container(
          height: 350,
          width: 350,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
            )
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: Text('ห้องเรียนของฉัน',style: TextStyle(fontSize: 20),),
              ),     
              Container(
                height: 250,
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20)
                  )
                ),
                child:  List_classroom_S(thfname: widget.thfname, thlname: widget.thlname, username: widget.username)
              ),
              SizedBox(height: 5),
            ],
          ),
        ),
        SizedBox(height: 20),



        //todolist
        Container(
                  height: 530,
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
                        'งานที่มอบหมาย',
                        style: TextStyle(fontSize: 20),
                      ),

                      // If there is no event today, show the message
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
      ]
      ),
      
      
      
    );
  }
}


