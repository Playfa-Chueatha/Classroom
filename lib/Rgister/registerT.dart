
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

  Future<void> signUp() async {
  try {
    var client = http.Client();
    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    String url = "http://localhost/edueliteroom01/registerteacher.php";
    final response = await client.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode({
        "thaifirstname_teacher": thaifirstname.text,
        "thailastname_teacher": thailastname.text,
        "username_teacher": username.text,
        "password_teacher": password.text,
        "email_teacher": email.text
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      
      if (data is Map && data.containsKey('error')) {
        // Handle the error case
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(data['error']),
        ));
      } else if (data.containsKey('success')) {
        // Success, navigate to login
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(data['success']),
        ));
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Login_T()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Unexpected response from server.'),
        ));
      }
    } else {
      // Handle non-200 status code
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Server error: ${response.statusCode}'),
      ));
    }
  } catch (e) {
    // Handle other errors
    print("Error: $e");
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('An error occurred: $e'),
    ));
  }
}



  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอก E-mail';
    }
    final emailRegex = RegExp(r'^[^@]+@gmail\.com$');
    if (!emailRegex.hasMatch(value)) {
      return 'กรุณากรอก E-mail ที่ถูกต้อง';
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
                  maxLength: 20,
                  decoration: const InputDecoration(
                    counterText: "",
                    label: Text(
                      "กรุณาระบุชื่อจริง",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  validator: (val) => validateThaiCharacters(val, 'กรุณากรอกระบุชื่อจริง'),
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
                  validator: (val) => validateThaiCharacters(val, 'กรุณากรอกระบุนามสกุล'),
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
                      "กรุณาระบุ User ของคุณ",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  validator: (val) => validateEnglishAndNumbers(val, 'กรุณากรอก User ของคุณ'),
                  controller: username,
                  ),
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
                      } else if (val != password.text) {
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
                          //await signUp();
                           bool pass = formKey.currentState!.validate(); //ปุ่มบันทึกลงฐานข้อมูล
                           if(pass){
                             await signUp(); 
                           }
                           formKey.currentState!.validate();
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