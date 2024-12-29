import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Getsubmitauswer extends StatefulWidget {
  final Examset exam;
  final String username;

  const Getsubmitauswer({
    super.key,
    required this.exam,
    required this.username,
  });

  @override
  State<Getsubmitauswer> createState() => _ChcekworkaftersubmitscoreauswerState();
}

class _ChcekworkaftersubmitscoreauswerState extends State<Getsubmitauswer> {
  late Future<List<GetsubmitauswerData>> questions;
  late String examId;
  late String username;

  // ฟังก์ชันดึงข้อมูล
  Future<List<GetsubmitauswerData>> fetchAnswers(String examId, String username) async {
    final url = Uri.parse('https://www.edueliteroom.com/connect/Getsubmitauswer.php');
    final response = await http.get(
      url.replace(queryParameters: {'examsets_id': examId, 'username': username}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => GetsubmitauswerData.fromJson(json)).toList();
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
        title: Text("ตรวจสอบการส่งคำตอบ "),
        actions: [
          FutureBuilder<List<GetsubmitauswerData>>(
            future: questions, // ใช้ questions ที่กำหนดไว้ใน initState
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(), // หรือใส่ข้อความรอโหลด
                );
              } else if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('No questions available'),
                );
              } else {
                final questionsList = snapshot.data!;

                // คำนวณผลรวมของ auswerQuestionScore
                double totalAuswerScore = 0.0;
                for (var question in questionsList) {
                  totalAuswerScore += question.auswerQuestionScore; // ตรวจสอบค่า null
                }

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'คะแนนเต็ม ${totalAuswerScore.toStringAsFixed(2)} คะแนน',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<GetsubmitauswerData>>(
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

            // คำนวณผลรวมของ auswer_question_score
            

            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8, // ปรับขนาดของ ListView ให้เหมาะสม
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
                                  Text(
                                    'คำตอบ: ${questionsList[index].submitAuswerReply}',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: const Color.fromARGB(255, 59, 59, 59)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
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
