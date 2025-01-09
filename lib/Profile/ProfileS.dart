import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:http/http.dart' as http;

class Profiles extends StatefulWidget {
  final String username;

  const Profiles({super.key, required this.username});

  @override
  _ProfiletState createState() => _ProfiletState();
}

class _ProfiletState extends State<Profiles> {
  Studentclass? Student;
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
  late TextEditingController majorController;
  late TextEditingController parentPhoneController;


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
    majorController = TextEditingController();
    parentPhoneController = TextEditingController();
  }

  // ฟังก์ชันเพื่อดึงข้อมูลจาก API
  Future<void> fetchUserData() async {
    final response = await http.get(Uri.parse('https://www.edueliteroom.com/connect/User_students.php?username=${widget.username}'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(response.body);
      if (data['error'] == null) {
        setState(() {
          Student = Studentclass.fromJson(data); 
          // กำหนดค่าให้กับ TextEditingController
          thfnameController.text = Student!.usersThfname;
          thlnameController.text = Student!.usersThlname;
          enfnameController.text = Student!.usersEnfname;
          enlnameController.text = Student!.usersEnlname;
          emailController.text = Student!.usersEmail;
          phoneController.text = Student!.usersPhone;
          parentPhoneController.text = Student!.usersParentphone;
          classroomController.text = Student!.usersClassroom;
          numroomController.text = Student!.usersNumroom;
          majorController.text = Student!.usersMajor;
          
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
  try {
    // พิมพ์ค่าที่จะส่งไปยัง API
    print('Sending data to API:');
    print({
      'users_auto': Student!.usersAuto.toString(),
      'users_username': widget.username,
      'users_thfname': thfnameController.text,
      'users_thlname': thlnameController.text,
      'users_enfname': enfnameController.text,
      'users_enlname': enlnameController.text,
      'users_email': emailController.text,
      'users_phone': phoneController.text,
      'users_classroom': classroomController.text,
      'users_numroom': numroomController.text,
      'users_parentphone': parentPhoneController.text,
      'usert_major': majorController.text,
      'users_number': numroomController.text,
    });

    final response = await http.post(
      Uri.parse('https://www.edueliteroom.com/connect/Update_students.php'),
      body: {
        'users_auto': Student!.usersAuto.toString(),
        'users_username': widget.username,
        'users_thfname': thfnameController.text,
        'users_thlname': thlnameController.text,
        'users_enfname': enfnameController.text,
        'users_enlname': enlnameController.text,
        'users_email': emailController.text,
        'users_phone': phoneController.text,
        'users_classroom': classroomController.text,
        'users_numroom': numroomController.text,
        'users_parentphone': parentPhoneController.text,
        'users_major': majorController.text,
        'users_number': numroomController.text,
      },
    );
    print(response.body);

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);

        if (data['error'] == null) {
          setState(() {
            Student = Studentclass.fromJson(data);
            isEditing = false;  // เปลี่ยนสถานะเป็นไม่แก้ไข
          });

          fetchUserData();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('บันทึกข้อมูลสำเร็จ'))
          );
        } else {
          print('Error: ${data['error']}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('เกิดข้อผิดพลาด: ${data['error']}'))
          );
        }
      } catch (e) {
        print('JSON Decode Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เกิดข้อผิดพลาดในการประมวลผลข้อมูล'))
        );
      }
    } else {
      print('Request failed with status: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้'))
      );
    }
  } catch (e) {
    print('Request Error: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('เกิดข้อผิดพลาดในการส่งคำขอ'))
    );
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
      body: Student == null
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
        _buildTextField('โทรศัพท์ผู้ปกครอง:', parentPhoneController),
        
        
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            label: Text(
              "กรุณาเลือกชั้นปีการศึกษา",
            ),
          ),
          value: selectedclassroom ?? Student!.usersClassroom, // แสดงค่าจาก Student ถ้ามี
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
              classroomController.text = value!;  
            });
          },
          validator: (value) => value == null ? 'กรุณาเลือกชั้นปีการศึกษา' : null,
        ),

        
        _buildTextField('ห้อง:', numroomController),
       DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        label: Text(
          "กรุณาเลือกแผนการเรียน",
        ),
      ),
      value: sectionOptions.contains(majorController.text)
          ? majorController.text 
          : null, // ใช้ค่าใน majorController แทน
      items: sectionOptions.map((section) {
        return DropdownMenuItem(
          value: section,
          child: Text(section),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          majorController.text = value ?? ""; // อัปเดตค่าที่เลือกใน majorController
        });
      },
      validator: (value) => value == null ? 'กรุณาเลือกแผนการเรียน' : null,
    ),

    SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.all(20),
          child: 
        
        ElevatedButton(
          onPressed: saveChanges,
          child: Text('บันทึกการเปลี่ยนแปลง'),
        )),
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
            _buildTableRow('ชื่อ(ภาษาไทย):', '${Student!.usersThfname} ${Student!.usersThlname}'),
            _buildTableRow('ชื่อ(ภาษาอังกฤษ):', '${Student!.usersEnfname} ${Student!.usersEnlname}'),
            _buildTableRow('อีเมล:', Student!.usersEmail),
            _buildTableRow('โทรศัพท์:', Student!.usersPhone),
            _buildTableRow('โทรศัพท์ผู้ปกครอง:', Student!.usersParentphone),
            _buildTableRow('ชั้นปี:', Student!.usersClassroom),
            _buildTableRow('ห้อง:', Student!.usersNumroom),
            _buildTableRow('แผนการเรียน:', Student!.usersMajor),
            
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
