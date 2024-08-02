
import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Classroom/announce_class.dart';
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
            // ToggleButtons(
            //   direction: Axis.horizontal,
            //   onPressed: (int index){
            //     setState(() {
            //       // for (int i = 0; 1 < isSelected.length;
            //       // i++){
            //       //   isSelected[i] = i == index;
            //       // } 
            //       for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
            //         if (buttonIndex == index) {
            //           isSelected[buttonIndex] = true;
            //       } else {
            //           isSelected[buttonIndex] = false;
            //         }
            //   }
            //     });
            //   },
            //   borderRadius: const BorderRadius.all(Radius.circular(8)),
            //   selectedBorderColor: Color.fromARGB(255, 152, 186, 218),
            //   selectedColor: Colors.white,
            //   fillColor: Color.fromARGB(255, 152, 186, 218),
            //   color: Colors.black,
            //   constraints: const BoxConstraints(
            //     minHeight: 40,
            //     minWidth: 150
            //   ),
            //   isSelected: isSelected,
            //   children: Menu, 
            //   ),
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
                      width: 300,
                      // alignment: Alignment.topCenter,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 147, 185, 221),
                        borderRadius: BorderRadius.only(
                          topRight:Radius.circular(20),
                          bottomRight: Radius.circular(20)
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20,),
                          Container(
                            width: 280,
                            height: 200,                            
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(20)
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: 280,
                            height: 200,                            
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(20)
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: 280,
                            height: 200,                            
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(20)
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: (){}, 
                            icon: Icon(Icons.logout,size: 50))
                        ],
                  ),
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
                        width: 760,
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
                                SizedBox(width: 670,height: 80),
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
                              width: 700,
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
                              width: 700,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10)
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