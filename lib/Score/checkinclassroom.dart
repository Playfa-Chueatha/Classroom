import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:flutter_esclass_2/Score/setting_checkinclassroom.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Checkinclassroom extends StatefulWidget {
  final String username;
  final String thfname;
  final String thlname;
  final String classroomName;
  final String classroomMajor;
  final String classroomYear;
  final String classroomNumRoom;

  const Checkinclassroom({
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
  State<Checkinclassroom> createState() => _CheckinclassroomState();
}

class _CheckinclassroomState extends State<Checkinclassroom> {
  List<liststudents> dataliststudents = [];
  List<List<bool>> _checkboxValues = [];
  String currentDate = '';
  String sortOption = 'users_number';
  bool sortAscending = true;

  Future<List<liststudents>> fetchStudents(String classroomName, String classroomMajor, String classroomYear, String classroomNumRoom) async {
    final url = Uri.parse('https://www.edueliteroom.com/connect/get_studentsforcheckinclassroom.php');

    final response = await http.post(
      url,
      body: {
        'classroomName': classroomName,
        'classroomMajor': classroomMajor,
        'classroomYear': classroomYear,
        'classroomNumRoom': classroomNumRoom,
      },
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data is Map && data.containsKey('error')) {
        throw Exception(data['error']);
      }

      return (data as List).map((item) => liststudents.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load students');
    }
  }

  @override
  void initState() {
    super.initState();
    currentDate = DateTime.now().toString().split(' ')[0]; // Get current date (yyyy-mm-dd)

    fetchStudents(widget.classroomName, widget.classroomMajor, widget.classroomYear, widget.classroomNumRoom).then((students) {
      setState(() {
        dataliststudents = students;
        _checkboxValues = List.generate(
          dataliststudents.length,
          (_) => List.generate(5, (_) => false),
        );
      });
    }).catchError((e) {
      print('Error fetching students: $e');
    });
  }

  void _saveCheckin() {
    for (int i = 0; i < dataliststudents.length; i++) {
      String status = '';
      if (_checkboxValues[i][0]) {
        status = 'present';
      } else if (_checkboxValues[i][1]) {
        status = 'late';
      } else if (_checkboxValues[i][2]) {
        status = 'absent';
      } else if (_checkboxValues[i][3]) {
        status = 'sick leave';
      } else if (_checkboxValues[i][4]) {
        status = 'personal leave';
      }

      _submitCheckin(dataliststudents[i].username, status);
    }

    fetchStudents(widget.classroomName, widget.classroomMajor, widget.classroomYear, widget.classroomNumRoom).then((students) {
      setState(() {
        dataliststudents = students;
        _checkboxValues = List.generate(
          dataliststudents.length,
          (_) => List.generate(5, (_) => false),
        );
      });
    }).catchError((e) {
      print('Error fetching students: $e');
    });

    setState(() {
      // เมื่อเสร็จสิ้นการบันทึกข้อมูลแล้วให้รีเฟรชหน้า
    });
  }

  String formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);  
    return DateFormat('dd-MM-yyyy').format(parsedDate); 
  }

  Future<void> _submitCheckin(String username, String status) async {
    final url = Uri.parse('https://www.edueliteroom.com/connect/checkin_classroom.php');

    try {
      final response = await http.post(
        url,
        body: {
          'classroomName': widget.classroomName,
          'classroomMajor': widget.classroomMajor,
          'classroomYear': widget.classroomYear,
          'classroomNumRoom': widget.classroomNumRoom,
          'username': username,
          'status': status,
          'date': currentDate,
        },
      );

      if (response.statusCode == 200) {
        final responseBody = response.body;
        if (responseBody.contains('success')) {
          print('Data saved successfully');
          print(response.body);

          fetchStudents(widget.classroomName, widget.classroomMajor, widget.classroomYear, widget.classroomNumRoom).then((students) {
            setState(() {
              dataliststudents = students;
              _checkboxValues = List.generate(
                dataliststudents.length,
                (_) => List.generate(5, (_) => false),
              );
            });
          }).catchError((e) {
            print('Error fetching students: $e');
          });
        } else {
          print('Failed to save data, response: $responseBody');
        }
      } else {
        print('Error: Received non-200 response code: ${response.statusCode}');
      }
    } catch (e) {
      print('Network error: $e');
    }
  }

  Color _getCheckboxColor(int index, int colIndex) {
    if (_checkboxValues[index][colIndex]) {
      switch (colIndex) {
        case 0:
          return Colors.green; 
        case 1:
          return Colors.yellow; 
        case 2:
          return Colors.red; 
        case 3:
          return Colors.blue; 
        case 4:
          return Colors.purple; 
        default:
          return Colors.grey; 
      }
    }
    return Colors.grey; 
  }

  // ฟังก์ชันเพื่อกำหนดข้อความและสีของสถานะการเช็คชื่อ
  Text _getStatusText(String status) {
    String statusText = '';
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
        statusText = 'ยังไม่ได้เช็คชื่อ';
        statusColor = const Color.fromARGB(255, 66, 66, 66);
        break;
    }

    return Text(statusText, style: TextStyle(color: statusColor));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.classroomName.isEmpty ||
        widget.classroomMajor.isEmpty ||
        widget.classroomYear.isEmpty ||
        widget.classroomNumRoom.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('เช็คชื่อนักเรียน'),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              onPressed: () {
                // เพิ่มฟังก์ชันแสดงประวัติ
              },
              icon: const Icon(Icons.edit_document),
              tooltip: 'ประวัติการเช็คชื่อ',
            ),
          ],
        ),
        body: Center(
          child: Text(
            ' ✿ กรุณาเลือกห้องเรียน ✿',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    bool isAnyCheckboxSelected() {
      for (int i = 0; i < _checkboxValues.length; i++) {
        if (_checkboxValues[i].contains(true)) {
          return true;
        }
      }
      return false;
    }

    dataliststudents.sort((a, b) => int.parse(a.studentNumber) - int.parse(b.studentNumber));
    

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('เช็คชื่อนักเรียนประจำวันที่: ${formatDate(currentDate)}'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
             showDialog(context: context, 
             builder: (context) => SettingCheckinClassroomDialog(
              classroomMajor: widget.classroomMajor,
              classroomName: widget.classroomName,
              classroomNumRoom: widget.classroomNumRoom,
              classroomYear: widget.classroomYear,
              thfname: widget.thfname,
              thlname: widget.thlname,
              username: widget.username,
             )
             );
            },
            icon: const Icon(Icons.edit_document),
            tooltip: 'ประวัติการเช็คชื่อ', 
          ),
          OutlinedButton(
            onPressed: isAnyCheckboxSelected() ? _saveCheckin : null,
            child: const Text('บันทึกการเช็คชื่อ'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              DataTable(
                columnSpacing: 20.0,
                columns: const [
                  DataColumn(label: Text('เลขที่ห้อง')),
                  DataColumn(label: Text('รหัสนักเรียน')),
                  DataColumn(label: Text('ชื่อ')),
                  DataColumn(label: Text('นามสกุล')),
                  DataColumn(label: Text('เบอร์โทร')),
                  DataColumn(label: Text('มาเรียน')),
                  DataColumn(label: Text('มาสาย')),
                  DataColumn(label: Text('ขาดเรียน')),
                  DataColumn(label: Text('ลาป่วย')),
                  DataColumn(label: Text('ลากิจ')),
                  DataColumn(label: Text('สถานะการมาเรียนวันนี้')),
                ],
                rows: dataliststudents.asMap().entries.map((entry) {
                  int index = entry.key;
                  liststudents student = entry.value;
                  return DataRow(
                    cells: [
                      DataCell(Text(student.studentNumber)),
                      DataCell(Text(student.studentId)),
                      DataCell(Text(student.firstName)),
                      DataCell(Text(student.lastName)),
                      DataCell(Text(student.phoneNumber)),
                      ...List.generate(
                        5,
                        (colIndex) => DataCell(
                          Checkbox(
                            value: _checkboxValues[index][colIndex],
                            activeColor: _getCheckboxColor(index, colIndex),
                            onChanged: (bool? value) {
                              setState(() {
                                for (int i = 0; i < _checkboxValues[index].length; i++) {
                                  _checkboxValues[index][i] = false; 
                                }
                                _checkboxValues[index][colIndex] = value ?? false;
                              });
                            },
                          ),
                        ),
                      ),
                      DataCell(_getStatusText(student.checkinStatus)),
                    ],
                  );
                }).toList(),
              ),
            ],
          )
        ),
      ),
    );
  }
}
