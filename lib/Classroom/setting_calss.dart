import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Classroom/add_classroom.dart';
import 'package:flutter_esclass_2/Data/Data_students.dart';
import 'package:flutter_esclass_2/Data/data_calssroom.dart';
import 'package:flutter_esclass_2/Model/Menu_listclassroom.dart';

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
                      // Menu
                      Container(
                        alignment: Alignment.topLeft,
                        height: 1000,
                        width: 350,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 147, 185, 221),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(300, 10, 0, 0),
                              child: IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) => AddClassroom(),
                                    );
                                  },
                                  icon: Icon(Icons.add),
                                ),
                            ),
                            Container(
                              height: 900,
                              width: 300,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 147, 185, 221),
                              ),
                              child: List_student(),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 50),

                      // รายชื่อนักเรียน
                      Container(
                        height: 1000,
                        width: 1440,
                        margin: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              Container(
                                  height: 440,
                                  width: 1300,
                                  margin: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(padding: EdgeInsets.all(20),child:Text('รายชื่อนักเรียนในห้องเรียน', style: TextStyle(fontSize: 30))),
                            
                                      SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: DataTable(
                                          columns: [
                                            DataColumn(label: SizedBox(width: 60, child: const Text('เลขที่ห้อง'))),
                                            DataColumn(label: SizedBox(width: 100, child: const Text('รหัสนักเรียน'))),
                                            DataColumn(label: SizedBox(width: 150, child: const Text('ชื่อ'))),
                                            DataColumn(label: SizedBox(width: 150, child: const Text('นามสกุล'))),
                                            DataColumn(label: SizedBox(width: 200, child: const Text('อีเมล'))),
                                            DataColumn(label: SizedBox(width: 100, child: const Text('ลบออกจากห้อง'))),
                                          ],
                                          rows: dataliststudents.asMap().entries.map((entry) {
                                            var student = entry.value;
                                            return DataRow(
                                              cells: [
                                                DataCell(Text(student.numroom.toString())),
                                                DataCell(Text(student.IDstudents.toString())),
                                                DataCell(Text(student.firstnamestudents)),
                                                DataCell(Text(student.lastnamestudents)),
                                                DataCell(Text(student.email)),
                                                DataCell(Center(child: 
                                                IconButton(
                                                  icon: Icon(Icons.delete, color: const Color.fromARGB(255, 230, 58, 58)),
                                                  onPressed: () {
                                                    
                                                  },
                                                ),)
                                              ),
                                              ],
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  )
                                  
                                  
                                ),

                                Container(
                                  height: 440,
                                  width: 1300,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(padding: EdgeInsets.all(20),child:Text('รายชื่อนักเรียนในห้องเรียน', style: TextStyle(fontSize: 30))),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: DataTable(
                                          columns: [
                                            DataColumn(label: SizedBox(width: 60, child: const Text('เลขที่ห้อง'))),
                                            DataColumn(label: SizedBox(width: 100, child: const Text('รหัสนักเรียน'))),
                                            DataColumn(label: SizedBox(width: 150, child: const Text('ชื่อ'))),
                                            DataColumn(label: SizedBox(width: 150, child: const Text('นามสกุล'))),
                                            DataColumn(label: SizedBox(width: 200, child: const Text('อีเมล'))),
                                            DataColumn(label: SizedBox(width: 100, child: const Text('เพิ่มเข้าห้องเรียน'))),
                                          ],
                                          rows: dataliststudents.asMap().entries.map((entry) {
                                            var student = entry.value;
                                            return DataRow(
                                              cells: [
                                                DataCell(Text(student.numroom.toString())),
                                                DataCell(Text(student.IDstudents.toString())),
                                                DataCell(Text(student.firstnamestudents)),
                                                DataCell(Text(student.lastnamestudents)),
                                                DataCell(Text(student.email)),
                                                DataCell(Center(child: 
                                                IconButton(
                                                  icon: Icon(Icons.add, color: const Color.fromARGB(255, 0, 0, 0)),
                                                  onPressed: () {
                                                    
                                                  },
                                                ),)
                                              ),
                                              ],
                                            );
                                          }).toList(),
                                        ),

                                      )
                                    ],
                                  ),
                                )

                            ],
                          ),
                        )
                        
                        
                        
                        
                      ),
                      SizedBox(width: 30),
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
}
