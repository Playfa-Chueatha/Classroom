import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // นำเข้าเพื่อใช้กับ inputFormatters
import 'package:flutter_esclass_2/Classroom/setting_calss.dart';
import 'package:flutter_esclass_2/Data/data_calssroom.dart';

class AddClassroom extends StatefulWidget {
  const AddClassroom({super.key});

  @override
  State<AddClassroom> createState() => _AddClassroomState();
}

class _AddClassroomState extends State<AddClassroom> {
  final formKey = GlobalKey<FormState>();
  String Name_class = '';
  String Section_class = '';  // กำหนดค่าเริ่มต้นเป็นค่าว่าง
  int Room_year = 100; //ชั้นปี
  int Room_No = 15; //ห้อง
  int School_year = 2590; //ปีการศึกษา
  String Detail = '';
  
  // รายการแผนการเรียน
  final List<String> sectionOptions = [
    'คณิตศาสตร์ - วิทยาศาสตร์',
    'ภาษาอังกฤษ-คณิตศาสตร์',
    'ภาษาอังกฤษ-ภาษาจีน',
    'ภาษาอังกฤษ-ภาษาฝรั่งเศส',
    'ภาษาอังกฤษ-ภาษาญี่ปุ่น',
    'สายศิลป์-สังคม',
  ];

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
            child: Column(
              children: [
                // ฟิลด์วิชา
                Container(
                  height: screenSize.height * 0.08,
                  width: screenSize.width * 0.3,
                  margin: EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: InputDecoration(
                      label: Text("วิชา", style: TextStyle(fontSize: 20)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "กรุณากรอกชื่อวิชา";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      Name_class = value ?? '';  // กำหนดค่าเริ่มต้นเป็นค่าว่าง
                    },
                  ),
                ),
                // ฟิลด์แผนการเรียน
                Container(
                  height: screenSize.height * 0.08,
                  width: screenSize.width * 0.3,
                  margin: EdgeInsets.all(10),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      label: Text("แผนการเรียน", style: TextStyle(fontSize: 20)),
                    ),
                    items: sectionOptions.map((String section) {
                      return DropdownMenuItem<String>(
                        value: section,
                        child: Text(section),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        Section_class = value ?? '';  // ตรวจสอบไม่ให้เป็น null
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณาเลือกแผนการเรียน';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      Section_class = value ?? '';  // กำหนดค่าเริ่มต้นเป็นค่าว่าง
                    },
                  ),
                ),
                // ฟิลด์ชั้นปี
                Container(
                  height: screenSize.height * 0.08,
                  width: screenSize.width * 0.3,
                  margin: EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: InputDecoration(
                      label: Text("ชั้นปี", style: TextStyle(fontSize: 20)),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(1),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "กรุณากรอกชั้นปี";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      Room_year = int.parse(value!);
                    },
                  ),
                ),
                // ฟิลด์ห้อง
                Container(
                  height: screenSize.height * 0.08,
                  width: screenSize.width * 0.3,
                  margin: EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: InputDecoration(
                      label: Text("ห้อง", style: TextStyle(fontSize: 20)),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(2),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "กรุณากรอกหมายเลขห้อง";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      Room_No = int.parse(value!);
                    },
                  ),
                ),
                // ฟิลด์ปีการศึกษา
                Container(
                  height: screenSize.height * 0.08,
                  width: screenSize.width * 0.3,
                  margin: EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: InputDecoration(
                      label: Text("ปีการศึกษา", style: TextStyle(fontSize: 20)),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "กรุณากรอกปีการศึกษา";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      School_year = int.parse(value!);
                    },
                  ),
                ),
                // ฟิลด์รายละเอียดเพิ่มเติม
                Container(
                  height: screenSize.height * 0.08,
                  width: screenSize.width * 0.3,
                  margin: EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: InputDecoration(
                      label: Text("รายละเอียดเพิ่มเติม", style: TextStyle(fontSize: 20)),
                    ),
                    onSaved: (value) {
                      Detail = value ?? ''; // กำหนดค่าเริ่มต้นเป็นค่าว่าง
                    },
                  ),
                ),
                SizedBox(height: 20),
                // ปุ่มสร้างห้องเรียน
                SizedBox(
                  height: screenSize.height * 0.07,
                  width: screenSize.width * 0.2,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 45, 124, 155),
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        data.add(
                          ClassroomData(
                            Name_class: Name_class,
                            Section_class: Section_class,
                            Room_year: Room_year,
                            Room_No: Room_No,
                            School_year: School_year,
                            Detail: Detail,
                          ),
                        );
                        formKey.currentState!.reset();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (ctx) => const SettingCalss()),
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
    );
  }
}
