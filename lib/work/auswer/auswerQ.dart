import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:flutter_esclass_2/work/asign_work_T.dart';
import 'package:flutter_esclass_2/work/auswer/ClassroomSearchDialog.dart';
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

  const 
  Auswer_Question({
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
  TextEditingController fullMarkinauswerController = TextEditingController();
  TextEditingController defaultMark = TextEditingController();

  List<TextEditingController> questionControllers = [];
  List<TextEditingController> markControllers = [];
  List<int> questionMarks = []; 
  final List<String> _questions = [];
  String? selectedDueDate;
  DateTime? _dueDate;
  int? totalMark;
  String? _direction;
  int? _fullMarks;
  bool isChecked = false;
  bool isCheckeddueDate = false;
  final List<Map<String, dynamic>> _selectedClassrooms = [];


  
Future<int?> saveAssignment({
    required String direction,
    required int fullMark,
    required DateTime deadline,
    required String username,
    required String classroomName,
    required String classroomMajor,
    required String classroomYear,
    required String classroomNumRoom, 
    required String isClosed,
}) async {
  const String apiUrl = "https://www.edueliteroom.com/connect/auswer_direction.php";

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

    print('Sending fullMark: ${fullMark.toString()}');
    print(response.body);

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
        throw Exception("Failed to save assignment: ${data['message']}");
      }
    } else {
      throw Exception("Server error: ${response.statusCode}");
    }
  } catch (error) {
    print("Error: $error");
    return null;
  }
}


void _submitAssignmentsForClassrooms() async {
  if (formKey.currentState!.validate()) {
    formKey.currentState!.save();

    final direction = _direction;
    final fullMark = _fullMarks;
    final deadline = _dueDate;
    final isClosed = isCheckeddueDate ? 'Yes' : 'No'; 

    if (direction != null && fullMark != null && deadline != null) {
      try {
        // วนลูปผ่านห้องเรียนที่เลือก
        for (var classroom in _selectedClassrooms) {
          final examsetsId = await saveAssignment(
            direction: direction,
            fullMark: fullMark,
            deadline: deadline,
            username: widget.username,
            classroomName: classroom['classroom_name'],  // ใช้ชื่อห้องเรียนที่เลือก
            classroomMajor: classroom['classroom_major'],  // ใช้สาขาวิชาของห้องเรียนที่เลือก
            classroomYear: classroom['classroom_year'],  // ใช้ปีการศึกษาของห้องเรียนที่เลือก
            classroomNumRoom: classroom['classroom_numroom'],  // ใช้หมายเลขห้องเรียน
            isClosed: isClosed, 
          );

          if (examsetsId != null) {
            // เมื่อบันทึกเสร็จแล้ว จะส่งคำถามหรือทำการเปลี่ยนหน้าจอ
            await _submitQuestions(examsetsId);
          } else {
            throw Exception('Failed to save assignment for classroom: ${classroom['classroom_name']}');
          }
        }

        // ไปยังหน้าถัดไปหลังจากบันทึกเสร็จ
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AssignWork_class_T(
              username: widget.username,
              thfname: widget.thfname,
              thlname: widget.thlname,
              classroomMajor: widget.classroomMajor,
              classroomName: widget.classroomName,
              classroomNumRoom: widget.classroomNumRoom,
              classroomYear: widget.classroomYear,
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('กรุณากรอกคำสั่งงานและคะแนนเต็มให้ครบถ้วน'), backgroundColor: Colors.red),
      );
    }
  }
}


