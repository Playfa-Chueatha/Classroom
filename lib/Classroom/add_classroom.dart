import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_esclass_2/Classroom/setting_calss.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';

class AddClassroom extends StatefulWidget {
  final Examset exam;
  final String username;
  final String thfname;
  final String thlname;
  const AddClassroom({
    super.key, 
    required this.exam,
    required this.username,
    required this.thfname,
    required this.thlname,
  });

  @override
  State<AddClassroom> createState() => _AddClassroomState();
}

class _AddClassroomState extends State<AddClassroom> {
  final formKey = GlobalKey<FormState>();
  String? selectedclassroom;
  late String Name_class;
  late String SubjectsID;
  late String Section_class;
  late String Room_year;
  late int Room_No;
  late int School_year;
  late String Detail;

  

  Future<void> addClassroom() async {
    var data = {
      'classroom_name': Name_class,
      'classroom_subjectsID': SubjectsID,
      'classroom_major': Section_class,
      'classroom_year': Room_year,
      'classroom_numroom': Room_No,
      'classroom_detail': Detail,
      'usert_username': widget.username,
    };

    var response = await http.post(
      Uri.parse('https://www.edueliteroom.com/connect/add_classroom.php'),
      body: json.encode(data),
      headers: {"Content-Type": "application/json"},
    );
    print(response.body);

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      if (responseData['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Classroom added successfully'), backgroundColor: Colors.green),
        );
        Navigator.pop(context, true); // ส่งค่ากลับไปที่หน้าหลักว่าเพิ่มสำเร็จ
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add classroom: ${data['message']}'), backgroundColor: Colors.red),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.body}'), backgroundColor: Colors.red),
      );
    }
  }

  void showToast(String message) {
    FToast().init(context).showToast(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.black87,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.info, color: Colors.white),
            SizedBox(width: 12.0),
            Text(message, style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return AlertDialog(
      title: Center(child: Text("สร้างห้องเรียนของคุณ")),
      content: Form(
        key: formKey,
        child: SizedBox(
          height: screenSize.height * 0.7,
          width: screenSize.width * 0.5,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Container(
                  height: screenSize.height * 0.08,
                  width: screenSize.width * 0.3,
                  margin: EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: InputDecoration(label: Text("วิชา", style: TextStyle(fontSize: 20))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "กรุณากรอกชื่อวิชา";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      Name_class = value ?? '';
                    },
                  ),
                ),
                Container(
                  height: screenSize.height * 0.08,
                  width: screenSize.width * 0.3,
                  margin: EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: InputDecoration(label: Text("รหัสวิชา", style: TextStyle(fontSize: 20))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "กรุณากรอกรหัสวิชา";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      SubjectsID = value ?? '';
                    },
                  ),
                ),
                Container(
                  height: screenSize.height * 0.08,
                  width: screenSize.width * 0.3,
                  margin: EdgeInsets.all(10),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(label: Text("แผนการเรียน", style: TextStyle(fontSize: 20))),
                    items: sectionOptions.map((String section) {
                      return DropdownMenuItem<String>(
                        value: section,
                        child: Text(section),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        Section_class = value ?? '';
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณาเลือกแผนการเรียน';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      Section_class = value ?? '';
                    },
                  ),
                ),
                Container(
                  height: screenSize.height * 0.08,
                  width: screenSize.width * 0.3,
                  margin: EdgeInsets.all(10),
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      label: Text("กรุณาเลือกชั้นปีการศึกษา", style: TextStyle(fontSize: 20)),
                    ),
                    value: selectedclassroom,
                    items: ["ชั้นมัธยมศึกษาปีที่ 4", "ชั้นมัธยมศึกษาปีที่ 5", "ชั้นมัธยมศึกษาปีที่ 6"]
                        .map((classroom) {
                      return DropdownMenuItem(
                        value: classroom,
                        child: Text(classroom),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedclassroom = value;
                        Room_year = value ?? '';
                      });
                    },
                    validator: (value) => value == null ? 'กรุณาเลือกชั้นปีการศึกษา' : null,
                  ),
                ),
                Container(
                  height: screenSize.height * 0.08,
                  width: screenSize.width * 0.3,
                  margin: EdgeInsets.all(10),
                  child: DropdownButtonFormField<int>(
                    decoration: InputDecoration(label: Text("เลือกห้อง", style: TextStyle(fontSize: 20))),
                    items: List.generate(30, (index) {
                      int roomNumber = index + 1;
                      return DropdownMenuItem<int>(
                        value: roomNumber,
                        child: Text(roomNumber.toString()),
                      );
                    }),
                    onChanged: (value) {
                      setState(() {
                        Room_No = value!;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return "กรุณาเลือกหมายเลขห้อง";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      Room_No = value!;
                    },
                  ),
                ),
                Container(
                  height: screenSize.height * 0.08,
                  width: screenSize.width * 0.3,
                  margin: EdgeInsets.all(10),
                  child: DropdownButtonFormField<int>(
                    decoration: InputDecoration(label: Text("ปีการศึกษา", style: TextStyle(fontSize: 20))),
                    items: List.generate(6, (index) {
                      int year = 2565 + index; // สร้างปีการศึกษา 2565 ถึง 2570
                      return DropdownMenuItem<int>(
                        value: year,
                        child: Text(year.toString()),
                      );
                    }),
                    onChanged: (value) {
                      setState(() {
                        School_year = value!;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return "กรุณาเลือกปีการศึกษา";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      School_year = value!;
                    },
                  ),
                ),
                Container(
                  height: screenSize.height * 0.08,
                  width: screenSize.width * 0.3,
                  margin: EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: InputDecoration(label: Text("รายละเอียดเพิ่มเติม", style: TextStyle(fontSize: 20))),
                    onSaved: (value) {
                      Detail = value ?? '';
                    },
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: screenSize.height * 0.07,
                  width: screenSize.width * 0.2,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 45, 124, 155),
                    ),
                    onPressed: () async {
                      var connectivityResult = await Connectivity().checkConnectivity();
                      // ignore: unrelated_type_equality_checks
                      if (connectivityResult == ConnectivityResult.none) {
                        showToast("กรุณาตรวจสอบการเชื่อมต่ออินเทอร์เน็ต");
                        return;
                      }

                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        await addClassroom();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SettingCalss(
                            username: widget.username,
                            classroomMajor: '',
                            classroomName: '',
                            classroomNumRoom: '',
                            classroomYear: '',
                            thfname: widget.thfname,
                            thlname: widget.thlname,
                            
                            )),
                        );
                      }
                    },
                    child: Text("สร้างห้องเรียน", style: TextStyle(fontSize: 20)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('ปิด'),
              ),
      ],
    );
  }
}
