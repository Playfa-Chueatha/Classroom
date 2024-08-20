import 'package:flutter/material.dart';

class repass extends StatefulWidget {
  const repass({super.key});

  @override
  State<repass> createState() => _repassState();
}

class _repassState extends State<repass> {

  
final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text('เปลี่ยนรหัสผ่าน'),),
      actions: [
        Form(
          key: formKey,
          child: Column(
            children: [
              Padding(padding: EdgeInsets.all(10),
              child: TextFormField(
                    decoration: InputDecoration(
                    label: Text("กรอกรหัสผ่านเดิม",style: TextStyle(fontSize: 16),),
                    contentPadding: EdgeInsets.symmetric(horizontal: 5),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(10),
              child: TextFormField(
                    decoration: InputDecoration(
                    label: Text("กรอกรหัสผ่านใหม่",style: TextStyle(fontSize: 16),),
                    contentPadding: EdgeInsets.symmetric(horizontal: 5),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(10),
              child: TextFormField(
                    decoration: InputDecoration(
                    label: Text("ยืนยันรหัสผ่านใหม่",style: TextStyle(fontSize: 16),),
                    contentPadding: EdgeInsets.symmetric(horizontal: 5),
                  ),
                ),
              ),
              SizedBox(height: 20), 
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: (){}, 
                    child: Text('เปลี่ยนรหัสผ่าน',style: TextStyle(color: const Color.fromARGB(255, 53, 200, 226)),)),
                  TextButton(
                    onPressed: (){}, 
                    child: Text('ยกเลิก',style: TextStyle(color: const Color.fromARGB(255, 235, 126, 119)),))
                ],
              )       
            ],
          ),
          
          
          ),
          
      ],
    );
  }
}