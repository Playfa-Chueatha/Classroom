import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Data/Data_students.dart';
import 'package:flutter_esclass_2/Score/setting_checkinclassroom.dart';

class Scorestudenst extends StatefulWidget {
  const Scorestudenst({super.key});

  @override
  State<Scorestudenst> createState() => _ScorestudentsState();
}

class _ScorestudentsState extends State<Scorestudenst> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text('รายชื่อนักเรียน'),
        backgroundColor: Colors.white,
        actions: [
          OutlinedButton(
            onPressed: (){},
            child: const Text('แก้ไขคะแนน')
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
                ],
                rows: dataliststudents.asMap().entries.map((entry) {
                  var student = entry.value;
                  return DataRow(
                    cells: [
                      DataCell(Text(student.numroom.toString())),
                      DataCell(Text(student.IDstudents.toString())),
                      DataCell(Text(student.firstnamestudents)),
                      DataCell(Text(student.lastnamestudents)),
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
