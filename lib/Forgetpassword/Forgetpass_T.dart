import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Login/login.dart';
import 'package:flutter_esclass_2/Login/loginT.dart';

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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 410,
                            height: 50, 
                            child: TextField(
                              controller: _controler,
                              obscureText: true,
                              decoration: InputDecoration(
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
                          SizedBox(
                            width: 80,
                            height: 50,
                            child: FilledButton(
                              onPressed: (){
                                setState(() {
                                  _validate = _controler.text.isEmpty;

                                });
                              },
                              style: FilledButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 10, 82, 104),
                                foregroundColor: Colors.white,
                                
                                
                             ), 
                            child: const Text("OTP",style: TextStyle(fontSize: 16),)),
                          )  
                        ],
                      ),
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
                            Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const Login_T()));
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
      ),          
    );
  }
}