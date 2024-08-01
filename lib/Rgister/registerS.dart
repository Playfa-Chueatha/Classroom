import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Login/loginS.dart';
import 'package:flutter_esclass_2/Login/loginT.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(const AddForm_Register_S());

class AddForm_Register_S extends StatelessWidget {
  const AddForm_Register_S({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'ESclass_Register',
      home: AddForm(),
    );
  }
}

class AddForm extends StatefulWidget {
  const AddForm({super.key});

  @override
  State<AddForm> createState() => _FormState();
}

class _FormState extends State<AddForm> {

  final formKey = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();
  TextEditingController surname = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController email = TextEditingController();
  String type = '1';

  Future signUp() async {
    String url = "http://192.168.1.102/classroom/register.php";
    final response = await http.post(Uri.parse(url), body: {
      'name': name.text,
      'surname': surname.text,
      'password': pass.text,
      'email': email.text,
      'type': type,
    });
    var data = json.decode(response.body);
    if (data == "Error") {
      Navigator.pushNamed(context, 'register');
    } else {
      Navigator.pushNamed(context, 'login');
    }
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอก E-mail';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'กรุณากรอก E-mail ที่ถูกต้อง';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Color.fromARGB(255, 147, 235, 241),
        // appBar: AppBar(
        //   title: const Text("สร้างชื่อผู้ใช้งาน"),
        //   backgroundColor: Color.fromARGB(255, 118, 232, 240),
        //   centerTitle: true,
        // ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(700, 150, 700, 100),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Text(
                  "สมัครสมาชิก",
                  style: TextStyle(fontSize: 30),
                ),
                SizedBox(height: 10),
                Image.asset('assets/images/นักเรียน2.png',height: 300),
                TextFormField(
                  maxLength: 20,
                  decoration: const InputDecoration(
                    counterText: "",
                    label: Text(
                      "กรุณาระบุชื่อจริง",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'กรุณากรอกระบุชื่อจริง';
                    }
                    return null;
                  },
                  controller: name,
                ),
                SizedBox(height: 10),
                TextFormField(
                  maxLength: 20,
                  decoration: const InputDecoration(
                    counterText: "",
                    label: Text(
                      "กรุณาระบุนามสกุล",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'กรุณากรอกระบุนามสกุล';
                    }
                    return null;
                  },
                  controller: surname,
                ),
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
                // Row(
                //   children: [
                //     Text(
                //       "คุณเป็นนักเรียนหรือครู",
                //       style: TextStyle(fontSize: 20),
                //     )
                //   ],
                // ),
                // Row(
                //   children: [
                //     Radio(
                //       value: 1,
                //       groupValue: _value,
                //       onChanged: (value) {
                //         setState(() {
                //           _value = value!;
                //           type = value.toString();
                //         });
                //       },
                //     ),
                //     SizedBox(
                //       width: 20.0,
                //     ),
                //     Text("ครู"),
                //   ],
                // ),
                // Row(
                //   children: [
                //     Radio(
                //       value: 2,
                //       groupValue: _value,
                //       onChanged: (value) {
                //         setState(() {
                //           _value = value!;
                //           type = value.toString();
                //         });
                //       },
                //     ),
                //     SizedBox(
                //       width: 20.0,
                //     ),
                //     Text("นักเรียน"),
                //   ],
                // ),
                TextFormField(
                  maxLength: 20,
                  obscureText: true,
                  decoration: const InputDecoration(
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
                  obscureText: true,
                  decoration: const InputDecoration(
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
                SizedBox(
                  height: 50,
                  width: 150,
                  child: FilledButton(
                    onPressed: (){
                    bool pass = formKey.currentState!.validate(); //ปุ่มบันทึกลงฐานข้อมูล
                    if(pass){
                      signUp();

                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Login_S()));
                    }
                    

                    formKey.currentState!.validate();
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 10, 82, 104),
                  ),
                  child: const Text("สมัครสมาชิก", style: TextStyle(fontSize: 20),)
                  ),
                )
              ],
            ),
        ),
      ),
    );
  }
}
