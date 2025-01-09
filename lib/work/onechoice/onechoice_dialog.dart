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
  String? selectedScore; 
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
      throw Exception('Failed to load data');
    }
  }

  void _editQuestion(BuildContext context, OneChoice oneChoice, int index) {
  // กำหนดค่าเริ่มต้นของ selectedScore จากคำตอบปัจจุบัน
  selectedScore = _getThaiAnswer(oneChoice.onechoiceAnswer);

  final TextEditingController questionController =
      TextEditingController(text: oneChoice.onechoiceQuestion);
  final TextEditingController optionAController =
      TextEditingController(text: oneChoice.onechoiceA);
  final TextEditingController optionBController =
      TextEditingController(text: oneChoice.onechoiceB);
  final TextEditingController optionCController =
      TextEditingController(text: oneChoice.onechoiceC);
  final TextEditingController optionDController =
      TextEditingController(text: oneChoice.onechoiceD);

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text('แก้ไขคำถามที่ ${index + 1}'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: questionController,
                    decoration: InputDecoration(labelText: 'คำถาม'),
                  ),
                  TextField(
                    controller: optionAController,
                    decoration: InputDecoration(labelText: 'ตัวเลือก ก'),
                  ),
                  TextField(
                    controller: optionBController,
                    decoration: InputDecoration(labelText: 'ตัวเลือก ข'),
                  ),
                  TextField(
                    controller: optionCController,
                    decoration: InputDecoration(labelText: 'ตัวเลือก ค'),
                  ),
                  TextField(
                    controller: optionDController,
                    decoration: InputDecoration(labelText: 'ตัวเลือก ง'),
                  ),
                  const SizedBox(height: 16),
                  Text('เลือกคำตอบที่ถูกต้อง:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Column(
                    children: ['ก', 'ข', 'ค', 'ง'].map((value) {
                      return RadioListTile<String>(
                        title: Text(value),
                        value: value,
                        groupValue: selectedScore,
                        onChanged: (newValue) {
                          setState(() {
                            selectedScore = newValue;
                            print("Selected Answer Updated: $selectedScore");
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('ยกเลิก'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (selectedScore != null) {
                    setState(() {
                      oneChoice = OneChoice(
                        onechoiceAuto: oneChoice.onechoiceAuto,
                        examsetsId: oneChoice.examsetsId,
                        onechoiceQuestion: questionController.text,
                        onechoiceA: optionAController.text,
                        onechoiceB: optionBController.text,
                        onechoiceC: optionCController.text,
                        onechoiceD: optionDController.text,
                        onechoiceAnswer: _getAnswerFromThai(selectedScore!),
                        onechoiceQuestionScore: oneChoice.onechoiceQuestionScore,
                      );
                    });
                    _sendUpdatedData(oneChoice);
                    Navigator.of(context).pop();
                  } else {
                    print('กรุณาเลือกคำตอบ');
                  }
                },
                child: Text('บันทึก'),
              ),
            ],
          );
        },
      );
    },
  );
}





  String _getAnswerFromThai(String thaiAnswer) {
    switch (thaiAnswer) {
      case 'ก':
        return 'a';
      case 'ข':
        return 'b';
      case 'ค':
        return 'c';
      case 'ง':
        return 'd';
      default:
        return ''; // กรณีค่าผิดปกติ
    }
  }

  String _getThaiAnswer(String answer) {
    switch (answer.toLowerCase()) {
      case 'a':
        return 'ก';
      case 'b':
        return 'ข';
      case 'c':
        return 'ค';
      case 'd':
        return 'ง';
      default:
        return answer; // กรณีค่าผิดปกติ
    }
  }

  Future<void> _sendUpdatedData(OneChoice oneChoice) async {
    final response = await http.post(
      Uri.parse('https://www.edueliteroom.com/connect/update_onechoice.php'),
      body: {
        'autoId': oneChoice.onechoiceAuto.toString(),
        'question': oneChoice.onechoiceQuestion,
        'a': oneChoice.onechoiceA,
        'b': oneChoice.onechoiceB,
        'c': oneChoice.onechoiceC,
        'd': oneChoice.onechoiceD,
        'answer': oneChoice.onechoiceAnswer,
        'score': oneChoice.onechoiceQuestionScore.toString(),
      },
    );

    print(response.body);

    if (response.statusCode == 200) {
      print('Data updated successfully');
      setState(() {
        _oneChoiceData = fetchOneChoiceData(widget.exam.autoId.toString());
      });
    } else {
      throw Exception('Failed to update data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<OneChoice>>(
      future: _oneChoiceData,
      builder: (context, snapshot) {
        String titleText;
        if (snapshot.connectionState == ConnectionState.waiting) {
          titleText = 'กำลังโหลด...';
        } else if (snapshot.hasError) {
          titleText = 'เกิดข้อผิดพลาด: ${snapshot.error}';
        } else if (snapshot.hasData) {
          final data = snapshot.data!;
          titleText = 'ตัวอย่างข้อสอบ: ${widget.exam.direction} ทั้งหมดจำนวน ${data.length} ข้อ คะแนนเต็ม ${widget.exam.fullMark} คะแนน';
        } else {
          titleText = 'ไม่มีข้อมูล';
        }

        return AlertDialog(
          title: Text(titleText),
          content: _buildContent(snapshot),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('ปิด'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContent(AsyncSnapshot<List<OneChoice>> snapshot) {
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
                        Text('ก: ${oneChoice.onechoiceA}'),
                        Text('ข: ${oneChoice.onechoiceB}'),
                        Text('ค: ${oneChoice.onechoiceC}'),
                        Text('ง: ${oneChoice.onechoiceD}'),
                        const SizedBox(height: 8),
                        Text(
                          'คำตอบที่ถูกต้อง: ${_getThaiAnswer(oneChoice.onechoiceAnswer)} ( ${oneChoice.onechoiceQuestionScore} คะแนน )',
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
                        _editQuestion(context, oneChoice, index);
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
  }
}
