import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:flutter_esclass_2/work/asign_work_T.dart';
import 'package:flutter_esclass_2/work/auswer/ClassroomSearchDialog.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OneChoice_test extends StatefulWidget {
  final Examset exam;
  final String username;
  final String thfname;
  final String thlname;
  final String classroomName;
  final String classroomMajor;
  final String classroomYear;
  final String classroomNumRoom;
  const OneChoice_test({
    super.key, 
    required this.exam,
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
  late double _fullMarks = 0.0;
  String? selectedDueDate;
  DateTime? _dueDate;
  bool isLoading = false;
  double? totalMark;
  bool isChecked = false;
  bool isCheckeddueDate = false;
  final List<Map<String, dynamic>> _selectedClassrooms = [];


  final TextEditingController fullMarksController = TextEditingController();
  final TextEditingController defaultMark = TextEditingController();

  Future<int?> saveAssignment({
    required String direction,
    required double fullMark,
    required DateTime deadline,
    required String username,
    required String classroomName,
    required String classroomMajor,
    required String classroomYear,
    required String classroomNumRoom,
    required String isClosed,
  }) async {
    const String apiUrl = "https://www.edueliteroom.com/connect/onechoice_direction.php";

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
          "isClosed": isClosed,
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

    final isClosed = isCheckeddueDate ? 'Yes' : 'No'; 

    if (_direction != null && _dueDate != null && _selectedClassrooms.isNotEmpty) {
      setState(() => isLoading = true);

      try {
        for (final classroom in _selectedClassrooms) {
          // ดึงข้อมูลคลาสเรียนแต่ละรายการ
          final classroomName = classroom['classroom_name'];
          final classroomMajor = classroom['classroom_major'];
          final classroomYear = classroom['classroom_year'];
          final classroomNumRoom = classroom['classroom_numroom'];

          // บันทึกการบ้านและรับ `examsetsId` สำหรับคลาสนั้น
          final examsetsId = await saveAssignment(
            direction: _direction!,
            fullMark: _fullMarks,
            deadline: _dueDate!,
            username: widget.username,
            classroomName: classroomName,
            classroomMajor: classroomMajor,
            classroomYear: classroomYear,
            classroomNumRoom: classroomNumRoom,
            isClosed: isClosed,
          );

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
                    'score': question.fullMarkinchoiceController.text
                  });
                } else {
                  debugPrint('ตัวเลือกไม่ครบหรือว่างสำหรับคำถาม: ${question.questionController.text}');
                }
              } else {
                debugPrint('คำถามไม่ครบถ้วน: ${question.questionController.text}');
              }
            }

            if (questionsAndChoices.isNotEmpty) {
              
              await saveQuestionsAndChoices(examsetsId, questionsAndChoices);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('กรุณากรอกคำถามและตัวเลือกให้ครบถ้วน'),
                backgroundColor: Colors.red,
              ));
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('ไม่สามารถบันทึกการบ้านได้สำหรับ $classroomName'),
              backgroundColor: Colors.red,
            ));
          }
        }

        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AssignWork_class_T(
            username: widget.username,
            thfname: widget.thfname,
            thlname: widget.thlname,
            exam: widget.exam, 
            classroomMajor: widget.classroomMajor,
            classroomName: widget.classroomName,
            classroomNumRoom: widget.classroomNumRoom,
            classroomYear: widget.classroomYear,
          )),
        );

      } catch (e) {
        print(' $e');

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
      return answer;  
  }
}

Future<void> saveQuestionsAndChoices(
  int examsetsId, List<Map<String, dynamic>> questionsAndChoices) async {
  const String apiUrl = "https://www.edueliteroom.com/connect/onechoice_question.php";

  
  if (examsetsId <= 0) {
    throw Exception('Invalid or missing examsetsId');
  }

  
  if (questionsAndChoices.isEmpty) {
    throw Exception('Invalid or missing questions data');
  }

  
  List<Map<String, dynamic>> convertedQuestions = questionsAndChoices.map((question) {
    return {
      'question': question['question'],  
      'a': question['a'],                
      'b': question['b'],               
      'c': question['c'],           
      'd': question['d'],   
      'answer': convertAnswer(question['answer']),
      'score': double.tryParse(question['score'].toString()) ?? 0 
    };
  }).toList();

  
  print('Sending JSON to server: ${jsonEncode({
    'examsetsId': examsetsId,
    'questions': convertedQuestions,
  })}');

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: jsonEncode({
        'examsetsId': examsetsId,
        'questions': convertedQuestions, 
      }),
      headers: {'Content-Type': 'application/json'},  
    );

  
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
      print("Server response body: ${response.body}");
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
  

  
  if (_questions.isNotEmpty && index >= 0 && index < _questions.length) {
    if (_isQuestionFilled(index)) { 
      setState(() {
        _savedQuestions.add(_questions[index]);
        _questions.removeAt(index); 
        _calculateTotalMarks();
      });

      print("คำถามที่บันทึก: ${_savedQuestions.last.questionController.text}");

      for (var i = 0; i < _savedQuestions.last.choices.length; i++) {
        print("ตัวเลือก ${_savedQuestions.last.choices[i].label}: ${_savedQuestions.last.choices[i].controller.text}");
      }

      print("คำตอบที่ถูกต้อง: ${_savedQuestions.last.selectedAnswer}");
      print("คะแนน: ${_savedQuestions.last.fullMarkinchoiceController.text}");
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
    _questions.add(_savedQuestions[index]);
    _savedQuestions.removeAt(index); 
  });
}

