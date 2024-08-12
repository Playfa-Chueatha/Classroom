import 'package:flutter/material.dart';

void  main()  => runApp(const ForgetPass());

class ForgetPass extends StatefulWidget {
  const ForgetPass({super.key});

  @override
  State<ForgetPass> createState() => _ForgetState();
}

class _ForgetState extends State<ForgetPass> {

  final _formkey = GlobalKey<FormState>();
  // ignore: unused_field
  String _name = '';
  // ignore: unused_field
  final String _last = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Re_Pass",
      home: Scaffold(
        body: Center(  
           child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              height: 750,
              width: 1500,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 147, 235, 241),borderRadius: BorderRadius.circular(20)
              ),
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    SizedBox(height: 50), 
                    Text("เปลี่ยนรหัสผ่าน", style: TextStyle(fontSize: 40)),
                    SizedBox(height: 70),
                    Container(
                      margin: EdgeInsets.fromLTRB(400,20,400,10),
                      child: TextFormField(
                        
                        decoration: const InputDecoration(
                        label: Text("กรุณากรอกรหัสผ่านเดิม", style: TextStyle(fontSize: 20),)
                        ),
                      onSaved: (Valuue){
                      _name=Valuue!;
                      },
                      validator: (value){
                      if(value==null || value.isEmpty){
                        return "กรุณากรอกรหัสผ่านเดิมของคุณ";
                      }
                      return null;
                      },
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.fromLTRB(400,20,400,10),
                      child: TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                        label: Text("กรุณากรอกรหัสผ่านใหม่", style: TextStyle(fontSize: 20),)
                        ),
                      onSaved: (Valuue){
                      _name=Valuue!;
                      },
                      validator: (value){
                      if(value==null || value.isEmpty){
                        return "กรุณากรอกรหัสผ่านใหม่ของคุณ";
                      }
                      return null;
                      },
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.fromLTRB(400,20,400,50),
                      child: TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                        label: Text("กรุณากรอกรหัสผ่านใหม่", style: TextStyle(fontSize: 20),)
                        ),
                      onSaved: (Valuue){
                      _name=Valuue!;
                      },
                      validator: (value){
                      if(value==null || value.isEmpty){
                        return "กรุณากรอกรหัสผ่านใหม่ของคุณ";
                      }
                      return null;
                      },
                      ),
                    ),

                    FilledButton(
                    onPressed: (){
                      _formkey.currentState!.validate();
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 10, 82, 104),
                    ),
                    child: const Text("สมัตรสมาชิก", style: TextStyle(fontSize: 20),)
                  ),
                  ],
                ),
              ),
            ),
           ),
        )
      ),          
    );
  }
}