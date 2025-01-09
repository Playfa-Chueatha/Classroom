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

  bool isUpdating = false;  // ตัวแปรสำหรับเช็คสถานะการอัปเดต

  @override
  void initState() {
    super.initState();
    // โหลดข้อมูลทันทีเมื่อหน้าเริ่มต้น
    futureQuestions = fetchQuestions(widget.exam.autoId);
  }

  Future<List<AuswerQuestion>> fetchQuestions(int examsetsId) async {
    try {
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
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  Future<void> updateQuestion(int questionAuto, String questionDetail, int examsetsId) async {
    setState(() {
      isUpdating = true;  // ตั้งสถานะเป็นกำลังอัปเดต
    });

    try {
      final url = Uri.parse('https://www.edueliteroom.com/connect/update_question_auswer.php');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'question_auto': questionAuto,
          'question_detail': questionDetail,
          'examsets_id': examsetsId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          print('Question updated successfully');
        } else {
          _showErrorDialog('เกิดข้อผิดพลาด: ${data['error']}');
        }
      } else {
        _showErrorDialog('ไม่สามารถเชื่อมต่อกับ API');
      }
    } catch (e) {
      _showErrorDialog('เกิดข้อผิดพลาดในการอัปเดตคำถาม');
    } finally {
      setState(() {
        isUpdating = false;  // รีเซ็ตสถานะ
      });
    }
  }

  void _editQuestion(AuswerQuestion question) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController controller = TextEditingController(text: question.questionDetail);

        return AlertDialog(
          title: Text('แก้ไขคำถาม'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'กรุณาแก้ไขคำถาม'),
            maxLines: null,
          ),
          actions: [
            TextButton(
              onPressed: isUpdating
                  ? null  // ถ้ากำลังอัปเดต จะไม่สามารถกดได้
                  : () async {
                      if (controller.text.trim().isEmpty) {
                        _showErrorDialog('คำถามไม่สามารถว่างได้');
                        return;
                      }

                      await updateQuestion(
                        question.questionAuto,
                        controller.text,
                        question.examsetsId,
                      );

                      // ถ้าอัปเดตสำเร็จ ก็อัปเดตข้อมูลในรายการ
                      setState(() {
                        question.questionDetail = controller.text;
                      });
                      Navigator.of(context).pop(); // ปิด Dialog
                    },
              child: Text('บันทึก'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ปิด Dialog โดยไม่ทำการแก้ไข
              },
              child: Text('ยกเลิก'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('เกิดข้อผิดพลาด'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ปิด Dialog
              },
              child: Text('ปิด'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AuswerQuestion>>(
      future: futureQuestions,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
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
          final questions = snapshot.data!;
          return AlertDialog(
            title: Text('ตัวอย่างข้อสอบ: ${widget.exam.direction} ทั้งหมดจำนวน ${questions.length} ข้อ คะแนนเต็ม ${widget.exam.fullMark} คะแนน'),
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
                      contentPadding: EdgeInsets.all(10),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          
                          Row(
                            children: [
                              Text(
                                'ข้อที่ ${index + 1}: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(questions[index].questionDetail),
                            ],                                            
                          ),
                          Text('คะแนน: ${questions[index].questionMark.toString()}', style: TextStyle(color: const Color.fromARGB(255, 11, 70, 119)),)
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.settings),
                        onPressed: () {
                          _editQuestion(questions[index]);
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
