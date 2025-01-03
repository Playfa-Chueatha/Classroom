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
  bool _isStatusFound = false;
  String? scoreMessage;

  final Map<String, TextEditingController> _scoreControllers = {};
  final TextEditingController _fullScoreController = TextEditingController();




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

Future<void> saveaffectivefullScore({
  required String classroomName,
  required String classroomMajor,
  required String classroomYear,
  required String classroomNumRoom,
  required String username,
  required String fullScore,
}) async {
  final response = await http.post(
    Uri.parse('https://www.edueliteroom.com/connect/saveaffectivefull_domain.php'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'classroomName': classroomName,
      'classroomMajor': classroomMajor,
      'classroomYear': classroomYear,
      'classroomNumRoom': classroomNumRoom,
      'usert_username': username,
      'affectivefull_domain_score': fullScore,
    }),
  );

  print(response.body);

  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    if (responseData['status'] == 'success') {
      print('บันทึกคะแนนเต็มสำเร็จ');
      setState(() {
        scoreMessage = 'บันทึกคะแนนสำเร็จ';
        _isStatusFound = true;
        affectivefull(
    classroomName: widget.classroomName,
    classroomMajor: widget.classroomMajor,
    classroomYear: widget.classroomYear,
    classroomNumRoom: widget.classroomNumRoom,
    username: widget.username,
  ).then((data) {
    setState(() {
      
      if (data['status'] == 'found') {
        scoreMessage = data['affectivefull_domain_score'].toString();
        _isStatusFound = true; 
      } else {
            scoreMessage = 'ไม่พบข้อมูลคะแนน'; 
            _isStatusFound = false; 
          }
        });
      }).catchError((error) {
        setState(() {
          scoreMessage = 'เกิดข้อผิดพลาด: $error';
          _isStatusFound = false; 
        });
      });
      futureCheckins = fetchHistoryCheckin(
        widget.classroomName,
        widget.classroomMajor,
        widget.classroomYear,
        widget.classroomNumRoom,
      );
      });
    } else {
      print('ไม่สามารถบันทึกคะแนนได้: ${responseData['message']}');
      setState(() {
       
        scoreMessage = 'ไม่สามารถบันทึกคะแนนได้: ${responseData['message']}';
        _isStatusFound = false;
      });
    }
  } else {
    print('ไม่สามารถติดต่อกับเซิร์ฟเวอร์ได้');
    setState(() {
      
      scoreMessage = 'ไม่สามารถติดต่อกับเซิร์ฟเวอร์ได้';
      _isStatusFound = false;

    });
  }
}



Future<Map<String, dynamic>> affectivefull({
  required String classroomName,
  required String classroomMajor,
  required String classroomYear,
  required String classroomNumRoom,
  required String username,
}) async {
  try {
    final response = await http.post(
      Uri.parse('https://www.edueliteroom.com/connect/get_affectivefull_domain_score.php'), // URL ของไฟล์ PHP
      body: {
        'classroomName': classroomName,
        'classroomMajor': classroomMajor,
        'classroomYear': classroomYear,
        'classroomNumRoom': classroomNumRoom,
        'username': username,
      },
    );
    print(response.body);

    if (response.statusCode == 200) {
      
      Map<String, dynamic> data = json.decode(response.body);
      return data; 
    } else {
      
      throw Exception('Failed to load data');
    }
  } catch (e) {
    throw Exception('Failed to make request: $e');
  }
}


  @override
