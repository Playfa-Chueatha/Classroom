import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Body_home extends StatefulWidget {
  const Body_home({super.key});

  @override
  State<Body_home> createState() => _Body_homeState();
}

class _Body_homeState extends State<Body_home> {


DateTime today = DateTime.now();

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
                      child: Column(
                        children: [
                          SizedBox(height: 20,),
                        ],
                      ),
                      ),
                      SizedBox(width: 50,),


                      //ปฏิทิน
                      Container(
                      height: 1000,
                      width: 1440,
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
                              width: 1440,
                              child: Row(
                                children: [
                                  SizedBox(width: 1370,height: 50),  
                                  // DropdownSearch(
                                  //   popupProps: PopupProps.menu(
                                  //     showSelectedItems: true,

                                  //   ),
                                  // ),   
                                  IconButton(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    icon: const Icon(Icons.add),
                                    iconSize: 30,
                                    onPressed: (){
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(builder: (context) => const main_home_T()),
                                      // );
                                    },
                                    style: IconButton.styleFrom(
                                      backgroundColor: Color.fromARGB(255, 147, 185, 221),
                                      highlightColor: Color.fromARGB(255, 56, 105, 151),
                                    ),
                                    tooltip: 'เพิ่มกิจกรรม', 
                                  ),


                                  
                                ],
                              ),
                              
                            ),
                          ]
                        ),
                      ),
                      Container(
                          height: 800,
                          width: 1000,
                          child: TableCalendar(
                              focusedDay: today, 
                              firstDay: DateTime.utc(2024, 01, 01), 
                              lastDay: DateTime.utc(2030, 11, 31 )),
                      ),
                      SizedBox(width: 30,),
                    ],
                  ),
                )
              ],
            )
          ]
        )
      ),
    );
  }
}