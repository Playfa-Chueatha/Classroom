import 'dart:convert';
import 'package:flutter/material.dart';
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

  // ฟังก์ชันที่ใช้สลับสถานะการแก้ไขข้อมูล
  void toggleEditing() {
    setState(() {
      isEditing = !isEditing; // สลับสถานะการแก้ไข
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
                      // สร้างฟอร์มในการแก้ไขข้อมูล
                      isEditing ? _buildEditForm() : _buildProfileTable(),
                    ],
                  ),
                ),
              ),
            ))
    );
  }

  // ฟังก์ชันสร้างฟอร์มการแก้ไขข้อมูล
  Widget _buildEditForm() {
  return Form(
    key: _formKey,
    child: Column(
      children: [
        _buildTextField('ชื่อ(ภาษาไทย):', thfnameController),
        _buildTextField('นามสกุล(ภาษาไทย):', thlnameController),
        _buildTextField('ชื่อ(ภาษาอังกฤษ):', enfnameController),
        _buildTextField('นามสกุล(ภาษาอังกฤษ):', enlnameController),
        _buildTextField('อีเมล:', emailController),
        _buildTextField('โทรศัพท์:', phoneController),
        
        
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            label: Text(
              "กรุณาเลือกชั้นปีการศึกษา",
              
            ),
          ),
          value: selectedclassroom ?? userData!.usertClassroom, 
          items: [
            "ชั้นมัธยมศึกษาปีที่ 4", 
            "ชั้นมัธยมศึกษาปีที่ 5", 
            "ชั้นมัธยมศึกษาปีที่ 6"
          ].map((clasroom) {
            return DropdownMenuItem(
              value: clasroom,
              child: Text(clasroom),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedclassroom = value;
              classroomController.text = value!;  
            });
          },
          validator: (value) => value == null ? 'กรุณาเลือกชั้นปีการศึกษา' : null,
        ),
        
        _buildTextField('ห้อง:', numroomController),
        _buildTextField('ครูประจำวิชา:', subjectsController),
        ElevatedButton(
          onPressed: saveChanges,
          child: Text('บันทึกการเปลี่ยนแปลง'),
        ),
      ],
    ),
  );
}


  // ฟังก์ชันสร้าง TextField สำหรับการแก้ไขข้อมูล
  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'กรุณากรอกข้อมูล';
          }
          return null;
        },
      ),
    );
  }

  // ฟังก์ชันสร้างตาราง
  Widget _buildProfileTable() {
    return Center(
      child: SingleChildScrollView(  // ใช้ SingleChildScrollView ห่อหุ้ม
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
