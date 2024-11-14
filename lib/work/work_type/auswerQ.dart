import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_esclass_2/Data/Data_assignwork.dart';
import 'package:flutter_esclass_2/work/asign_work_T.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class Auswer_Question extends StatefulWidget {
  const Auswer_Question({super.key});

  @override
  State<Auswer_Question> createState() => _Answer_QuestionState();
}

class _Answer_QuestionState extends State<Auswer_Question> with SingleTickerProviderStateMixin {
  List<PlatformFile> _files = [];
  final List<String> _links = [];
  String _direction = 'คัด ก-ฮ';
  int _fullMarks = 0;
  DateTime? _dueDate;
  bool _isAssignmentVisible = false;
  late AnimationController _controller;
  final TextEditingController _questionController = TextEditingController();
  final List<String> _questions = [];
  final List<String> _answers = [];

  // เปิดไฟล์จาก URL
  void _openFile(String fileName) async {
    final fileUrl = 'https://your-server-endpoint/files/$fileName'; // URL ของไฟล์ที่อัพโหลด
    if (await canLaunch(fileUrl)) {
      await launch(fileUrl);
    } else {
      print('Could not launch $fileUrl');
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
  }

  void _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'ppt', 'pptx', 'png', 'jpg'],
    );

    if (result != null) {
      setState(() {
        _files = result.files;
      });
    } else {
      print('No file selected');
    }
  }

  void _removeFile(int index) {
    setState(() {
      _files.removeAt(index);
    });
  }

  void _removeLink(int index) {
    setState(() {
      _links.removeAt(index);
    });
  }

  // ignore: unused_element
  Future<void> _uploadFile(String filePath) async {
    var uri = Uri.parse('https://your-server-endpoint/upload');
    var request = http.MultipartRequest('POST', uri);
    var file = await http.MultipartFile.fromPath('file', filePath);
    request.files.add(file);

    var response = await request.send();

    if (response.statusCode == 200) {
      print('File uploaded successfully');
    } else {
      print('Failed to upload file');
    }
  }

  void _showLinkDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String link = '';
        return AlertDialog(
          title: Text('ใส่ลิงค์'),
          content: TextField(
            onChanged: (value) {
              link = value;
            },
            decoration: InputDecoration(
              hintText: 'กรุณาใส่ลิงค์',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  if (link.isNotEmpty) {
                    _links.add(link);
                  }
                });
                Navigator.of(context).pop();
              },
              child: Text('ตกลง'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('ยกเลิก'),
            ),
          ],
        );
      },
    );
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

    if (_direction.isEmpty || _fullMarks <= 0 || _questions.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบถ้วน')),
    );
    return;
  }
    final newauswerq = auswerq(
      directionauswerq: _direction,
      fullMarksauswerq: _fullMarks,
      dueDateauswerq: _dueDate != null ? formatter.format(_dueDate!) : 'ไม่กำหนด',
      filesauswerq: _files.map((file) => file.name).toList(),
      linksauswerq: _links,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AssignWork_class_T(assignmentsauswerq: [newauswerq], assignmentsupfile: [], assignmentsonechoice: [], assignmentsmanychoice: [], username: '',),
      ),
    );
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

  void _addQuestion() {
    final questionText = _questionController.text.trim();
    if (questionText.isNotEmpty) {
      setState(() {
        _questions.add(questionText);
        _answers.add('');
        _questionController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เพิ่มคำถามของคุณ')),
      );
    }
  }

  void _editQuestion(int index) {
    _questionController.text = _questions[index];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('แก้ไขคำถาม'),
          content: TextField(
            controller: _questionController,
            decoration: InputDecoration(labelText: 'เขียนคำถามที่ต้องการแก้ไข'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  _questions[index] = _questionController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _addAnswer(int index, String answer) {
    setState(() {
      _answers[index] = answer;
    });
  }

  void _removeQuestion(int index) {
    setState(() {
      _questions.removeAt(index);
      _answers.removeAt(index); // ลบคำตอบที่เกี่ยวข้องด้วย
    });
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  onChanged: (value) {
                    _direction = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'เขียนคำสั่งงานของคุณ',
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: _pickFiles,
                    icon: Icon(Icons.upload),
                  ),
                  IconButton(
                    onPressed: _showLinkDialog,
                    icon: Icon(Icons.link),
                  ),
                ],
              ),
              if (_links.isNotEmpty)
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 142, 217, 238),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("ลิงค์ :", style: TextStyle(fontSize: 16)),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _links.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(_links[index]),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _removeLink(index),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              if (_files.isNotEmpty)
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 142, 217, 238),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("ไฟล์ที่อัพโหลด :", style: TextStyle(fontSize: 16)),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _files.length,
                        itemBuilder: (context, index) {
                          final file = _files[index];
                          return ListTile(
                            title: GestureDetector(
                              onTap: () => _openFile(file.name),
                              child: Text(
                                file.name,
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _removeFile(index),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: TextField(
                  controller: _questionController,
                  decoration: InputDecoration(
                    labelText: 'เขียนคำถามของคุณ',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: _addQuestion,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  'มีจำนวนคำถามทั้งหมด ${_questions.length} ข้อ',
                  style: TextStyle(fontSize: 14,color: const Color.fromARGB(255, 13, 177, 206)),
                ),
              ),
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
                            } ,
                            child: Text('มอบหมายงาน'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3, // Adjust height as needed
                child: ListView.builder(
                  itemCount: _questions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('${index + 1}. ${_questions[index]}'),
                      subtitle: TextField(
                        decoration: InputDecoration(labelText: 'เขียนคำตอบของคุณ'),
                        onChanged: (text) => _addAnswer(index, text),
                      ),
                     trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _editQuestion(index),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _removeQuestion(index),
                          ),
                        ],
                      ),
                    );
                    
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
