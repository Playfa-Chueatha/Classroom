import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class Repassword extends StatefulWidget {
  const Repassword({super.key});

  @override
  State<Repassword> createState() => _RepassState();
}

class _RepassState extends State<Repassword> {

  TextEditingController pass = TextEditingController();
  TextEditingController repass = TextEditingController();

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
    return AlertDialog(
      title: const Center(child: Text("เปลี่ยนรหัสผ่าน"),),
        content: const Text("กรุณาเปลี่ยนรหัสผ่านที่รัดกุม"),
        actions: [
          Column(
          children: [
              SizedBox(
                width: 300,
                child: TextField(
                  // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    obscureText: _isObscurd,
                    controller: pass,
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
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10,vertical: 16),
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
              const SizedBox(height: 20),
              SizedBox(
                width: 300,
                child: TextField(
                  // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    obscureText: _isObscurd2,
                    controller: repass,
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
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10,vertical: 16),
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
              const SizedBox(height: 30),

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
