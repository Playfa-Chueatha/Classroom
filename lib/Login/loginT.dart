import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Forgetpassword/Forgetpass_T.dart';
import 'package:flutter_esclass_2/Home/homeT.dart';
import 'package:flutter_esclass_2/Rgister/registerT.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

void  main()  => runApp(const Logint());

class Login_T extends StatelessWidget {
  const Login_T({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login_teacher',
      home: Logint(),
    );
  }
}

class Logint extends StatefulWidget {
  const Logint({super.key});

  @override
  State<Logint> createState() => _LogintState();
}

class _LogintState extends State<Logint> {

  final formKey = GlobalKey<FormState>();

  TextEditingController pass = TextEditingController();
  TextEditingController email = TextEditingController();

  Future signIn() async {
    String url = "http://192.168.1.102/classroom/login.php";
    final response = await http.post(Uri.parse(url), body: {
      'password': pass.text,
      'email': email.text,
    });
    var data = json.decode(response.body);
    if (data == "Error") {
      Navigator.pushNamed(context, 'login');
    } else {
      Navigator.pushNamed(context, 'classT');
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
    return Scaffold(
        body: Center(

          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Container(
                alignment: Alignment.center,
                height: 800,
                width: 1000,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 147, 235, 241),
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Column(
                  children: [
                    SizedBox(height: 50),
                    Text("Login",style: TextStyle(fontSize: 40)),
                    SizedBox(height: 30),
                    Image.asset('assets/images/ครู.png',height: 200),
                    SizedBox(height: 50),
                    Container(
                      margin: EdgeInsets.fromLTRB(300,20,300,10),
                      child: TextFormField(
                
                        decoration: const InputDecoration(
                          prefix: Icon(Icons.person_outline_outlined),
                          label: Text("กรุณากรอกชื่อผู้ใช้", style: TextStyle(fontSize: 20),)
                        ),
                        validator: validateEmail,
                        controller: email,
                      ),
                    ),

                  Container(
                      margin: EdgeInsets.fromLTRB(300,10,300,50),
                      child: TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                          prefix: Icon(Icons.lock),
                          label: Text("กรุณากรอกรหัสผ่าน", style: TextStyle(fontSize: 20),)
                        ),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'กรุณากรอกรหัสผ่าน';
                          }
                          return null;
                        },
                        controller: pass,
                      ),
                    ),
                  FilledButton(
                    onPressed: (){
                    bool pass = formKey.currentState!.validate(); //ปุ่ม login
                    if(pass){
                      signIn();

                      Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const main_home_T()),
                                );
                      
                    }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 10, 82, 104),
                    ),
                    child: const Text("เข้าสู่ระบบ", style: TextStyle(fontSize: 20),)
                  ),
                  SizedBox(height: 90),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Color.fromARGB(255, 67, 132, 230)
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddForm_Register_T())).then((value) {
                        },),// print Botton
                        child: Text("สมัครสมาชิก", style: TextStyle(fontSize: 20),),),
                      Icon(Icons.linear_scale),
                      TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Color.fromARGB(255, 238, 108, 115)
                      ),
                      onPressed: () => 
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Forgetpass_T())).then((value) {},),// print Botton
                        child: Text("ลืมรหัสผ่าน", style: TextStyle(fontSize: 20),),),
                    ],
                  )
                  ],
                ),
              ),
            ),
            
        ),
        )
    );
  }
}