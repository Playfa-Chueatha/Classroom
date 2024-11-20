import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/work/asign_work_T.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class Auswer_Question extends StatefulWidget {
  final String username;
  final String thfname;
  final String thlname;
  final String classroomName;
  final String classroomMajor;
  final String classroomYear;
  final String classroomNumRoom;

  const Auswer_Question({
    super.key,
    required this.username,
    required this.thfname,
    required this.thlname,
    required this.classroomName,
    required this.classroomMajor,
    required this.classroomYear,
    required this.classroomNumRoom,
  });

  @override
  State<Auswer_Question> createState() => _Answer_QuestionState();
}

class _Answer_QuestionState extends State<Auswer_Question> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController questionController = TextEditingController();
  final TextEditingController fullMarksController = TextEditingController();
  final TextEditingController linkController = TextEditingController();
  TextEditingController questionTextController = TextEditingController();

  final List<String> _questions = [];
  String? selectedDueDate;
  DateTime? _dueDate;

  String? _direction;
  int? _fullMarks;

  Future<int?> saveAssignment({
    required String direction,
    required int fullMark,
    required DateTime deadline,
    required String username,
    required String classroomName,
    required String classroomMajor,
    required String classroomYear,
    required String classroomNumRoom,
  }) async {
    const String apiUrl = "https://www.edueliteroom.com/connect/auswer_direction.php";

    print("Sending data to PHP: ");
    print("Direction: $direction");
    print("FullMark: $fullMark");
    print("Deadline: ${DateFormat('yyyy-MM-dd').format(deadline)}");
    print("Username: $username");
    print("ClassroomName: $classroomName");
    print("ClassroomMajor: $classroomMajor");
    print("ClassroomYear: $classroomYear");
    print("ClassroomNumRoom: $classroomNumRoom");

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          "direction": direction,
          "fullMark": fullMark.toString(),
          "deadline": DateFormat('yyyy-MM-dd').format(deadline),
          "username": username,
          "classroomName": classroomName,
          "classroomMajor": classroomMajor,
          "classroomYear": classroomYear,
          "classroomNumRoom": classroomNumRoom.toString(),
        },
      );

      print(response.body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          final auswerAuto = int.tryParse(data['auswer_auto']);

          if (auswerAuto != null) {
            return auswerAuto; 
          } else {
            throw Exception("Failed to parse auswer_auto as int");
          }
        } else {
          print(data['message']);
        }
      } else {
        print("Failed to save assignment. Server error.");
      }
    } catch (error) {
      print("Error: $error");
      return null;
    }
    return null;
  }

  void _submitAssignment() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      if (_direction != null && _fullMarks != null && _dueDate != null) {
        try {
          final auswerId = await saveAssignment(
            direction: _direction!,
            fullMark: _fullMarks!,
            deadline: _dueDate!,
            username: widget.username,
            classroomName: widget.classroomName,
            classroomMajor: widget.classroomMajor,
            classroomYear: widget.classroomYear,
            classroomNumRoom: widget.classroomNumRoom,
          );

          if (auswerId != null) {
            await _submitQuestions(auswerId); 

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AssignWork_class_T(
                username: widget.username, thfname: widget.thfname, thlname: widget.thlname,
                classroomMajor: widget.classroomMajor,
                classroomName: widget.classroomName,
                classroomNumRoom: widget.classroomNumRoom,
                classroomYear: widget.classroomYear,
              )),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('กรุณากรอกคำสั่งงานและคะแนนเต็มให้ครบถ้วน'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  Future<void> _submitQuestions(int auswerId) async {
    try {
      final response = await http.post(
        Uri.parse('https://www.edueliteroom.com/connect/auswer_question.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'auswer_id': auswerId,
          'questions': _questions,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('บันทึกคำสั่งงานเรียบร้อย'),
            backgroundColor: Colors.green,
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to add questions: ${data['message']}'),
            backgroundColor: Colors.red,
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: ${response.statusCode}'),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> _selectDueDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _dueDate = pickedDate;
        selectedDueDate = DateFormat('dd MMM yyyy').format(pickedDate);
      });
    }
  }

  void _addQuestion() {
    String questionText = questionTextController.text;

    if (questionText.isNotEmpty) {
      setState(() {
        _questions.add(questionText);
      });

      questionTextController.clear();
    } else {
      print("กรุณากรอกคำถาม");
    }
  }

  void _editQuestion(int index) {
    questionController.text = _questions[index];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('แก้ไขคำถาม'),
          content: TextField(
            controller: questionController,
            decoration: const InputDecoration(labelText: 'แก้ไขคำถามของคุณ'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _questions[index] = questionController.text.trim();
                });
                Navigator.of(context).pop();
              },
              child: const Text('บันทึก'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('ยกเลิก'),
            ),
          ],
        );
      },
    );
  }

  void _removeQuestion(int index) {
    setState(() {
      _questions.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'เขียนคำสั่งงานของคุณ',
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'กรุณากรอกคำสั่งงาน'
                      : null,
                  onSaved: (value) {
                    _direction = value ?? '';
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: fullMarksController,
                        decoration: const InputDecoration(labelText: 'คะแนนเต็ม'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'กรุณากรอกคะแนนเต็ม';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _fullMarks = int.tryParse(value!) ?? 0;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        controller: TextEditingController(text: selectedDueDate),
                        decoration: InputDecoration(
                          labelText: 'กำหนดส่ง',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: _selectDueDate,
                          ),
                        ),
                        validator: (value) => _dueDate == null
                            ? 'กรุณาเลือกวันที่กำหนดส่ง'
                            : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'คำถาม:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ..._questions.asMap().entries.map((entry) {
                      int index = entry.key;
                      String question = entry.value;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(question),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _editQuestion(index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _removeQuestion(index),
                            ),
                          ],
                        ),
                      );
                    }),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: questionTextController,
                            decoration: const InputDecoration(
                              labelText: 'คำถามใหม่',
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: _addQuestion,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submitAssignment,
                  child: const Text('บันทึกคำสั่งงาน'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
