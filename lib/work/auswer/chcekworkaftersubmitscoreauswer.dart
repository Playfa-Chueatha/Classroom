import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Chcekworkaftersubmitscoreauswer extends StatefulWidget {
  final Examset exam;
  final String username;

  const Chcekworkaftersubmitscoreauswer({
    super.key,
    required this.exam,
    required this.username,
  });

  @override
  State<Chcekworkaftersubmitscoreauswer> createState() =>
      _ChcekworkaftersubmitscoreauswerState();
}

class _ChcekworkaftersubmitscoreauswerState
    extends State<Chcekworkaftersubmitscoreauswer> {
  late Future<List<AnswerData>> questions;
  late String examId;
  late String username;

  // ฟังก์ชันดึงข้อมูล
  Future<List<AnswerData>> fetchAnswers(String examId, String username) async {
    final url = Uri.parse('https://www.edueliteroom.com/connect/Chcekworkaftersubmitscoreauswer.php');
    final response = await http.get(
      url.replace(queryParameters: {'examsets_id': examId, 'username': username}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => AnswerData.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load answers');
    }
  }

  @override
  void initState() {
    super.initState();
    examId = widget.exam.autoId.toString(); 
    username = widget.username;
    questions = fetchAnswers(examId, username); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ตรวจสอบคะแนนหลังจากส่งคำตอบ"),
      ),
      body: FutureBuilder<List<AnswerData>>(
        future: questions, // ใช้ questions ที่กำหนดไว้ใน initState
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No questions available'));
          } else {
            final questionsList = snapshot.data!;

            // คำนวณผลรวมของ checkwork_auswer_score และ auswer_question_score
            double totalCheckworkScore = 0.0;
            double totalAuswerScore = 0.0;

            for (var question in questionsList) {
              totalCheckworkScore += question.checkworkAuswerScore; // ตรวจสอบค่า null
              totalAuswerScore += question.auswerQuestionScore ?? 0.0; // ตรวจสอบค่า null
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,  
                    child: ListView.builder(
                      itemCount: questionsList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: EdgeInsets.all(20),
                          color: Color.fromARGB(255, 152, 186, 218),
                          elevation: 4,
                          child: ListTile(
                            contentPadding: EdgeInsets.all(16),
                            title: Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'ข้อที่ ${index + 1}: ${questionsList[index].questionDetail} (คะแนนเต็ม ${questionsList[index].auswerQuestionScore} คะแนน)',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                  ),
                                  Text('คำตอบ: ${questionsList[index].submitAuswerReply}',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: const Color.fromARGB(255, 59, 59, 59)),
                                  ),
                                  Text('คะแนนที่ได้: ${questionsList[index].checkworkAuswerScore}',
                                    style: TextStyle(fontSize: 16, color: const Color.fromARGB(255, 4, 89, 158)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  // แสดงผลรวมคะแนน
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: 
                        Text(
                          'ผลรวมคะแนนที่ได้ ${totalCheckworkScore.toStringAsFixed(2)} คะแนน จากคะแนนเต็ม ${totalAuswerScore.toStringAsFixed(2)} คะแนน',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
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
}
