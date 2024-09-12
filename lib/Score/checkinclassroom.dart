import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Data/Data_students.dart';
import 'package:flutter_esclass_2/Score/setting_checkinclassroom.dart';

class Checkinclassroom extends StatefulWidget {
  const Checkinclassroom({super.key});

  @override
  State<Checkinclassroom> createState() => _ScorestudentsState();
}

class _ScorestudentsState extends State<Checkinclassroom> {
  // สร้าง List เพื่อเก็บสถานะของ Checkbox แต่ละคอลัมน์
  List<List<bool>> _checkboxValues = List.generate(
    dataliststudents.length,
    (_) => List.generate(5, (_) => false), // 5 คือจำนวนคอลัมน์ Checkbox: มาเรียน, มาสาย, ลากิจ, ลาป่วย, ขาดเรียน
    
  );

  
   // สร้าง List เพื่อเก็บจำนวนรอบที่กด Checkbox
  final List<List<int>> _checkinCounts = List.generate(
  dataliststudents.length,
  (_) => List.generate(5, (_) => 0), // 5 คือจำนวนคอลัมน์ Checkbox
  );

  


  void _saveCheckin() {
  for (int i = 0; i < _checkboxValues.length; i++) {
    for (int j = 0; j < _checkboxValues[i].length; j++) {
      if (_checkboxValues[i][j]) {
        _checkinCounts[i][j]++;
      }
    }
  }
  setting_checkinclassroom(context, _checkinCounts);
  // เคลียร์ค่า Checkbox
  setState(() {
    _checkboxValues = List.generate(
      dataliststudents.length,
      (_) => List.generate(5, (_) => false),
    );
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text('รายชื่อนักเรียน'),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              setting_checkinclassroom(context, _checkinCounts);
            },
            icon: const Icon(Icons.edit_document),
            tooltip: 'ประวัติการเช็คชื่อ',
          ),
          OutlinedButton(
            onPressed: _saveCheckin, 
            child: const Text('บันทึกการเช็คชื่อ')
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              DataTable(
                columnSpacing: 20.0,
                columns: [
                  DataColumn(
                    label: SizedBox(
                      width: 60,
                      child: const Text('เลขที่ห้อง'),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: 150,
                      child: const Text('รหัสนักเรียน'),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: 150,
                      child: const Text('ชื่อ'),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: 150,
                      child: const Text('นามสกุล'),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: 200,
                      child: const Text('อีเมล'),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: 80,
                      child: const Text('มาเรียน'),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: 80,
                      child: const Text('มาสาย'),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: 80,
                      child: const Text('ลากิจ'),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: 80,
                      child: const Text('ลาป่วย'),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: 80,
                      child: const Text('ขาดเรียน'),
                    ),
                  ),
                ],
                rows: dataliststudents.asMap().entries.map((entry) {
                  int index = entry.key;
                  var student = entry.value;
                  return DataRow(
                    cells: [
                      DataCell(Text(student.numroom.toString())),
                      DataCell(Text(student.IDstudents.toString())),
                      DataCell(Text(student.firstnamestudents)),
                      DataCell(Text(student.lastnamestudents)),
                      DataCell(Text(student.email)),
                      DataCell(
                        Checkbox(
                          value: _checkboxValues[index][0],
                          activeColor: Colors.green,
                          onChanged: (bool? value) {
                            setState(() {
                              for (int i = 0; i < _checkboxValues[index].length; i++) {
                                _checkboxValues[index][i] = false; // ยกเลิกการเลือกทั้งหมด
                              }
                              _checkboxValues[index][0] = value ?? false; // เลือกเฉพาะช่องที่ต้องการ
                            });
                          },
                        ),
                      ),
                      DataCell(
                        Checkbox(
                          value: _checkboxValues[index][1],
                          activeColor: const Color.fromARGB(255, 211, 191, 14),
                          onChanged: (bool? value) {
                            setState(() {
                              for (int i = 0; i < _checkboxValues[index].length; i++) {
                                _checkboxValues[index][i] = false;
                              }
                              _checkboxValues[index][1] = value ?? false;
                            });
                          },
                        ),
                      ),
                      DataCell(
                        Checkbox(
                          value: _checkboxValues[index][2],
                          activeColor: Colors.purple,
                          onChanged: (bool? value) {
                            setState(() {
                              for (int i = 0; i < _checkboxValues[index].length; i++) {
                                _checkboxValues[index][i] = false;
                              }
                              _checkboxValues[index][2] = value ?? false;
                            });
                          },
                        ),
                      ),
                      DataCell(
                        Checkbox(
                          value: _checkboxValues[index][3],
                          activeColor: Colors.blue,
                          onChanged: (bool? value) {
                            setState(() {
                              for (int i = 0; i < _checkboxValues[index].length; i++) {
                                _checkboxValues[index][i] = false;
                              }
                              _checkboxValues[index][3] = value ?? false;
                            });
                          },
                        ),
                      ),
                      DataCell(
                        Checkbox(
                          value: _checkboxValues[index][4],
                          activeColor: Colors.red,
                          onChanged: (bool? value) {
                            setState(() {
                              for (int i = 0; i < _checkboxValues[index].length; i++) {
                                _checkboxValues[index][i] = false;
                              }
                              _checkboxValues[index][4] = value ?? false;
                            });
                          },
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
