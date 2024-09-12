import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Data/Data_students.dart';

class SettingCheckinClassroomDialog extends StatefulWidget {
  final List<List<int>> checkinCounts;

  const SettingCheckinClassroomDialog({super.key, required this.checkinCounts});

  @override
  _SettingCheckinClassroomDialogState createState() => _SettingCheckinClassroomDialogState();
}

class _SettingCheckinClassroomDialogState extends State<SettingCheckinClassroomDialog> {
  bool _showScoreColumn = false;

  void _toggleScoreColumn() {
    setState(() {
      _showScoreColumn = !_showScoreColumn;
    });
  }

  void _showScoreNotification() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('คำเตือน'),
          content: const Text('กรอกข้อมูลในช่องคะแนนจิตพิสัยจะถูกบันทึกในหน้าคะแนน หน้านักเรียน คุณต้องการดำเนินการต่อหรือไม่?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ปิดการแจ้งเตือน
                _toggleScoreColumn(); // เปิดคอลัมน์คะแนน
              },
              child: const Text('ตกลง'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ปิดการแจ้งเตือน
              },
              child: const Text('ยกเลิก'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('ประวัติการเช็คชื่อเข้าห้องเรียน'),
      content: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 20.0,
          columns: [
            DataColumn(label: SizedBox(width: 60, child: const Text('เลขที่ห้อง'))),
            DataColumn(label: SizedBox(width: 100, child: const Text('รหัสนักเรียน'))),
            DataColumn(label: SizedBox(width: 150, child: const Text('ชื่อ'))),
            DataColumn(label: SizedBox(width: 150, child: const Text('นามสกุล'))),
            DataColumn(label: SizedBox(width: 200, child: const Text('อีเมล'))),
            DataColumn(label: SizedBox(width: 80, child: const Text('มาเรียน'))),
            DataColumn(label: SizedBox(width: 80, child: const Text('มาสาย'))),
            DataColumn(label: SizedBox(width: 80, child: const Text('ลากิจ'))),
            DataColumn(label: SizedBox(width: 80, child: const Text('ลาป่วย'))),
            DataColumn(label: SizedBox(width: 80, child: const Text('ขาดเรียน'))),
            if (_showScoreColumn)
              DataColumn(label: SizedBox(width: 80, child: const Text('คะแนน'))),
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
                DataCell(Text(widget.checkinCounts[index][0].toString())),
                DataCell(Text(widget.checkinCounts[index][1].toString())),
                DataCell(Text(widget.checkinCounts[index][2].toString())),
                DataCell(Text(widget.checkinCounts[index][3].toString())),
                DataCell(Text(widget.checkinCounts[index][4].toString())),
                if (_showScoreColumn)
                  DataCell(TextFormField()), // แสดงเฉพาะเมื่อ _showScoreColumn เป็น true
              ],
            );
          }).toList(),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: _showScoreColumn ? _toggleScoreColumn : _showScoreNotification,
          child: Text(_showScoreColumn ? 'ซ่อนคะแนนจิตพิสัย' : 'กรอกคะแนนจิตพิสัย'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('ปิด'),
        ),
      ],
    );
  }
}

// ใช้ฟังก์ชันนี้ในการเปิด dialog
void setting_checkinclassroom(BuildContext context, List<List<int>> checkinCounts) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SettingCheckinClassroomDialog(checkinCounts: checkinCounts);
    },
  );
}
