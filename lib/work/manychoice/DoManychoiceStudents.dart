import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:flutter_esclass_2/work/manychoice/successManychoice.dart';
import 'package:flutter_esclass_2/work/onechoice/successOnechoice.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Domanychoicestudents extends StatefulWidget {
  final Examset exam;
  final String username;
  final String thfname;
  final String thlname;

  const Domanychoicestudents({
    super.key,
    required this.exam,
    required this.username,
    required this.thfname,
    required this.thlname,
  });

  @override
  State<Domanychoicestudents> createState() => _DomanychoicestudentsState();
}

class _DomanychoicestudentsState extends State<Domanychoicestudents> {
  late Future<List<Manychoice>> manyChoiceData;
  Map<String, List<String>> selectedAnswers = {};  // เปลี่ยนจาก Map<String, String> เป็น Map<String, List<String>>

  Future<List<Manychoice>> fetchManyChoiceData(String examId) async {
    final response = await http.post(
      Uri.parse('https://www.edueliteroom.com/connect/fetch_manychoiceforEdit.php'),
      body: {'examsets_id': examId},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Manychoice.fromJson(json)).toList();
    } else {
      throw Exception('ไม่สามารถโหลดข้อมูลได้');
    }
  }

  void submitAnswers() async {
    final String examsetsId = widget.exam.autoId.toString();
    List<Map<String, dynamic>> answersToSubmit = [];

    final data = await manyChoiceData;

    // ตรวจสอบว่าเลือกคำตอบครบทุกข้อหรือไม่
    if (selectedAnswers.length != data.length) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('กรุณาตอบทุกข้อก่อนส่งคำตอบ')));
      return;
    }

    // วนลูปผ่านคำตอบที่เลือก
    for (var entry in selectedAnswers.entries) {
      final String questionId = entry.key;  // ใช้ questionId เป็น String
      final List<String> selectedAnswerList = entry.value;

      try {
        // หาคำถามที่ตรงกับ questionId ในข้อมูลที่โหลด
        final manyChoice = data.firstWhere((q) => q.manychoiceAuto == questionId);

        print('-----------------------------------');
        


        num score = 0;

        // แปลงคำตอบที่ถูกต้องเป็น List (ไม่สนใจตัวพิมพ์)
        List<String> correctAnswers = manyChoice.manychoiceAnswer
            .split(',')
            .map((e) => e.trim().toLowerCase())  // แปลงเป็นตัวพิมพ์เล็ก
            .toList();

        // แปลง selectedAnswerList เป็นตัวพิมพ์เล็กเพื่อการเปรียบเทียบที่ไม่สนใจตัวพิมพ์
        List<String> selectedAnswerListLower = selectedAnswerList
            .map((e) => e.toLowerCase())  // แปลงเป็นตัวพิมพ์เล็ก
            .toList();

        // ตรวจสอบว่าคำตอบที่เลือกตรงกับคำตอบที่ถูกต้อง
        if (selectedAnswerListLower.length == correctAnswers.length &&
            selectedAnswerListLower.every((answer) => correctAnswers.contains(answer))) {
          score = manyChoice.manychoiceQuestionScore as num;
        }



        answersToSubmit.add({
          'examsets_id': examsetsId,
          'question_id': manyChoice.manychoiceAuto,
          'submit_manychoice_reply': selectedAnswerList.map((e) => e.toUpperCase()).join(','),
          'submit_manychoice_score': score.toStringAsFixed(2),
          'submit_manychoice_time': DateTime.now().toIso8601String(),
          'users_username': widget.username,
        });
      } catch (e) {
        print('Error finding question for ID $questionId: $e');
      }
    }

    
    final response = await http.post(
      Uri.parse('https://www.edueliteroom.com/connect/submit_manychoice.php'),
      headers: {'Content-Type': 'application/json'},  
      body: json.encode({'answers': answersToSubmit}),
    );

    if (response.statusCode == 200) {
      
      
      Navigator.push(
      context,
        MaterialPageRoute(
          builder: (context) => Successmanychoice(
            exam: widget.exam,
            username: widget.username,
            thfname: widget.thfname,
            thlname: widget.thlname,
            type: 'manychoice',
          ),
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('คำตอบของคุณถูกส่งแล้ว!'),
          backgroundColor: Colors.green,  
        ),
        
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('คำตอบของคุณถูกส่งแล้ว!'), backgroundColor: Colors.green),
      );
      print("Username: ${widget.username}");
      print("ExamAutoId: ${widget.exam.autoId}");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการส่งคำตอบ'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    manyChoiceData = fetchManyChoiceData(widget.exam.autoId.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ตัวอย่างข้อสอบ: ${widget.exam.direction} ( ${widget.exam.fullMark} คะแนน)'),
      ),
      body: FutureBuilder<List<Manychoice>>(
        future: manyChoiceData,
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
                        final manyChoice = data[index];

                        List<Widget> options = [];
                        if (manyChoice.manychoiceA.isNotEmpty) options.add(buildCheckboxOption(manyChoice, 'A', manyChoice.manychoiceA, manyChoice.manychoiceAuto));
                        if (manyChoice.manychoiceB.isNotEmpty) options.add(buildCheckboxOption(manyChoice, 'B', manyChoice.manychoiceB, manyChoice.manychoiceAuto));
                        if (manyChoice.manychoiceC.isNotEmpty) options.add(buildCheckboxOption(manyChoice, 'C', manyChoice.manychoiceC, manyChoice.manychoiceAuto));
                        if (manyChoice.manychoiceD.isNotEmpty) options.add(buildCheckboxOption(manyChoice, 'D', manyChoice.manychoiceD, manyChoice.manychoiceAuto));
                        if (manyChoice.manychoiceE.isNotEmpty) options.add(buildCheckboxOption(manyChoice, 'E', manyChoice.manychoiceE, manyChoice.manychoiceAuto));
                        if (manyChoice.manychoiceF.isNotEmpty) options.add(buildCheckboxOption(manyChoice, 'F', manyChoice.manychoiceF, manyChoice.manychoiceAuto));

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'คำถาม ${index + 1}: ${manyChoice.manychoiceQuestion} ( ${manyChoice.manychoiceQuestionScore} คะแนน)',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ...options, 
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
                        submitAnswers(); 

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

  Widget buildCheckboxOption(Manychoice manyChoice, String option, String optionText, String questionId) {
    // แปลงตัวเลือกจาก A, B, C, D ให้เป็น ก, ข, ค, ง
    Map<String, String> optionMapping = {
      'A': 'ก',
      'B': 'ข',
      'C': 'ค',
      'D': 'ง',
      'E': 'จ',
      'F': 'ฉ',
    };

    String displayOption = optionMapping[option] ?? option; // แสดงผลตามที่กำหนดใน optionMapping

    return ListTile(
      title: Text('$displayOption: $optionText'),  // แสดงตัวเลือกในรูปแบบ ก ข ค ง
      leading: Checkbox(
        value: selectedAnswers[questionId]?.contains(option) ?? false,  // ตรวจสอบว่ามีตัวเลือกนี้ใน selectedAnswers หรือไม่
        onChanged: (bool? value) {
          setState(() {
            if (value == true) {
              // ถ้าผู้ใช้เลือกตัวเลือก
              selectedAnswers.putIfAbsent(questionId, () => []).add(option);  // เก็บข้อมูลเป็น a, b, c, d
            } else {
              // ถ้าผู้ใช้ยกเลิกการเลือก
              selectedAnswers[questionId]?.remove(option);
              if (selectedAnswers[questionId]?.isEmpty ?? true) {
                selectedAnswers.remove(questionId);
              }
            }
          });
        },
      ),
    );
  }
}
