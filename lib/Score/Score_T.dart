import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Model/appbar_teacher.dart';
import 'package:flutter_esclass_2/Model/menu_t.dart';
import 'package:flutter_esclass_2/Score/Tab.dart';
import 'package:flutter_esclass_2/Score/checkinclassroom.dart';

class Score_T_body extends StatefulWidget {
  final String? username;
  const Score_T_body ({super.key, required this.username});


  @override
  State<Score_T_body> createState() => _Score_T_bodyState();
}

class _Score_T_bodyState extends State<Score_T_body> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 195, 238, 250),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 152, 186, 218),
        title: Text('Edueliteroom'),
        actions: [
          // appbarteacher(context, widget.username),
        ],
      ),
       body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(height: 10),
            Column(
              children: [
                SizedBox(height: 30),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
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
                      child:Menuu_class(username: '',),//menu.dart
                      ),
                      SizedBox(width: 50,),

                      Container(
                        height: 1000,
                        width: 1440,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)
                        ), 
                        child: TabScore(),  
                                         
                      ),
                      SizedBox(width: 30)
                      
                    ],
                  ),
                )
              ],
            )
          ],
        ),
       ),
    );
  }
}