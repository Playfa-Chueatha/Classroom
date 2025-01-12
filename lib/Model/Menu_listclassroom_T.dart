import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Classroom/add_classroom.dart';
import 'package:flutter_esclass_2/Classroom/setting_calss.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:http/http.dart' as http;

class List_classroom extends StatefulWidget {
  final String username;
  final String thfname;
  final String thlname;

  const List_classroom({super.key, required this.username, required this.thfname, required this.thlname});

  @override
  State<List_classroom> createState() => _List_classroomState();
}

class _List_classroomState extends State<List_classroom> {
  List<dynamic> classrooms = []; // Initialize the classrooms list
  List<dynamic> classroomsType0 = []; // Empty list initially
  List<dynamic> classroomsType1 = []; // Empty list initially

  @override
  void initState() {
    super.initState();
    fetchClassrooms(); // Fetch classrooms when the widget is initialized
  }

  Future<void> fetchClassrooms() async {
    try {
      final response = await http.get(Uri.parse('https://www.edueliteroom.com/connect/get_classrooms_teacherforsetting.php?username=${widget.username}'));
      // print(response.body); // Check the response from the API
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        List<dynamic> uniqueClassrooms = [];
        Set<String> seen = {};

        for (var classroom in data) {
          String identifier = "${classroom['classroom_name']}-${classroom['classroom_major']}-${classroom['classroom_year']}-${classroom['classroom_numroom']}-${classroom['classroom_subjectsID']}";

          if (!seen.contains(identifier)) {
            seen.add(identifier);
            uniqueClassrooms.add(classroom);
          }
        }

        setState(() {
          classrooms = uniqueClassrooms;
          // Now filter the classrooms by type after fetching the data
          classroomsType0 = classrooms.where((classroom) => classroom['classroom_type'] == '0').toList();
          classroomsType1 = classrooms.where((classroom) => classroom['classroom_type'] == '1').toList();
        });
        print("Classrooms loaded: $classrooms"); // Check if classrooms are loaded properly
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> updateClassroomType(int classroomId, int classroomType) async {
  final url = Uri.parse('https://www.edueliteroom.com/connect/update_classroom_type.php');

  try {
    final response = await http.post(url, body: {
      'classroom_id': classroomId.toString(), // ส่ง classroom_id เป็น String
      'classroom_type': classroomType.toString(), // ส่ง classroom_type เป็น String
    });

    print(response.body); // ตรวจสอบผลลัพธ์จากเซิร์ฟเวอร์
    if (response.statusCode == 200) {
      setState(() {
        fetchClassrooms(); // Fetch classrooms again to update the list
      });
      print("Update successful");
    } else {
      // การอัปเดตล้มเหลว
      print("Failed to update classroom type");
    }
  } catch (e) {
    print("Error: $e");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ห้องเรียนของฉัน'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
            child: ElevatedButton.icon(
              onPressed: () async {
                bool? result = await showDialog(
                  context: context,
                  builder: (BuildContext context) => AddClassroom(
                    username: widget.username,
                    thfname: widget.thfname,
                    thlname: widget.thlname,
                    exam: Examset(autoId: 0, direction: '', fullMark: 0, deadline: '', time: '', type: '', closed: '', inspectionStatus: '', classroomId: 0, usertUsername: ''),
                  ),
                );

                if (result == true) {
                  setState(() {
                    fetchClassrooms(); // Fetch classrooms again to update the list
                  });
                }
              },
              icon: const Icon(Icons.add),
              label: const Text("เพิ่มห้องเรียน", style: TextStyle(fontSize: 14, color: Colors.black)),
              style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 203, 212, 216)),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          // ห้องเรียนที่ classroom_type == 0
          if (classroomsType0.isNotEmpty)
            ...classroomsType0.map((classroom) {
              return buildClassroomCard(classroom);
            }),

          // ห้องเรียนที่ classroom_type == 1
          if (classroomsType1.isNotEmpty)
            ...classroomsType1.map((classroom) {
              return buildClassroomCard(classroom);
            }),
        ],
      ),
    );
  }

  // ฟังก์ชันช่วยในการสร้าง card สำหรับห้องเรียน
  Widget buildClassroomCard(dynamic classroom) {
  final screenWidth = MediaQuery.of(context).size.width;

  // แปลง classroom_type ให้เป็น int หากเป็น String เพื่อให้เปรียบเทียบได้ถูกต้อง
  int classroomType = int.tryParse(classroom['classroom_type'].toString()) ?? 0;

  // กำหนดสถานะของ Checkbox และสีพื้นหลังตาม classroom_type
  bool isSelected = classroomType == 1 || (classroom['isSelected'] ?? false);
  Color backgroundColor = classroomType == 1
      ? Colors.grey.withOpacity(0.3) // สีเทาเมื่อ classroom_type = 1
      : Color.fromARGB(255, 195, 238, 250); // สีพื้นฐาน

  return Container(
    margin: EdgeInsets.fromLTRB(0, 10, 10, 10),
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
    ),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: screenWidth * 0.2,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: const BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
            ),
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: backgroundColor,
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingCalss(
                      classroomName: classroom['classroom_name'],
                      classroomMajor: classroom['classroom_major'],
                      classroomYear: classroom['classroom_year'],
                      classroomNumRoom: classroom['classroom_numroom'],
                      username: widget.username,
                      thfname: widget.thfname,
                      thlname: widget.thlname,
                    ),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Checkbox(
  value: isSelected,
  onChanged: (bool? value) {
    setState(() {
      classroom['isSelected'] = value;
    });

    // เปลี่ยนค่า classroom_type ตามสถานะ Checkbox
    int updatedClassroomType = value == true ? 1 : 0;
    
    // ส่ง classroom_id และ classroom_type ไปยังฟังก์ชัน updateClassroomType
    updateClassroomType(int.parse(classroom['classroom_id'].toString()), updatedClassroomType);
  },
),

                      Text("${classroom['classroom_name']}", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.009)),
                      SizedBox(width: screenWidth * 0.002),
                    ],
                  ),
                  Text(" รหัสวิชา: ${classroom['classroom_subjectsID']}", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.007, color: Color.fromARGB(255, 77, 77, 77))),
                  Text("${classroom['classroom_year']} ห้อง ${classroom['classroom_numroom']}", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.007, color: const Color.fromARGB(255, 77, 77, 77))),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}


}
