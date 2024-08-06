
import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Model/menu.dart';

class class_S_body extends StatefulWidget {
  const class_S_body({super.key});

  @override
  State<class_S_body> createState() => _class_S_bodyState();
}

class _class_S_bodyState extends State<class_S_body> {

    int counter = 0;

    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 195, 238, 250),
      body: SingleChildScrollView(
        scrollDirection:Axis.vertical,
        child: Column(
          children: [
            SizedBox(height: 10,),
            Column(
              children: [
                SizedBox(height: 30),
                SingleChildScrollView(
                  scrollDirection:Axis.horizontal,
                  child: Row(
                    children: [


                      //menu
                      Container(
                      height: 1000,
                      width: 400,
                      alignment: Alignment.topCenter,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 147, 185, 221),
                        borderRadius: BorderRadius.only(
                          topRight:Radius.circular(20),
                          bottomRight: Radius.circular(20)
                        ),
                      ),
                      child: Menuu_class(),//menu.dart,
                      ),
                      SizedBox(width: 50,),


                      //ประกาศ
                      Container(
                      height: 1000,
                      width: 750,
                      // alignment: Alignment.topCenter,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)
                        ),
                        
                        child: Column(
                          children: [
                            SizedBox(height: 20,),


                            Text("ประกาศ", style: TextStyle(fontSize: 40),),
                            SizedBox(height: 20),
                            Container(
                              height: 60,
                              width: 700,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 147, 185, 221),
                                borderRadius: BorderRadius.circular(20)
                              ),
                            )
                          ]
                        ),
                      ),
                      SizedBox(width: 50,),


                      //งายที่มอบหมาย
                      Container(
                        height: 1000,
                        width: 650,
                        alignment: Alignment.topCenter,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 152, 186, 218),
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 20,),
                            Text("งานที่ได้รับ", style: TextStyle(fontSize: 30),),
                            Container(
                              alignment: Alignment.center,
                              height: 400,
                              width: 600,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)
                              ),
                            ),
                            SizedBox(height: 30),
                            Text("งานที่เลยกำหนดแล้ว", style: TextStyle(fontSize: 30),),
                            Container(
                              alignment: Alignment.center,
                              height: 400,
                              width: 600,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 20)
                    ],
                  ),
                )
              ],
            )
          ],
        ),),
    );
  }
}