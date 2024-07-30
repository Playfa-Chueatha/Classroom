import 'package:flutter/material.dart';

void  main()  => runApp(const ClassS());

const List<Widget> Menu = [
  Text('หน้าหลัก'),
  Text('ห้องเรียน'),
  Text('งานที่ได้รับ'),
  Text('คะแนนของฉัน'),
];

class ClassS extends StatefulWidget {
  const ClassS({super.key});

  @override
  State<ClassS> createState() => _ClassTState();
}

class _ClassTState extends State<ClassS> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: toggleS(),
    );
  }
}

class toggleS extends StatefulWidget {
  const toggleS({super.key});

  @override
  State<toggleS> createState() => _toggleTState();
}

class _toggleTState extends State<toggleS> {

  int counter = 0;

  List <bool> isSelected = [false,true,false,false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 195, 238, 250),
      appBar: AppBar(
        title: Text('ES Class'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 152, 186, 218),
      ),
      body: SingleChildScrollView(
        scrollDirection:Axis.vertical,
        child: Column(
          children: [
            SizedBox(height: 10,),
            ToggleButtons(
              direction: Axis.horizontal,
              onPressed: (int index){
                setState(() {
                  // for (int i = 0; 1 < isSelected.length;
                  // i++){
                  //   isSelected[i] = i == index;
                  // } 
                  for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
                    if (buttonIndex == index) {
                      isSelected[buttonIndex] = true;
                  } else {
                      isSelected[buttonIndex] = false;
                    }
              }
                });
              },
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              selectedBorderColor: Color.fromARGB(255, 152, 186, 218),
              selectedColor: Colors.white,
              fillColor: Color.fromARGB(255, 152, 186, 218),
              color: Colors.black,
              constraints: const BoxConstraints(
                minHeight: 40,
                minWidth: 150
              ),
              isSelected: isSelected,
              children: Menu, 
              ),
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
                            // Container(
                            //   height: 50,
                            //   width: 700,
                            //   child: Row(
                            //     children: [
                            //       SizedBox(width: 650,height: 50),
                            //       IconButton(
                            //         color: Color.fromARGB(255, 0, 0, 0),
                            //         icon: const Icon(Icons.add),
                            //         iconSize: 30,
                            //         onPressed: (){},
                            //         style: IconButton.styleFrom(
                            //           backgroundColor: Color.fromARGB(255, 147, 185, 221),
                            //           highlightColor: Color.fromARGB(255, 56, 105, 151),
                            //         ), 
                            //       )
                            //     ],
                            //   ),
                            // ),


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
                        width: 750,
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
                      SizedBox(width: 1)
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