import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:flutter_esclass_2/work/asign_work_T.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class many_choice extends StatefulWidget {
  final String username;
  final String thfname;
  final String thlname;
  final String classroomName;
  final String classroomMajor;
  final String classroomYear;
  final String classroomNumRoom;

  const many_choice({
    super.key,
    required this.thfname,
    required this.thlname,
    required this.username,
    required this.classroomName,
    required this.classroomMajor,
    required this.classroomYear,
    required this.classroomNumRoom,
  });

  @override
  _many_choice createState() => _many_choice();
}

class _many_choice extends State<many_choice> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final List<Question> _questions = []; 
  final List<Question> _savedQuestions = []; 
  late AnimationController _controller;
  String? selectedDueDate;
  DateTime? _dueDate;
  String? _direction;
  int? _fullMarks;
  bool isLoading = false;

  final TextEditingController fullMarksController = TextEditingController();


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
    const String apiUrl = "https://www.edueliteroom.com/connect/manychoice_direction.php";

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

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          final examsetsAuto = int.tryParse(data['examsets_auto']);
          print('$examsetsAuto');

          if (examsetsAuto != null) {
            return examsetsAuto; 
          } else {
            throw Exception("Failed to parse examsets_auto as int");
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
      setState(() => isLoading = true);

  
      try {
        final examsetsId = await saveAssignment(
          direction: _direction!,
          fullMark: _fullMarks!,
          deadline: _dueDate!,
          username: widget.username,
          classroomName: widget.classroomName,
          classroomMajor: widget.classroomMajor,
          classroomYear: widget.classroomYear,
          classroomNumRoom: widget.classroomNumRoom,
        );
        // print('ExamsetID: $examsetsId');
        // print('$_savedQuestions');
        if (examsetsId != null) {
          List<Map<String, dynamic>> questionsAndChoices = [];

          // เพิ่มคำถามและตัวเลือก
          for (var question in _savedQuestions) {
            int index = _savedQuestions.indexOf(question);
            if (index >= 0 && question.choices.length >= 4) {
              if (question.choices.every((choice) => choice.controller.text.isNotEmpty)) {
                questionsAndChoices.add({
                  'question': question.questionController.text,
                  'a': question.choices[0].controller.text,
                  'b': question.choices[1].controller.text,
                  'c': question.choices[2].controller.text,
                  'd': question.choices[3].controller.text,
                  'e': (question.choices.length > 4) ? question.choices[4].controller.text : '',
                  'f': (question.choices.length > 5) ? question.choices[5].controller.text : '',
                  'g': (question.choices.length > 6) ? question.choices[6].controller.text : '',
                  'h': (question.choices.length > 7) ? question.choices[7].controller.text : '',
                  'answer': convertAnswer(question.selectedAnswers.join(',')),
                });
              } else {
                debugPrint('ตัวเลือกไม่ครบสำหรับคำถาม: ${question.questionController.text}');
              }
            } else {
              debugPrint('คำถามไม่ครบถ้วนหรือไม่มีตัวเลือก: ${question.questionController.text}');
            }
          }


          print('questionsAndChoices in _submitAssignment: $questionsAndChoices');
          if (questionsAndChoices.isEmpty) {
            print('$_savedQuestions');
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('กรุณากรอกคำถามและตัวเลือกให้ครบถ้วน'),
              backgroundColor: Colors.red,
            ));
            return;
          }

          await saveQuestionsAndChoices(examsetsId, questionsAndChoices);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AssignWork_class_T(
              username: widget.username, thfname: widget.thfname, thlname: widget.thlname,
                classroomMajor: widget.classroomMajor,
                classroomName: widget.classroomName,
                classroomNumRoom: widget.classroomNumRoom,
                classroomYear: widget.classroomYear,
            )), );

        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('ไม่สามารถบันทึกการบ้านได้'),
            backgroundColor: Colors.red,
          ));
        }
      } catch (e) {
        print('$e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ));
      } finally {
        setState(() => isLoading = false); 
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('กรุณากรอกข้อมูลให้ครบถ้วน'),
        backgroundColor: Colors.red,
      ));
    }
  }
}

