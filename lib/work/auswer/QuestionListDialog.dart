import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Data/Data.dart';

class QuestionListDialog extends StatelessWidget {
  final List<AuswerQuestion> questions;

  const QuestionListDialog({super.key, required this.questions});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('ตัวอย่างข้อสอบทั้งหมดจำนวน ${questions.length} ข้อ'),
      content: SizedBox(
        width: double.maxFinite, // Make the dialog wide enough for ListView
        child: questions.isEmpty
            ? Center(child: Text('ไม่มีข้อสอบ'))
            : ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    color: Color.fromARGB(255, 152, 186, 218),
                    elevation: 4,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      title: Row(
                        children: [
                          Text(
                            'ข้อที่ ${index + 1}: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: Text(questions[index].questionDetail),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.settings),
                        onPressed: () {
                          // Handle the settings button action here
                          print('Settings for question ${questions[index].questionDetail}');
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('ปิด'),
        ),
      ],
    );
  }
}
