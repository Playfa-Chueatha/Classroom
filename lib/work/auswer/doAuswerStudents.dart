import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:flutter_esclass_2/Model/appbar_students.dart';

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

  @override
  void initState() {
    super.initState();
    // สร้าง TextEditingController สำหรับคำถามแต่ละข้อ
    for (int i = 0; i < widget.questions.length; i++) {
      _controllers[i] = TextEditingController();
    }
  }

  @override
  void dispose() {
    // ลบ TextEditingController เมื่อ Widget ถูกลบ
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
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 152, 186, 218),
        title: const Text('แบบทดสอบแบบถามตอบ'),
        actions: [
          appbarstudents(context, widget.thfname, widget.thlname, widget.username),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ' ${exam.direction}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                            'คำถามที่ ${index + 1}: ${question.questionDetail}',
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
                  onPressed: (){},
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
