import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Forgetpass_T extends StatefulWidget {
  const Forgetpass_T({super.key});

  @override
  State<Forgetpass_T> createState() => _Forgetpass_TState();
}

class _Forgetpass_TState extends State<Forgetpass_T> {
  final _controlerEmail = TextEditingController();
  final _controlerUsername = TextEditingController();
  final _controlerOTP = TextEditingController();
  final bool _validateEmail = false;

  
  Future<void> checkUserData(String username, String emailOrPhone) async {
  final url = Uri.parse('https://www.edueliteroom.com/connect/checkusert.php');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'email_or_phone': emailOrPhone,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        // ข้อมูลตรงกัน
        String contactInfo = data['email_or_phone'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('รหัส OTP ได้ถูกส่งไปยัง $contactInfo'),
            backgroundColor: Colors.green,
          ),
        );
        // ดำเนินการส่ง OTP หรือกระบวนการอื่นๆ ต่อ
      } else {
        // ข้อมูลไม่ตรงกัน
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('ไม่มีข้อมูลที่ตรงกันกรุณาตรวจสอบข้อมูลของคุณ'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      // มีปัญหาในการเชื่อมต่อกับ API
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${response.statusCode}, โปรดลองใหม่อีกครั้ง'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('เกิดข้อผิดพลาด: $e, โปรดลองใหม่อีกครั้ง'),
        backgroundColor: Colors.red,
      ),
    );
  }
}



  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color.fromARGB(255, 147, 235, 241),
          ),
          height: screenHeight * 0.8,
          width: screenWidth * 0.8,
          margin: EdgeInsets.all(40),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.1),
              Text(
                "ลืมรหัสผ่าน",
                style: TextStyle(fontSize: screenHeight * 0.05),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 50, 20, 10),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    SizedBox(
                      width: screenWidth * 0.4,
                      child: TextField(
                        controller: _controlerUsername,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          fillColor: Colors.white,
                          focusColor: Colors.white,
                          labelText: 'กรุณาใส่ชื่อผู้ใช้ของคุณ',
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    SizedBox(
                      width: screenWidth * 0.4,
                      child: TextField(
                        controller: _controlerEmail,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              String username = _controlerUsername.text;
                              String emailOrPhone = _controlerEmail.text;

                              checkUserData(username, emailOrPhone);
                            },
                            icon: Icon(Icons.email),
                            tooltip: 'ส่งรหัส OTP ',
                          ),
                          border: OutlineInputBorder(),
                          labelText: 'กรุณากรอกอีเมล์ของคุณ',
                          errorText: _validateEmail ? "กรุณากรอกอีเมล์ของคุณ" : null,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    SizedBox(
                      width: screenWidth * 0.4,
                      child: TextField(
                        controller: _controlerOTP,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          fillColor: Colors.white,
                          focusColor: Colors.white,
                          labelText: 'กรุณาใส่รหัส OTP ที่ส่งถึงคุณ',
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    SizedBox(
                      height: screenHeight * 0.07,
                      child: FilledButton(
                        onPressed: () {
                          
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 10, 82, 104),
                          foregroundColor: Colors.white,
                        ),
                        child: Text(
                          "เปลี่ยนรหัสผ่าน",
                          style: TextStyle(fontSize: screenHeight * 0.025),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