void _deleteQuestion(int index) {
  setState(() {
    _savedQuestions.removeAt(index); 
    
  });
  _calculateTotalMarks();
}

 @override
  void initState() {
    super.initState();
    _addNewQuestion(); 
    _selectedClassrooms.add({
      'classroom_name': widget.classroomName,
      'classroom_major': widget.classroomMajor,
      'classroom_year': widget.classroomYear,
      'classroom_numroom': widget.classroomNumRoom,
    });
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

  void _calculateTotalMarks() {
    setState(() {
      totalMark = _savedQuestions.fold<double>(0.0, (sum, question) {
        double questionMark = double.tryParse(question.fullMarkinchoiceController.text) ?? 0.0;
        return sum + questionMark;
      });
      
      // หาก totalMark เป็น 0 จะตั้งค่าให้เป็น null
      if (totalMark == 0.0) {
        totalMark = null;
      } else {
        // แปลง totalMark ให้เป็นทศนิยม 2 ตำแหน่ง
        totalMark = double.parse(totalMark!.toStringAsFixed(2));
      }
    });
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
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'กรุณากรอกคะแนนเต็ม';
                          }
                          final number = double.tryParse(value);
                          if (number == null) {
                            return 'กรุณากรอกตัวเลขที่ถูกต้อง';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          if (value != null && value.isNotEmpty) {
                            _fullMarks = double.parse(double.parse(value).toStringAsFixed(2));
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 14),
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

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: isCheckeddueDate,
                          onChanged: (bool? value) {
                            setState(() {
                              isCheckeddueDate = value ?? false;
                            });
                          },
                        ),
                        Text(
                          'ปิดรับงานเมื่อครบกำหนด',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),

                    
                  ],
                ),),
                
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Checkbox(
                                value: isChecked,
                                onChanged: (bool? value) {
                                  if (value != null) {
                                    setState(() {
                                      isChecked = value;

                                      if (isChecked) {
                                        for (var question in _questions) {
                                           if (defaultMark.text.isNotEmpty) {
                                              question.fullMarkinchoiceController.text = defaultMark.text;
                                            }
                                        }
                                      }
                                    });
                                  }
                                },
                              ),

                              Text('กำหนดคะแนนเริ่มต้น'),
                              SizedBox(width: 10,),
                              SizedBox(
                                width: 100,
                                child: TextFormField(
                                  controller: defaultMark,
                                  decoration: const InputDecoration(labelText: 'คะแนนเต็ม'),
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                                  ],
                                  enabled: isChecked, 
                                  onChanged: (value) {
                                      if (isChecked) {
                                        setState(() {
                                          for (var question in _questions) {
                                            question.fullMarkinchoiceController.text = value;
                                          }
                                        });
                                      }
                                    },
                                  validator: (value) {
                                    if (isChecked) {
                                      if (value == null || value.isEmpty) {
                                        return 'กรุณากรอกคะแนนเต็ม';
                                      }
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    if (value != null && value.isNotEmpty) {
                                        defaultMark.text = double.parse(value).toStringAsFixed(2);
                                      }
                                  },
                                ),
                              ),
                            ],
                          )
                        ),
                          
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'คะแนนรวมทั้งหมด:',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 10),
                              Text(
                                totalMark != null && totalMark! > 0
                                    ? '$totalMark คะแนน'
                                    : 'ยังไม่มีการกรอกคะแนนในแต่ละข้อ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: totalMark != null && totalMark! > 0 ? Colors.green : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],    
                    ),
                ),   

                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start, 
                    children: [
                      IconButton(
                            onPressed: () async {
                              final selectedClassrooms = await showDialog<List<Map<String, dynamic>>>(
                                context: context,
                                builder: (BuildContext context) {
                                  return ClassroomSearchDialog(
                                    initialSelectedClassrooms: _selectedClassrooms, username: widget.username, 
                                  );
                                },
                              );

                              if (selectedClassrooms != null) {
                                setState(() {
                                  _selectedClassrooms.addAll(selectedClassrooms); 
                                });
                              }
                            },
                            icon: const Icon(Icons.add),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "เพิ่มห้องเรียน",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _selectedClassrooms.length,
                      itemBuilder: (context, index) {
                        final classroom = _selectedClassrooms[index];
                        return ListTile(
                          title: Text(
                            '${classroom['classroom_name']} - ${classroom['classroom_major']} ',
                          ),
                          subtitle: Text(
                            'ม. ${classroom['classroom_year']}/${classroom['classroom_numroom']}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                            
                              setState(() {
                                _selectedClassrooms.removeAt(index);
                              });
                            },
                          ),
                        );
                      },
                    ),
                            
                Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    
                    final enteredFullMarks = double.tryParse(fullMarksController.text) ?? 0.0;
                    final calculatedTotalMark = totalMark ?? 0.0;

                    
                    if (calculatedTotalMark.toStringAsFixed(2) !=
                        enteredFullMarks.toStringAsFixed(2)) {
                          print('คะแนนรวมทั้งหมด (${calculatedTotalMark.toStringAsFixed(2)}) ไม่ตรงกับคะแนนเต็ม (${enteredFullMarks.toStringAsFixed(2)})');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'คะแนนรวมทั้งหมด (${calculatedTotalMark.toStringAsFixed(2)}) '
                            'ไม่ตรงกับคะแนนเต็ม (${enteredFullMarks.toStringAsFixed(2)})',
                          ),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    } else {
                      _submitAssignment();
                    }
                  },
                  child: const Text('มอบหมายงาน'),
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
            if (!isChecked)
              SizedBox(
                width: 100,
                child: TextFormField(
                  controller: question.fullMarkinchoiceController,
                  inputFormatters: [
                     FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}$')),
                  ],
                  decoration: InputDecoration(
                    labelText: 'คะแนน',
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              )
            else 
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'คะแนน: ${defaultMark.text.isNotEmpty ? defaultMark.text : '0.00'}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ElevatedButton(
              onPressed: () {

                // ตรวจสอบสถานะ isChecked และตั้งค่าคะแนน
                if (isChecked) {
                  question.fullMarkinchoiceController.text = defaultMark.text;
                }
                // ตรวจสอบว่ามีการป้อนคะแนนหรือไม่
                if (question.fullMarkinchoiceController.text.isEmpty) {
                  // แสดงข้อความแจ้งเตือน
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('กรุณาป้อนคะแนนก่อนบันทึกคำถาม'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                

                // บันทึกคำถาม
                _saveQuestion(index);
              },
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
                  child: Text(' ${question.questionController.text} (${question.fullMarkinchoiceController.text} คะแนน)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),),
            


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
            Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
            
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
  final TextEditingController fullMarkinchoiceController = TextEditingController();
  final List<Choice> choices = [
    Choice(label: 'ก'),
    Choice(label: 'ข'),
    Choice(label: 'ค'),
    Choice(label: 'ง'),
  ];
  String? selectedAnswer;

  // แปลงข้อมูลเป็น Map สำหรับส่งไปยังเซิร์ฟเวอร์
  Map<String, dynamic> toMap() {
    // ตรวจสอบข้อมูลว่าไม่เป็นค่าว่าง
    List<Map<String, dynamic>> choicesData = choices.map((choice) {
      return {
        'label': choice.label,
        'answer': choice.controller.text.isNotEmpty
            ? choice.controller.text
            : 'ยังไม่ได้กรอกข้อมูล',
      };
    }).toList();

    return {
      'question': questionController.text.isNotEmpty
          ? questionController.text
          : 'ยังไม่ได้กรอกข้อมูล', // ตรวจสอบกรอกคำถาม
      'selectedAnswer': selectedAnswer ?? 'ยังไม่ได้เลือกคำตอบ',
      'choices': choicesData,
      'score': fullMarkinchoiceController.text.isNotEmpty
          ? fullMarkinchoiceController.text
          : '0', // ตรวจสอบคะแนน
    };
  }

  // ฟังก์ชัน toString เพื่อแสดงข้อมูลคำถามและตัวเลือก
  @override
  String toString() {
    String choicesString = choices.map((choice) {
      return '${choice.label}: ${choice.controller.text}';
    }).join(', ');

    return 'Question: ${questionController.text}, Selected Answer: $selectedAnswer, Full Mark: ${fullMarkinchoiceController.text}, Choices: [$choicesString]';
  }
}

class Choice {
  final String label;
  final TextEditingController controller = TextEditingController();

  Choice({required this.label});

  // ฟังก์ชัน toString เพื่อแสดงข้อมูลของตัวเลือก
  @override
  String toString() {
    return 'Label: $label, Answer: ${controller.text}';
  }
}


