import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void  main()  => runApp(const Repass());

class Repassword extends StatelessWidget {
  const Repassword({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Repassword",
      home: Repass(),
      
    );
  }
}
class Repass extends StatelessWidget {
  const Repass({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Center(child: Text("เปลี่ยนรหัสผ่าน"),),
        content: Text("กรุณาเปลี่ยนรหัสผ่านที่รัดกุม"),
        actions: [
          Column(
          children: [
              SizedBox(
                width: 300,
                child: TextField(
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 16),
                      hintText: 'กรุณากรอกรหัสผ่านของคุณ',
                      isCollapsed: true,
                      isDense: true,
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),        
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                      )
                    ),
              ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 300,
                child: TextField(
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 16),
                      hintText: 'กรุณากรอกรหัสผ่านของคุณอีกครั้ง',
                      isCollapsed: true,
                      isDense: true,
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),        
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                      )
                    ),
                ),
              ),
              SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                    TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        style: TextButton.styleFrom(
                          foregroundColor: Color.fromARGB(255, 63, 124, 238)
                      ),
                        child: const Text('OK'),
                    ),
                    TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        style: TextButton.styleFrom(
                          foregroundColor: Color.fromARGB(255, 238, 108, 115)
                      ),
                        child: const Text('Cancel'),
                    ),  
                ],
              )
              
          ]
          )
          
        ],
    );
  }
}