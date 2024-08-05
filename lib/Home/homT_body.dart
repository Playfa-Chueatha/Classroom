import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Home/Even.dart';
import 'package:flutter_esclass_2/Home/Todolist_alert.dart';
import 'package:flutter_esclass_2/Home/calendar.dart';
import 'package:flutter_esclass_2/Home/menu.dart';
import 'package:flutter_esclass_2/Home/todolist_body.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class Body_home extends StatefulWidget {
  const Body_home({super.key});

  @override
  State<Body_home> createState() => _Body_homeState();
}

class _Body_homeState extends State<Body_home> {


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
                      child:Menuu_class(),//menu.dart
                      ),
                      SizedBox(width: 50,),


                      //ปฏิทิน
                      Container(
                      height: 1000,
                      width: 1440,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)
                        ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 20,),
                              Container(
                              height: 50,
                              width: 1440,
                              child: Row(
                                children: [
                                  SizedBox(width: 1370,height: 50),    
                                  IconButton(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    icon: const Icon(Icons.add),
                                    iconSize: 30,
                                    onPressed: (){
                                      showDialog(
                                        context: context, 
                                        builder: (BuildContext context) => Alert_addtodo(),// todolist_alert.dart
                                      );
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

                            //calender
                            Container(
                                height: 400,
                                width: 1300,
                                child: Calendar_Home(),//calendar.dart
                            ),
                            SizedBox(width: 30,),


                            //Even
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                //todolist
                                Container(
                                  margin: EdgeInsets.all(40),
                                  height: 400,
                                  width: 600,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: Todolist_class(),//todolist_body.dart
                                ),

                                //Even
                                Container(
                                  margin: EdgeInsets.all(40),
                                  height: 400,
                                  width: 600,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20)
                                  ), 
                                  child: Even_class(),//Even.dart                              
                                )
                              ]
                            ),
                            ],
                        )
                      ),
                      SizedBox(width: 30)
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