String convertAnswer(String answer) {
  List<String> validAnswers = [];
  List<String> choices = answer.split(',');

  for (String choice in choices) {
    switch (choice.trim()) {
      case 'ก':
      case 'a': 
        validAnswers.add('a');
        break;
      case 'ข':
      case 'b': 
        validAnswers.add('b');
        break;
      case 'ค':
      case 'c': 
        validAnswers.add('c');
        break;
      case 'ง':
      case 'd': 
        validAnswers.add('d');
        break;
      case 'จ':
      case 'e':
        validAnswers.add('e');
        break;
      case 'ฉ':
      case 'f': 
        validAnswers.add('f');
        break;
      case 'ช':
      case 'g': 
        validAnswers.add('g');
        break;
      case 'ซ':
      case 'h': 
        validAnswers.add('h');
        break;
      default:
        throw Exception('คำตอบไม่ถูกต้อง: $choice');
    }
  }
  
  return validAnswers.join(',');
}



Future<void> saveQuestionsAndChoices(
  int examsetsId, List<Map<String, dynamic>> questionsAndChoices) async {
  const String apiUrl = "https://www.edueliteroom.com/connect/manychoice_question.php";


  List<Map<String, dynamic>> convertedQuestions = questionsAndChoices.map((question) {

    if (question['a'].toString().isEmpty || 
        question['b'].toString().isEmpty || 
        question['c'].toString().isEmpty || 
        question['d'].toString().isEmpty) {
      throw Exception("ตัวเลือก ก ข ค และ ง ต้องไม่เป็นค่าว่าง");
    }

    return {
      'question': question['question'],
      'a': question['a'].toString().isNotEmpty ? question['a'] : '',
      'b': question['b'].toString().isNotEmpty ? question['b'] : '',
      'c': question['c'].toString().isNotEmpty ? question['c'] : '',
      'd': question['d'].toString().isNotEmpty ? question['d'] : '',
      'e': question['e']?.toString() ?? '', 
      'f': question['f']?.toString() ?? '',
      'g': question['g']?.toString() ?? '',
      'h': question['h']?.toString() ?? '',
      'answer': convertAnswer(question['answer']), 
    };
  }).toList();

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: jsonEncode({
        'examsetsId': examsetsId.toString(),
        'questions': convertedQuestions,
      }),
      headers: {'Content-Type': 'application/json'}, 
    );

    print('------------------------------------------------------------------');
    print('ExamsetID: ${examsetsId.toString()}');
    print('คำถามและตัวเลือก: $convertedQuestions');
    print('ข้อความส่งกลับ ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['error'] != null) {
        throw Exception("Failed: ${data['error']}");
      }


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ข้อมูลบันทึกสำเร็จ!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      print("Server error: ${response.statusCode}");
    }
  } catch (error) {
    print("Error while saving questions and choices: $error");
    
  
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('เกิดข้อผิดพลาด: $error'),
        backgroundColor: Colors.red,
      ),
    );
    
    rethrow;
  }
}


void _saveQuestion(int index) {
  if (_questions.isEmpty) {
    print('_questions ว่าง');
    return;
  }

  if (_savedQuestions.isEmpty) {
    print('_savedQuestions ว่าง');
  }

  // Ensure that the index is valid
  if (_questions.isNotEmpty && index >= 0 && index < _questions.length) {
    if (_isQuestionFilled(index)) { 
      setState(() {
        _savedQuestions.add(_questions[index]);
        _questions.removeAt(index); 
      });

      print("คำถามที่บันทึก _savedQuestions: ${_savedQuestions.last.questionController.text}");

      for (var i = 0; i < _savedQuestions.last.choices.length; i++) {
        print("ตัวเลือก ${_savedQuestions.last.choices[i].label}: ${_savedQuestions.last.choices[i].controller.text}");
      }

      print("คำตอบที่ถูกต้อง _savedQuestions: ${_savedQuestions.last.selectedAnswers}");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('กรุณากรอกคำถาม ตัวเลือก และเลือกคำตอบที่ถูกต้อง'))
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('กรุณาเลือกคำถามที่ถูกต้อง'))
    );
  }
}

