import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Forgetpassword/Forgetpass_T.dart';
import 'package:flutter_esclass_2/Home/homeT.dart';
import 'package:flutter_esclass_2/Rgister/registerT.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Login_T extends StatefulWidget {

  const Login_T({super.key});

  @override
  State<Login_T> createState() => _Login_TState();
}

class _Login_TState extends State<Login_T> {
  final formKey = GlobalKey<FormState>();
  TextEditingController usert_password = TextEditingController();
  TextEditingController usert_username = TextEditingController();
  bool _isObscured = true;
  String? username;
  String thfname = "";
  String thlname = "";

  @override
  void initState() {
    super.initState();
  }

  void loginWithPredefinedCredentials() {
    usert_username.text = "paiyfa11";  
    usert_password.text = "mild39840";  
    signIn();  
  }

  Future<void> signIn() async {
    try {
      var client = http.Client();
      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      String url = "https://www.edueliteroom.com/connect/login_teacher.php";

      final response = await client.post(Uri.parse(url),
          headers: headers,
          body: jsonEncode({
            "usert_username": usert_username.text,
            "usert_password": usert_password.text,
          }));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['error'] != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['error'])),
          );
        } else if (data['success'] == true) {
          setState(() {
            username = data['user']['usert_username'];
            thfname = data['user']['usert_thfname'] ?? "ไม่ระบุ";
            thlname = data['user']['usert_thlname'] ?? "ไม่ระบุ";
          });

          if (username != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => main_home_T(
                      thfname: thfname,
                      thlname: thlname,
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
        child: Container(
          alignment: Alignment.center,
          height: height * 0.9, 
          width: width * 0.6, 
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 147, 235, 241),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: height * 0.05),
                Text(
                  "Login",
                  style: TextStyle(fontSize: height * 0.05), 
                ),
                SizedBox(height: height * 0.03),
                Image.asset(
                  'assets/images/ครู.png',
                  height: height * 0.2, // ความสูงของรูปภาพ 30% ของความสูงหน้าจอ
                ),
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
                    controller: usert_username,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.1, vertical: height * 0.01),
                  child: TextFormField(
                    obscureText: _isObscured,
                    controller: usert_password,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      labelText: "กรุณากรอกรหัสผ่าน",
                      labelStyle: TextStyle(fontSize: height * 0.025),
                      suffixIcon: IconButton(
                        padding: const EdgeInsetsDirectional.all(10.0),
                        icon: _isObscured
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isObscured = !_isObscured;
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
                    bool pass = formKey.currentState!.validate();
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Registert_T()),
                        );
                      },
                      child: Text("สมัครสมาชิก", style: TextStyle(fontSize: height * 0.025)),
                    ),
                    Icon(Icons.linear_scale),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Color.fromARGB(255, 238, 108, 115),
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Forgetpass_T()),
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
