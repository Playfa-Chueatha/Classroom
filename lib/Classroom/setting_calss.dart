import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Classroom/add_classroom.dart';
import 'package:flutter_esclass_2/Classroom/dialog_searchStudents.dart';
import 'package:flutter_esclass_2/Data/Data_students.dart';
import 'package:flutter_esclass_2/Data/data_calssroom.dart';
import 'package:flutter_esclass_2/Model/Menu_listclassroom_T.dart';
import 'package:flutter_esclass_2/Model/appbar_teacher.dart';
import 'package:http/http.dart' as http;

class SettingCalss extends StatefulWidget {
  final String thfname;
  final String thlname;
  final String username;
  final String classroomName;
  final String classroomMajor;
  final String classroomYear;
  final String classroomNumRoom;

  const SettingCalss({
    super.key,
    required this.thfname,
    required this.thlname,
    required this.username, 
    required this.classroomName,
    required this.classroomMajor,
    required this.classroomYear,
    required this.classroomNumRoom,
  });

  @override
  State<SettingCalss> createState() => _SettingCalssState();
}

class _SettingCalssState extends State<SettingCalss> {
  List<dynamic> studentsInClass = [];
  List<dynamic> removedStudents = []; // สำหรับเก็บนักเรียนที่ถูกลบ
  bool isLoading = true;
  String sortOption = 'users_number'; // ตัวเลือกการเรียงลำดับ
  bool sortAscending = true; // true สำหรับเรียงจากน้อยไปมาก

  @override
  void initState() {
    super.initState();
    fetchStudentsInClass();
  }

