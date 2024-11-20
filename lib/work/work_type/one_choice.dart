import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_esclass_2/Data/Data_assignwork.dart';
import 'package:flutter_esclass_2/work/asign_work_T.dart';
import 'package:intl/intl.dart';

class OneChoice_test extends StatefulWidget {
  final String username;
  final String thfname;
  final String thlname;
  const OneChoice_test({super.key, required this.username, required this.thfname, required this.thlname});

  @override
  _OneChoiceState createState() => _OneChoiceState();
}

class _OneChoiceState extends State<OneChoice_test> with SingleTickerProviderStateMixin {
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

  bool _isQuestionFilled(int index) {
  final question = _questions[index];
  
  // ตรวจสอบว่ามีการกรอกคำถามหรือไม่
  if (question.questionController.text.isEmpty) {
    return false;
  }
  
  // ตรวจสอบว่ามีการกรอกตัวเลือกครบถ้วนหรือไม่
  for (final choice in question.choices) {
    if (choice.controller.text.isEmpty) {
      return false;
    }
  }
  
  // ตรวจสอบว่ามีการเลือกคำตอบที่ถูกต้องหรือไม่
  if (question.selectedAnswer == null || question.selectedAnswer!.isEmpty) {
    return false;
  }
  
  return true;
}

void _saveQuestion(int index) {
  if (_isQuestionFilled(index)) { // ตรวจสอบว่ามีการกรอกข้อมูลครบถ้วน
    setState(() {
      _savedQuestions.add(_questions[index]);
      _questions.removeAt(index); 
    });
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('กรุณากรอกคำถาม ตัวเลือก และเลือกคำตอบที่ถูกต้อง')),
    );
  }
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

    if (_direction.isEmpty || _fullMarks <= 0 ) {
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


    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AssignWork_class_T(
          thfname: widget.thfname, thlname: widget.thlname, username: widget.username, classroomMajor: '', classroomName: '', classroomYear: '', classroomNumRoom: '',
        ),
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
                          onPressed: () {
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


class Question {
  final TextEditingController questionController = TextEditingController();
  final List<Choice> choices = [
    Choice(label: 'ก'),
    Choice(label: 'ข'),
    Choice(label: 'ค'),
    Choice(label: 'ง'),
  ];
  String? selectedAnswer;
}

class Choice {
  final String label;
  final TextEditingController controller = TextEditingController();

  Choice({required this.label});
}
