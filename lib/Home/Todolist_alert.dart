import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Data/Data_todolist.dart';

class Alert_addtodo extends StatefulWidget {
  final Function(Todoclass) onAddTodo;
  const Alert_addtodo({super.key, required this.onAddTodo});

  @override
  State<Alert_addtodo> createState() => add_todoState();
}

class add_todoState extends State<Alert_addtodo> {
  final formKey = GlobalKey<FormState>();
  String Title = '';
  String Detail = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text("เพิ่มกิจกรรมของคุณ")),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              maxLength: 25,
              decoration: InputDecoration(
                counterText: "",
                label: Text("หัวข้อ", style: TextStyle(fontSize: 20)),
              ),
              onSaved: (value) {
                Title = value!;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'กรุณากรอกหัวข้อ';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                label: Text("รายละเอียด", style: TextStyle(fontSize: 20)),
              ),
              onSaved: (value) {
                Detail = value ?? ''; 
              },
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      widget.onAddTodo(Todoclass(
                        Title: Title,
                        Detail: Detail,
                      ));
                      formKey.currentState?.reset();
                      Navigator.of(context).pop();
                    }
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Color.fromARGB(255, 63, 124, 238),
                  ),
                  child: const Text('OK'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  style: TextButton.styleFrom(
                    foregroundColor: Color.fromARGB(255, 238, 108, 115),
                  ),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
