import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class Scorestudenstofrteacher extends StatefulWidget {
  final String username;
  final String thfname;
  final String thlname;
  final String classroomName;
  final String classroomMajor;
  final String classroomYear;
  final String classroomNumRoom;

  const Scorestudenstofrteacher({
    super.key,
    required this.username,
    required this.thfname,
    required this.thlname,
    required this.classroomName,
    required this.classroomMajor,
    required this.classroomYear,
    required this.classroomNumRoom,
  });

  @override
  State<Scorestudenstofrteacher> createState() => _ScorestudentsState();
}

class _ScorestudentsState extends State<Scorestudenstofrteacher> {
  // ดึงข้อมูลจาก API
  Future<ScoreStudentsInClass> fetchData() async {
    final response = await http.post(
      Uri.parse('https://www.edueliteroom.com/connect/fetch_scorestudentsinclass.php'),
      body: {
        'classroomName': widget.classroomName,
        'classroomMajor': widget.classroomMajor,
        'classroomYear': widget.classroomYear,
        'classroomNumRoom': widget.classroomNumRoom,
      },
    );
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      return ScoreStudentsInClass.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายชื่อนักเรียน'),
      ),
      body: FutureBuilder<ScoreStudentsInClass>(
        future: fetchData(),
        builder: (context, snapshot) {
          // ตรวจสอบสถานะของ Future
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // ระหว่างโหลดข้อมูล
          } else if (snapshot.hasError) {
            return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('ไม่มีข้อมูล'));
          }

          final data = snapshot.data;

          // สร้างแผนที่เก็บคะแนนตาม examsetId และ examsetDirection
          Map<String, Map<String, String>> scoreMap = {};
          Map<String, String> examsetDirections = {}; // เก็บ examsetDirection

          for (var score in data!.scores) {
            if (!scoreMap.containsKey(score.examsetId)) {
              scoreMap[score.examsetId] = {};
            }
            scoreMap[score.examsetId]![score.username] = score.scoreTotal;

            // บันทึก examsetDirection และ examsetFullMark (อ้างอิงจากข้อมูล score)
            examsetDirections[score.examsetId] = score.scoreType;  // เชื่อมกับ examsetDirection เช่น Midterm, Final
          }

          // แสดงข้อมูลในตาราง
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                const DataColumn(label: Text('เลขที่')),
                const DataColumn(label: Text('รหัสนักเรียน')),
                const DataColumn(label: Text('ชื่อ')),
                const DataColumn(label: Text('นามสกุล')),
                // แสดงคอลัมน์ที่เชื่อมโยงกับ examsetTime และ examsetFullMark
                ...examsetDirections.entries.map((entry) {
                  // ดึงข้อมูลจาก examsetDetails ที่ตรงกับ examsetId
                  final examset = data.examsetDetails.firstWhere(
                      (examset) => examset.examsetId == entry.key);

                  return DataColumn(
                    label: Tooltip(
                      message: entry.value, // แสดง examsetDirection ใน tooltip
                      child: Text('${examset.examsetTime}(${examset.examsetFullMark})'), // แสดง examsetTime(examsetFullMark)
                    ),
                  );
                }),
              ],
              rows: data.userDetails.map<DataRow>((user) {
                return DataRow(cells: [
                  DataCell(Text(user.userNumber)),
                  DataCell(Text(user.userId)),
                  DataCell(Text(user.thFname)),
                  DataCell(Text(user.thLname)),
                  // แสดงคะแนนจาก scoreMap โดยอิงจาก username และ examsetId
                  ...examsetDirections.keys.map((examsetId) {
                    return DataCell(
                      Text(scoreMap[examsetId]?[user.username] ?? '-'),
                    );
                  }),
                ]);
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
