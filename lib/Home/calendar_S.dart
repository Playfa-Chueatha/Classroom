import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Data/data_calssroom.dart';
import 'package:flutter_esclass_2/Home/Even.dart';
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

  final TextEditingController _eventController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  Future<void> addEventToDatabase(String event, String time, String formattedDate, String username) async {
  final url = Uri.parse('https://www.edueliteroom.com/connect/event_students.php');
    if (event.isEmpty || time.isEmpty || username.isEmpty || formattedDate.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบถ้วน'), backgroundColor: Colors.red),
      );
      return;
    }

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          'event_users_title': event,
          'event_users_date': formattedDate,
          'event_users_time': time,
          'users_username': widget.username, 
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('เพิ่มกิจกรรมสำเร็จ'), backgroundColor: Colors.green),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('เพิ่มกิจกรรมไม่สำเร็จ: ${responseData['message']}'), backgroundColor: Colors.red),
          );
        }
        // Clear fields if success
        _eventController.clear();
        _timeController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เกิดข้อผิดพลาดจากเซิร์ฟเวอร์: ${response.statusCode}'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดจากเครือข่าย: ${e.toString()}'), backgroundColor: Colors.red),
      );
    }
  }


  void _addEvent(String event, String time, DateTime eventDate) {
    setState(() {
      final eventDateKey = DateTime(eventDate.year, eventDate.month, eventDate.day);
      _events[eventDateKey] ??= [];
      _events[eventDateKey]!.add({'event': event, 'time': time});
      _selectedEvents = _events[eventDateKey]!;

      String formattedDate = "${eventDate.year}-${eventDate.month.toString().padLeft(2, '0')}-${eventDate.day.toString().padLeft(2, '0')}";
      
      
      addEventToDatabase(event, time, formattedDate, widget.username).then((_) {
        
        fetchEvents();
      });

      
      _eventController.clear();
      _timeController.clear();
    });
  }


  void fetchEvents() async {
    final url = Uri.parse('https://www.edueliteroom.com/connect/event_students.php?users_username=${widget.username}');
    try {
      final response = await http.get(url);
      // print("API Response: ${response.body}");
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success') {
          // print("Data fetched successfully: ${responseData['data']}");
          setState(() {
            _events.clear();
            dataevent.clear();
            for (var event in responseData['data']) {
              DateTime eventDate = DateTime.parse(event['event_users_date']);
              final eventDateKey = DateTime(eventDate.year, eventDate.month, eventDate.day);
              dataevent.add(Even_teacher(
                Title: event['event_users_title'],
                Date: event['event_users_date'],
                Time: event['event_users_time'],
              ));
              if (_events[eventDateKey] == null) {
                _events[eventDateKey] = [];
                
              }
              _events[eventDateKey]!.add({
                'event': event['event_users_title'],
                'date': event['event_users_date'],
                'time': event['event_users_time'],
              });
            }
            _selectedEvents = _events[_selectedDay] ?? [];
          });
        }
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

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selectedTime != null) {
      final formattedTime = '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
      _timeController.text = formattedTime;
    }
  }

  void _showAddEventDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('เพิ่มกิจกรรมของคุณ'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _eventController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'กิจกรรม',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _timeController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'เวลา (HH:mm)',
                ),
                readOnly: true,
                onTap: () {
                  _selectTime(context);
                },
              ),
            ],
          ),
          actions: [
            OutlinedButton(
              onPressed: () {
                final eventText = _eventController.text;
                final timeText = _timeController.text;
                final eventDate = _selectedDay;

                if (eventText.isNotEmpty && timeText.isNotEmpty) {
                  _addEvent(eventText, timeText, eventDate);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบถ้วน!')),
                  );
                }
              },
              child: Text('ตกลง'),
            ),
            OutlinedButton(
              onPressed: () {
                _eventController.clear();
                _timeController.clear();
                Navigator.of(context).pop();
              },
              child: Text('ยกเลิก'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(400, 10, 0, 5),
            child: ElevatedButton(
              onPressed: () {
                _showAddEventDialog(context);
              },
              child: Text('เพิ่มกิจกรรม'),
            ),
          ),
          Row(
            children: [
              Container(
                height: 400,
                width: 1000,
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(color: Colors.white),
                child: TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _selectedDay,
                  selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
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
                      color: const Color.fromARGB(255, 18, 153, 177),
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
                                Text('วันที่: ${event['date'] ?? ''}'),
                                Text('เวลา: ${event['time'] ?? ''} น.'),
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
