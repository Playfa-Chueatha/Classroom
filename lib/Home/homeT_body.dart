import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Home/Even.dart';
import 'package:flutter_esclass_2/Home/Todolist_alert.dart';
import 'package:flutter_esclass_2/Home/calendar.dart';
import 'package:flutter_esclass_2/Model/menu.dart';
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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


                      //ปฏิทิน
                      Container(
                      height: 1000,
                      width: 1500,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)
                        ),
                          child: Center(
                            child:                          
                          Column(
                            children: [

                            //calender
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: SizedBox(
                                height: 470,
                                width: 1450,
                                child: Calendar_Home(),//calendar.dart
                              ),
                            ),

                                //todolist
                                Container(
                                  // margin: EdgeInsets.all(5),
                                  height: 500,
                                  width: 600,               
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: todocalss(),//todolist_body.dart
                                ),
 
                            ],
                        ))
                      ),
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