bool _isQuestionFilled(int index) {
  var question = _questions[index];
  // ignore: unnecessary_null_comparison
  bool isAnswerSelected = question.selectedAnswers != null;
  bool areChoicesFilled = question.choices.every((choice) => choice.controller.text.isNotEmpty);

  return isAnswerSelected && areChoicesFilled;
}




  @override
  void initState() {
    super.initState();
     _addNewQuestion();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  void _addNewQuestion() {
    setState(() {
      _questions.add(Question());
    });
  }

  void _addChoice(int index) {
    setState(() {
      _questions[index].choices.add(Choice(_questions[index]._nextChoiceLabel()));
    });
  }

  

  void _editmanyQuestion(int index) {
      setState(() {
        _questions.add(_savedQuestions[index]); 
        _savedQuestions.removeAt(index); 
      });
    }

    void _deletemanyQuestion(int index) {
      setState(() {
        _savedQuestions.removeAt(index); 
      });
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
        key: formKey,
        child: Column(
          children: [

            //คำสั่ง------------------------------------------------
           Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.symmetric(vertical: 5),
              child: TextFormField(
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
            ),


            //ปุ่มมอบหมายงาน-------------------------------------------------
            Padding(padding: EdgeInsets.fromLTRB(20,10,20,10),
              child:  Row(
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
                ),),

                Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: _submitAssignment,
                          child: Text('มอบหมายงาน'),
                        ),
                      ),
                    ),


            Container(
              height: MediaQuery.of(context).size.height * 0.9,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: ListView(
                children: [
                  ..._questions.asMap().entries.map((entry) {
                    int index = entry.key;
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: _buildQuestionCard(index),
                    );
                  }),
                  Divider(),
                  _savedQuestions.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ตัวอย่างข้อสอบ:',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              ..._savedQuestions.asMap().entries.map((entry) {
                                int index = entry.key;
                                Question question = entry.value;
                                return _buildExamQuestion(question, index); // เพิ่ม index เข้าไป
                              }),

                            ],
                          ),
                        )
                      : Container(),
                ],
              ),
            ),

            

          ],
        ),
        )
      ),
      
      
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewQuestion,
        tooltip: 'เพิ่มคำถามใหม่',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildQuestionCard(int index) {
  final question = _questions[index];

  return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: question.questionController,
              decoration: InputDecoration(
                labelText: 'เขียนคำถามข้อที่ ${index + 1}',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'กรุณากรอกคำถาม';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            Text(
              'ตัวเลือก:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            for (int i = 0; i < question.choices.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Text('${question.choices[i].label}.', style: TextStyle(fontSize: 16)),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: question.choices[i].controller,
                        decoration: InputDecoration(
                          hintText: 'ตัวเลือกที่ ${question.choices[i].label}',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'กรุณากรอกตัวเลือกที่ ${question.choices[i].label}';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _addChoice(index),
              child: Text('เพิ่มตัวเลือก'),
            ),
            SizedBox(height: 20),
            Text(
              'เลือกคำตอบที่ถูกต้อง:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            for (int i = 0; i < question.choices.length; i++)
              CheckboxListTile(
                title: Text('ตัวเลือก ${question.choices[i].label}'),
                value: question.selectedAnswers.contains(question.choices[i].label),
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      question.selectedAnswers.add(question.choices[i].label);
                    } else {
                      question.selectedAnswers.remove(question.choices[i].label);
                    }
                  });
                },
              ),
            ElevatedButton(
              onPressed: () => _saveQuestion(index),
              child: Text('บันทึกคำถาม'),
            ),
          ],
        ),
    ),
  );
}


  Widget _buildExamQuestion(Question question, int index) {
    int questionIndex = _savedQuestions.indexOf(question);
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [

                Text(
                  'ข้อที่ ${index + 1}: ', 
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Text(
                    question.questionController.text,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                

                IconButton(
                  onPressed: () => _editmanyQuestion(questionIndex),
                  icon: Icon(Icons.edit, color: Colors.black,)
                ),

                IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deletemanyQuestion(questionIndex)
              ),

              ],
            ),
            
            SizedBox(height: 10),
            ...question.choices.map((choice) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text('${choice.label}. ${choice.controller.text}'),
              );
            }),
            SizedBox(height: 10),
            Text(
              'คำตอบที่ถูกต้อง: ${question.selectedAnswers.isNotEmpty ? question.selectedAnswers.join(", ") : "ยังไม่ได้เลือก"}',
              style: TextStyle(fontSize: 16, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}


//---------------------------------------------------------
class Question {
  TextEditingController questionController = TextEditingController();
  List<Choice> choices = [
    Choice('ก'),
    Choice('ข'),
    Choice('ค'),
    Choice('ง'),
  ];
  List<String> selectedAnswers = [];

  void addChoice() {
    if (choices.length < 8) {
      choices.add(Choice(_nextChoiceLabel()));
    }
  }

  void removeChoice(int index) {
    if (choices.length > 4) {
      choices[index].dispose();
      choices.removeAt(index);
    }
  }

  String _nextChoiceLabel() {
    final labels = ['ก', 'ข', 'ค', 'ง', 'จ', 'ฉ', 'ช', 'ซ'];
    return labels[choices.length % labels.length];
  }

  void dispose() {
    questionController.dispose();
    for (var choice in choices) {
      choice.dispose();
    }
  }
}

class Choice {
  String label;
  TextEditingController controller = TextEditingController();

  Choice(this.label);

  void dispose() {
    controller.dispose();
  }
}