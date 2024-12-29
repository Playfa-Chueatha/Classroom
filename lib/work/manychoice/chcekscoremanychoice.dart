import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Chcekscoremanychoice extends StatefulWidget {
  final Examset exam;
  final String username;

  const Chcekscoremanychoice({
    super.key,
    required this.exam,
    required this.username,
  });

  @override
  State<Chcekscoremanychoice> createState() => _ChcekscoremanychoiceState();
}

class _ChcekscoremanychoiceState extends State<Chcekscoremanychoice> {
  late Future<Chcekscoremanychoicedata> manyChoiceData;

  Future<Chcekscoremanychoicedata> sendDataToPHP(int autoId, String username) async {
    final response = await http.post(
      Uri.parse('https://www.edueliteroom.com/connect/Chcekscore_manychoice.php'),
      body: {
        'autoId': autoId.toString(),
        'username': username,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Chcekscoremanychoicedata.fromJson(data);
    } else {
      print("Error: ${response.statusCode}");
      print("Response Body: ${response.body}");
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    manyChoiceData = sendDataToPHP(widget.exam.autoId, widget.username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ตรวจสอบคำตอบ'),
      ),
      body: FutureBuilder<Chcekscoremanychoicedata>(
        future: manyChoiceData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.manychoiceData.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            final data = snapshot.data!;
            
            // คำนวณคะแนนรวม
            double totalScore = data.submitManychoiceData.fold(
              0,
              (sum, item) => sum + item.submitManychoiceScore,
            );

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: data.manychoiceData.length,
                    itemBuilder: (context, index) {
                      final manychoice = data.manychoiceData[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'คำถาม ${index + 1}: ${manychoice.manychoiceQuestion} '
                                '(คะแนนเต็ม ${manychoice.manychoiceQuestionScore} คะแนน)',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildChoiceText('ก: ', manychoice.manychoiceA),
                              _buildChoiceText('ข: ', manychoice.manychoiceB),
                              _buildChoiceText('ค: ', manychoice.manychoiceC),
                              _buildChoiceText('ง: ', manychoice.manychoiceD),
                              if (manychoice.manychoiceE != null) _buildChoiceText('จ: ', manychoice.manychoiceE),
                              if (manychoice.manychoiceF != null) _buildChoiceText('ฉ: ', manychoice.manychoiceF),
                              if (manychoice.manychoiceG != null) _buildChoiceText('ช: ', manychoice.manychoiceG),
                              if (manychoice.manychoiceH != null) _buildChoiceText('ซ: ', manychoice.manychoiceH),
                              const SizedBox(height: 8),
                              Text(
                                'คำตอบที่ถูกต้อง: ${manychoice.manychoiceAnswer.toUpperCase()}',
                                style: const TextStyle(color: Colors.green),
                              ),
                              const SizedBox(height: 8),
                              for (var submit in data.submitManychoiceData)
                                if (submit.questionId == manychoice.manychoiceAuto)
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: submit.submitManychoiceReply.toUpperCase() ==
                                              manychoice.manychoiceAnswer.toUpperCase()
                                          ? Colors.green
                                          : Colors.red,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'คำตอบที่เลือก: ${submit.submitManychoiceReply}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // แสดงคะแนนรวม
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.blue.shade100,
                  child: Text(
                    'คะแนนรวมที่คุณได้: ${totalScore.toStringAsFixed(2)} '
                    'คะแนน จากคะแนนเต็ม ${widget.exam.fullMark} คะแนน',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildChoiceText(String label, String? choice) {
    return choice != null && choice.isNotEmpty
        ? Text(
            '$label $choice',
            style: const TextStyle(fontSize: 14),
          )
        : const SizedBox();
  }
}



