import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(const AddForm());

class AddForm extends StatefulWidget {
  const AddForm({super.key});

  @override
  State<AddForm> createState() => _FormState();
}

class _FormState extends State<AddForm> {
  int _value = 1;

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
    return MaterialApp(
      title: "ESclass",
      home: Scaffold(
        // appBar: AppBar(
        //   title: const Text("สร้างชื่อผู้ใช้งาน"),
        //   backgroundColor: Color.fromARGB(255, 118, 232, 240),
        //   centerTitle: true,
        // ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(700, 150, 700, 100),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Text(
                  "สมัครสมาชิก",
                  style: TextStyle(fontSize: 30),
                ),
                TextFormField(
                  maxLength: 20,
                  decoration: const InputDecoration(
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
                TextFormField(
                  maxLength: 20,
                  decoration: const InputDecoration(
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
                    label: Text(
                      "กรุณากรอก E-mail",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  validator: validateEmail,
                  controller: email,
                ),
                Row(
                  children: [
                    Text(
                      "คุณเป็นนักเรียนหรือครู",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      value: 1,
                      groupValue: _value,
                      onChanged: (value) {
                        setState(() {
                          _value = value!;
                          type = value.toString();
                        });
                      },
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Text("ครู"),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      value: 2,
                      groupValue: _value,
                      onChanged: (value) {
                        setState(() {
                          _value = value!;
                          type = value.toString();
                        });
                      },
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Text("นักเรียน"),
                  ],
                ),
                TextFormField(
                  maxLength: 20,
                  decoration: const InputDecoration(
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
                  decoration: const InputDecoration(
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
                  height: 20,
                ),
                FilledButton(
                  onPressed: (){
<<<<<<< HEAD
                    bool pass = formKey.currentState!.validate(); //ปุ่มบันทึกลงฐานข้อมูล
                    if(pass){
                      signUp();
                    }
                    Navigator.pushNamed(context, 'login');
=======
                    formKey.currentState!.validate();
>>>>>>> 64e45affaa4f2cd31007af78c8732b03945ca855
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.green
                  ),
                  child: const Text("สมัครสมาชิก", style: TextStyle(fontSize: 20),)
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
