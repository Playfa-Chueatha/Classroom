import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CalendarHome_T extends StatefulWidget {
  final String username;
  const CalendarHome_T({super.key, required this.username});

  @override
  _CalendarHomeState createState() => _CalendarHomeState();
}

class _CalendarHomeState extends State<CalendarHome_T> {
  late Map<DateTime, List<Map<String, String>>> _events;
  late List<Map<String, String>> _selectedEvents;
  late DateTime _selectedDay;
  List<Even_teacher> dataevent = [];


  void fetchEvents() async {
  final url = Uri.parse(
      'https://www.edueliteroom.com/connect/event_assignment.php?usert_username=${widget.username}');
  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      if (responseData['status'] == 'success') {
        setState(() {
          _events.clear();
          dataevent.clear();

          for (var event in responseData['data_assignment']) {
            DateTime eventDate = DateTime.parse(event['event_assignment_duedate']);
            final eventDateKey = DateTime(eventDate.year, eventDate.month, eventDate.day);

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
          }

          // อัปเดตเหตุการณ์ที่เลือกไว้สำหรับวันที่ปัจจุบัน
          final todayKey = DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day);
          _selectedEvents = _events[todayKey] ?? [];
        });
      } else {
        print('Error: ${responseData['message']}');
      }
    } else {
      print('Failed to fetch data: ${response.statusCode}');
    }
  } catch (e) {
    print('Network error: $e');
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

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: screenHeight * 0.45,
                width: screenWidth * 0.55,
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
                    DateTime checkDay = DateTime(day.year, day.month, day.day); // ตรวจสอบเฉพาะวันที่
                    return _events[checkDay]?.map((event) => '●').toList() ?? [];
                  },
                  calendarStyle: CalendarStyle(
                    markersAutoAligned: true,
                    markerDecoration: BoxDecoration(
                      color: const Color.fromARGB(255, 221, 100, 100),
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false, // ซ่อนปุ่มที่เกี่ยวกับการเปลี่ยนมุมมอง (สัปดาห์, เดือน)
                    titleCentered: true, // จัดตำแหน่งหัวข้อให้ตรงกลาง
                    leftChevronVisible: true, // แสดงปุ่มเลื่อนเดือนก่อนหน้า
                    rightChevronVisible: true, // แสดงปุ่มเลื่อนเดือนถัดไป
                  ),
                ),
              ),
              Container(
                height: screenHeight * 0.4,
                width: screenWidth * 0.2,
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
