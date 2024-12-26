import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QuestionListDialog extends StatefulWidget {
  final Examset exam;

  const QuestionListDialog({
    super.key,
    required this.exam,
  });

  @override
  _QuestionListDialogState createState() => _QuestionListDialogState();
}

class _QuestionListDialogState extends State<QuestionListDialog> {
  late Future<List<AuswerQuestion>> futureQuestions;

  @override
  void initState() {
    super.initState();
    // โหลดข้อมูลทันทีเมื่อหน้าเริ่มต้น
    futureQuestions = fetchQuestions(widget.exam.autoId);
  }

  Future<List<AuswerQuestion>> fetchQuestions(int examsetsId) async {
    final url = Uri.parse('https://www.edueliteroom.com/connect/fetch_auswerforEdit.php');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'examsets_id': examsetsId}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        return (data['data'] as List)
            .map((item) => AuswerQuestion.fromJson(item))
            .toList();
      } else {
        throw Exception('Failed to fetch questions: ${data['error']}');
      }
    } else {
      throw Exception('Failed to connect to API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AuswerQuestion>>(
      future: futureQuestions,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // แสดง Loading เมื่อกำลังดึงข้อมูล
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // แสดงข้อความเมื่อเกิดข้อผิดพลาด
          return AlertDialog(
            title: Text('เกิดข้อผิดพลาด'),
            content: Text(snapshot.error.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('ปิด'),
              ),
            ],
          );
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          // แสดงข้อมูลเมื่อโหลดสำเร็จ
          final questions = snapshot.data!;
          return AlertDialog(
            title: Text('ตัวอย่างข้อสอบทั้งหมดจำนวน ${questions.length} ข้อ'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
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
                          Text('${widget.exam.autoId}'),
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
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('ปิด'),
              ),
            ],
          );
        } else {
          // แสดงข้อความเมื่อไม่มีข้อมูล
          return AlertDialog(
            title: Text('ไม่มีข้อสอบ'),
            content: Text('ไม่พบข้อสอบในชุดนี้'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('ปิด'),
              ),
            ],
          );
        }
      },
    );
  }
}
