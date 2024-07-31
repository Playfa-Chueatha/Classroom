import 'package:flutter/material.dart';

void  main()  => runApp(const Logint());
class Logint extends StatefulWidget {
  const Logint({super.key});

  @override
  State<Logint> createState() => _LogintState();
}

class _LogintState extends State<Logint> {

  final _formkey = GlobalKey<FormState>();
  // ignore: unused_field
  String _name = '';
  // ignore: unused_field
  String _last = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login_student',
      home: Scaffold(
        body: Center(

          child: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Container(
                alignment: Alignment.center,
                height: 750,
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
                    Image.asset('assets/images/Profile.jpg',height: 200),
                    SizedBox(height: 50),
                    Container(
                      margin: EdgeInsets.fromLTRB(300,20,300,10),
                      child: TextFormField(
                        decoration: const InputDecoration(
                        label: Text("กรุณากรอกชื่อผู้ใช้", style: TextStyle(fontSize: 20),)
                        ),
                        onSaved: (Valuue){
                           _name=Valuue!;
                        },
                        validator: (value){
                        if(value==null || value.isEmpty){
                          return "กรุณากรอกชื่อผู้ใช้ของคุณ";
                        }
                        return null;
                        }
                      ),
                    ),

                  Container(
                      margin: EdgeInsets.fromLTRB(300,10,300,50),
                      child: TextFormField(
                        decoration: const InputDecoration(
                        label: Text("กรุณากรอกรหัสผ่าน", style: TextStyle(fontSize: 20),)
                        ),
                        onSaved: (Valuue){
                           _name=Valuue!;
                        },
                        validator: (value){
                        if(value==null || value.isEmpty){
                          return "กรุณากรอกรหัสผ่านของคุณ";
                        }
                        return null;
                        }
                      ),
                    ),
                  
                  FilledButton(
                    onPressed: (){
                      _formkey.currentState!.validate();
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 10, 82, 104),
                    ),
                    child: const Text("เข้าสู่ระบบ", style: TextStyle(fontSize: 20),)
                  ),
                    
                  ],
                ),
              ),
            ),
            
          ),
        ),
        )
    );
  }
}