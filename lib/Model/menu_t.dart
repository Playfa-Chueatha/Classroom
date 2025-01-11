import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Classroom/setting_calss.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:flutter_esclass_2/Model/Menu_listclassroom_T_inclass.dart';
import 'package:http/http.dart' as http;

class Menuu_class extends StatefulWidget {
  final String username;
  final String thfname;
  final String thlname;

  const Menuu_class({super.key, required this.username, required this.thfname, required this.thlname});

  @override
  State<Menuu_class> createState() => _MenuState();
}

class _MenuState extends State<Menuu_class> {
  List<Even_teacher> dataevent = []; 
  bool isLoading = true; // สถานะโหลดข้อมูล
  bool hasTodayEvent = false; // เช็คว่ามีงานวันนี้หรือไม่

  // ฟังก์ชันดึงข้อมูลจาก API
  Future<void> fetchEvents() async {
    final url = Uri.parse('https://www.edueliteroom.com/connect/event_assignment.php?usert_username=${widget.username}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['status'] == 'success') {
          setState(() {
            dataevent.clear();
            isLoading = false;
            hasTodayEvent = false;

            for (var event in responseData['data_assignment']) {
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
            }

            // Sort events: Today first, then future events
            dataevent.sort((a, b) {
              final dateA = DateTime.parse(a.Date);
              final dateB = DateTime.parse(b.Date);
              return dateA.compareTo(dateB);
            });

            // Check if today has any events
            for (var event in dataevent) {
              if (isToday(event.Date)) {
                hasTodayEvent = true;
                break;
              }
            }
          });
        } else {
          setState(() {
            isLoading = false;
          });
          print('Error: ${responseData['message']}');
        }
      } else {
        setState(() {
          isLoading = false;
        });
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Network error: $e');
    }
  }

  
  bool isToday(String eventDate) {
    final today = DateTime.now();
    final eventDateTime = DateTime.parse(eventDate); 
    return today.year == eventDateTime.year &&
           today.month == eventDateTime.month &&
           today.day == eventDateTime.day;
  }

 
  bool isFuture(String date) {
    DateTime eventDate = DateTime.parse(date);
    DateTime currentDate = DateTime.now();
    
    
    return eventDate.isAfter(currentDate);
  }


  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 195, 238, 250),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) 
          : Column(
              children: [
                
                Container(
                  height: screenHeight * 0.4,
                  width: screenWidth * 0.35,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: SizedBox(
                        height: screenHeight * 0.39,
                        width: screenWidth * 0.3,
                        child: List_classroom_inclass(
                          thfname: widget.thfname,
                          thlname: widget.thlname,
                          username: widget.username,
                        ),
                      ),
                ),
                 SizedBox(height: screenHeight * 0.02,),


                
                Container(
                height: screenHeight * 0.475,
                width: screenWidth * 0.35,
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
                            final isEventToday = isToday(event.Date); 
                            final isEventInFuture = isFuture(event.Date); 

                            
                            if (isEventToday || isEventInFuture) {
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: isEventToday
                                      ? Colors.blue 
                                      : const Color.fromARGB(255, 195, 238, 250), 
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
                                  ),
                                ),
                              );
                            }
                            return SizedBox(); 
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
