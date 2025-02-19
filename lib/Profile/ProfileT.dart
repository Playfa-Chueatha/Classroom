import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:http/http.dart' as http;

class Profilet extends StatefulWidget {
  final String username;

  const Profilet({super.key, required this.username});

  @override
  _ProfiletState createState() => _ProfiletState();
}

class _ProfiletState extends State<Profilet> {
  DataProfileT? userData;
  bool isEditing = false;
  final _formKey = GlobalKey<FormState>();
   String? selectedclassroom;
   int? selectedRoom;


  // เพิ่มตัวควบคุมสำหรับฟิลด์ต่างๆ
  late TextEditingController thfnameController;
  late TextEditingController thlnameController;
  late TextEditingController enfnameController;
  late TextEditingController enlnameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController classroomController;
  late TextEditingController numroomController;
  late TextEditingController subjectsController;

  @override
  void initState() {
    super.initState();
    fetchUserData();
    // เริ่มต้นตัวควบคุม
    thfnameController = TextEditingController();
    thlnameController = TextEditingController();
    enfnameController = TextEditingController();
    enlnameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    classroomController = TextEditingController();
    numroomController = TextEditingController();
    subjectsController = TextEditingController();
  }

  // ฟังก์ชันเพื่อดึงข้อมูลจาก API
  Future<void> fetchUserData() async {
    final response = await http.get(Uri.parse('https://www.edueliteroom.com/connect/User_teacher.php?username=${widget.username}'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['error'] == null) {
        setState(() {
          userData = DataProfileT.fromJson(data); 
          // กำหนดค่าให้กับ TextEditingController
          thfnameController.text = userData!.usertThfname;
          thlnameController.text = userData!.usertThlname;
          enfnameController.text = userData!.usertEnfname;
          enlnameController.text = userData!.usertEnlname;
          emailController.text = userData!.usertEmail;
          phoneController.text = userData!.usertPhone;
          classroomController.text = userData!.usertClassroom;
          numroomController.text = userData!.usertNumroom;
          subjectsController.text = userData!.usertSubjects;
        });
      } else {
        print('Error: ${data['error']}');
      }
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  // ฟังก์ชันเพื่อบันทึกการแก้ไขข้อมูล
  Future<void> saveChanges() async {
  final response = await http.post(
    Uri.parse('https://www.edueliteroom.com/connect/Update_teacher.php'),
    body: {
      'usert_auto': userData!.usertAuto.toString(),
      'usert_username': userData!.usertUsername,
      'usert_thfname': thfnameController.text,
      'usert_thlname': thlnameController.text,
      'usert_enfname': enfnameController.text,
      'usert_enlname': enlnameController.text,
      'usert_email': emailController.text,
      'usert_phone': phoneController.text,
      'usert_classroom': classroomController.text,
      'usert_numroom': numroomController.text,
      'usert_subjects': subjectsController.text,
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data['error'] == null) {
      // อัปเดตข้อมูลใน UI
      setState(() {
        userData = DataProfileT.fromJson(data);
        isEditing = false; // เปลี่ยนสถานะเป็นไม่แก้ไข
      });

      // เรียกใช้ฟังก์ชัน fetchUserData() เพื่อรีเฟรชข้อมูล
      fetchUserData();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('บันทึกข้อมูลสำเร็จ')));
    } else {
      print('Error: ${data['error']}');
    }
  } else {
    print('Request failed with status: ${response.statusCode}');
  }
}


  void toggleEditing() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 152, 186, 218),
        title: const Text('โปรไฟล์'),
        actions: [
          TextButton.icon(
            onPressed: toggleEditing,
            icon: Icon(Icons.edit, color: Colors.white),
            label: Text(
              'แก้ไขโปรไฟล์',
              style: TextStyle(color: Colors.white),
            ),
            style: TextButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 24, 113, 187),
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ],
      ),
      body: userData == null
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color.fromARGB(255, 147, 185, 221),
                ),
                width: MediaQuery.of(context).size.width * 0.7, 
                height: MediaQuery.of(context).size.height * 0.8,
                child: SingleChildScrollView(
                  child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 100),
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black26,
                                offset: Offset(2, 2),
                                blurRadius: 10),
                          ],
                          image: const DecorationImage(
                            image: AssetImage("assets/images/ครู.png"),
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      isEditing ? _buildEditForm() : _buildProfileTable(),
                    ],
                  ),
                ),
              ),
            ))
    );
  }


  // ฟังก์ชันสร้าง TextField สำหรับการแก้ไขข้อมูล
  Widget _buildTextField(String label, TextEditingController controller, {String? Function(String?)? validator}) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(labelText: label),
    validator: validator,
  );
}

