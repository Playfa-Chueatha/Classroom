import 'package:flutter/material.dart';
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

              return DataTable(
                columnSpacing: 20.0,
                columns: [
                  DataColumn(label: const Text('เลขที่')),
                  DataColumn(label: const Text('รหัสนักเรียน')),
                  DataColumn(label: const Text('ชื่อ')),
                  DataColumn(label: const Text('นามสกุล')),
                  DataColumn(label: const Text('เบอร์โทร')),
                  ...dates.map((date) => DataColumn(label: Text(date))),
                ],
                rows: (() {
                  // กรองข้อมูลนักเรียนให้ไม่ซ้ำ
                  final uniqueStudents = <String>{};
                  return (checkins
                        ..sort((a, b) => int.parse(a.usersNumber).compareTo(int.parse(b.usersNumber))))
                      .where((checkin) => uniqueStudents.add(checkin.usersId)) // กรองนักเรียนซ้ำ
                      .map((checkin) {
                    // ดึงข้อมูลการเช็คชื่อของนักเรียนแต่ละคน
                    var studentCheckins =
                        checkins.where((c) => c.usersId == checkin.usersId).toList();
                    var firstCheckin = studentCheckins.first;

                    return DataRow(
                      cells: [
                        DataCell(Text(firstCheckin.usersNumber)),
                        DataCell(Text(firstCheckin.usersId)),
                        DataCell(Text(firstCheckin.usersThfname)),
                        DataCell(Text(firstCheckin.usersThlname)),
                        DataCell(Text(firstCheckin.usersPhone)),
                        ...dates.map((date) {
                          // ค้นหาสถานะการเช็คชื่อในวันนั้น
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
                                ),
                              )
                              .checkinClassroomStatus;

                              String statusText = '';
                          Color statusColor = Colors.black; // ค่าเริ่มต้นคือสีดำ

                          // กำหนดข้อความและสีตามสถานะ
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
                      ],
                    );
                  }).toList();
                })(),
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

class HistoryCheckin {
  final String checkinClassroomAuto;
  final String checkinClassroomDate;
  final String usersUsername;
  final String checkinClassroomClassID;
  final String checkinClassroomStatus;
  final String usersPrefix;
  final String usersThfname;
  final String usersThlname;
  final String usersNumber;
  final String usersId;
  final String usersPhone;

  HistoryCheckin({
    required this.checkinClassroomAuto,
    required this.checkinClassroomDate,
    required this.usersUsername,
    required this.checkinClassroomClassID,
    required this.checkinClassroomStatus,
    required this.usersPrefix,
    required this.usersThfname,
    required this.usersThlname,
    required this.usersNumber,
    required this.usersId,
    required this.usersPhone,
  });

  factory HistoryCheckin.fromJson(Map<String, dynamic> json) {
    return HistoryCheckin(
      checkinClassroomAuto: json['checkin_classroom_auto'],
      checkinClassroomDate: json['checkin_classroom_date'],
      usersUsername: json['users_username'],
      checkinClassroomClassID: json['checkin_classroom_classID'],
      checkinClassroomStatus: json['checkin_classroom_status'],
      usersPrefix: json['users_prefix'],
      usersThfname: json['users_thfname'],
      usersThlname: json['users_thlname'],
      usersNumber: json['users_number'],
      usersId: json['users_id'],
      usersPhone: json['users_phone'],
    );
  }
}
