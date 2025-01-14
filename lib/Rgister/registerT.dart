
import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Login/loginT.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;



class Registert_T extends StatefulWidget {
  const Registert_T({super.key});

  @override
  State<Registert_T> createState() => _FormState();
}

class _FormState extends State<Registert_T> {

  final formKey = GlobalKey<FormState>();

  TextEditingController thaifirstname = TextEditingController();
  TextEditingController thailastname = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController prefix = TextEditingController();

  String? selectedPrefix;
  String engfirstname = "-";
  String englastname = "-";
  String phone = "-";
  String subject = "-";
  int room = 0;
  int numroom = 0;
  String msg = '';

    
    //check user ว่ามีอยู่แล้วหรือไม่
  Future<void> checkUser() async {
    String url = "https://edueliteroom.com/connect/check_user_teacher.php";

    final Map<String, dynamic> queryParams = {
      "usert_username": username.text,
      "thaifirstname": thaifirstname.text,
      "thailastname": thailastname.text,
      "email": email.text,
    };

    try {
      http.Response response =
          await http.get(Uri.parse(url).replace(queryParameters: queryParams));

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
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
    }
  }




  // ฟังก์ชัน saveProfileT
Future<void> saveProfileT(context) async {
    Uri uri = Uri.parse('https://www.edueliteroom.com/connect/Register_teacher.php');

    // ข้อมูลที่ต้องการส่งเป็น JSON
    Map<String, dynamic> data = {
      'usert_prefix': prefix.text,
      'usert_thfname': thaifirstname.text,
      'usert_thlname': thailastname.text,
      'usert_enfname': engfirstname,
      'usert_enlname': englastname,
      'usert_username': username.text,
      'usert_password': password.text,
      'usert_email': email.text,
      'usert_classroom': room.toString(),
      'usert_numroom': numroom.toString(),
      'usert_phone': phone,
      'usert_subjects': subject,
    };

    try {
      // ส่งข้อมูลแบบ JSON
      http.Response response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}'); 

      if (response.statusCode == 200) {
        try {
          var responseBody = jsonDecode(response.body);
          if (responseBody['success'] != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('การบันทึกข้อมูลเสร็จสิ้น')),
            );
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Login_T()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('การบันทึกข้อมูลล้มเหลว กรุณาลองใหม่อีกครั้ง')),
            );
          }
        } catch (e) {
          // ถ้าเกิดข้อผิดพลาดในการแปลง JSON แสดงข้อความให้ผู้ใช้
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('เกิดข้อผิดพลาดในการแปลงข้อมูล: $e')),
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
  final screenWidth = MediaQuery.of(context).size.width;

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
              style: TextStyle(fontSize: screenWidth * 0.03), // ปรับขนาดฟอนต์ตามหน้าจอ
            ),
            SizedBox(height: 10),
            Image.asset(
              'assets/images/ครู2.png',
              height: screenWidth * 0.4, // ปรับขนาดภาพตามหน้าจอ
            ),
            SizedBox(height: 50),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
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
              validator: (value) =>
                  value == null ? 'กรุณาเลือกคำนำหน้าชื่อ' : null,
            ),
            SizedBox(height: 10),
            TextFormField(
              maxLength: 20,
              decoration: const InputDecoration(
                counterText: "",
                label: Text(
                  "กรุณาระบุชื่อจริง",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              validator: (val) =>
                  validateThaiCharacters(val, 'กรุณากรอกระบุชื่อจริง'),
              controller: thaifirstname,
            ),
            const SizedBox(height: 10),
            TextFormField(
              maxLength: 20,
              decoration: const InputDecoration(
                counterText: "",
                label: Text(
                  "กรุณาระบุนามสกุล",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              validator: (val) =>
                  validateThaiCharacters(val, 'กรุณากรอกระบุนามสกุล'),
              controller: thailastname,
            ),
            SizedBox(height: 10),
            TextFormField(
              maxLength: 40,
              decoration: const InputDecoration(
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
              maxLength: 20,
              decoration: const InputDecoration(
                counterText: "",
                label: Text(
                  "กรุณาระบุชื่อผู้ใช้ของคุณ",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              validator: (val) =>
                  validateEnglishAndNumbers(val, 'กรุณากรอกชื่อผู้ใช้ของคุณ'),
              controller: username,
            ),
            TextFormField(
              maxLength: 20,
              obscureText: _isObscurd,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  padding: const EdgeInsetsDirectional.all(10.0),
                  icon: _isObscurd
                      ? const Icon(Icons.visibility_off)
                      : const Icon(Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _isObscurd = !_isObscurd;
                    });
                  },
                ),
                counterText: "",
                label: const Text(
                  "กรุณากรอกรหัสผ่าน",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return 'กรุณากรอกรหัสผ่าน';
                }
                return null;
              },
              controller: password,
            ),
            TextFormField(
              maxLength: 20,
              obscureText: _isObscurd2,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  padding: const EdgeInsetsDirectional.all(10.0),
                  icon: _isObscurd2
                      ? const Icon(Icons.visibility_off)
                      : const Icon(Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _isObscurd2 = !_isObscurd2;
                    });
                  },
                ),
                counterText: "",
                label: const Text(
                  "กรุณายืนยันรหัสผ่าน",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              validator: (val) {
                if (val!.isEmpty) {
                  return 'กรุณากรอกยืนยันรหัสผ่าน';
                } else if (val != password.text) {
                  return 'รหัสผ่านไม่ตรงกัน';
                }
                return null;
              },
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                await checkUser();
                if (msg == "สามารถใช้ User นี้ได้" && formKey.currentState!.validate()) {
                  saveProfileT(context);
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