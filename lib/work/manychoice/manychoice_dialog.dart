import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ManychoiceDialog extends StatefulWidget {
  final Examset exam;
  const ManychoiceDialog({
    super.key,
    required this.exam, required String username, required String thfname, required String thlname,
  });

  @override
  State<ManychoiceDialog> createState() => _ManychoiceDialogState();
}

class _ManychoiceDialogState extends State<ManychoiceDialog> {
  late Future<List<Manychoice>> manyChoiceData;

  Future<List<Manychoice>> fetchManyChoiceData(String examId) async {
    final response = await http.post(
      Uri.parse('https://www.edueliteroom.com/connect/fetch_manychoiceforEdit.php'),
      body: {'examsets_id': examId},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Manychoice.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    manyChoiceData = fetchManyChoiceData(widget.exam.autoId.toString());
  }

  final Map<String, String> answerMapping = {
  'a': 'ก',
  'b': 'ข',
  'c': 'ค',
  'd': 'ง',
  'e': 'จ',
  'f': 'ฉ',
  'g': 'ช',
  'h': 'ซ',
};

// แปลงค่าจาก manychoiceAnswer
String transformManyChoiceAnswer(String manychoiceAnswer) {
  return manychoiceAnswer
      .split('') // แยกคำตอบออกเป็นตัวอักษร
      .map((char) => answerMapping[char]) // แปลงค่าตาม Map
      .where((value) => value != null) // กรองค่าที่ไม่ได้แมป (null)
      .join(', '); // รวมกลับด้วยคอมมา
}

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('ตัวอย่างข้อสอบ: ${widget.exam.direction} ( ${widget.exam.fullMark} คะแนน )'),
      content: FutureBuilder<List<Manychoice>>(
        future: manyChoiceData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('เกิดข้อผิดพลาด: ${snapshot.error}');
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            return SizedBox(
              width: double.maxFinite,
              height: 400,
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final item = data[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    elevation: 4,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'คำถาม ${index + 1}: ${item.manychoiceQuestion}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildChoiceText('ก: ', item.manychoiceA),
                              _buildChoiceText('ข: ', item.manychoiceB),
                              _buildChoiceText('ค: ', item.manychoiceC),
                              _buildChoiceText('ง: ', item.manychoiceD),
                              _buildChoiceText('จ: ', item.manychoiceE),
                              _buildChoiceText('ฉ: ', item.manychoiceF),
                              _buildChoiceText('ช: ', item.manychoiceG),
                              _buildChoiceText('ซ: ', item.manychoiceH),
                              const SizedBox(height: 8),
                              Text(
                                'คำตอบที่ถูกต้อง: ${transformManyChoiceAnswer(item.manychoiceAnswer)}',
                                style: const TextStyle(color: Colors.green),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'คะแนน: ${item.manychoiceQuestionScore}',
                                style: const TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 8,
                          bottom: 8,
                          child: IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              // Add your action here for editing this question
                              print('Edit button pressed for question ${index + 1}');
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          } else {
            return const Center(child: Text('ไม่มีข้อมูล'));
          }
        },
      ),
    );
  }

  // ฟังก์ชันสำหรับแสดงตัวเลือกคำตอบ
  Widget _buildChoiceText(String label, String choice) {
    return choice.isNotEmpty
        ? Text(
            '$label $choice',
            style: TextStyle(fontSize: 14),
          )
        : SizedBox(); // ถ้าไม่มีข้อมูล ก็จะไม่แสดงอะไร
  }
}
