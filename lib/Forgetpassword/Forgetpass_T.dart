import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Forgetpassword/Alert.dart';
import 'package:flutter_esclass_2/Login/login.dart';
import 'package:flutter_esclass_2/Login/loginT.dart';
import 'package:flutter_esclass_2/Rgister/registerT.dart';
import "package:http/http.dart" as http;
void  main()  => runApp(const Forgetpass_T());

class Forgetpass_T extends StatelessWidget {
  const Forgetpass_T({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Forget Password',
      home: Forget(),
    );
  }
}

class Forget extends StatefulWidget {
  const Forget({super.key});

  @override
  State<Forget> createState() => _ForgetState();
}

class _ForgetState extends State<Forget> {
  final _controler = TextEditingController();
  bool _validate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Color.fromARGB(255, 147, 235, 241)),
            height: 1000,
            width: 1000,
            margin: EdgeInsets.all(40),
            child: Column(
              children: [
                SizedBox(height: 100,),
                Text("ลืมรหัสผ่าน",style: TextStyle(fontSize: 30),),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 50, 20, 10),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                          SizedBox(
                            width: 500,
                            height: 50, 
                            child: TextField(
                              controller: _controler,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  onPressed: (){
                                    setState(() {
                                  _validate = _controler.text.isEmpty;
                                });
                                  }, 
                                  icon: Icon(Icons.email),
                                  tooltip: 'ส่งรหัส OTP ไปยังอีเมล์ของคุณ'
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                  )
                                ),
                                labelText: 'กรุณากรอกอีเมล์',
                                errorText: _validate ?  "กรุณากรอกอีเมล์ของคุณ" : null,
                              ),
                            ),
                          ),
                          SizedBox(width: 10,),
                          SizedBox(height: 30,),
                          SizedBox(
                            width: 500,
                            child: TextField(
                              obscureText: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                fillColor: Colors.white,
                                focusColor: Colors.white,
                                labelText: 'กรุณาใส่รหัส OTP ที่ส่งไปยังอีเมล์ของคุณ'
                              ),
                            ),
                          ),
                          SizedBox(height: 30,),
                          SizedBox(
                            height: 50,
                            child: FilledButton(
                              onPressed: (){
                                showDialog(
                                  context: context, 
                                  builder: (BuildContext context) => Repassword(),);
                              },

                            style: FilledButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 10, 82, 104),
                              foregroundColor: Colors.white
                            ),
                            child: const Text("เปลี่ยนรหัสผ่าน",style: TextStyle(fontSize: 20),)),
                        ),
                    ],
                  ),
                )
              ],
            ),          
        )
      )          
    );
  }
}