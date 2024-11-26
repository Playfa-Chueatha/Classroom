import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_esclass_2/work/asign_work_T.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OneChoice_test extends StatefulWidget {
  final String username;
  final String thfname;
  final String thlname;
  final String classroomName;
  final String classroomMajor;
  final String classroomYear;
  final String classroomNumRoom;
  const OneChoice_test({
    super.key, 
    required this.username, 
    required this.thfname, 
    required this.thlname, 
    required this.classroomName, 
    required this.classroomMajor, 
    required this.classroomYear, 
    required this.classroomNumRoom
  });

  @override
  _OneChoiceState createState() => _OneChoiceState();
}

class _OneChoiceState extends State<OneChoice_test> with SingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  final List<Question> _questions = []; 
  final List<Question> _savedQuestions = []; 
  List<String> questionsAndChoices = [];
  String? _direction;
  int? _fullMarks;
  String? selectedDueDate;
  DateTime? _dueDate;
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
    const String apiUrl = "https://www.edueliteroom.com/connect/onechoice_direction.php";

    // print("Sending data to PHP: ");
    // print("Direction: $direction");
    // print("FullMark: $fullMark");
    // print("Deadline: ${DateFormat('yyyy-MM-dd').format(deadline)}");
    // print("Username: $username");
    // print("ClassroomName: $classroomName");
    // print("ClassroomMajor: $classroomMajor");
    // print("ClassroomYear: $classroomYear");
    // print("ClassroomNumRoom: $classroomNumRoom");

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

      // print("Response status: ${response.statusCode}");
      // print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          final examsetsAuto = int.tryParse(data['examsets_auto']);

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
        // บันทึกการบ้านและรับ examsetsId
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
        if (examsetsId != null) {
          List<Map<String, dynamic>> questionsAndChoices = [];

          // เพิ่มคำถามและตัวเลือก
          for (var question in _savedQuestions) {
            int index = _savedQuestions.indexOf(question);
            if (index >= 0 && question.choices.length == 4) {
              if (question.choices.every((choice) => choice.controller.text.isNotEmpty)) {
                questionsAndChoices.add({
                  'question': question.questionController.text,
                  'a': question.choices[0].controller.text,
                  'b': question.choices[1].controller.text,
                  'c': question.choices[2].controller.text,
                  'd': question.choices[3].controller.text,
                  'answer': question.selectedAnswer,
                });

              } else {
                debugPrint('ตัวเลือกไม่ครบหรือว่างสำหรับคำถาม: ${question.questionController.text}');
                for (var choice in question.choices) {
                  debugPrint('Choice Label: ${choice.label}, Text: ${choice.controller.text}');
                }
              }
            } else {
              debugPrint('คำถามไม่ครบถ้วน: ${question.questionController.text}');
            }
          }

          // print('$questionsAndChoices');
          if (questionsAndChoices.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('กรุณากรอกคำถามและตัวเลือกให้ครบถ้วน'),
              backgroundColor: Colors.red,
            ));
            return;
          }

          // ส่งข้อมูลคำถามไปยัง PHP
          await saveQuestionsAndChoices(examsetsId, questionsAndChoices);

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
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('ไม่สามารถบันทึกการบ้านได้'),
            backgroundColor: Colors.red,
          ));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ));
      } finally {
        setState(() => isLoading = false); // หยุดการโหลด
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
  switch (answer) {
    case 'ก':
      return 'a';
    case 'ข':
      return 'b';
    case 'ค':
      return 'c';
    case 'ง':
      return 'd';
    default:
      return answer;  // หากไม่พบค่าให้ส่งคืนค่าเดิม
  }
}

Future<void> saveQuestionsAndChoices(
  int examsetsId, List<Map<String, dynamic>> questionsAndChoices) async {
  const String apiUrl = "https://www.edueliteroom.com/connect/onechoice_question.php";

  // แปลงค่าตัวเลือกและคำตอบให้เป็น JSON
  List<Map<String, dynamic>> convertedQuestions = questionsAndChoices.map((question) {
    return {
      'question': question['question'],
      'a': question['a'],
      'b': question['b'],
      'c': question['c'],
      'd': question['d'],
      'answer': convertAnswer(question['answer']),  // แปลงคำตอบเป็น a, b, c, d
    };
  }).toList();

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: jsonEncode({
        'examsetsId': examsetsId.toString(),
        'questions': convertedQuestions,  // ไม่ต้องแปลงเป็น JSON ซ้ำ
      }),
      headers: {'Content-Type': 'application/json'},  // ระบุ Content-Type เป็น application/json
    );

    print('------------------------------------------------------------------');
    print('ExamsetID: ${examsetsId.toString()}');
    print('คำถามและตัวเลือก: $convertedQuestions');
    print('ข้อความส่งกลับ ${response.body}');
    print('Sending JSON: ${jsonEncode({
            'examsetsId': examsetsId.toString(),
            'questions': jsonEncode(convertedQuestions),
          })}');


    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['error'] != null) {
        throw Exception("Failed: ${data['error']}");
      }

      // แจ้งเตือนเมื่อบันทึกข้อมูลสำเร็จ
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
    
    // แจ้งเตือนเมื่อเกิดข้อผิดพลาด
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

      print("คำถามที่บันทึก: ${_savedQuestions.last.questionController.text}");

      for (var i = 0; i < _savedQuestions.last.choices.length; i++) {
        print("ตัวเลือก ${_savedQuestions.last.choices[i].label}: ${_savedQuestions.last.choices[i].controller.text}");
      }

      print("คำตอบที่ถูกต้อง: ${_savedQuestions.last.selectedAnswer}");
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
  bool isAnswerSelected = question.selectedAnswer != null;
  bool areChoicesFilled = question.choices.every((choice) => choice.controller.text.isNotEmpty);

  return isAnswerSelected && areChoicesFilled;
}






