import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Profile/alertEditprofile.dart';
import 'package:flutter_esclass_2/Profile/repass.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';



class Profile_T extends StatefulWidget {
  const Profile_T({super.key});

  @override
  State<Profile_T> createState() => _Profile_TState();
}

class _Profile_TState extends State<Profile_T> {
  final double coverHeight = 280;

  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            height: 1500,
            width: 1500,
            margin: EdgeInsets.all(50),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 147, 185, 221),
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 30),
                  Container(
                    child: Row(
                      children: [
                        SizedBox(width: 1100),
                        SizedBox(
                          height: 50,
                          width: 200,
                          child: FilledButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => repass(),
                              );
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 228, 223, 153),
                              foregroundColor: Colors.black,
                            ),
                            child: Text("เปลี่ยนรหัสผ่าน", style: TextStyle(fontSize: 20)),
                          ),
                        ),
                        SizedBox(width: 10),
                        SizedBox(
                          height: 50,
                          width: 150,
                          child: FilledButton(
                            onPressed: () async {
                              final result = await showDialog(
                                context: context,
                                builder: (context) => const alertprofile_T(),
                              );

                              if (result != null && result is dataprofile_T) {
                                // ถ้ามีค่าที่ส่งกลับมา ให้ใช้ setState เพื่ออัปเดต UI
                                setState(() {
                                  dataprofileT[0] = result;
                                });
                            }},
                            style: FilledButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 10, 82, 104),
                            ),
                            child: Text("แก้ไขข้อมูล", style: TextStyle(fontSize: 20)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 50),
                  Container(
                    height: 300,
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(2, 2),
                          blurRadius: 10,
                        ),
                      ],
                      image: _image == null
                          ? DecorationImage(
                              image: AssetImage("assets/images/ครู.png"),
                            )
                          : DecorationImage(
                              image: FileImage(_image!), 
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 50,
                    width: 150,
                    child: FilledButton(
                      onPressed: _pickImage,
                      style: FilledButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 10, 82, 104),
                      ),
                      child: Text("แก้ไขโปรไฟล์", style: TextStyle(fontSize: 20)),
                    ),
                  ),
                  SizedBox(height: 50),





                  Container(
                    height: 700,
                    width: 1200,
                    margin: EdgeInsets.all(50),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: 
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        //text      
                            Container(
                              height: 500,
                              width: 400,
                              decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 255, 255, 255)
                                ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "ชื่อ-นามสกุล(ภาษาไทย): ",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  'ชื่อ-นามสกุล(ภาษาอังกฤษ): ',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  'ครูประจำชั้นมัธยมศึกษาปีที่: ',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  'ห้อง: ',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  'เบอร์โทร: ',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  'E-mail: ',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  'วิชาที่สอน: ',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        



                        //data      
                            Container(
                              height: 500,
                              width: 400,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 255, 255, 255)
                              ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  " ${dataprofileT[0].thainame_teacher}",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  ' ${dataprofileT[0].Engname_teacher}',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  ' ${dataprofileT[0].school_year}',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  ' ${dataprofileT[0].room_no}',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  ' ${dataprofileT[0].phone}',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  ' ${dataprofileT[0].email_teacher}',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  ' ${dataprofileT[0].subjects}',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                  SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class dataprofile_T {
  dataprofile_T({
    required this.id_teacher,
    required this.thainame_teacher,
    required this.Engname_teacher,
    required this.email_teacher,
    required this.school_year,
    required this.room_no,
    required this.phone,
    required this.subjects,
  });

  int id_teacher;
  String thainame_teacher;
  String Engname_teacher;
  String email_teacher;
  int school_year;
  int room_no;
  String phone;
  String subjects;
}

List<dataprofile_T> dataprofileT = [
  dataprofile_T(
    id_teacher: 1,
    thainame_teacher: 'ปลายฟ้า เชื้อถา',
    Engname_teacher: 'Paiyfa Chueatha',
    email_teacher: 'paiyfa.11@gmail.com',
    school_year: 4,
    room_no: 9,
    phone: '0615052245',
    subjects: 'คณิตศาสตร์',
  ),
];
