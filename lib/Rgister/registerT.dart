// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Login/loginT.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;


class Registert_T extends StatelessWidget {
  const Registert_T({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Register',
      home: AddForm_Register_T(),
    );
  }
}

class AddForm_Register_T extends StatefulWidget {
  const AddForm_Register_T({super.key});

  @override
  State<AddForm_Register_T> createState() => _FormState();
}

class _FormState extends State<AddForm_Register_T> {

  final formKey = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();
  TextEditingController surname = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController email = TextEditingController();

  Future<dynamic> signUp() async {
    try {
      var client = http.Client();
      var headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

      String url = "http://edueliteroom.com/connect/registerteacher.php";
      print('POST Register !');
      final response = await client.post(Uri.parse(url),
          headers: headers,
          body: jsonEncode({
            "name": name.text,
            "surname": surname.text,
            "password": pass.text,
            "email": email.text
          }));

      print(jsonDecode(response.body));
      //var data = jsonDecode(response.body);
      // print(response.body);

      /*
    if (data == "Error") {
      Navigator.pushNamed(context, 'register');
    } else {
      Navigator.pushNamed(context, 'login');
    }*/
    } catch (e) {
      print(e);
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

  var _isObscurd;
  var _isObscurd2;
  @override
  void initState(){
    super.initState();

    _isObscurd = true;
    _isObscurd2 = true;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 147, 235, 241),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(500, 150, 500, 100),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Text(
                  "สมัครสมาชิก",
                  style: TextStyle(fontSize: 30),
                ),
                SizedBox(height: 10),
                Image.asset('assets/images/ครู2.png',height: 300),
                TextFormField(
                  controller: name,
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
                  }
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
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'กรุณากรอกระบุนามสกุล';
                    }
                    return null;
                  },
                  controller: surname,
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
                  ),),
                  TextFormField(
                    maxLength: 20,
                    obscureText: _isObscurd,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          padding: const EdgeInsetsDirectional.all(10.0),
                          icon: _isObscurd ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                          onPressed: (){
                            setState(() {
                            _isObscurd =!_isObscurd;
                          });
                          }, 
                      ),
                      counterText: "",
                      label: const Text(
                        "กรุณากรอกรหัสผ่าน",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  TextFormField(
                    maxLength: 20,
                    obscureText: _isObscurd2,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          padding: const EdgeInsetsDirectional.all(10.0),
                          icon: _isObscurd2 ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                          onPressed: (){
                            setState(() {
                            _isObscurd2 =!_isObscurd2;
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
                        onPressed: () async {
                          await signUp();
                          // bool pass = formKey.currentState!.validate(); //ปุ่มบันทึกลงฐานข้อมูล
                          // if(pass){
                          //   signUp();

                          // /*Navigator.push(
                          //     context,
                          //     MaterialPageRoute(builder: (context) => const Login_T()));*/
                          // }

                          // formKey.currentState!.validate();
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 10, 82, 104),
                        ),
                        child: const Text(
                          "สมัครสมาชิก",
                          style: TextStyle(fontSize: 20),
                        )
                    ),
                  )
            
               
            ],
          )
          )
      ),
    );
  }
}