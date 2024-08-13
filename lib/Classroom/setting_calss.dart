
import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Classroom/add_classroom.dart';
import 'package:flutter_esclass_2/Data/data_calssroom.dart';
import 'package:flutter_esclass_2/Model/model_Listparticipantroom.dart';
import 'package:flutter_esclass_2/Model/model_Listsudent.dart';


class SettingCalss extends StatefulWidget {
  const SettingCalss({super.key});

  @override
  State<SettingCalss> createState() => _SettingCalssState();
}

class _SettingCalssState extends State<SettingCalss> {

                                               
  
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
                      alignment: Alignment.topLeft,             
                      height: 1000,
                      width: 400,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 147, 185, 221),
                        borderRadius: BorderRadius.only(
                          topRight:Radius.circular(20),
                          bottomRight: Radius.circular(20)
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(width: 350),
                              IconButton(
                                onPressed: (){
                                  showDialog(
                                    context: context, 
                                    builder: (BuildContext context) => AddClassroom(),);
                                  
                                }, 
                                icon: Icon(Icons.settings))
                            ],
                          ),
                          Container(
                            height: 900,
                            width: 380,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 147, 185, 221),
                            ),
                            child: DataCalssroom(),
                          ),
                          
                        ],
                      ),
                      ),
                      SizedBox(width: 50,),


                      //รายชื่อนักเรียน
                      Container(
                      height: 1000,
                      width: 1440,
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)
                        ),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 50, 0, 10),
                              height: 440,
                              width: 1300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color.fromARGB(255, 147, 185, 221),
                              ),
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                                    child: Text('รายชื่อนักเรียน',style: TextStyle(fontSize: 30))), 
                                  ModelRoom()
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 10, 0, 50),
                              height: 440,
                              width: 1300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color.fromARGB(255, 147, 185, 221),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                                    child: Text('รายชื่อคำขอเข้าห้องเรียน',style: TextStyle(fontSize: 30))),
                                  Listparticipantroom()
                                ],
                              ),
                            )
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

