import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_esclass_2/Home/calendar_S.dart';
import 'package:flutter_esclass_2/Home/homeT.dart';
import 'package:flutter_esclass_2/Home/todolist_S.dart';
import 'package:flutter_esclass_2/Home/todolist_T.dart';
import 'package:flutter_esclass_2/Login/login.dart';
import 'package:flutter_esclass_2/Model/Chat.dart';
import 'package:flutter_esclass_2/Model/appbar_students.dart';
import 'package:flutter_esclass_2/Model/menu_s.dart';
import 'package:flutter_esclass_2/Model/menu_t.dart';
import 'package:flutter_esclass_2/Profile/ProfileS.dart';
import 'package:flutter_esclass_2/Score/Score_S.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class main_home_S extends StatefulWidget {
  final String thfname;
  final String thlname;
  final String username;
  const main_home_S({super.key, required this.thfname, required this.thlname, required this.username});


  @override
  State<main_home_S> createState() => _homeState();
}

class _homeState extends State<main_home_S> {
  Future<Map<String, String>> fetchTeacherInfo() async {
    final response = await http.get(Uri.parse('https://www.edueliteroom.com/connect/get_user_students.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        'thfname': data['users_thfname'] ?? "ไม่ระบุ",
        'thlname': data['users_thlname'] ?? "ไม่ระบุ",
      };
    } else {
      throw Exception('ล้มเหลวในการโหลดข้อมูล');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 195, 238, 250),
        appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 152, 186, 218),
        title: Text('Edueliteroom'),
        actions: [
          appbarstudents(context, widget.thfname, widget.thlname, widget.username),
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
                      child:Menuu_class_s(thfname: widget.thfname, thlname: widget.thlname, username: widget.username),//menu.dart
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
                                child: CalendarHome_S(username: widget.username),//calendar.dart
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
                                  child: Todocalss_S(username: widget.username),//todolist_body.dart
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