 Future<void> fetchStudentsInClass() async {
  try {
    final response = await http.get(Uri.parse(
        'https://www.edueliteroom.com/connect/get_studentsinclass.php?classroom_name=${widget.classroomName}&classroom_major=${widget.classroomMajor}&classroom_year=${widget.classroomYear}&classroom_numroom=${widget.classroomNumRoom}'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
  if (data != null) {
    setState(() {
      studentsInClass = data['students_in_class'];
      removedStudents = data['removed_students'];
    });
      } else {
        setState(() {
          studentsInClass = [];
          removedStudents = [];
        });
        print("ไม่พบข้อมูล");
      }
    } else {
      setState(() {
        studentsInClass = [];
        removedStudents = [];
      });
      print("ข้อผิดพลาด: ${response.statusCode}");
    }
  } catch (e) {
    setState(() {
      studentsInClass = [];
      removedStudents = [];
    });
    print('ข้อผิดพลาด: $e');
  }
}

  // ฟังก์ชันในการลบสมาชิกออกจากห้องเรียน
  void deleteStudentFromClass(String users_id, String classroomName, String classroomMajor, String classroomYear, String classroomNumRoom) async {
    final response = await http.post(
      Uri.parse('https://www.edueliteroom.com/connect/update_removeclass_type.php'),
      body: {
        'users_id': users_id,
        'classroomName': classroomName,
        'classroomMajor': classroomMajor,
        'classroomYear': classroomYear,
        'classroomNumRoom': classroomNumRoom,
      },
    );

    if (response.statusCode == 200) {
      print('ลบออกสำเร็จ');
      fetchStudentsInClass(); // โหลดข้อมูลนักเรียนใหม่
    } else {
      print('ลบไม่สำเร็จ');
    }
  }

  // ฟังก์ชันในการลบสมาชิกออกจากห้องเรียน
  void addStudentFromClass(String users_id, String classroomName, String classroomMajor, String classroomYear, String classroomNumRoom) async {
    final response = await http.post(
      Uri.parse('https://www.edueliteroom.com/connect/update_inclass_type.php'),
      body: {
        'users_id': users_id,
        'classroomName': classroomName,
        'classroomMajor': classroomMajor,
        'classroomYear': classroomYear,
        'classroomNumRoom': classroomNumRoom,
      },
    );

    if (response.statusCode == 200) {
      print('เพิ่มเข้าห้องเรียนสำเร็จ');
      fetchStudentsInClass(); // โหลดข้อมูลนักเรียนใหม่
    } else {
      print('เพิ่มเข้าห้องเรียนไม่สำเร็จ');
    }
  }

  void sortStudentsinclass() {
  if (sortOption == 'users_number') {
    studentsInClass.sort((a, b) => sortAscending
        ? a['users_number'].compareTo(b['users_number'])
        : b['users_number'].compareTo(a['users_number']));
  } else if (sortOption == 'users_id') {
    studentsInClass.sort((a, b) => sortAscending
        ? a['users_id'].compareTo(b['users_id'])
        : b['users_id'].compareTo(a['users_id']));
  } else if (sortOption == 'classroom_id') { 
    studentsInClass.sort((a, b) => sortAscending
        ? a['classroom_id'].compareTo(b['classroom_id'])
        : b['classroom_id'].compareTo(a['classroom_id']));
  }
}

void sortStudentsremove() {
  if (sortOption == 'users_number') {
    removedStudents.sort((a, b) => sortAscending
        ? a['users_number'].compareTo(b['users_number'])
        : b['users_number'].compareTo(a['users_number']));
  } else if (sortOption == 'users_id') {
    removedStudents.sort((a, b) => sortAscending
        ? a['users_id'].compareTo(b['users_id'])
        : b['users_id'].compareTo(a['users_id']));
  } else if (sortOption == 'classroom_id') { 
    removedStudents.sort((a, b) => sortAscending
        ? a['classroom_id'].compareTo(b['classroom_id'])
        : b['classroom_id'].compareTo(a['classroom_id']));
  }
}


  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 195, 238, 250),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 30, 141, 172),
        actions: [
          appbarteacher(context, widget.thfname, widget.thlname, widget.username),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Column(
              children: [
                const SizedBox(height: 30),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // เมนูห้องเรียน
                      Container(
                        alignment: Alignment.topLeft,
                        height: 1000,
                        width: 350,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 147, 185, 221),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(170, 5, 5, 5),
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AddClassroom(username: widget.username),
                                  );
                                },
                                icon: const Icon(Icons.add),
                                label: const Text(
                                  "เพิ่มห้องเรียน",
                                  style: TextStyle(fontSize: 16, color: Colors.black),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 203, 212, 216),
                                ),
                              ),
                            ),
                            Container(
                              height: 900,
                              width: 300,
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 147, 185, 221),
                              ),
                              child: List_classroom(username: widget.username),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 50),

                      // ข้อมูลนักเรียน
                      Container(
                        height: 1000,
                        width: 1440,
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              Container(
                                height: 850,
                                width: 1300,
                                margin: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 195, 238, 250),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(26),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('รายชื่อนักเรียนในห้องเรียน ${widget.classroomName} ${widget.classroomYear}/${widget.classroomNumRoom} (${widget.classroomMajor})',
                                              style: TextStyle(fontSize: 20)),
                                          Container(
                                            child: Row(
                                              children: [

                                                OutlinedButton(
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return DialogSearchstudents(
                                                          classroomName: widget.classroomName,
                                                          classroomMajor: widget.classroomMajor,
                                                          classroomNumRoom: widget.classroomNumRoom,
                                                          classroomYear: widget.classroomYear,
                                                          thfname: '',
                                                          thlname: '',
                                                          username: widget.username,
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Text('เพิ่มนักเรียน'),
                                                ),
                                                SizedBox(width: 10),

                                              DropdownButton<String>(
                                                value: sortOption,
                                                icon: const Icon(Icons.arrow_drop_down),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    sortOption = newValue!;
                                                    sortStudentsinclass(); // เรียกใช้ฟังก์ชันในการเรียงข้อมูล
                                                  });
                                                },
                                                items: <String>['users_number', 'users_id']
                                                    .map<DropdownMenuItem<String>>((String value) {
                                                  return DropdownMenuItem<String>(
                                                    value: value,
                                                    child: Text(value == 'users_number' ? 'เรียงตามเลขที่ห้อง' : 'เรียงตามรหัสนักเรียน'),
                                                  );
                                                }).toList(),
                                              ),

                                        
                                              ],
                                            ),
                                          )
                                          
                                        ],
                                      ),
                                    ),
                                    studentsInClass.isEmpty
                                        ? Center(
                                            child: Text(
                                              'ไม่มีนักเรียนในห้องเรียนนี้',
                                              style: TextStyle(fontSize: 20, color: Colors.red),
                                            ),
                                          )
                                        : SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: DataTable(
                                              columns: const [
                                                DataColumn(label: Text('เลขที่ห้อง')),
                                                DataColumn(label: Text('รหัสนักเรียน')),
                                                DataColumn(label: Text('ชื่อ')),
                                                DataColumn(label: Text('นามสกุล')),
                                                DataColumn(label: Text('แผนการเรียน')),
                                                DataColumn(label: Text('ลบออกจากห้อง')),
                                              ],
                                              rows: studentsInClass.map<DataRow>((student) {
                                                return DataRow(cells: [
                                                  DataCell(Text(student['users_number'].toString())),
                                                  DataCell(Text(student['users_id'].toString())),
                                                  DataCell(Text(student['users_thfname'])),
                                                  DataCell(Text(student['users_thlname'])),
                                                  DataCell(Text(student['users_major'])),
                                                  DataCell(Center(child: IconButton(                      
                                                    onPressed: () {
                                                      String usersId = student['users_id']; 
                                                      String classroomName = widget.classroomName;
                                                      String classroomMajor = widget.classroomMajor;
                                                      String classroomYear = widget.classroomYear;
                                                      String classroomNumRoom = widget.classroomNumRoom;

                                                      showDialog(
                                                        context: context, 
                                                        builder: (BuildContext context){
                                                          return AlertDialog(
                                                            title: Text('ยืนยันการลบ'),
                                                            content: Text('คุณต้องการลบ ${student['users_thfname']} ${student['users_thlname']} ออกจากห้องเรียนหรือไม่?'),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                onPressed: () {
                                                                  // ยืนยันการลบ
                                                                  deleteStudentFromClass(usersId, classroomName, classroomMajor, classroomYear, classroomNumRoom);
                                                                  Navigator.of(context).pop(); // ปิด Dialog
                                                                },
                                                                child: Text('ยืนยัน'),
                                                              ),
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(context).pop(); // ปิด Dialog โดยไม่ทำอะไร
                                                                },
                                                                child: Text('ยกเลิก'),
                                                              ),
                                                            ],
                                                          );
                                                        }
                                                      );
                                                      
                                                    }, 
                                                    icon: Icon(Icons.delete),
                                                  ))),
                                                ]);
                                              }).toList(),
                                            ),
                                          ),
                                          
                                          // นักเรียนที่ถูกลบ
                                          Padding(
                                            padding: EdgeInsets.all(26),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text('รายชื่อนักเรียนที่ถูกลบออกจากห้องเรียน',
                                                    style: TextStyle(fontSize: 20)),

                                                DropdownButton<String>(
                                                value: sortOption,
                                                icon: const Icon(Icons.arrow_drop_down),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    sortOption = newValue!;
                                                    sortStudentsremove(); // เรียกใช้ฟังก์ชันในการเรียงข้อมูล
                                                  });
                                                },
                                                items: <String>['users_number', 'users_id']
                                                    .map<DropdownMenuItem<String>>((String value) {
                                                  return DropdownMenuItem<String>(
                                                    value: value,
                                                    child: Text(value == 'users_number' ? 'เรียงตามเลขที่ห้อง' : 'เรียงตามรหัสนักเรียน'),
                                                  );
                                                }).toList(),
                                              ),
                                              ],
                                            ),
                                          ),
                                          removedStudents.isEmpty
                                              ? Center(
                                                  child: Text(
                                                    'ไม่มีนักเรียนที่ถูกลบ',
                                                    style: TextStyle(fontSize: 20, color: Colors.red),
                                                  ),
                                                )
                                              : SingleChildScrollView(
                                                  scrollDirection: Axis.vertical,
                                                  child: DataTable(
                                                    columns: const [
                                                      DataColumn(label: Text('เลขที่ห้อง')),
                                                      DataColumn(label: Text('รหัสนักเรียน')),
                                                      DataColumn(label: Text('ชื่อ')),
                                                      DataColumn(label: Text('นามสกุล')),
                                                      DataColumn(label: Text('แผนการเรียน')),
                                                      DataColumn(label: Text('คืนเข้าห้องเรียน')),
                                                    ],
                                                    rows: removedStudents.map<DataRow>((student) {
                                                      return DataRow(cells: [
                                                        DataCell(Text(student['users_number'].toString())),
                                                        DataCell(Text(student['users_id'].toString())),
                                                        DataCell(Text(student['users_thfname'])),
                                                        DataCell(Text(student['users_thlname'])),
                                                        DataCell(Text(student['users_major'])),
                                                        DataCell(Center(child: IconButton(                      
                                                          onPressed: () { 
                                                            String usersId = student['users_id']; 
                                                            String classroomName = widget.classroomName;
                                                            String classroomMajor = widget.classroomMajor;
                                                            String classroomYear = widget.classroomYear;
                                                            String classroomNumRoom = widget.classroomNumRoom;
                                                            showDialog(
                                                              context: context, 
                                                              builder: (BuildContext context){
                                                                return AlertDialog(
                                                                  title: Text('ยืนยันการเพิ่มรายชื่อนักเรียนเข้าห้องเรียน'),
                                                                  content: Text('คุณต้องการเพิ่ม ${student['users_thfname']} ${student['users_thlname']} เข้าห้องเรียนหรือไม่?'),
                                                                  actions: <Widget>[
                                                                    TextButton(
                                                                      onPressed: () {
                                                                        // ยืนยันการลบ
                                                                        addStudentFromClass(usersId, classroomName, classroomMajor, classroomYear, classroomNumRoom);
                                                                        Navigator.of(context).pop(); // ปิด Dialog
                                                                      },
                                                                      child: Text('ยืนยัน'),
                                                                    ),
                                                                    TextButton(
                                                                      onPressed: () {
                                                                        Navigator.of(context).pop(); // ปิด Dialog โดยไม่ทำอะไร
                                                                      },
                                                                      child: Text('ยกเลิก'),
                                                                    ),
                                                                  ],
                                                                );
                                                              }
                                                            ); }, 
                                                          icon: Icon(Icons.restore),
                                                        ))),
                                                      ]);
                                                    }).toList(),
                                                  ),
                                                ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
