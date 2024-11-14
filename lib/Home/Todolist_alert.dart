import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Data/Data_todolist.dart';

class Alert_addtodo extends StatelessWidget {
  final Function(TodoClass) onAddTodo;

  const Alert_addtodo({super.key, required this.onAddTodo});

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController detailController = TextEditingController();

    return AlertDialog(
      title: Text('เพิ่ม To-Do'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(labelText: 'ชื่อ To-Do'),
          ),
          TextField(
            controller: detailController,
            decoration: InputDecoration(labelText: 'รายละเอียด (ถ้าไม่มี ให้เป็น -)'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            String title = titleController.text.trim();
            String detail = detailController.text.trim().isEmpty ? '-' : detailController.text.trim(); // ใช้ '-' หากไม่มีรายละเอียด

            if (title.isNotEmpty) {
              onAddTodo(TodoClass(
                title: title,
                detail: detail,
                status: 'Not Started',
                autoId: 0, // หรือค่าเริ่มต้นที่คุณต้องการ
              ));
              Navigator.of(context).pop();
            } else {
              // แสดงข้อความเตือนถ้าชื่อเป็นค่าว่าง
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('กรุณากรอกชื่อ To-Do')),
              );
            }
          },
          child: Text('เพิ่ม'),
        ),
      ],
    );
  }
}

