import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:flutter_esclass_2/Login/loginS.dart';
import 'package:flutter_esclass_2/Login/loginT.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AddForm_Register_S extends StatefulWidget {
  const AddForm_Register_S({super.key});

  @override
  State<AddForm_Register_S> createState() => _FormState();
}

class _FormState extends State<AddForm_Register_S> {

  final formKey = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();
  TextEditingController surname = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController studentid = TextEditingController();
  TextEditingController numroom = TextEditingController();
  TextEditingController prefix = TextEditingController();
  TextEditingController clasroom_year = TextEditingController();
  TextEditingController clasroom_major = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController phone = TextEditingController();


  String type = '1';
  String? selectedPrefix;
  String? selectedclassroom;
  String? selectedmajor;
  String engfirstname = '-';
  String englastname = '-';
  String parentphone = '-';
  String teacher_name = '-';
  String msg = '';




Future<void> checkUser() async {
    String url = "https://www.edueliteroom.com/connect/check_user_students.php";

    final Map<String, dynamic> queryParams = {
      "users_username": username.text,
      "thaifirstname": name.text,
      "thailastname": surname.text,
      "email": email.text,
    };

    try {
  http.Response response =
      await http.get(Uri.parse(url).replace(queryParameters: queryParams));

  // ตรวจสอบเนื้อหาที่ตอบกลับจากเซิร์ฟเวอร์
  print("Response body: ${response.body}");

  if (response.statusCode == 200) {
    var responseBody = jsonDecode(response.body);  // ลองแปลงเป็น JSON
    setState(() {
      if (responseBody['status'] == "available") {
        msg = "สามารถใช้ User นี้ได้";
      } else if (responseBody['status'] == "duplicate_name") {
        msg = "ชื่อและนามสกุลซ้ำในระบบ";
      } else if (responseBody['status'] == "duplicate_username") {
        msg = "User นี้มีผู้ใช้แล้ว";
      } else if (responseBody['status'] == "duplicate_email") {
        msg = "อีเมลนี้มีผู้ใช้งานแล้ว";
      }
    });
  } else {
    print("Error: ${response.statusCode}");
  }
} catch (error) {
  print("Error: $error");
  setState(() {
    msg = "เกิดข้อผิดพลาดในการเชื่อมต่อ";
  });
}
}



  // ฟังก์ชัน saveProfileS
Future<void> saveProfileS(context) async {
  Uri uri = Uri.parse('https://www.edueliteroom.com/connect/Register_students.php');

  // ข้อมูลที่ต้องการส่งเป็น JSON
  Map<String, dynamic> data = {
    'users_prefix': prefix.text,
    'users_username': username.text, 
    'users_password': pass.text,
    'users_id': studentid.text,
    'users_thfname': name.text,
    'users_thlname': surname.text,
    'users_classroom': clasroom_year.text,
    'users_numroom': numroom.text,
    'users_number': number.text,
    'users_major': clasroom_major.text,
    'users_email': email.text,
    'users_enfname': engfirstname,
    'users_enlname': englastname,
    'usert_username' : teacher_name,
    'users_phone': phone.text,
    'users_parentphone': parentphone,
  };

  try {
    // ส่งข้อมูลแบบ JSON
    http.Response response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data), // ต้องแปลงเฉพาะข้อมูลที่เป็น JSON ได้
    );

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      if (responseBody['success'] != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('การบันทึกข้อมูลเสร็จสิ้น')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login_S()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('การบันทึกข้อมูลล้มเหลว กรุณาลองใหม่อีกครั้ง')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการเชื่อมต่อกับเซิร์ฟเวอร์')),
      );
    }
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('เกิดข้อผิดพลาด: $error')),
    );
  }
}



String? validatenumber(String? value) {
  if (value == null || value.isEmpty) {
    return 'กรุณากรอกเบอร์โทร';
  }

  // ตรวจสอบว่ามีตัวอักษรไทยหรือไม่
  final thaiRegex = RegExp(r'[\u0E00-\u0E7F]');
  if (thaiRegex.hasMatch(value)) {
    return 'ไม่สามารถกรอกภาษาไทยในเบอร์โทรได้';
  }

  // ตรวจสอบว่าเป็นตัวเลขทั้งหมดและมีความยาว 10 หลัก
  final phoneRegex = RegExp(r'^[0-9]{10}$');
  if (!phoneRegex.hasMatch(value)) {
    return 'กรุณากรอกเบอร์โทรให้ถูกต้อง (10 หลัก)';
  }

  return null;
}



