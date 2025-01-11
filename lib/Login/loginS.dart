import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Forgetpassword/Forgetpass_S.dart';
import 'package:flutter_esclass_2/Home/homeS.dart';
import 'package:flutter_esclass_2/Rgister/registerS.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Login_S extends StatefulWidget {
  const Login_S({super.key});

  @override
  State<Login_S> createState() => _LogintState();
}

class _LogintState extends State<Login_S> {
  final formkey = GlobalKey<FormState>();

  TextEditingController users_password = TextEditingController();
  TextEditingController users_username = TextEditingController();
  var _isObscurd;
  String? username;
  String thfnames = "";
  String thlnames = "";

  @override
  void initState() {
    super.initState();
    _isObscurd = true;
  }

  void loginWithPredefinedCredentials() {
    users_username.text = "Pasika";  
    users_password.text = "test_students02";  
    signIn();  
  }

  Future signIn() async {
    try {
      var client = http.Client();
      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      String url = "https://www.edueliteroom.com/connect/login_students.php";

      final response = await client.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode({
          "users_username": users_username.text,
          "users_password": users_password.text,
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['error'] != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['error'])),
          );
        } else if (data['success'] == true) {
          setState(() {
            username = data['user']['users_username'];
            thfnames = data['user']['users_thfname'] ?? "ไม่ระบุ";
            thlnames = data['user']['users_thlname'] ?? "ไม่ระบุ";
          });

          // print('Username: $username');
          // print('Thairfirstname: $thfnames');
          // print('Thailastname: $thlnames');

          // Check if username is not null
          if (username != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => main_home_S(
                      thfname: thfnames,
                      thlname: thlnames,
                      username: username!)),
            );
          } else {
            print("Username is null");
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("เกิดข้อผิดพลาดในการเข้าสู่ระบบ")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("เกิดข้อผิดพลาดจากเซิร์ฟเวอร์: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("เกิดข้อผิดพลาดในการเชื่อมต่อกับเซิร์ฟเวอร์: $e")),
      );
      print("Error: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double width = size.width;
    final double height = size.height;

    return Scaffold(
      body: Center(
        child: Form(
            key: formkey,
            child: Container(
              alignment: Alignment.center,
          height: height * 0.9, 
          width: width * 0.6, 
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 147, 235, 241),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  SizedBox(height: height * 0.05),
                  Text("Login", style: TextStyle(fontSize: height * 0.05)),
                  SizedBox(height: height * 0.03),
                  Image.asset('assets/images/นักเรียน.png', height: height * 0.2,),
                  SizedBox(height: height * 0.05),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                    child: TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person_outline_outlined),
                        labelText: "กรุณากรอกชื่อผู้ใช้",
                        labelStyle: TextStyle(fontSize: height * 0.025),
                      ),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'กรุณากรอกชื่อผู้ใช้';
                        }
                        return null;
                      },
                      controller: users_username,
                    ),            
                  ),
                   Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.1, vertical: height * 0.01),
                  child: TextFormField(
                    obscureText: _isObscurd,
                    controller: users_password,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      labelText: "กรุณากรอกรหัสผ่าน",
                      labelStyle: TextStyle(fontSize: height * 0.025),
                      suffixIcon: IconButton(
                        padding: const EdgeInsetsDirectional.all(10.0),
                        icon: _isObscurd
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isObscurd = !_isObscurd;
                          });
                        },
                      ),
                    ),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'กรุณากรอกรหัสผ่าน';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: height * 0.05),
                  FilledButton(
                  onPressed: () async {
                    bool pass = formkey.currentState!.validate();
                    if (pass) {
                      await signIn();
                    }
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 10, 82, 104),
                    padding: EdgeInsets.symmetric(
                      vertical: height * 0.02,
                      horizontal: width * 0.1,
                    ),
                  ),
                  child: Text("เข้าสู่ระบบ", style: TextStyle(fontSize: height * 0.03)),
                ),
                  SizedBox(height: height * 0.08),
                  FilledButton(
                    onPressed: loginWithPredefinedCredentials,
                    style: FilledButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 82, 104, 10),
                    ),
                    child: Text("Login"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Color.fromARGB(255, 67, 132, 230),
                        ),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddForm_Register_S()),
                        ),
                        child: Text("สมัครสมาชิก", style: TextStyle(fontSize: height * 0.025)),
                      ),
                      Icon(Icons.linear_scale),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Color.fromARGB(255, 238, 108, 115),
                        ),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Forgetpass_S()),
                        ),
                        child: Text("ลืมรหัสผ่าน", style: TextStyle(fontSize: height * 0.025)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }
}
