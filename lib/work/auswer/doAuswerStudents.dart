import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:flutter_esclass_2/Model/appbar_students.dart';
import 'package:flutter_esclass_2/work/asign_work_S.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Doauswerstudents extends StatefulWidget {
  final List<AuswerQuestion> questions;
  final Examset exam;
  final String thfname;
  final String thlname;
  final String username;

  const Doauswerstudents({
    super.key,
    required this.thfname,
    required this.thlname,
    required this.username,
    required this.questions, 
    required this.exam,
  });

  @override
  State<Doauswerstudents> createState() => _DoauswerstudentsState();
}

class _DoauswerstudentsState extends State<Doauswerstudents> {
  final Map<int, TextEditingController> _controllers = {}; 



  void _submitAnswers() async {
  const url = "https://www.edueliteroom.com/connect/submit_auswer.php";
  final answers = <Map<String, dynamic>>[];

  // ตรวจสอบว่า widget.questions ไม่ว่าง
  if (widget.questions.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('ไม่มีคำถามที่จะส่ง')),
    );
    return;
  }

  // เตรียมข้อมูลคำตอบ
  for (int i = 0; i < widget.questions.length; i++) {
    answers.add({
      'question_id': widget.questions[i].questionAuto,
      'submit_auswer_reply': _controllers[i]?.text ?? '',
    });
  }

  final data = {
    'examsets_id': widget.exam.autoId,
    'users_username': widget.username,
    'answers': answers,
  };

  print("Data being sent: $data");

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    ).timeout(const Duration(seconds: 30)); 
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ส่งคำตอบสำเร็จ')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('เกิดข้อผิดพลาดในการส่งคำตอบ')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ไม่สามารถเชื่อมต่อเซิร์ฟเวอร์ได้')),
      );
    }
  } catch (e) {
    // จัดการข้อผิดพลาดเมื่อเกิดปัญหาการเชื่อมต่อ
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
    );
  }
}



  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.questions.length; i++) {
      _controllers[i] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final exam = widget.exam;

    return Scaffold(
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                children: [
                   Text(
                      ' ${exam.direction}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),

                    Text(' คะแนนเต็ม ${exam.fullMark} คะแนน', style: const TextStyle(fontSize: 18),),

                ],
              ),
             
              Text(
                ' ข้อสอบทั้งหมดจำนวน ${widget.questions.length} ข้อ',
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                ' ${exam.type}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.questions.length,
                itemBuilder: (context, index) {
                  final question = widget.questions[index];
                  return Card(
                    color: const Color.fromARGB(255, 179, 207, 233),
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'คำถามที่ ${index + 1}: ${question.questionDetail} ( ${question.questionMark} คะแนน )',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                              controller: _controllers[index],
                              decoration: const InputDecoration(
                                hintText: ' ',
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: (){
                    _submitAnswers();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => work_body_S( classroomMajor: '', classroomName: '',thfname: widget.thfname,thlname: widget.thlname, classroomNumRoom: '', classroomYear: '',username: widget.username,), // เปลี่ยนให้เป็นหน้า WorkBody_S ที่คุณต้องการไป
                      ),
                    );

                  },
                  child: const Text('ส่งคำตอบ'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
