import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SettingCheckinClassroomDialog extends StatefulWidget {
  final String username;
  final String thfname;
  final String thlname;
  final String classroomName;
  final String classroomMajor;
  final String classroomYear;
  final String classroomNumRoom;

  const SettingCheckinClassroomDialog({
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
  _SettingCheckinClassroomDialogState createState() =>
      _SettingCheckinClassroomDialogState();
}

class _SettingCheckinClassroomDialogState
    extends State<SettingCheckinClassroomDialog> {
  late Future<List<HistoryCheckin>> futureCheckins;
  bool _isEditing = false;

  final Map<String, TextEditingController> _scoreControllers = {};
void _saveAffectiveScores() async {
  print("บันทึกคะแนนจิตพิสัยเริ่มทำงาน");

  List<Map<String, String>> scoresToSave = [];
  List<HistoryCheckin> checkins = await futureCheckins;

  if (checkins.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('ไม่มีข้อมูลการเช็คชื่อ')));
    return;
  }

  _scoreControllers.forEach((username, controller) {
    if (controller.text.isEmpty) {
      return;
    }

    HistoryCheckin checkin = checkins.firstWhere(
      (checkin) => checkin.usersUsername == username,
      orElse: () => HistoryCheckin(
        checkinClassroomAuto: '',
        checkinClassroomDate: '',
        usersUsername: '',
        checkinClassroomClassID: '',
        checkinClassroomStatus: 'ไม่มีข้อมูล',
        usersPrefix: '',
        usersThfname: '',
        usersThlname: '',
        usersNumber: '',
        usersId: '',
        usersPhone: '',
        affectiveDomainScore: ''
      ),
    );

    if (checkin.usersUsername.isNotEmpty && controller.text.isNotEmpty) {
      scoresToSave.add({
        'usersUsername': checkin.usersUsername,
        'affectiveDomainScore': controller.text,
        'affectiveDomainClassID': checkin.checkinClassroomClassID,
      });
      print("เพิ่มคะแนน: ${controller.text} สำหรับ ${checkin.usersUsername}");
    }
  });

  
  if (scoresToSave.isNotEmpty) {
    final response = await http.post(
      Uri.parse('https://www.edueliteroom.com/connect/save_affective_scores.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'scores': scoresToSave}),
    );


    if (response.statusCode == 200) {
      json.decode(response.body);
      SnackBar(
      content: Text('บันทึกสำเร็จ'),
        backgroundColor: Colors.green, // พื้นหลังสีเขียว
      );
      
      setState(() {
        futureCheckins = fetchHistoryCheckin(
          widget.classroomName,
          widget.classroomMajor,
          widget.classroomYear,
          widget.classroomNumRoom,
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('เกิดข้อผิดพลาด: ${response.body}')));
    }
  }
}



  @override
  void initState() {
    super.initState();
    futureCheckins = fetchHistoryCheckin(
      widget.classroomName,
      widget.classroomMajor,
      widget.classroomYear,
      widget.classroomNumRoom,
    );
  }

  Future<List<HistoryCheckin>> fetchHistoryCheckin(
      String classroomName, String classroomMajor, String classroomYear, String classroomNumRoom) async {
    final response = await http.post(
      Uri.parse('https://www.edueliteroom.com/connect/historycheckin.php'),
      body: {
        'classroomName': classroomName,
        'classroomMajor': classroomMajor,
        'classroomYear': classroomYear,
        'classroomNumRoom': classroomNumRoom,
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => HistoryCheckin.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'ประวัติการเช็คชื่อเข้าห้องของวิชา ${widget.classroomName} ${widget.classroomYear}/${widget.classroomNumRoom} (${widget.classroomMajor})',
      ),
      content: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: FutureBuilder<List<HistoryCheckin>>(
          future: futureCheckins,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('ไม่มีข้อมูลการเช็คชื่อ'));
            } else {
              List<HistoryCheckin> checkins = snapshot.data!;

              // จัดกลุ่มข้อมูลตามวันที่
              Map<String, List<HistoryCheckin>> groupedData = {};
              for (var checkin in checkins) {
                if (!groupedData.containsKey(checkin.checkinClassroomDate)) {
                  groupedData[checkin.checkinClassroomDate] = [];
                }
                groupedData[checkin.checkinClassroomDate]!.add(checkin);
              }

              // ดึงวันที่ทั้งหมด
              List<String> dates = groupedData.keys.toList()
                ..sort((a, b) => DateTime.parse(a).compareTo(DateTime.parse(b)));

              // การนับจำนวนสถานะในแต่ละวัน
              Map<String, Map<String, int>> statusCount = {};

              // คำนวณจำนวนสถานะ
              for (var checkin in checkins) {
                String date = checkin.checkinClassroomDate;
                String status = checkin.checkinClassroomStatus;

                if (!statusCount.containsKey(date)) {
                  statusCount[date] = {
                    'มาเรียน': 0,
                    'มาสาย': 0,
                    'ขาดเรียน': 0,
                    'ลาป่วย': 0,
                    'ลากิจ': 0,
                    'ไม่มีข้อมูล': 0,
                  };
                }

                switch (status) {
                  case 'present':
                    statusCount[date]!['มาเรียน'] = statusCount[date]!['มาเรียน']! + 1;
                    break;
                  case 'late':
                    statusCount[date]!['มาสาย'] = statusCount[date]!['มาสาย']! + 1;
                    break;
                  case 'absent':
                    statusCount[date]!['ขาดเรียน'] = statusCount[date]!['ขาดเรียน']! + 1;
                    break;
                  case 'sick leave':
                    statusCount[date]!['ลาป่วย'] = statusCount[date]!['ลาป่วย']! + 1;
                    break;
                  case 'personal leave':
                    statusCount[date]!['ลากิจ'] = statusCount[date]!['ลากิจ']! + 1;
                    break;
                  default:
                    statusCount[date]!['ไม่มีข้อมูล'] = statusCount[date]!['ไม่มีข้อมูล']! + 1;
                    break;
                }
              }

              String convertStatusToDisplayText(String status) {
                switch (status) {
                  case 'present':
                    return 'มาเรียน';
                  case 'late':
                    return 'มาสาย';
                  case 'absent':
                    return 'ขาดเรียน';
                  case 'sick leave':
                    return 'ลาป่วย';
                  case 'personal leave':
                    return 'ลากิจ';
                  default:
                    return 'ไม่มีข้อมูล';
                }
              }

              return Column(
                children: [
                  DataTable(
                    columnSpacing: 20.0,
                    columns: [
                      DataColumn(label: const Text('เลขที่')),
                      DataColumn(label: const Text('รหัสนักเรียน')),
                      DataColumn(label: const Text('ชื่อ')),
                      DataColumn(label: const Text('นามสกุล')),
                      DataColumn(label: const Text('Username')),
                      DataColumn(label: const Text('เบอร์โทร')),
                      DataColumn(
                        label: Container(
                          color: const Color.fromARGB(255, 83, 133, 25), // กำหนดสีพื้นหลังที่นี่
                          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          child: const Text(
                            'คะแนนปัจจุบัน',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white), // กำหนดสีข้อความในคอลัมน์
                          ),
                        ),
                      ),

                      ...dates.map((date) => DataColumn(label: Text(date))),
                      DataColumn(label: const Text('มาเรียน')),
                      DataColumn(label: const Text('มาสาย')),
                      DataColumn(label: const Text('ขาดเรียน')),
                      DataColumn(label: const Text('ลาป่วย')),
                      DataColumn(label: const Text('ลากิจ')),
                      
                      if (_isEditing) DataColumn(label: const Text('คะแนนจิตพิสัย')), // เพิ่มคอลัมน์คะแนนจิตพิสัย
                    ],
                    rows: (() {
                      final uniqueStudents = <String>{};
                      return (checkins
                             ..sort((a, b) => int.parse(a.usersNumber).compareTo(int.parse(b.usersNumber)))).where((checkin) => uniqueStudents.add(checkin.usersId))
                          .map((checkin) {
                        var studentCheckins = checkins.where((c) => c.usersId == checkin.usersId).toList();
                        var firstCheckin = studentCheckins.first;

                        // คำนวณจำนวนสถานะในแต่ละแถว
                        int presentCount = studentCheckins.where((c) => c.checkinClassroomStatus == 'present').length;
                        int lateCount = studentCheckins.where((c) => c.checkinClassroomStatus == 'late').length;
                        int absentCount = studentCheckins.where((c) => c.checkinClassroomStatus == 'absent').length;
                        int sickLeaveCount = studentCheckins.where((c) => c.checkinClassroomStatus == 'sick leave').length;
                        int personalLeaveCount = studentCheckins.where((c) => c.checkinClassroomStatus == 'personal leave').length;

                        return DataRow(
                          cells: [
                            DataCell(Text(firstCheckin.usersNumber)),
                            DataCell(Text(firstCheckin.usersId)),
                            DataCell(Text(firstCheckin.usersThfname)),
                            DataCell(Text(firstCheckin.usersThlname)),
                            DataCell(Text(firstCheckin.usersUsername)),
                            DataCell(Text(firstCheckin.usersPhone)),
                            DataCell(
                              Container(
                                color: const Color.fromARGB(255, 108, 204, 151), // สีพื้นหลัง
                                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        firstCheckin.affectiveDomainScore.isEmpty
                                            ? 'ยังไม่ได้เพิ่มคะแนน'
                                            : firstCheckin.affectiveDomainScore,
                                        style: TextStyle(color: Colors.black), // กำหนดสีข้อความ
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ...dates.map((date) {
                              var status = studentCheckins
                                  .firstWhere(
                                    (c) => c.checkinClassroomDate == date,
                                    orElse: () => HistoryCheckin(
                                      checkinClassroomAuto: '',
                                      checkinClassroomDate: date,
                                      usersUsername: '',
                                      checkinClassroomClassID: '',
                                      checkinClassroomStatus: 'ไม่มีข้อมูล',
                                      usersPrefix: '',
                                      usersThfname: '',
                                      usersThlname: '',
                                      usersNumber: '',
                                      usersId: checkin.usersId,
                                      usersPhone: '',
                                      affectiveDomainScore:'',
                                    ),
                                  )
                                  .checkinClassroomStatus;

                              String statusText = convertStatusToDisplayText(status);
                              Color statusColor = Colors.black;

                              switch (status) {
                                case 'present':
                                  statusText = 'มาเรียน';
                                  statusColor = Colors.green;
                                  break;
                                case 'late':
                                  statusText = 'มาสาย';
                                  statusColor = const Color.fromARGB(255, 165, 149, 2);
                                  break;
                                case 'absent':
                                  statusText = 'ขาดเรียน';
                                  statusColor = Colors.red;
                                  break;
                                case 'sick leave':
                                  statusText = 'ลาป่วย';
                                  statusColor = Colors.blue;
                                  break;
                                case 'personal leave':
                                  statusText = 'ลากิจ';
                                  statusColor = Colors.purple;
                                  break;
                                default:
                                  statusText = 'ไม่มีข้อมูล';
                                  statusColor = Colors.black;
                                  break;
                              }

                              return DataCell(Text(
                                statusText,
                                style: TextStyle(color: statusColor),
                              ));
                            }),
                            DataCell(Text(presentCount.toString())),
                            DataCell(Text(lateCount.toString())),
                            DataCell(Text(absentCount.toString())),
                            DataCell(Text(sickLeaveCount.toString())),
                            DataCell(Text(personalLeaveCount.toString())),
                            if (_isEditing)
                              DataCell(
                                TextField(
                                  controller: _scoreControllers[firstCheckin.usersUsername] = TextEditingController(),
                                  decoration: InputDecoration(hintText: 'กรอกคะแนน'),
                                ),
                              ),
                          ],
                        );
                      }).toList();
                    })(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _isEditing = !_isEditing;
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 0, 165, 165)),
                            padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
                          ),
                          child: Text(
                            _isEditing ? 'ปิดกรอกคะแนน' : 'เพิ่มคะแนนจิตพิสัย',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      if (_isEditing)
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: ElevatedButton(
                            onPressed: _saveAffectiveScores,
                            child: const Text('บันทึกคะแนนจิตพิสัย'),
                          ),
                        ),
                    ],
                  ),
                ],
              );
            }
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('ปิด'),
        ),
      ],
    );
  }
}
