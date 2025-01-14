import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:flutter_esclass_2/Login/loginT.dart';
import 'package:http/http.dart' as http;

class Forgetpass_T extends StatefulWidget {
  const Forgetpass_T({super.key});

  @override
  State<Forgetpass_T> createState() => _Forgetpass_TState();
}

class _Forgetpass_TState extends State<Forgetpass_T> {
  final _controlerEmail = TextEditingController();
  final _controlerUsername = TextEditingController();
  final _controlerPhone = TextEditingController();
  final _controlerPassword = TextEditingController();
  UserTeacher? userTeacher;

  bool _isEmailFieldVisible = false;
  bool _isUsernameFieldVisible = true;
  bool _isPhoneFieldVisible = false;
  bool _isPasswordFieldVisible = false;
  bool _isPasswordVisible = false;

  Future<void> checkUserData(String username) async {
    final url = Uri.parse('https://www.edueliteroom.com/connect/forgetpass.php');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': username}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'success') {
          userTeacher = UserTeacher.fromJson(data['data']);  // เก็บข้อมูล UserTeacher

          setState(() {
            _isEmailFieldVisible = true;
            _isUsernameFieldVisible = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('ข้อมูลผู้ใช้ ${userTeacher?.username} ถูกต้อง กรุณากรอกอีเมล'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('ไม่พบข้อมูลที่ตรงกัน'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
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

  Future<void> sendDataToApi(String username, String password) async {
  final url = Uri.parse('https://www.edueliteroom.com/connect/update_password.php');

  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      print(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ข้อมูลถูกส่งสำเร็จ'),backgroundColor: Colors.green,),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login_T()),  // เปลี่ยน Login_T เป็นหน้าที่ต้องการ
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการส่งข้อมูล'),backgroundColor: Colors.red,),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์'),backgroundColor: Colors.red,),
    );
  }
}


  Future<void> checkEmail(String email) async {
    String userEmail = _controlerEmail.text.trim();

    // สมมุติว่า userTeacher เป็นตัวแปรที่เก็บข้อมูล UserTeacher ที่ได้จากการดึงข้อมูล
    if (userTeacher?.email == userEmail) {
      // ถ้าตรงกับอีเมลใน UserTeacher
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('อีเมลถูกต้อง'),
          backgroundColor: Colors.green,
        ),
      );

      setState(() {
        _isEmailFieldVisible = false;  // ปิดช่องกรอกอีเมล
        _isPhoneFieldVisible = true;  // แสดงช่องกรอกเบอร์โทร
      });
    } else {
      // ถ้าอีเมลไม่ตรง
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('อีเมลไม่ตรงกับข้อมูลที่มีในระบบ'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> checkPhone(String phone) async {
    String userPhone = _controlerPhone.text.trim();

    // ตรวจสอบว่า phone ที่กรอกตรงกับข้อมูลใน UserTeacher หรือไม่
    if (userTeacher?.phone == userPhone) {
      // ถ้าตรงกับข้อมูลใน UserTeacher
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('เบอร์โทรศัพท์ถูกต้อง'),
          backgroundColor: Colors.green,
        ),
      );

      setState(() {
        _isPhoneFieldVisible = false; 
        _isPasswordFieldVisible = true;  
      });
    } else {
      // ถ้าเบอร์โทรศัพท์ไม่ตรง
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('เบอร์โทรศัพท์ไม่ตรงกับข้อมูลที่มีในระบบ'),
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
                    if (_isUsernameFieldVisible)
                      SizedBox(
                        width: screenWidth * 0.6,
                        child: TextField(
                          controller: _controlerUsername,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'กรุณาใส่ชื่อผู้ใช้ของคุณ',
                          ),
                        ),
                      ),
                    if (_isEmailFieldVisible)
                      SizedBox(
                        width: screenWidth * 0.6,
                        child: TextField(
                          controller: _controlerEmail,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'กรุณากรอกอีเมลของคุณ',
                          ),
                        ),
                      ),
                    if (_isPhoneFieldVisible)
                      SizedBox(
                        width: screenWidth * 0.6,
                        child: TextField(
                          controller: _controlerPhone,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'กรุณากรอกเบอร์โทรของคุณ',
                          ),
                        ),
                      ),
                    if (_isPasswordFieldVisible)
                      SizedBox(
                      width: screenWidth * 0.6,
                      child: TextField(
                        controller: _controlerPassword,
                        obscureText: !_isPasswordVisible, // เมื่อ _isPasswordVisible เป็น true จะทำให้ไม่ซ่อนรหัสผ่าน
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'กรอกรหัสผ่านใหม่',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible ? Icons.visibility_off : Icons.visibility, // ใช้ icon ของดวงตา
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible; // เปลี่ยนสถานะการแสดงรหัสผ่าน
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    FilledButton(
                      onPressed: () {
                        if (_isUsernameFieldVisible) {
                          String username = _controlerUsername.text.trim();
                          if (username.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('กรุณากรอกชื่อผู้ใช้')),
                            );
                            return;
                          }
                          checkUserData(username);
                        } else if (_isEmailFieldVisible) {
                          String email = _controlerEmail.text.trim();
                          if (email.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('กรุณากรอกอีเมล')),
                            );
                            return;
                          }
                          checkEmail(email);
                        } else if (_isPhoneFieldVisible) {
                          String phone = _controlerPhone.text.trim();
                          if (phone.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('กรุณากรอกเบอร์โทร')),
                            );
                            return;
                          }
                          checkPhone(phone);  // ตรวจสอบเบอร์โทร
                        } else if (_isPasswordFieldVisible) {
                          String password = _controlerPassword.text.trim();
                          if (password.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('กรุณากรอกรหัสผ่านใหม่')),
                            );
                            return;
                          }
                          String username = _controlerUsername.text.trim();
                          _controlerPassword.text.trim(); // รับค่ารหัสผ่านจาก controller

                          if (username.isEmpty || password.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบถ้วน')),
                            );
                            return;
                          }

                          // ส่งข้อมูลไปยัง API
                          sendDataToApi(username, password);
                        }
                      },
                      child: Text(_isUsernameFieldVisible
                          ? "ตรวจสอบชื่อผู้ใช้"
                          : _isEmailFieldVisible
                              ? "ยืนยันอีเมล"
                              : _isPhoneFieldVisible
                                  ? "ยืนยันเบอร์โทร"
                                  : "เสร็จสิ้น"),
                    ),
                  ],
                ),
              )

              
            ],
          ),
        ),
      ),
    );
  }
}
