import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:flutter_esclass_2/work/onechoice/successOnechoice.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Doonechoicestudents extends StatefulWidget {
  final Examset exam;
  final String username;
  final String thfname;
  final String thlname;
  
  const Doonechoicestudents({
    super.key, 
    required this.exam,
    required this.username, 
    required this.thfname, 
    required this.thlname, 
  });

  @override
  State<Doonechoicestudents> createState() => _DoonechoicestudentsState();
}

class _DoonechoicestudentsState extends State<Doonechoicestudents> {
  late Future<List<OneChoice>> _oneChoiceData;
  Map<int, String> selectedAnswers = {};  // เปลี่ยนให้เก็บด้วย onechoiceAuto เป็น key

  @override
  void initState() {
    super.initState();
    _oneChoiceData = fetchOneChoiceData(widget.exam.autoId.toString());
  }

  Future<List<OneChoice>> fetchOneChoiceData(String examId) async {
    final response = await http.post(
      Uri.parse('https://www.edueliteroom.com/connect/fetch_onechoiceforEdit.php'),
      body: {'examsets_id': examId},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => OneChoice.fromJson(json)).toList();
    } else {
      throw Exception('ไม่สามารถโหลดข้อมูลได้');
    }
  }

  String convertToLetter(String answer) {
    switch (answer) {
      case 'ก':
        return 'a';
      case 'ข':
        return 'b';
      case 'ค':
        return 'c';
      case 'ง':
        return 'd';
      default:
        return '';
    }
  }

  void submitAnswers() async {
    final String examsetsId = widget.exam.autoId.toString();
    List<Map<String, dynamic>> answersToSubmit = [];

    final data = await _oneChoiceData;

    // ตรวจสอบว่าเลือกคำตอบครบทุกข้อหรือไม่
    if (selectedAnswers.length != data.length) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('กรุณาตอบทุกข้อก่อนส่งคำตอบ')));
      return; // ไม่ทำการบันทึกคำตอบ
    }

    // วนลูปผ่านคำตอบที่เลือก
    for (var entry in selectedAnswers.entries) {
      final int questionId = entry.key;
      final String selectedAnswer = entry.value;

      // ตรวจสอบว่า questionId มีค่าที่ถูกต้องหรือไม่
      if (questionId == 0) {
        print('Invalid questionId: $questionId');
        continue; // ข้ามการทำงานนี้ไป
      }

      try {
        // หาคำถามที่ตรงกับ questionId ในข้อมูลที่โหลด
        final oneChoice = data.firstWhere((q) => q.onechoiceAuto == questionId);

        // แปลง selectedAnswer จาก 'ก', 'ข', 'ค', 'ง' เป็น 'A', 'B', 'C', 'D'
        String letterAnswer = convertToLetter(selectedAnswer);

        // ตรวจสอบว่าคำตอบที่เลือกถูกต้องหรือไม่
        num score = (letterAnswer == oneChoice.onechoiceAnswer) ? oneChoice.onechoiceQuestionScore : 0;

        answersToSubmit.add({
          'examsets_id': examsetsId,
          'question_id': oneChoice.onechoiceAuto.toString(),
          'submit_onechoice_reply': letterAnswer,
          'submit_onechoice_score': score.toStringAsFixed(2),
          'submit_onechoice_time': DateTime.now().toIso8601String(), // Timestamp
          'users_username': widget.username,
        });
      } catch (e) {
        // ถ้าไม่พบคำถามที่ตรงกับ questionId
        print('Error finding question for ID $questionId: $e');
      }
    }

    // ส่งคำตอบไปยัง PHP ผ่าน HTTP POST
    final response = await http.post(
      Uri.parse('https://www.edueliteroom.com/connect/submit_onechoice.php'),
      body: json.encode({'answers': answersToSubmit}),
    );

    if (response.statusCode == 200) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Successonechoice(exam: widget.exam, username: widget.username,thfname: widget.thfname,thlname: widget.thlname, type: 'onechoice' )));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('คำตอบของคุณถูกส่งแล้ว!'),
          backgroundColor: Colors.green,  
        ),
      );
    } else {
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('เกิดข้อผิดพลาดในการส่งคำตอบ'),
          backgroundColor: Colors.red,  
        ),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<OneChoice>>(
        future: _oneChoiceData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No questions available.'));
          } else {
            final data = snapshot.data!;

            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 100,
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final oneChoice = data[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'คำถาม ${index + 1}: ${oneChoice.onechoiceQuestion} ( ${oneChoice.onechoiceQuestionScore} คะแนน)',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                buildRadioOption(oneChoice, 'ก', oneChoice.onechoiceA, oneChoice.onechoiceAuto),
                                buildRadioOption(oneChoice, 'ข', oneChoice.onechoiceB, oneChoice.onechoiceAuto),
                                buildRadioOption(oneChoice, 'ค', oneChoice.onechoiceC, oneChoice.onechoiceAuto),
                                buildRadioOption(oneChoice, 'ง', oneChoice.onechoiceD, oneChoice.onechoiceAuto),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        submitAnswers(); // เรียกใช้งานฟังก์ชัน submitAnswers เมื่อปุ่มถูกกด
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                        textStyle: TextStyle(fontSize: 20),
                      ),
                      child: Text('ส่งคำตอบ'),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildRadioOption(OneChoice oneChoice, String option, String optionText, int questionId) {
    return ListTile(
      title: Text('$option: $optionText'),
      leading: Radio<String>(
        value: option,
        groupValue: selectedAnswers[questionId],
        onChanged: (value) {
          setState(() {
            selectedAnswers[questionId] = value!;
          });
        },
      ),
    );
  }
}
