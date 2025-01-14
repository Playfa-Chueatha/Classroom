import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Forgetpassword/Forgetpass_S.dart';
import 'package:flutter_esclass_2/Home/homeS.dart';
import 'package:flutter_esclass_2/Home/homeT.dart';
import 'package:flutter_esclass_2/Login/loginS.dart';
import 'package:flutter_esclass_2/Login/loginT.dart';

class Login_class extends StatefulWidget {
  const Login_class({super.key});

  @override
  State<Login_class> createState() => _Login_classState();
}

class _Login_classState extends State<Login_class> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 147, 235, 241),
            borderRadius: BorderRadius.circular(20),
          ),
          height: screenHeight * 0.8, // ใช้ 80% ของความสูงหน้าจอ
          width: screenWidth * 0.7,  // ใช้ 90% ของความกว้างหน้าจอ
          margin: EdgeInsets.all(screenWidth * 0.02), 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/Eduelite.png",
                height: screenHeight * 0.3, // ขนาดของรูปภาพเป็น 20% ของความสูงหน้าจอ
                width: screenWidth * 0.4, // ขนาดของรูปภาพเป็น 30% ของความกว้างหน้าจอ
              ),
              Text(
                "Edueliteroom",
                style: TextStyle(fontSize: screenWidth * 0.02), // ขนาดตัวอักษร 8% ของความกว้างหน้าจอ
              ),
              SizedBox(height: screenHeight * 0.01), // ระยะห่างระหว่างข้อความกับปุ่ม
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Container สำหรับ Teacher
                  Container(
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/ครู.png",
                          width: screenWidth * 0.2, // ขนาดรูปภาพเป็น 40% ของความกว้างหน้าจอ
                          height: screenHeight * 0.2, // ขนาดรูปภาพเป็น 25% ของความสูงหน้าจอ
                        ),
                        SizedBox(height: screenHeight * 0.03), // ระยะห่างจากรูปภาพ
                        FilledButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const Login_T()),
                            );
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 45, 124, 155),
                          ),
                          child: Text(
                            "Teacher",
                            style: TextStyle(fontSize: screenWidth * 0.01), // ขนาดตัวอักษร 5% ของความกว้างหน้าจอ
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02), // ระยะห่างระหว่างปุ่ม
                  // Container สำหรับ Student
                  Container(
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/นักเรียน.png",
                          width: screenWidth * 0.2, // ขนาดรูปภาพเป็น 40% ของความกว้างหน้าจอ
                          height: screenHeight * 0.2, // ขนาดรูปภาพเป็น 25% ของความสูงหน้าจอ
                        ),
                        SizedBox(height: screenHeight * 0.03), // ระยะห่างจากรูปภาพ
                        FilledButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const Login_S()),
                            );
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 45, 124, 155),
                          ),
                          child: Text(
                            "Student",
                            style: TextStyle(fontSize: screenWidth * 0.01), // ขนาดตัวอักษร 5% ของความกว้างหน้าจอ
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
