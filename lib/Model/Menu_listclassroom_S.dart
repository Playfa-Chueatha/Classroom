import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Classroom/calssS.dart';
import 'package:flutter_esclass_2/Classroom/setting_calss.dart';
import 'package:flutter_esclass_2/Model/appbar_students.dart';
import 'package:http/http.dart' as http;

class List_classroom_S extends StatefulWidget {
  final String username;
  final String thfname;
  final String thlname;

  const List_classroom_S({super.key, required this.username, required this.thfname, required this.thlname});

  @override
  State<List_classroom_S> createState() => _List_classroomState();
}

class _List_classroomState extends State<List_classroom_S> {
  List<dynamic> classrooms = [];

  @override
  void initState() {
    super.initState();
    fetchClassrooms();
  }

  Future<void> fetchClassrooms() async {
    try {
      final response = await http.get(Uri.parse('https://www.edueliteroom.com/connect/get_classrooms_students.php?username=${widget.username}'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        List<dynamic> uniqueClassrooms = [];
        Set<String> seen = {};

        for (var classroom in data) {
          String identifier = "${classroom['classroom_name']}-${classroom['classroom_major']}-${classroom['classroom_year']}-${classroom['classroom_numroom']}";

          if (!seen.contains(identifier)) {
            seen.add(identifier);
            uniqueClassrooms.add(classroom);
          }
        }

        setState(() {
          classrooms = uniqueClassrooms;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('ห้องเรียนของฉัน'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              fetchClassrooms();  
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: classrooms.length,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.fromLTRB(0, 5, 5, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: screenHeight * 0.05,
                  width: screenWidth * 0.2,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 195, 238, 250),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 195, 238, 250),
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () {
                       Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => classS(
                            classroomName: classrooms[index]['classroom_name'],
                            classroomMajor: classrooms[index]['classroom_major'],
                            classroomYear: classrooms[index]['classroom_year'],
                            classroomNumRoom: classrooms[index]['classroom_numroom'],
                            username: widget.username, thfname: widget.thfname, thlname: widget.thlname,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("${classrooms[index]['classroom_name']}", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.009,)),
                            SizedBox(width: 8),
                            // Text("${classrooms[index]['classroom_major']}", style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 77, 77, 77))),
                          ],
                        ),
                        Text("${classrooms[index]['classroom_year']}/${classrooms[index]['classroom_numroom']}", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.007, color: const Color.fromARGB(255, 77, 77, 77))),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
