import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_esclass_2/Home/calendar.dart';
import 'package:flutter_esclass_2/Home/homeT.dart';
import 'package:flutter_esclass_2/Home/todolist_body.dart';
import 'package:flutter_esclass_2/Login/login.dart';
import 'package:flutter_esclass_2/Model/Chat.dart';
import 'package:flutter_esclass_2/Model/appbar_students.dart';
import 'package:flutter_esclass_2/Model/menu_t.dart';
import 'package:flutter_esclass_2/Profile/ProfileS.dart';
import 'package:flutter_esclass_2/Score/Score_S.dart';


class main_home_S extends StatefulWidget {
  const main_home_S({super.key});

  @override
  State<main_home_S> createState() => _homeState();
}

class _homeState extends State<main_home_S> {

  // List <bool> isSelected = [true,false,false,false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 195, 238, 250),
        appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 152, 186, 218),
        title: Text('Edueliteroom'),
        actions: [
          appbarstudents(context)
        ],
        ),
      

      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
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
                        color: Color.fromARGB(255, 195, 238, 250),
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
                                  width: 1400,               
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