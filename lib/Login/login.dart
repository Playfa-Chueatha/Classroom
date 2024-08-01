import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_esclass_2/Forgetpassword/Forgetpass.dart';
import 'package:flutter_esclass_2/Login/loginS.dart';
import 'package:flutter_esclass_2/Login/loginT.dart';


void  main()  => runApp(const Login_class());

class Login_class extends StatelessWidget {
   const Login_class({super.key});
  
  @override
  Widget build(BuildContext context) {
    
    return const MaterialApp(
      home: Test_b(),
    );
  }
}


class Test_b extends StatefulWidget {
  const Test_b({super.key});

  @override
  State<Test_b> createState() => _Test_bState();
}

class _Test_bState extends State<Test_b> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: (){}),
      
      appBar: AppBar(
        title: Text("Test"),
      ),
      body: Center(
        child: Container(
            decoration: BoxDecoration(color: Color.fromARGB(255, 147, 235, 241),borderRadius: BorderRadius.circular(20)),
            height: 750,
            width: 1000,
            margin: EdgeInsets.all(40),
            child: Column(
              children: [
                SizedBox(height: 150,),
                Text("Wellcome to ESclass", style: TextStyle(fontSize: 30)),
                SizedBox(height: 200,),
                Container (
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Image.asset("assets/images/ครู.png",width: 200, height: 100,),
                            const SizedBox(height: 10,),
                            FilledButton(
                              onPressed: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const Logint()),
                                );
                              },
                              style: FilledButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 45, 124, 155)), 
                              child: Text("Teacher", style: TextStyle(fontSize: 20),),)
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Image.asset("assets/images/นักเรียน.png",width: 200, height: 100,),
                            const SizedBox(height: 10,),
                            FilledButton(
                              onPressed: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const Logins()),
                                );
                              },
                              style: FilledButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 45, 124, 155)
                              ), 
                              child: Text("Student", style: TextStyle(fontSize: 20),),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // SizedBox(height: 150,),
                // TextButton(
                //   style: TextButton.styleFrom(
                //     foregroundColor: Color.fromARGB(255, 10, 82, 104)
                //   ),
                //   onPressed: () => Navigator.push(
                //     context,
                //     MaterialPageRoute(builder: (context) => Forget())).then((value) {
                //       print('Back from to me');
                //     },),// print Botton
                //   child: Text("ลืมรหัสผ่าน", style: TextStyle(fontSize: 20),),),
              ],
            )   
          )
      ),
    );
  }
}