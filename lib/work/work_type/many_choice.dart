import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_esclass_2/Data/Data_assignwork.dart';
import 'package:flutter_esclass_2/work/asign_work_T.dart';
import 'package:intl/intl.dart';

class many_choice extends StatefulWidget {
  const many_choice({super.key});

  @override
  _many_choice createState() => _many_choice();
}

class _many_choice extends State<many_choice> with SingleTickerProviderStateMixin {
  final List<Question> _questions = []; 
  final List<Question> _savedQuestions = []; 
  String _direction = '';
  int _fullMarks = 0;
  bool _isAssignmentVisible = false;
  late AnimationController _controller;
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

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
      _questions[index].choices.add(Choice(_questions[index].nextChoiceLabel()));
    });
  }

  void _saveQuestion(int index) {
  final question = _questions[index];
  if (question.formKey.currentState!.validate()) {
    if (question.selectedAnswers.isEmpty) {
      // แสดงข้อความเตือนหากไม่มีการเลือกคำตอบที่ถูกต้อง
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('กรุณาเลือกคำตอบที่ถูกต้องอย่างน้อยหนึ่งข้อ')),
      );
      return;
    }
        setState(() {
          _savedQuestions.add(question);
          _questions.removeAt(index);
        });
      }
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


  void _toggleAssignment() {
    setState(() {
      _isAssignmentVisible = !_isAssignmentVisible;
      if (_isAssignmentVisible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  Future<void> _selectDueDate() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null && selectedDate != _dueDate) {
      setState(() {
        _dueDate = selectedDate;
      });
    }
  }

  void _assignWork() {
    final DateFormat formatter = DateFormat('dd MMM yyyy');

      if (_direction.isEmpty || _fullMarks <=0 ) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบถ้วน')),
      );
      return;
    }

    if (_savedQuestions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('กรุณาเพิ่มคำถามอย่างน้อยหนึ่งข้อ')),
      );
      return;
    }


    final newManyChoice = Manychoice(
      directionmany: _direction,
      fullMarkmany: _fullMarks,
      dueDatemany: _dueDate != null ? formatter.format(_dueDate!) : 'ไม่กำหนด',
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AssignWork_class_T(
          assignmentsonechoice: [], 
          assignmentsauswerq: [], 
          assignmentsupfile: [], 
          assignmentsmanychoice: [newManyChoice], username: '',),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [

            //คำสั่ง------------------------------------------------
            Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.symmetric(vertical: 5),
              child: TextFormField(
                onChanged: (value) {
                  _direction = value;
                },
                decoration: InputDecoration(
                  labelText: 'เขียนคำสั่งงานของคุณ',
                ),
              ),
            ),

            //ปุ่มมอบหมายงาน-------------------------------------------------
            TextButton.icon(
              onPressed: _toggleAssignment,
              label: Text(
                'กำหนดคะแนน',
                style: TextStyle(color: const Color.fromARGB(255, 19, 80, 95)),
              ),
              icon: Icon(Icons.score, color: const Color.fromARGB(255, 74, 184, 228)),
            ),
            SizeTransition(
              sizeFactor: _controller,
              axisAlignment: -1,
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 142, 217, 238),
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: EdgeInsets.only(top: 10, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      onChanged: (value) {
                        _fullMarks = int.tryParse(value) ?? 0;
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                      ],
                      decoration: InputDecoration(hintText: 'คะแนนเต็ม'),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            readOnly: true,
                            onTap: _selectDueDate,
                            decoration: InputDecoration(
                              hintText: _dueDate != null
                                  ? DateFormat('dd MMM yyyy').format(_dueDate!)
                                  : 'วันที่ครบกำหนด',
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed:() {
                                  _assignWork();
                                },
                          child: Text('มอบหมายงาน'),
                        ),
                      ),
                    ),
                  ],
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

  return Form(
    key: question.formKey, // ใช้ formKey เพื่อจัดการสถานะของฟอร์มนี้
    child: Card(
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

class Question {
  TextEditingController questionController = TextEditingController();
  List<Choice> choices = [
    Choice('ก'),
    Choice('ข'),
    Choice('ค'),
    Choice('ง'),
  ];
  List<String> selectedAnswers = [];
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void dispose() {
    questionController.dispose();
    for (var choice in choices) {
      choice.dispose();
    }
  }

  String nextChoiceLabel() {
    final labels = ['ก', 'ข', 'ค', 'ง', 'จ', 'ฉ', 'ช', 'ซ', 'ฌ', 'ญ'];
    return labels[choices.length % labels.length];
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
