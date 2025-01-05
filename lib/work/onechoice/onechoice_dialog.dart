import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OnechoiceDialog extends StatefulWidget {
  final Examset exam;

  const OnechoiceDialog({
    super.key,
    required this.exam,
  });

  @override
  State<OnechoiceDialog> createState() => _ManychoiceDialogState();
}

class _ManychoiceDialogState extends State<OnechoiceDialog> {
  late Future<List<OneChoice>> _oneChoiceData;

  @override
  void initState() {
    super.initState();
    // Convert autoId to String, since examId should be a String
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
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('ตัวอย่างข้อสอบ '),
      content: FutureBuilder<List<OneChoice>>(
        future: _oneChoiceData,
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
                  final oneChoice = data[index];
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
                                'คำถาม ${index + 1}: ${oneChoice.onechoiceQuestion}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text('A: ${oneChoice.onechoiceA}'),
                              Text('B: ${oneChoice.onechoiceB}'),
                              Text('C: ${oneChoice.onechoiceC}'),
                              Text('D: ${oneChoice.onechoiceD}'),
                              const SizedBox(height: 8),
                              Text(
                                'คำตอบที่ถูกต้อง: ${oneChoice.onechoiceAnswer.toUpperCase()} ( ${oneChoice.onechoiceQuestionScore} คะแนน )',
                                style: const TextStyle(color: Colors.green),
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
                              // Add your action here
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
            return const Text('ไม่มีข้อมูล');
          }
        },
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
  }
}
