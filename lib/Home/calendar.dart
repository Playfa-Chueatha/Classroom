import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar_Home extends StatefulWidget {
  const Calendar_Home({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<Calendar_Home> {
  late Map<DateTime, List<Map<String, String>>> _events;
  late List<Map<String, String>> _selectedEvents;
  late DateTime _selectedDay;

  final TextEditingController _eventController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _events = {};
    _selectedEvents = [];
    _selectedDay = DateTime.now();
  }

  void _addEvent(String event, String time, DateTime eventDate) {
    setState(() {
      if (_events[eventDate] == null) {
        _events[eventDate] = [];
      }
      _events[eventDate]!.add({'event': event, 'time': time});
      _selectedEvents = _events[eventDate]!;
    });
  }

  void _deleteEvent(Map<String, String> event) {
    setState(() {
      _events[_selectedDay]?.remove(event);
      if (_events[_selectedDay]?.isEmpty ?? true) {
        _events.remove(_selectedDay);
      }
      _selectedEvents = _events[_selectedDay] ?? [];
    });
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

                // ใช้วันที่ปัจจุบันถ้าผู้ใช้ไม่ได้เลือกวันที่
                final eventDate = _selectedDay;

                if (eventText.isNotEmpty && timeText.isNotEmpty) {
                  _addEvent(eventText, timeText, eventDate);
                  _eventController.clear();
                  _timeController.clear();
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

  void _showEditEventDialog(BuildContext context, Map<String, String> event) {
    final TextEditingController eventController = TextEditingController(text: event['event']);
    final TextEditingController timeController = TextEditingController(text: event['time']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('แก้ไขกิจกรรมของคุณ'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: eventController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'กิจกรรม',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: timeController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'เวลา (HH:mm)',
                ),
                readOnly: true,
                onTap: () {
                  _selectTime(context).then((_) {
                    // เมื่อเลือกเวลาแล้ว ให้ทำการอัปเดตเวลาใน TextField
                    final selectedTime = _timeController.text;
                    timeController.text = selectedTime;
                  });
                },
              ),
            ],
          ),
          actions: [
            OutlinedButton(
              onPressed: () {
                final updatedEventText = eventController.text;
                final updatedTimeText = timeController.text;

                if (updatedEventText.isNotEmpty && updatedTimeText.isNotEmpty) {
                  setState(() {
                    _events[_selectedDay]?.remove(event);
                    _events[_selectedDay]!.add({'event': updatedEventText, 'time': updatedTimeText});
                    _selectedEvents = _events[_selectedDay]!;
                  });
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
            padding: EdgeInsets.fromLTRB(1250, 10, 0, 5),
            child: ElevatedButton(
              onPressed: () {
                _showAddEventDialog(context);
              },
              child: Text('เพิ่มกิจกรรม'),
            ),
          ),
          Row(
            children: [
              // Calendar
              Container(
                height: 400,
                width: 1030,
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
                      _selectedEvents = _events[selectedDay] ?? [];
                    });
                  },
                  eventLoader: (day) => _events[day] ?? [],
                  calendarBuilders: CalendarBuilders(
                    selectedBuilder: (context, date, events) {
                      return Container(
                        margin: const EdgeInsets.fromLTRB(50, 5, 50, 5),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 113, 155, 228),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Text(
                            '${date.day}',
                            style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Event List
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
                            title: Container(
                              height: 70,
                              width: 1200,
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
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _deleteEvent(event);
                              },
                            ),
                            onTap: () {
                              _showEditEventDialog(context, event);
                            },
                          );
                        },
                      )
                    : Center(child: Text('- ไม่มีกิจกรรมในวันที่เลือก -')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
