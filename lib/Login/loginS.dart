import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Forgetpassword/Forgetpass_S.dart';
import 'package:flutter_esclass_2/Home/homeS.dart';
import 'package:flutter_esclass_2/Rgister/registerS.dart';


class Login_S extends StatefulWidget {
  const Login_S({super.key});

  @override
  State<Login_S> createState() => _LogintState();
}

class _LogintState extends State<Login_S> {

  final _formkey = GlobalKey<FormState>();
  // ignore: unused_field
  String _name = '';
  // ignore: unused_field
  final String _last = '';

  var _isObscurd;

  @override
  void initState(){
    super.initState();

    _isObscurd = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formkey,
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
                    Image.asset('assets/images/นักเรียน.png',height: 200),
                    SizedBox(height: 50),
                    Container(
                      margin: EdgeInsets.fromLTRB(300,20,300,10),
                      child: TextFormField(
                        decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person_outline_outlined),
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
                        obscureText: _isObscurd,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            padding: const EdgeInsetsDirectional.all(10.0),
                            icon: _isObscurd ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                            onPressed: (){
                              setState(() {
                                _isObscurd =!_isObscurd;
                              });
                            }, 
                             ),
                        label: const Text("กรุณากรอกรหัสผ่าน", style: TextStyle(fontSize: 20),)),
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const main_home_S()),
                      );
                      
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
                        MaterialPageRoute(builder: (context) => AddForm_Register_S())).then((value) {
                        },),// print Botton
                        child: Text("สมัครสมาชิก", style: TextStyle(fontSize: 20),),),
                      Icon(Icons.linear_scale),
                      TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Color.fromARGB(255, 238, 108, 115)
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Forgetpass_S())).then((value) {},),// print Botton
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