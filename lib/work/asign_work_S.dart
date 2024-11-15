import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Model/appbar_students.dart';
import 'package:flutter_esclass_2/Model/menu_t.dart';
import 'package:flutter_esclass_2/Model/menu_s.dart';

class work_body_S extends StatefulWidget {
  final String thfname;
  final String thlname;
  final String username;
  const work_body_S({super.key, required this.thfname, required this.thlname, required this.username});

  @override
  State<work_body_S> createState() => _work_body_SState();
}

class _work_body_SState extends State<work_body_S> {                
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 195, 238, 250),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 152, 186, 218),
        title: Text('Edueliteroom'),
        actions: [
          // appbarstudents(context)
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
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      //menu
                      Container(
                      height: 1000,
                      width: 400,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 147, 185, 221),
                        borderRadius: BorderRadius.only(
                          topRight:Radius.circular(20),
                          bottomRight: Radius.circular(20)
                        ),
                      ),
                      child:Menuu_class_s(thfname: widget.thfname, thlname: widget.thlname, username: widget.username),//menu.dart,
                      ),
                      SizedBox(width: 50,),
                    



                      //งานที่ได้รับ
                      Container(
                      height: 1000,
                      width: 600,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)
                        ),
                        
                        child: Column(
                          children: [
                            SizedBox(height: 70,),       
                            Text("งานที่ได้รับ", style: TextStyle(fontSize: 20),),
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
                            SizedBox(height: 20),
                            Container(
                              height: 100,
                              width: 500,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 147, 185, 221),
                                borderRadius: BorderRadius.circular(20)
                              ),
                            ),
                          ]
                        ),
                      ),
                      SizedBox(width: 50,),

                      //รายละเอียดงาน
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
                            SizedBox(height: 70),                            
                            Text("รายละเอียดงาน", style: TextStyle(fontSize: 30),),
                            Container(
                              alignment: Alignment.center,
                              height: 400,
                              width: 700,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)
                              ),
                            ),
              
                          ]
                        )
                      ),
                      SizedBox(width: 20)
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