Widget _buildEditForm() {
  return Form(
    key: _formKey,
    child: Column(
      children: [
        _buildTextField(
          'ชื่อ(ภาษาไทย):',
          thfnameController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'กรุณากรอกชื่อ(ภาษาไทย)';
            }
            if (!RegExp(r'^[ก-๏\s]+$').hasMatch(value)) {
              return 'กรุณากรอกเฉพาะอักษรภาษาไทย';
            }
            return null;
          },
        ),
        _buildTextField(
          'นามสกุล(ภาษาไทย):',
          thlnameController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'กรุณากรอกนามสกุล(ภาษาไทย)';
            }
            if (!RegExp(r'^[ก-๏\s]+$').hasMatch(value)) {
              return 'กรุณากรอกเฉพาะอักษรภาษาไทย';
            }
            return null;
          },
        ),
        _buildTextField(
          'ชื่อ(ภาษาอังกฤษ):',
          enfnameController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'กรุณากรอกชื่อ(ภาษาอังกฤษ)';
            }
            if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
              return 'กรุณากรอกเฉพาะอักษรภาษาอังกฤษ';
            }
            return null;
          },
        ),
        _buildTextField(
          'นามสกุล(ภาษาอังกฤษ):',
          enlnameController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'กรุณากรอกนามสกุล(ภาษาอังกฤษ)';
            }
            if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
              return 'กรุณากรอกเฉพาะอักษรภาษาอังกฤษ';
            }
            return null;
          },
        ),
        _buildTextField(
          'อีเมล:',
          emailController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'กรุณากรอกอีเมล';
            }
            if (!RegExp(r'^[a-zA-Z0-9._%+-]+@(gmail\.com|hotmail\.com)$').hasMatch(value)) {
              return 'กรุณากรอกอีเมลที่ลงท้ายด้วย @gmail.com หรือ @hotmail.com';
            }
            return null;
          },
        ),
        _buildTextField(
          'โทรศัพท์:',
          phoneController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'กรุณากรอกหมายเลขโทรศัพท์';
            }
            if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
              return 'กรุณากรอกหมายเลขโทรศัพท์ให้ครบ 10 หลัก';
            }
            return null;
          },
        ),
        DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              label: Text("กรุณาเลือกชั้นปีการศึกษา"),
            ),
            value: selectedclassroom == "0" || selectedclassroom == null
                ? null  // หากค่าเป็น "0" หรือ null ให้ค่า value เป็น null
                : selectedclassroom ?? (userData?.usertClassroom),
            items: [
              "ชั้นมัธยมศึกษาปีที่ 4",
              "ชั้นมัธยมศึกษาปีที่ 5",
              "ชั้นมัธยมศึกษาปีที่ 6"
            ].map((classroom) {
              return DropdownMenuItem(
                value: classroom,
                child: Text(classroom),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedclassroom = value;
                classroomController.text = value ?? ''; // ใช้ค่า '' ถ้าเป็น null
              });
            },
            validator: (value) =>
                value == null ? 'กรุณาเลือกชั้นปีการศึกษา' : null,
          ),
          DropdownButtonFormField<int>(
          decoration: const InputDecoration(
            label: Text('กรุณาเลือกห้อง:'),
          ),
          value: selectedRoom == 0 ? null : selectedRoom, // กำหนดค่าเป็น null เมื่อ selectedRoom เป็น 0
          items: List.generate(30, (index) {
            int roomNumber = index + 1;
            return DropdownMenuItem(
              value: roomNumber,
              child: Text(roomNumber.toString()),
            );
          }),
          onChanged: (value) {
            setState(() {
              selectedRoom = value ?? 0; // ถ้าเลือกห้องเป็น null ให้ตั้งค่าเป็น 0
              numroomController.text = value?.toString() ?? ''; // กรอกหมายเลขห้อง
            });
          },
          validator: (value) => value == null ? 'กรุณาเลือกห้อง' : null,
        ),






        _buildTextField('ครูประจำวิชา:', subjectsController),
        Padding(padding: EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              saveChanges();
            }
          },
          child: Text('บันทึกการเปลี่ยนแปลง'),
        )),
      ],
    ),
  );
}

  // ฟังก์ชันสร้างตาราง
  Widget _buildProfileTable() {
    return Center(
      child: SingleChildScrollView(  
        child: Table(
          columnWidths: {
            0: FixedColumnWidth(200),
            1: FixedColumnWidth(250),
          },
          children: [
            _buildTableRow('ชื่อ(ภาษาไทย):', '${userData!.usertThfname} ${userData!.usertThlname}'),
            _buildTableRow('ชื่อ(ภาษาอังกฤษ):', '${userData!.usertEnfname} ${userData!.usertEnlname}'),
            _buildTableRow('อีเมล:', userData!.usertEmail),
            _buildTableRow('โทรศัพท์:', userData!.usertPhone),
            _buildTableRow('ครูประจำชั้น:', userData!.usertClassroom),
            _buildTableRow('ห้อง:', userData!.usertNumroom),
            _buildTableRow('ครูประจำวิชา:', userData!.usertSubjects),
          ],
        ),
      ),
    );
  }

  // ฟังก์ชันสร้าง TableRow พร้อมจัดการค่าว่าง
  TableRow _buildTableRow(String title, String value) {
    final isValueEmpty = value.isEmpty || value == "-" || value == "0" || value == " - ";
    return TableRow(
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(
          isValueEmpty ? "*กรอกข้อมูล" : value,
          style: TextStyle(
            fontSize: 18,
            color: isValueEmpty ? Colors.red : Colors.black,
          ),
        ),
      ],
    );
  }
}


