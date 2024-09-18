import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Classroom/classT.dart';
import 'package:flutter_esclass_2/Home/calendar.dart';
import 'package:flutter_esclass_2/Home/homeS.dart';
import 'package:flutter_esclass_2/Home/todolist_body.dart';
import 'package:flutter_esclass_2/Login/login.dart';
import 'package:flutter_esclass_2/Model/Chat.dart';
import 'package:flutter_esclass_2/Model/menu_t.dart';
import 'package:flutter_esclass_2/Profile/ProfileT.dart';
import 'package:flutter_esclass_2/Model/appbar_teacher.dart';
import 'package:flutter_esclass_2/work/asign_work_T.dart';
import 'package:flutter_esclass_2/work/work_type/Detail_work.dart';
class main_home_T extends StatefulWidget {
  const main_home_T({super.key});

  @override
  State<main_home_T> createState() => _main_home_TState();
}

class _main_home_TState extends State<main_home_T> {

  int counter = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 152, 186, 218),
        title: Text('Edueliteroom'),
        actions: [
          appbarteacher(context)
        ],
      ),

      body: Scaffold(
        backgroundColor:  Color.fromARGB(255, 195, 238, 250),
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
      ) 
    );
  }
}

