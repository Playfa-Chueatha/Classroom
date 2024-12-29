import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Chcekscoreonechoice extends StatefulWidget {
  final Examset exam;
  final String username;
  const Chcekscoreonechoice({
    super.key,
    required this.exam,
    required this.username,
  });

  @override
  State<Chcekscoreonechoice> createState() => _ChcekscoreonechoiceState();
}

class _ChcekscoreonechoiceState extends State<Chcekscoreonechoice> {
  late Future<Chcekscoreonechoicedata> _data;
  double totalScore = 0; // ตัวแปรสำหรับเก็บคะแนนรวม

  @override
  void initState() {
    super.initState();
    _data = sendDataToPHP(widget.exam.autoId, widget.username);
  }

  Future<Chcekscoreonechoicedata> sendDataToPHP(int autoId, String username) async {
    final response = await http.post(
      Uri.parse('https://www.edueliteroom.com/connect/Chcekscore_onechoice.php'),
      body: {
        'autoId': autoId.toString(),
        'username': username,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Chcekscoreonechoicedata.fromJson(data);
    } else {
      throw Exception('Failed to load data');
    }
  }

  // ฟังก์ชันคำนวณคะแนนรวม
  void calculateTotalScore(Chcekscoreonechoicedata data) {
    double sum = 0;
    for (var submit in data.submitOnechoiceData) {
      sum += submit.submitOnechoiceScore; // รวมคะแนน
    }
    setState(() {
      totalScore = sum; // อัปเดตคะแนนรวม
    });
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('ตรวจสอบคำตอบ'),
    ),
    body: FutureBuilder<Chcekscoreonechoicedata>(
      future: _data,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.onechoiceData.isEmpty) {
          return const Center(child: Text('No data available'));
        } else {
          var data = snapshot.data!;
          
          // คำนวณคะแนนรวมที่นี่โดยไม่ใช้ setState
          double totalScore = 0;
          for (var submit in data.submitOnechoiceData) {
            totalScore += submit.submitOnechoiceScore;
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: data.onechoiceData.length,
                  itemBuilder: (context, index) {
                    var onechoice = data.onechoiceData[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      elevation: 4,
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'คำถาม ${index + 1}: ${onechoice.onechoiceQuestion} (คะแนนเต็ม ${onechoice.onechoiceQuestionScore} คะแนน)',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text('ก: ${onechoice.onechoiceA}'),
                                Text('ข: ${onechoice.onechoiceB}'),
                                Text('ค: ${onechoice.onechoiceC}'),
                                Text('ง: ${onechoice.onechoiceD}'),
                                const SizedBox(height: 8),
                                Text(
                                  'คำตอบที่ถูกต้อง: ${onechoice.onechoiceAnswer.toUpperCase()}',
                                  style: const TextStyle(color: Colors.green),
                                ),
                                const SizedBox(height: 8),
                                for (var submit in data.submitOnechoiceData)
                                  if (submit.questionId ==
                                      onechoice.onechoiceAuto)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: submit
                                                        .submitOnechoiceReply
                                                        .toUpperCase() ==
                                                    onechoice.onechoiceAnswer
                                                        .toUpperCase()
                                                ? Colors.green
                                                : Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            'คำตอบที่เลือก: ${submit.submitOnechoiceReply}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // แสดงผลรวมคะแนนด้านล่าง
              Container(
                padding: const EdgeInsets.all(16),             
                child: Text(
                  'คะแนนรวมที่คุณได้ ${totalScore.toStringAsFixed(2)} คะแนน จากคะแนนเต็ม ${widget.exam.fullMark} คะแนน',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          );
        }
      },
    ),
  );
}}
