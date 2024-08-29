import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Forgetpassword/Forgetpass_S.dart';
import 'package:flutter_esclass_2/Home/homeS.dart';
import 'package:flutter_esclass_2/Home/homeT.dart';
import 'package:flutter_esclass_2/Login/loginS.dart';
import 'package:flutter_esclass_2/Login/loginT.dart';

class Login_class extends StatefulWidget {
  const Login_class({super.key});

  @override
  State<Login_class> createState() => _Login_classState();
}

class _Login_classState extends State<Login_class> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: (){}),
      
      body: Center(       
        child:  SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            alignment: Alignment.center,            
            decoration: BoxDecoration(color: Color.fromARGB(255, 147, 235, 241),borderRadius: BorderRadius.circular(20)),
            height: 750,
            width: 1000,
            margin: EdgeInsets.all(40),
            child: Column(
              children: [
                SizedBox(height: 50),
                Image.asset("assets/images/Eduelite.png",height: 150,width: 150),
                Text("Wellcome to Eduelite", style: TextStyle(fontSize: 30)),
                SizedBox(height: 100),
                Container (
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Image.asset("assets/images/ครู.png",width: 200, height: 200,),
                            const SizedBox(height: 30,),
                            FilledButton(
                              onPressed: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const Login_T(),),
                                );
                              },
                              style: FilledButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 45, 124, 155)), 
                              child: Text("Teacher", style: TextStyle(fontSize: 20),),)
                          ],
                        ),
                      ),

                      SizedBox(width: 200),
                      Container(
                        child: Column(
                          children: [
                            Image.asset("assets/images/นักเรียน.png",width: 200, height: 200,),
                            const SizedBox(height: 30,),
                            FilledButton(
                              onPressed: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const Login_S()),
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





                //เอาไว้ทดสอบขี้เกียจlogin
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: (){
                        /*Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const main_home_T()),);*/
                      }, 
                      icon: Icon(Icons.person_outline)),
                      SizedBox(width: 300),
                      IconButton(
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const main_home_S()),);
                      }, 
                      icon: Icon(Icons.person_outline))
                  ],
                )
              ],
            )   
          )
          
        )
        
      ),
    );
  }
}