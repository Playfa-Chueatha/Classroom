import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Classroom/classT.dart';
import 'package:flutter_esclass_2/Home/calendar_T.dart';
import 'package:flutter_esclass_2/Home/todolist_T.dart';
import 'package:flutter_esclass_2/Model/appbar_teacher.dart';
import 'package:flutter_esclass_2/Model/menu_t.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class main_home_T extends StatefulWidget {
  final String thfname;
  final String thlname;
  final String username;  // เพิ่มตัวแปร username

  const main_home_T({super.key, required this.thfname, required this.thlname, required this.username});

  @override
  State<main_home_T> createState() => _main_home_TState();
}

class _main_home_TState extends State<main_home_T> {
  Future<Map<String, String>> fetchTeacherInfo() async {
    final response = await http.get(Uri.parse('https://www.edueliteroom.com/connect/get_user_teacher.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        'thfname': data['usert_thfname'] ?? "ไม่ระบุ",
        'thlname': data['usert_thlname'] ?? "ไม่ระบุ",
      };
    } else {
      throw Exception('ล้มเหลวในการโหลดข้อมูล');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 152, 186, 218),
        title: Text('Edueliteroom'),
        actions: [
          appbarteacher(context, widget.thfname, widget.thlname, widget.username),
        ],
      ),
      body: FutureBuilder<Map<String, String>>(
        future: fetchTeacherInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text("เกิดข้อผิดพลาดในการเชื่อมต่อ: ${snapshot.error}"),
            );
          } else {
            if (widget.thfname.isEmpty || widget.thlname.isEmpty) {
              return Center(
                child: Text("ชื่อหรือชื่อสกุลไม่ถูกต้อง"),
              );
            }
            return Scaffold(
              backgroundColor: Color.fromARGB(255, 195, 238, 250),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 1000,
                                width: 400,
                                alignment: Alignment.topCenter,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 195, 238, 250),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                ),
                                child: Menuu_class(username:widget.username),
                              ),
                              Container(
                                height: 1000,
                                width: 1500,
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(10),
                                        child: SizedBox(
                                          height: 470,
                                          width: 1450,
                                          child: CalendarHome_T(username: widget.username), // ส่ง username ไปที่ CalendarHome
                                        ),
                                      ),
                                      Container(
                                        height: 500,
                                        width: 1400,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Todocalss_T(username: widget.username),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
