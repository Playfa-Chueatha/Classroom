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

 Future<void> updateDataToApi(int manychoiceAuto, String question, double score, Map<String, String> choices) async {
  final url = Uri.parse('https://www.edueliteroom.com/connect/update_manychoice.php');

  if (question.isEmpty || score <= 0 || choices.isEmpty) {
    print('ข้อมูลไม่สมบูรณ์');
    return;
  }

  final data = {
    'manychoice_auto': manychoiceAuto.toString(),  // แปลงเป็น String ก่อนส่ง
    'manychoice_question': question,
    'manychoice_question_score': score.toString(),
    'manychoice_a': choices['ก'] ?? '',
    'manychoice_b': choices['ข'] ?? '',
    'manychoice_c': choices['ค'] ?? '',
    'manychoice_d': choices['ง'] ?? '',
    'manychoice_e': choices['จ'] ?? '',
    'manychoice_f': choices['ฉ'] ?? '',
    'manychoice_g': choices['ช'] ?? '',
    'manychoice_h': choices['ซ'] ?? '',
  };

  try {
    final response = await http.post(url, body: data);
    if (response.statusCode == 200) {
      print('Data updated successfully');
    } else {
      print('Failed to update data');
    }
  } catch (error) {
    print('Error: $error');
  }
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
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  final TextEditingController questionController =
                                      TextEditingController(text: item.manychoiceQuestion);
                                  final TextEditingController scoreController =
                                      TextEditingController(text: item.manychoiceQuestionScore.toString());

                                  final Map<String, TextEditingController> choiceControllers = {
                                    'ก': TextEditingController(text: item.manychoiceA),
                                    'ข': TextEditingController(text: item.manychoiceB),
                                    'ค': TextEditingController(text: item.manychoiceC),
                                    'ง': TextEditingController(text: item.manychoiceD),
                                    'จ': TextEditingController(text: item.manychoiceE),
                                    'ฉ': TextEditingController(text: item.manychoiceF),
                                    'ช': TextEditingController(text: item.manychoiceG),
                                    'ซ': TextEditingController(text: item.manychoiceH),
                                  };

                                  List<Widget> buildChoiceFields() {
                                    return choiceControllers.entries
                                        .where((entry) => entry.value.text.isNotEmpty)
                                        .map((entry) => Column(
                                              children: [
                                                TextField(
                                                  controller: entry.value,
                                                  decoration: InputDecoration(
                                                    labelText: '${entry.key}:',
                                                    border: const OutlineInputBorder(),
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                              ],
                                            ))
                                        .toList();
                                  }

                                  return AlertDialog(
                                    title: Text('แก้ไขคำถาม ${index + 1}'),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TextField(
                                            controller: questionController,
                                            decoration: const InputDecoration(
                                              labelText: 'คำถาม',
                                              border: OutlineInputBorder(),
                                            ),
                                            maxLines: 2,
                                          ),
                                          const SizedBox(height: 10),
                                          ...buildChoiceFields(),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('ยกเลิก'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          setState(() {
                                            item.manychoiceQuestion = questionController.text;
                                            item.manychoiceQuestionScore = double.tryParse(scoreController.text) ?? item.manychoiceQuestionScore;

                                            choiceControllers.forEach((key, controller) {
                                              switch (key) {
                                                case 'ก':
                                                  item.manychoiceA = controller.text;
                                                  break;
                                                case 'ข':
                                                  item.manychoiceB = controller.text;
                                                  break;
                                                case 'ค':
                                                  item.manychoiceC = controller.text;
                                                  break;
                                                case 'ง':
                                                  item.manychoiceD = controller.text;
                                                  break;
                                                case 'จ':
                                                  item.manychoiceE = controller.text;
                                                  break;
                                                case 'ฉ':
                                                  item.manychoiceF = controller.text;
                                                  break;
                                                case 'ช':
                                                  item.manychoiceG = controller.text;
                                                  break;
                                                case 'ซ':
                                                  item.manychoiceH = controller.text;
                                                  break;
                                              }
                                            });
                                          });

                                          await updateDataToApi(
                                            int.tryParse(item.manychoiceAuto) ?? 0,  // Safely convert to int
                                            item.manychoiceQuestion,
                                            item.manychoiceQuestionScore,
                                            {
                                              'ก': item.manychoiceA,
                                              'ข': item.manychoiceB,
                                              'ค': item.manychoiceC,
                                              'ง': item.manychoiceD,
                                              'จ': item.manychoiceE,
                                              'ฉ': item.manychoiceF,
                                              'ช': item.manychoiceG,
                                              'ซ': item.manychoiceH,
                                            },
                                          );
                                          Navigator.pop(context); 
                                        },
                                        child: const Text('บันทึก'),
                                      ),
                                    ],
                                  );
                                },
                              );
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

  Widget _buildChoiceText(String label, String choice) {
    return choice.isNotEmpty
        ? Text(
            '$label $choice',
            style: TextStyle(fontSize: 14),
          )
        : SizedBox();
  }
}