String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอก E-mail';
    }

    // ตรวจสอบภาษาไทยในอีเมล
    final thaiRegex = RegExp(r'[\u0E00-\u0E7F]');
    if (thaiRegex.hasMatch(value)) {
      return 'ไม่สามารถกรอกภาษาไทยใน E-mail ได้';
    }

    // ตรวจสอบรูปแบบอีเมลที่รองรับ @gmail.com หรือ @hotmail.com
    final emailRegex = RegExp(r'^[^@]+@(gmail\.com|hotmail\.com)$');
    if (!emailRegex.hasMatch(value)) {
      return 'กรุณากรอก E-mail ที่ถูกต้อง (ใช้ @gmail.com หรือ @hotmail.com)';
    }
    return null;
  }

  String? validateThaiCharacters(String? value, String errorMessage) {
    final thaiRegex = RegExp(r'^[\u0E00-\u0E7F]+$');
    if (value == null || value.isEmpty) {
      return errorMessage;
    }
    if (!thaiRegex.hasMatch(value)) {
      return 'กรุณากรอกเฉพาะตัวอักษรภาษาไทย';
    }
    return null;
  }

  String? validateEnglishAndNumbers(String? value, String errorMessage) {
    final englishNumberRegex = RegExp(r'^[a-zA-Z0-9]+$');
    if (value == null || value.isEmpty) {
      return errorMessage;
    }
    if (!englishNumberRegex.hasMatch(value)) {
      return 'กรุณากรอกเฉพาะตัวอักษรภาษาอังกฤษและตัวเลข';
    }
    return null;
  }


  bool _isObscurd = true;
  bool _isObscurd2 = true ;

    @override
  void initState() {
    super.initState();
  }

  @override