void initState() {
  super.initState();
  affectivefull(
    classroomName: widget.classroomName,
    classroomMajor: widget.classroomMajor,
    classroomYear: widget.classroomYear,
    classroomNumRoom: widget.classroomNumRoom,
    username: widget.username,
  ).then((data) {
    setState(() {
      
      if (data['status'] == 'found') {
        scoreMessage = data['affectivefull_domain_score'].toString(); 
        _isStatusFound = true; 
      } else {
        scoreMessage = 'ไม่พบข้อมูลคะแนน';
        _isStatusFound = false; 
      }
    });
  }).catchError((error) {
    setState(() {
      scoreMessage = 'เกิดข้อผิดพลาด: $error'; 
      _isStatusFound = false; 
    });
  });
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


 @override
Widget build(BuildContext context) {
  return AlertDialog(
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'ประวัติการเช็คชื่อเข้าห้องของวิชา ${widget.classroomName} ${widget.classroomYear}/${widget.classroomNumRoom} (${widget.classroomMajor})',
        ),
        // ใช้ค่า scoreMessage ที่ได้รับจาก API แทน
        _isStatusFound
            ? Row(
              children: [
                Text(
                'คะแนนเต็ม: $scoreMessage คะแนน',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              IconButton(
                onPressed: () async {
                  TextEditingController scoreController = TextEditingController();
                  
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('เพิ่ม/แก้ไขคะแนนเต็ม'),
                        content: TextField(
                          controller: scoreController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(hintText: 'กรอกคะแนนเต็ม'),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('ยกเลิก'),
                          ),
                          TextButton(
                            onPressed: () async {
                              String fullScore = scoreController.text;
                              if (fullScore.isNotEmpty) {
                                await saveaffectivefullScore(
                                  classroomName: widget.classroomName,
                                  classroomMajor: widget.classroomMajor,
                                  classroomYear: widget.classroomYear,
                                  classroomNumRoom: widget.classroomNumRoom,
                                  username: widget.username,
                                  fullScore: fullScore,
                                );
                                Navigator.pop(context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('กรุณากรอกคะแนนเต็ม')),
                                );
                              }
                            },
                            child: Text('บันทึก'),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: Icon(Icons.edit)
              )
              ],
            ) 
            : Text('กรุณาเพิ่มคะแนนเต็ม', style: TextStyle(fontSize: 16),),
      ],
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

            return Column(
              children: [
                DataTable(
                  columnSpacing: 20.0,
                  columns: [
                    DataColumn(label: const Text('เลขที่')),
                    DataColumn(label: const Text('รหัสนักเรียน')),
                    DataColumn(label: const Text('ชื่อ')),
                    DataColumn(label: const Text('นามสกุล')),
                    DataColumn(label: const Text('เบอร์โทร')),
                    
                    ...dates.map((date) => DataColumn(label: Text(date))),
                    DataColumn(label: const Text('มาเรียน')),
                    DataColumn(label: const Text('มาสาย')),
                    DataColumn(label: const Text('ขาดเรียน')),
                    DataColumn(label: const Text('ลาป่วย')),
                    DataColumn(label: const Text('ลากิจ')),
                    DataColumn(
                      label: Container(
                        color: const Color.fromARGB(255, 83, 133, 25),
                        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        child: const Text(
                          'คะแนนปัจจุบัน',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                    if (_isEditing) DataColumn(label: const Text('คะแนนจิตพิสัย')),
                  ],
                  rows: (() {
                    final uniqueStudents = <String>{};
                    return (checkins
                           ..sort((a, b) => int.parse(a.usersNumber).compareTo(int.parse(b.usersNumber)))).toList()
                        .where((checkin) => uniqueStudents.add(checkin.usersId))
                        .map((checkin) {
                      var studentCheckins = checkins.where((c) => c.usersId == checkin.usersId).toList();
                      var firstCheckin = studentCheckins.first;

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
                          DataCell(Text(firstCheckin.usersPhone)),
                          
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
                                    affectiveDomainScore: '',
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
                          DataCell(
                            Container(
                              color: const Color.fromARGB(255, 108, 204, 151),
                              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      firstCheckin.affectiveDomainScore.isEmpty
                                          ? 'ยังไม่ได้เพิ่มคะแนน'
                                          : firstCheckin.affectiveDomainScore,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (_isEditing)
                            DataCell(
                              SizedBox(
                                width: 100, // Add width to TextField
                                child: TextField(
                                  controller: _scoreControllers[firstCheckin.usersUsername] =
                                      TextEditingController(),
                                  decoration: InputDecoration(hintText: 'กรอกคะแนน'),
                                ),
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
                      onPressed: _isStatusFound
                          ? () {
                              setState(() {
                                _isEditing = !_isEditing;
                              });
                            }
                          : null, // ปิดปุ่มเมื่อ _isStatusFound เป็น false
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          _isStatusFound
                              ? const Color.fromARGB(255, 0, 165, 165) // สีเมื่อพบสถานะ
                              : Colors.grey, // สีทึบเมื่อไม่พบสถานะ
                        ),
                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
                      ),
                      child: Text(
                        _isEditing ? 'ปิดกรอกคะแนน' : 'เพิ่มคะแนนจิตพิสัย',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  if (_isEditing) // เงื่อนไขแสดงปุ่มบันทึกคะแนนเมื่อ _isEditing เป็น true
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: ElevatedButton(
                      onPressed: () {
                        _saveAffectiveScores();
                        print("บันทึกคะแนน");
                        
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // สีปุ่ม
                      ),
                      child: Text('บันทึกคะแนน'),
                    ),
                  ),
                ],
              ),
              
              if (!_isStatusFound) // ถ้าสถานะไม่พบ 'found'
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'กรุณากรอกคะแนนเต็มก่อนทำการให้คะแนนนักเรียน',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 200,
                          child: TextFormField(
                            controller: _fullScoreController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              label: Text('คะแนนเต็ม')
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            String fullScore = _fullScoreController.text;
                            if (fullScore.isNotEmpty) {
                              saveaffectivefullScore(
                                classroomName: widget.classroomName,
                                classroomMajor: widget.classroomMajor,
                                classroomYear: widget.classroomYear,
                                classroomNumRoom: widget.classroomNumRoom,
                                username: widget.username, 
                                fullScore: fullScore,
                              );
                            } else {
                              print('กรุณากรอกคะแนนเต็ม');
                            }                         
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue, // สีปุ่ม
                          ),
                          child: Text('เพิ่มคะแนนเต็ม'),
                        ),
                      ],
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