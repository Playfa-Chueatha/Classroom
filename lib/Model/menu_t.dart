import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Classroom/setting_calss.dart';
import 'package:flutter_esclass_2/Home/Even.dart';
import 'package:flutter_esclass_2/Model/Menu_listclassroom_T.dart';
import 'package:flutter_esclass_2/Model/Menu_listclassroom_T_inclass.dart';
import 'package:http/http.dart' as http;

class Menuu_class extends StatefulWidget {
  final String username;

  const Menuu_class({super.key, required this.username});

  @override
  State<Menuu_class> createState() => _MenuState();
}

class _MenuState extends State<Menuu_class> {
  late final Map<DateTime, List<Map<String, String>>> _events = {};
  List<Even_teacher> dataevent = [];
  bool isLoading = true; // Loading state

  Future<void> fetchEvents() async {
    final url = Uri.parse('https://www.edueliteroom.com/connect/event_teacher.php?usert_username=${widget.username}');
    
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        
        if (responseData['status'] == 'success') {
          setState(() {
            _events.clear();
            dataevent.clear();
            isLoading = false;

            List<Even_teacher> todayEvents = []; // Current day's events
            List<Even_teacher> futureEvents = []; // Future events

            for (var event in responseData['data']) {
              DateTime eventDate = DateTime.parse(event['event_usert_date']);
              DateTime today = DateTime.now();
              
              // Check if the event date is today (ignoring the time)
              if (eventDate.year == today.year && eventDate.month == today.month && eventDate.day == today.day) {
                todayEvents.add(Even_teacher(
                  Title: event['event_usert_title'],
                  Date: event['event_usert_date'],
                  Time: event['event_usert_time'],
                ));
              } else if (eventDate.isAfter(today)) {
                futureEvents.add(Even_teacher(
                  Title: event['event_usert_title'],
                  Date: event['event_usert_date'],
                  Time: event['event_usert_time'],
                ));
              }
            }
            
            // Sort today’s and future events by date
            todayEvents.sort((a, b) => DateTime.parse(a.Date).compareTo(DateTime.parse(b.Date)));
            futureEvents.sort((a, b) => DateTime.parse(a.Date).compareTo(DateTime.parse(b.Date)));

            // Combine today’s and future events
            dataevent = todayEvents + futureEvents;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          print('Error: ${responseData['message']}');
        }
      } else {
        print('Error: ${response.statusCode}'); 
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Network error: $e');
      setState(() {
        isLoading = false;
      });
    }
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
      body: isLoading
        ? Center(child: CircularProgressIndicator()) // Loading indicator
        : Column(
          children: [
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
                            builder: (context) => SettingCalss(username: widget.username, classroomName: '', classroomMajor: '', classroomYear: '', classroomNumRoom: '', thfname: '', thlname: '',),
                          ),
                        );
                      },
                      icon: Icon(Icons.settings),
                    ),
                  ),
                  SizedBox(
                    height: 250,
                    width: 300,
                    child: List_classroom_inclass(username: widget.username), // Menu_listclassroom.dart
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Assigned tasks section
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
                ],
              ),
            ),
            SizedBox(height: 20),

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
                      itemCount: dataevent.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 195, 238, 250),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ListTile(
                            title: Text(dataevent[index].Title),
                            subtitle: Text(
                              'วันที่: ${dataevent[index].Date} เวลา: ${dataevent[index].Time} น.',
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
