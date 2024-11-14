import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Login/loginS.dart';
import 'package:flutter_esclass_2/Login/loginT.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AddForm_Register_S extends StatefulWidget {
  const AddForm_Register_S({super.key});

  @override
  State<AddForm_Register_S> createState() => _FormState();
}

class _FormState extends State<AddForm_Register_S> {

  final formKey = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();
  TextEditingController surname = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController studentid = TextEditingController();
  TextEditingController numroom = TextEditingController();
  TextEditingController prefix = TextEditingController();
  TextEditingController clasroom_year = TextEditingController();
  TextEditingController clasroom_major = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController number = TextEditingController();


  String type = '1';
  String? selectedPrefix;
  String? selectedclassroom;
  String? selectedmajor;
  String engfirstname = '-';
  String englastname = '-';
  String phone = '-';
  String parentphone = '-';
  String teacher_name = '-';
  String msg = '';


//check user ว่ามีอยู่แล้วหรือไม่
  Future<void> checkUser() async {
  String url = "https://www.edueliteroom.com/connect/check_user_students.php";

  // ข้อมูลที่ส่งไปในคำขอ
  final Map<String, dynamic> body = {
    "users_username": username.text,  // ใช้ค่า .text
  };

  try {
    // เปลี่ยนจาก GET เป็น POST
    http.Response response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'}, // เพิ่ม headers
      body: jsonEncode(body), // ส่งข้อมูลในรูปแบบ JSON
    );

    if (response.statusCode == 200) {
      var checkEmailS = jsonDecode(response.body);
      setState(() {
        if (checkEmailS.isEmpty) {
          msg = "สามารถใช้ User นี้ได้";
        } else {
          msg = "User นี้มีผู้ใช้แล้ว";
        }
      });
    } else {
      print("Error: ${response.statusCode}");
    }
  } catch (error) {
    print("Error: $error");
  }
}



  // ฟังก์ชัน saveProfileS
Future<void> saveProfileS(context) async {
  Uri uri = Uri.parse('https://www.edueliteroom.com/connect/Register_students.php');

  // ข้อมูลที่ต้องการส่งเป็น JSON
  Map<String, dynamic> data = {
    'users_prefix': prefix.text,
    'users_username': username.text, 
    'users_password': pass.text,
    'users_id': studentid.text,
    'users_thfname': name.text,
    'users_thlname': surname.text,
    'users_classroom': clasroom_year.text,
    'users_numroom': numroom.text,
    'users_number': number.text,
    'users_major': clasroom_major.text,
    'users_email': email.text,
    

    'users_enfname': engfirstname,
    'users_enlname': englastname,
    'usert_username' : teacher_name,
    'users_phone': phone,
    'users_parentphone': parentphone,
  };

  try {
    // ส่งข้อมูลแบบ JSON
    http.Response response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data), // ต้องแปลงเฉพาะข้อมูลที่เป็น JSON ได้
    );

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      if (responseBody['success'] != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('การบันทึกข้อมูลเสร็จสิ้น')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login_S()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('การบันทึกข้อมูลล้มเหลว กรุณาลองใหม่อีกครั้ง')),
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


  bool _isObscurd = true;
  bool _isObscurd2 = true ;

    @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
                Image.asset('assets/images/นักเรียน2.png',height: 300),
                SizedBox(height: 50),
                

                //รหัสนักเรียน
                TextFormField(
                  maxLength: 20,
                  decoration: const InputDecoration(
                    counterText: "",
                    label: Text(
                      "กรุณากรอกรหัสนักเรียน",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  validator: (val) => val == null || val.isEmpty ? 'กรุณากรอกรหัสนักเรียน' : null,
                  controller: studentid,
                ),
                SizedBox(height: 10),

                //คำนำหน้าชื่อ
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
                  validator: (value) => value == null ? 'กรุณาเลือกคำนำหน้าชื่อ' : null,
                ),
                SizedBox(height: 10),

                //ชื่อจริง
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


                //นามสกุล
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

               
                //ชั้นปีการศึกษา
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    label: Text(
                      "กรุณาเลือกชั้นปีการศึกษา",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  value: selectedclassroom,
                  items: ["ชั้นมัธยมศึกษาปีที่ 4", "ชั้นมัธยมศึกษาปีที่ 5", "ชั้นมัธยมศึกษาปีที่ 6"].map((clasroom) {
                    return DropdownMenuItem(
                      value: clasroom,
                      child: Text(clasroom),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedclassroom = value;
                      clasroom_year.text = value!;
                    });
                  },
                  validator: (value) => value == null ? 'กรุณาเลือกชั้นปีการศึกษา' : null,
                ),
                SizedBox(height: 10),

                //ห้อง
                TextFormField(
                  maxLength: 2,
                  decoration: const InputDecoration(
                    counterText: "",
                    label: Text(
                      "กรุณาระบุห้องของคุณ",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'กรุณาระบุห้องของคุณ';
                    }
                    return null;
                  },
                  controller: numroom,
                ),
                SizedBox(height: 10),


                //เลขที่
                TextFormField(
                  maxLength: 2,
                  decoration: const InputDecoration(
                    counterText: "",
                    label: Text(
                      "กรุณาระบุเลขที่ของคุณ",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'กรุณาระบุเลขที่ของคุณ';
                    }
                    return null;
                  },
                  controller: number,
                ),
                SizedBox(height: 10),



                //แผนการเรียน
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    label: Text(
                      "กรุณาเลือกแผนการเรียน",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  value: selectedmajor,
                  items: ["วิทยาศาสตร์-คณิตศาสตร์", "ภาษาอังกฤษ-ภาษาจีน", "ภาษาอังกฤษ-ญี่ปุ่น"].map((major) {
                    return DropdownMenuItem(
                      value: major,
                      child: Text(major),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedmajor = value;
                      clasroom_major.text = value!;
                    });
                  },
                  validator: (value) => value == null ? 'กรุณาเลือกแผนการเรียน' : null,
                ),
                SizedBox(height: 10),


                //EMAIL
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



                //ชื่อผู้ใช้
                TextFormField(
                  maxLength: 40,
                  decoration: const InputDecoration(
                    counterText: "",
                    label: Text(
                      "กรุณากรอกชื่อผู้ใช้",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  validator: (val) => validateEnglishAndNumbers(val, 'กรุณากรอกชื่อผู้ใช้ของคุณ'),
                  controller: username,
                ),

                //รหัสผ่าน
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
                    if (val!.isEmpty) {
                      return 'กรุณากรอกรหัสผ่าน';
                    }
                    return null;
                  },
                  controller: pass,
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
                ElevatedButton(
                onPressed: () {
                  checkUser();
                  if (formKey.currentState!.validate()) {
                    saveProfileS(context);

                    print('Selected Prefix: ${prefix.text}');
                    print('Thai First Name: ${name.text}');
                    print('Thai Last Name: ${surname.text}');
                    print('Email: ${email.text}');
                    print('Username: ${username.text}');
                    print('Password: ${pass.text}');
                    
                  }
                },
                child: const Text("สมัครสมาชิก",style: TextStyle(fontSize: 20),),
              )
              ],
            ),
        ),
      ),
    );
  }
}
