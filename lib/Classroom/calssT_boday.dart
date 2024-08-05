
import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Classroom/announce_class.dart';
import 'package:flutter_esclass_2/Home/menu.dart';
import 'package:flutter_esclass_2/work/add_work.dart';

class Class_T_body extends StatefulWidget {
  const Class_T_body({super.key});

  @override
  State<Class_T_body> createState() => _Class_T_bodyState();
}

class _Class_T_bodyState extends State<Class_T_body> {

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
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 147, 185, 221),
                        borderRadius: BorderRadius.only(
                          topRight:Radius.circular(20),
                          bottomRight: Radius.circular(20)
                        ),
                      ),
                    child:Menuu_class(),//menu.dart,
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
                            Container(
                              height: 50,
                              width: 700,
                              child: Row(
                                children: [
                                  SizedBox(width: 650,height: 50),
                                  IconButton(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    icon: const Icon(Icons.add),
                                    iconSize: 30,
                                    onPressed: (){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const AnnounceClass()),);
                                    },
                                    style: IconButton.styleFrom(
                                      backgroundColor: Color.fromARGB(255, 147, 185, 221),
                                      highlightColor: Color.fromARGB(255, 56, 105, 151),
                                    ),
                                    tooltip: 'เพิ่มประกาศ', 
                                  )
                                ],
                              ),
                            ),


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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(width: 560,height: 80),
                                IconButton(
                                  onPressed: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const add_wprk_T()),);
                                }, 
                                  
                                  tooltip: 'มอบหมายงาน',
                                  icon: Icon(Icons.add_circle_outline_sharp,size: 50))
                              ],
                            ),                            
                            Text("งานที่มอบหมาย", style: TextStyle(fontSize: 30),),
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