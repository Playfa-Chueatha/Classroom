import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Forgetpassword/Forgetpass.dart';

void  main()  => runApp(const Login());

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "ESclass",
      home: Scaffold(
        body:Center(
          child: Container(
            decoration: BoxDecoration(color: Color.fromARGB(255, 147, 235, 241),borderRadius: BorderRadius.circular(20)),
            height: 1000,
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
                              onPressed: (){},
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
                              onPressed: (){},
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
                SizedBox(height: 250,),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Color.fromARGB(255, 10, 82, 104)
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Forget())).then((value) {
                      print('Back from to me');
                    },),// print Botton
                  child: Text("ลืมรหัสผ่าน", style: TextStyle(fontSize: 20),),),
              ],
            )   
          )
        )  
      )
    );
  }
}