Widget build(BuildContext context) {
  // คำนวณขนาดหน้าจอ
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  return Scaffold(
    backgroundColor: Color.fromARGB(255, 147, 235, 241),
    body: SingleChildScrollView(
       padding: EdgeInsets.fromLTRB(
        screenWidth * 0.1, // ใช้เปอร์เซ็นต์ของความกว้างหน้าจอ
        150,
        screenWidth * 0.1,
        100,
      ),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Text(
              "สมัครสมาชิก",
              style: TextStyle(fontSize: screenWidth * 0.03), // ปรับขนาดฟอนต์
            ),
            SizedBox(height: screenHeight * 0.02),
            Image.asset(
              'assets/images/นักเรียน2.png',
              height: screenHeight * 0.4, // ปรับขนาดรูปภาพ
            ),
            SizedBox(height: 50),

            // รหัสนักเรียน
            TextFormField(
              maxLength: 20,
              decoration: InputDecoration(
                counterText: "",
                label: Text(
                  "กรุณากรอกรหัสนักเรียน",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              validator: (val) => val == null || val.isEmpty ? 'กรุณากรอกรหัสนักเรียน' : null,
              controller: studentid,
            ),
            SizedBox(height: screenHeight * 0.02),

            // คำนำหน้าชื่อ
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                label: Text(
                  "กรุณาเลือกคำนำหน้าชื่อ",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              value: selectedPrefix,
              items: ["นาย", "นาง", "นางสาว"].map((prefix) {
                return DropdownMenuItem(
                  value: prefix,
                  child: Text(prefix),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedPrefix = value;
                  prefix.text = value!;
                });
              },
              validator: (value) => value == null ? 'กรุณาเลือกคำนำหน้าชื่อ' : null,
            ),
            SizedBox(height: screenHeight * 0.02),

            // ชื่อจริง
            TextFormField(
              maxLength: 20,
              decoration: InputDecoration(
                counterText: "",
                label: Text(
                  "กรุณาระบุชื่อจริง",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              validator: (val) =>
                  validateThaiCharacters(val, 'กรุณากรอกระบุชื่อจริง'),
              controller: name,
            ),
            SizedBox(height: screenHeight * 0.02),


                //นามสกุล
                TextFormField(
                  maxLength: 20,
                  decoration: InputDecoration(
                    counterText: "",
                    label: Text(
                      "กรุณาระบุนามสกุล",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  validator: (val) =>
                    validateThaiCharacters(val, 'กรุณากรอกระบุนามสกุล'),
                  controller: surname,
                ),
                SizedBox(height:  screenHeight * 0.02),

               
                //ชั้นปีการศึกษา
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    label: Text(
                      "กรุณาเลือกชั้นปีการศึกษา",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  value: selectedclassroom,
                  items: ["ชั้นมัธยมศึกษาปีที่ 4", "ชั้นมัธยมศึกษาปีที่ 5", "ชั้นมัธยมศึกษาปีที่ 6"].map((clasroom) {
                    return DropdownMenuItem(
                      value: clasroom,
                      child: Text(clasroom),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedclassroom = value;
                      clasroom_year.text = value!;
                    });
                  },
                  validator: (value) => value == null ? 'กรุณาเลือกชั้นปีการศึกษา' : null,
                ),
                SizedBox(height:  screenHeight * 0.02),

                

                //ห้อง
                DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    label: Text(
                      "กรุณาระบุห้องของคุณ",
                      style: TextStyle(fontSize: 20),
                    ),
                    
                  ),
                  value: null, // ค่าเริ่มต้น (เป็น null เพื่อบังคับให้ผู้ใช้เลือก)
                  items: List.generate(
                    30,
                    (index) => DropdownMenuItem(
                      value: index + 1, // เริ่มต้นที่ 1
                      child: Text('${index + 1}'), // แสดงค่าเป็นตัวเลข
                    ),
                  ),
                  onChanged: (val) {
                    if (val != null) {
                      numroom.text = val.toString(); // เก็บค่าที่เลือกใน TextEditingController
                    }
                  },
                  validator: (val) {
                    if (val == null) {
                      return 'กรุณาเลือกห้องของคุณ';
                    }
                    return null;
                  },
                ),
                SizedBox(height:  screenHeight * 0.02),


                //เลขที่

                DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    label: Text(
                      "กรุณาระบุเลขที่ของคุณ",
                      style: TextStyle(fontSize: 20),
                    ),
                    
                  ),
                  value: null, // ค่าเริ่มต้น (เป็น null เพื่อบังคับให้ผู้ใช้เลือก)
                  items: List.generate(
                    30,
                    (index) => DropdownMenuItem(
                      value: index + 1, // เริ่มต้นที่ 1
                      child: Text('${index + 1}'), // แสดงค่าเป็นตัวเลข
                    ),
                  ),
                  onChanged: (val) {
                    if (val != null) {
                      number.text = val.toString(); // เก็บค่าที่เลือกใน TextEditingController
                    }
                  },
                  validator: (val) {
                    if (val == null) {
                      return 'กรุณาระบุเลขที่ของคุณ';
                    }
                    return null;
                  },
                ),

                
                SizedBox(height:  screenHeight * 0.02),



                //แผนการเรียน
                 DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    label: Text(
                      "กรุณาเลือกแผนการเรียน",style: TextStyle(fontSize: 20),
                    ),
                  ),
                  value: sectionOptions.contains(clasroom_major.text)
                      ? clasroom_major.text 
                      : null, // ใช้ค่าใน majorController แทน
                  items: sectionOptions.map((section) {
                    return DropdownMenuItem(
                      value: section,
                      child: Text(section),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedmajor = value;
                      clasroom_major.text = value!;
                    });
                  },
                  validator: (value) => value == null ? 'กรุณาเลือกแผนการเรียน' : null,
                ),
                SizedBox(height:  screenHeight * 0.02),


                //EMAIL
                TextFormField(
                  maxLength: 40,
                  decoration: InputDecoration(
                    counterText: "",
                    label: Text(
                      "กรุณากรอก E-mail",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  validator: validateEmail,
                  controller: email,
                ),

                TextFormField(
                  maxLength: 10,
                  decoration: InputDecoration(
                    counterText: "",
                    label: Text(
                      "กรุณากรอกเบอร์โทร",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  validator: validatenumber,
                  controller: phone,
                ),



                //ชื่อผู้ใช้
                TextFormField(
                  maxLength: 40,
                  decoration: InputDecoration(
                    counterText: "",
                    label: Text(
                      "กรุณากรอกชื่อผู้ใช้",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  validator: (val) {
                    String trimmedValue = val?.replaceAll(' ', '') ?? '';
                    return validateEnglishAndNumbers(trimmedValue, 'กรุณากรอกชื่อผู้ใช้ของคุณ');
                  },
                  controller: username,
                  onChanged: (val) {
                    username.text = val.replaceAll(' ', '');
                    username.selection = TextSelection.fromPosition(
                      TextPosition(offset: username.text.length),
                    );
                  },
                ),


                //รหัสผ่าน
                 TextFormField(
                  maxLength: 20,
                  obscureText: _isObscurd,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        padding: const EdgeInsetsDirectional.all(10.0),
                        icon: _isObscurd ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
                        onPressed: (){
                          setState(() {
                          _isObscurd =!_isObscurd;
                        });
                        }, 
                    ),
                    counterText: "",
                    label: Text(
                      "กรุณากรอกรหัสผ่าน",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'กรุณากรอกรหัสผ่าน';
                    }
                    return null;
                  },
                  controller: pass,
                ),
                TextFormField(
                  maxLength: 20,
                  obscureText: _isObscurd2,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        padding: const EdgeInsetsDirectional.all(10.0),
                        icon: _isObscurd2 ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
                        onPressed: (){
                          setState(() {
                          _isObscurd2 =!_isObscurd2;
                        });
                        }, 
                    ),
                    counterText: "",
                    label: Text(
                      "กรุณายืนยันรหัสผ่าน",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'กรุณากรอกยืนยันรหัสผ่าน';
                    } else if (val != pass.text) {
                      return 'รหัสผ่านไม่ตรงกัน';
                    }
                    return null;
                  },
                ),
                const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () async {
                await checkUser();
                if (msg == "สามารถใช้ User นี้ได้" && formKey.currentState!.validate()) {
                  saveProfileS(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(msg)),
                  );
                }
              },
              child: const Text(
                "สมัครสมาชิก",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

              
        
  }
