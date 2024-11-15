import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_esclass_2/Data/Data_assignwork.dart';
import 'package:flutter_esclass_2/work/asign_work_T.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class upfilework extends StatefulWidget {
  final String username;
  final String thfname;
  final String thlname;
  const upfilework({super.key, required this.username, required this.thfname, required this.thlname});

  @override
  State<upfilework> createState() => _Answer_QuestionState();
}

class _Answer_QuestionState extends State<upfilework> with SingleTickerProviderStateMixin {
  List<PlatformFile> _files = [];
  final List<String> _links = [];
  String _direction = '';
  int _fullMarks = 0;
  DateTime? _dueDate;
  bool _isAssignmentVisible = false;
  late AnimationController _controller;
  

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

  void _assignWork() {
    final DateFormat formatter = DateFormat('dd MMM yyyy');

    if (_direction.isEmpty || _fullMarks <= 0 ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบถ้วน')),
    );
    return;
  }

    final Newupfile= upfile(
      directionupfile: _direction,
      fullMarksupfile: _fullMarks,
      dueDateupfile: _dueDate != null ? formatter.format(_dueDate!) : 'ไม่กำหนด',
      filesupfile: _files.map((file) => file.name).toList(),
      linksupfile: _links,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AssignWork_class_T(
          assignmentsupfile: [Newupfile], 
          assignmentsauswerq: [], 
          assignmentsonechoice: [], 
          assignmentsmanychoice: [], 
          thfname: widget.thfname, thlname: widget.thlname, username: widget.username,
        ),
      ),
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
            ],
          ),
        ),
      ),
    );
  }
}

class Assignment {
  final String direction;
  final String fullMarks;
  final String dueDate;
  final List<String> files;
  final List<String> links;

  Assignment({
    required this.direction,
    required this.fullMarks,
    required this.dueDate,
    required this.files,
    required this.links,
  });
}