Future<void> _submitQuestions(int examsetsId) async {
  try {
    List<Map<String, dynamic>> questionData = [];
    for (int i = 0; i < _questions.length; i++) {
      final questionScore = isChecked
          ? int.tryParse(defaultMark.text) ?? 0
          : int.tryParse(markControllers[i].text) ?? 0;

      questionData.add({
        'question_detail': _questions[i],
        'auswer_question_score': questionScore,
      });

      print('Question: ${_questions[i]}, Score: $questionScore');
    }

    final response = await http.post(
      Uri.parse('https://www.edueliteroom.com/connect/auswer_question.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'examsets_id': examsetsId,
        'questions': questionData,
      }),
    );

    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('บันทึกคำสั่งงานเรียบร้อย'),
          backgroundColor: Colors.green,
        ));
      } else {
        throw Exception('Failed to add questions: ${data['message']}');
      }
    } else {
      throw Exception('HTTP error: ${response.statusCode}');
    }
  } catch (e) {
    print('Request error: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
    );
  }
}



 
  @override
  void initState() {
    super.initState();
    fullMarksController.text = _fullMarks?.toString() ?? '';
     _selectedClassrooms.add({
      'classroom_name': widget.classroomName,
      'classroom_major': widget.classroomMajor,
      'classroom_year': widget.classroomYear,
      'classroom_numroom': widget.classroomNumRoom,
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

void updateTotalMarks() {
  int sum = 0;

 
  if (isChecked) {
    
    sum = (int.tryParse(defaultMark.text) ?? 0) * _questions.length;
  } else {
    
    for (int i = 0; i < questionMarks.length; i++) {
      sum += questionMarks[i];
    }
  }

  setState(() {
    totalMark = sum;
  });
}


  void _addQuestion() {
    String questionText = questionTextController.text;
    int questionMark = int.tryParse(fullMarkinauswerController.text) ?? 0;
    questionMarks.add(questionMark); 

    if (questionText.isNotEmpty) {
      setState(() {
        _questions.add(questionText);
        updateTotalMarks();
        questionControllers.add(TextEditingController(text: questionTextController.text));
        markControllers.add(TextEditingController(text: fullMarkinauswerController.text));
        if (!isChecked) fullMarkinauswerController.clear();
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
      questionControllers[index].dispose();
      markControllers[index].dispose();
      questionControllers.removeAt(index);
      markControllers.removeAt(index);
    });
  }
  
  @override
  void dispose() {
    fullMarksController.dispose(); 
    super.dispose();
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
              mainAxisSize: MainAxisSize.min,
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
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: const InputDecoration(labelText: 'คะแนนเต็ม'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'กรุณากรอกคะแนนเต็ม';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _fullMarks = int.tryParse(value ?? '') ?? 0; 
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
                ),

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
                                        fullMarkinauswerController.text = defaultMark.text;
                                      } else {
                                        fullMarkinauswerController.clear();
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
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    enabled: isChecked, 
                                    onChanged: (value) {
                                      if (isChecked) {
                                        setState(() {
                                          fullMarkinauswerController.text = value;
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
                                      defaultMark.text = value ?? '';
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

                     return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: TextField(
                                controller: questionControllers[index],
                                readOnly: true,
                                decoration: const InputDecoration(border: InputBorder.none),
                              ),
                            ),
                            SizedBox(width: 10),
                            Row(
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: TextFormField(
                                    controller: markControllers[index],
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    decoration: const InputDecoration(labelText: 'คะแนน'),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      if (!isChecked) {
                                        setState(() {
                                          
                                        });
                                      }
                                    },
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    _editQuestion(index);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    _removeQuestion(index);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),

                              
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_questions.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('กรุณาเพิ่มคำถามอย่างน้อย 1 ข้อก่อนมอบหมายงาน'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } else {
                              final enteredFullMarks = int.tryParse(fullMarksController.text) ?? 0;

                              // ตรวจสอบคะแนนรวมว่าเข้ากันไหม
                              if (totalMark != enteredFullMarks) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'คะแนนรวมทั้งหมด ($totalMark) ไม่ตรงกับคะแนนเต็ม (${fullMarksController.text})',
                                    ),
                                    backgroundColor: Colors.red,
                                    duration: const Duration(seconds: 3),
                                  ),
                                );
                              } else {
                                // เรียกฟังก์ชันมอบหมายงาน
                                _submitAssignmentsForClassrooms();
                              }
                            }
                          },
                          child: const Text('มอบหมายงาน'),
                        ),
                      ),
                    ),

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
                        isChecked 
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        'คะแนน: ${defaultMark.text.isNotEmpty ? defaultMark.text : '0'}',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  : SizedBox(
                                      width: 100,
                                      child: TextFormField(
                                        controller: fullMarkinauswerController,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                        ],
                                        decoration: InputDecoration(
                                          labelText: 'คะแนน',
                                        ),
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          if (!isChecked) {
                                            setState(() {
                                              
                                            });
                                          }
                                        },
                                      ),
                                    ),
                      
                        
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            if (questionTextController.text.isEmpty || fullMarkinauswerController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบทุกช่อง')),
                              );
                            } else {
                              _addQuestion();
                            }
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),
                
                  ],
                ),               
              ],
            ),
          ),
        ),
      ),
    );
  }
}