void _editQuestion(int index) {
  setState(() {
    _questions.add(_savedQuestions[index]); // เพิ่มคำถามที่เลือกกลับไปยัง _questions เพื่อแก้ไข
    _savedQuestions.removeAt(index); // ลบคำถามที่เลือกจาก _savedQuestions
  });
}

void _deleteQuestion(int index) {
  setState(() {
    _savedQuestions.removeAt(index); // ลบคำถามที่เลือกจาก _savedQuestions
  });
}

 @override
  void initState() {
    super.initState();
    _addNewQuestion(); 
  }

  @override
  void dispose() {
    fullMarksController.dispose();
    super.dispose();
  }


 

  void _addNewQuestion() {
    setState(() {
      _questions.add(Question());
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
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _questions.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _buildQuestionCard(index),
                  );
                },
              ),
            ),

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
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _savedQuestions.length,
                      itemBuilder: (context, index) {
                        return _buildExamQuestion(_savedQuestions[index], index);
                      },
                    ),
                  ],
                ),
              )
            : Container(),

          ],
        ),
      ),),

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
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 20),
            Text(
              'เลือกคำตอบที่ถูกต้อง:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            for (int i = 0; i < question.choices.length; i++)
              RadioListTile<String>(
                title: Text('ตัวเลือก ${question.choices[i].label}'),
                value: question.choices[i].label,
                groupValue: question.selectedAnswer,
                onChanged: (String? value) {
                  setState(() {
                    question.selectedAnswer = value;
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
                  'ข้อที่ ${index + 1}: ', // แสดงหมายเลขข้อ
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Text(
                    question.questionController.text,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  onPressed: () => _editQuestion(questionIndex), 
                  icon: Icon(Icons.edit, color: Colors.black,)
                ),

                IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteQuestion(questionIndex),
              ),
              ],
            ),            
            SizedBox(height: 10),
            for (int i = 0; i < question.choices.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text('${question.choices[i].label}: ${question.choices[i].controller.text}'),
              ),
            SizedBox(height: 10),
            Text(
              'คำตอบที่ถูกต้อง: ${question.selectedAnswer}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}


//Data-----------------------------------------------------------
class Question {
  final TextEditingController questionController = TextEditingController();
  final List<Choice> choices = [
    Choice(label: 'ก'),
    Choice(label: 'ข'),
    Choice(label: 'ค'),
    Choice(label: 'ง'),
  ];
  String? selectedAnswer;

  // ฟังก์ชันเพื่อเตรียมข้อมูลให้พร้อมสำหรับการส่งไปยังฐานข้อมูล
  Map<String, dynamic> toMap() {
  List<Map<String, dynamic>> choicesData = choices.map((choice) {
    return {
      'label': choice.label,
      'answer': choice.controller.text.isNotEmpty
          ? choice.controller.text
          : 'ยังไม่ได้กรอกข้อมูล',
    };
  }).toList();

  return {
    'question': questionController.text,
    'selectedAnswer': selectedAnswer,
    'choices': choicesData,
  };
}


  // เพิ่มฟังก์ชัน toString เพื่อแสดงข้อมูลคำถามและตัวเลือก
  @override
  String toString() {
    String choicesString = choices.map((choice) {
      return '${choice.label}: ${choice.controller.text}';
    }).join(', ');

    return 'Question: ${questionController.text}, Selected Answer: $selectedAnswer, Choices: [$choicesString]';
  }
}


class Choice {
  final String label;
  final TextEditingController controller = TextEditingController();

  Choice({required this.label});

  // เพิ่มฟังก์ชัน toString เพื่อแสดงข้อมูลของตัวเลือก
  @override
  String toString() {
    return 'Label: $label, Answer: ${controller.text}';
  }
}

