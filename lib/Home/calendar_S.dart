import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CalendarHome_S extends StatefulWidget {
  final String username;
  const CalendarHome_S({super.key, required this.username});

  @override
  _CalendarHomeState createState() => _CalendarHomeState();
}

class _CalendarHomeState extends State<CalendarHome_S> {
  late Map<DateTime, List<Map<String, String>>> _events;
  late List<Map<String, String>> _selectedEvents;
  late DateTime _selectedDay;
  List<Even_teacher> dataevent = [];


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
          _selectedEvents = _events[_selectedDay] ?? [];
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



  @override
  void initState() {
    super.initState();
    _events = {};
    _selectedEvents = [];
    _selectedDay = DateTime.now();
    fetchEvents();
   
  }


  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Column(
        children: [
          
          Row(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(10,30,30,10),
                height: 400,
                width: 1000,
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(color: Colors.white),
                child: TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _selectedDay,
                  selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                  availableGestures: AvailableGestures.none,
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _selectedEvents = _events[DateTime(selectedDay.year, selectedDay.month, selectedDay.day)] ?? [];
                    });
                  },
                  eventLoader: (day) {
                    DateTime checkDay = DateTime(day.year, day.month, day.day); 
                    return _events[checkDay]?.map((event) => '●').toList() ?? [];
                    
                  },
                  calendarStyle: CalendarStyle(
                    markersAutoAligned: true,
                    markerDecoration: BoxDecoration(
                      color: const Color.fromARGB(255, 221, 100, 100),
                      shape: BoxShape.circle,
                    ),
                  ),
                  
                ),
              ),
              Container(
                height: 400,
                width: 400,
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color.fromARGB(255, 147, 185, 221),
                ),
                child: _selectedEvents.isNotEmpty
                    ? ListView.builder(
                        itemCount: _selectedEvents.length,
                        itemBuilder: (context, index) {
                          final event = _selectedEvents[index];
                          return ListTile(
                            title: Text(event['event'] ?? ''),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('วันที่สุดท้ายที่รับงาน: ${event['date'] ?? ''} น.'),
                                Text('วิชา: ${event['classroom_name']} (${event['classroom_year']}/${event['classroom_numroom']})'),
                              ],
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text('ไม่มีกิจกรรมสำหรับวันที่เลือก'),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
