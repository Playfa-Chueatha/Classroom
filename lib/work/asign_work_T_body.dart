import 'package:flutter/material.dart';

class work_body_T extends StatefulWidget {
  const work_body_T({super.key});

  @override
  State<work_body_T> createState() => _work_body_TState();
}

class _work_body_TState extends State<work_body_T> {

  int counter = 0;

  // List <bool> isSelected = [false,false,true,false];

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
                      width: 400,
                      alignment: Alignment.topCenter,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 147, 185, 221),
                        borderRadius: BorderRadius.only(
                          topRight:Radius.circular(20),
                          bottomRight: Radius.circular(20)
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 20,),
                        ],
                      ),
                      ),
                      SizedBox(width: 50,),


                      //งานที่มอบหมาย
                      Container(
                      height: 1000,
                      width: 600,
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
                                  SizedBox(width: 300,height: 50),  
                                  // DropdownSearch(
                                  //   popupProps: PopupProps.menu(
                                  //     showSelectedItems: true,

                                  //   ),
                                  // ),   
                                  IconButton(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    icon: const Icon(Icons.add),
                                    iconSize: 30,
                                    onPressed: (){},
                                    style: IconButton.styleFrom(
                                      backgroundColor: Color.fromARGB(255, 147, 185, 221),
                                      highlightColor: Color.fromARGB(255, 56, 105, 151),
                                    ),
                                    tooltip: 'มอบหมายงาน', 
                                  ),
                                ],
                              ),
                            ),
                            
                            Text("งานที่มอบหมาย", style: TextStyle(fontSize: 20),),
                            SizedBox(height: 20),
                            Container(
                              height: 100,
                              width: 500,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 147, 185, 221),
                                borderRadius: BorderRadius.circular(20)
                              ),
                            ),
                            SizedBox(height: 50,),
                            Text("งานที่เลยกำหนดแล้ว", style: TextStyle(fontSize: 20),),
                          ]
                        ),
                      ),
                      SizedBox(width: 50,),



                      //งายที่มอบหมาย รายละเอียด
                      Container(
                        height: 1000,
                        width: 800,
                        alignment: Alignment.topCenter,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 152, 186, 218),
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 50,),
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
                          ],
                        ),
                      ),
                      SizedBox(width: 2)
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      )
    );
  }
}