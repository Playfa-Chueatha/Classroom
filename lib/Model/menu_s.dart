
import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Classroom/add_classroom.dart';
import 'package:flutter_esclass_2/Classroom/setting_calss.dart';
import 'package:flutter_esclass_2/Home/Even.dart';
import 'package:flutter_esclass_2/Model/Menu_listclassroom_S.dart';
import 'package:flutter_esclass_2/Model/Menu_todolist.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
  

class Menuu_class_s extends StatefulWidget {
  final String username;

  const Menuu_class_s({super.key, required this.username});

  @override
  State<Menuu_class_s> createState() => _MenuState();
}

class _MenuState extends State<Menuu_class_s> {
  late final Map<DateTime, List<Map<String, String>>> _events = {};
  List<Even_teacher> dataevent = [];
  bool isLoading = true; // Loading state


  Future<void> fetchEvents() async {
  final url = Uri.parse('https://www.edueliteroom.com/connect/event_students.php?users_username=${widget.username}');
  
  try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        
        if (responseData['status'] == 'success') {
          setState(() {
            _events.clear();
            dataevent.clear();
            isLoading = false;

            List<Even_teacher> todayEvents = []; // รายการสำหรับกิจกรรมในวันปัจจุบัน
            List<Even_teacher> futureEvents = []; // รายการสำหรับกิจกรรมในอนาคต

            for (var event in responseData['data']) {
              DateTime eventDate = DateTime.parse(event['event_users_date']);
              
              // ตรวจสอบกิจกรรมในวันปัจจุบัน
              if (eventDate.isAtSameMomentAs(DateTime.now())) {
                todayEvents.add(Even_teacher(
                  Title: event['event_users_title'],
                  Date: event['event_users_date'],
                  Time: event['event_users_time'],
                ));
              } 
              // ตรวจสอบกิจกรรมในอนาคต
              else if (eventDate.isAfter(DateTime.now())) {
                futureEvents.add(Even_teacher(
                  Title: event['event_users_title'],
                  Date: event['event_users_date'],
                  Time: event['event_users_time'],
                ));
              }
            }
            
            // รวมกิจกรรมในวันปัจจุบันและกิจกรรมในอนาคต
            dataevent = todayEvents + futureEvents;
            
            // เรียงลำดับกิจกรรมในอนาคต
            futureEvents.sort((a, b) => DateTime.parse(a.Date).compareTo(DateTime.parse(b.Date)));
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
                child:  List_classroom_S(username: widget.username),//Menu_listclassroom.dart
              ),
              SizedBox(height: 5),
            ],
          ),
        ),
        SizedBox(height: 20),



        //todolist
        Container(
          height: 300,
          width: 350,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
            )
          ), 
          child: Column(
            children: const [
              SizedBox(height: 20),
              Text('งานที่มอบหมาย',style: TextStyle(fontSize: 20),),
              // MenuTodolist()
            ],
          ),  
        ),
        SizedBox(height: 20),



        //useronline
        Container(
          height: 300,
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
              SizedBox(height: 20),
              Text('กิจกรรมที่กำลังมาถึง',style: TextStyle(fontSize: 20),),
              Expanded(
                  child: ListView.builder(
                    itemCount: dataevent.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 195, 238, 250),
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: ListTile(
                          title: Text(dataevent[index].Title),
                          subtitle: Text(
                            'วันที่: ${dataevent[index].Date} เวลา: ${dataevent[index].Time} น.',
                          ),
                          
                        )
                      ); 
                    },
                  )
                ),
              
            ],
          ), 
        ),
      ]
      ),
      
      
      
    );
  }
}


