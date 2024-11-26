import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:flutter_esclass_2/work/asign_work_T.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class upfilework extends StatefulWidget {
  final String username;
  final String thfname;
  final String thlname;
  final String classroomName;
  final String classroomMajor;
  final String classroomYear;
  final String classroomNumRoom;

  const upfilework({
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
  State<upfilework> createState() => _Answer_QuestionState();
}

class _Answer_QuestionState extends State<upfilework> {
  final formKey = GlobalKey<FormState>();
  final List<String> _links = [];
  List<PlatformFile> selectedFiles = [];
  String? _direction;
  int? _fullMarks;
  String? selectedDueDate;
  DateTime? _dueDate;

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
  const String apiUrl = "https://www.edueliteroom.com/connect/upfile_direction.php";

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
        "classroomNumRoom": classroomNumRoom,
      },
    );

    // Correcting the print statements to use function arguments
    print("Direction: $direction, Full Mark: $fullMark, Deadline: $deadline");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success']) {
        return int.tryParse(data['examsets_auto']);
      } else {
        throw Exception(data['message']);
      }
    } else {
      throw Exception("Failed to save assignment. Server error.");
    }
  } catch (error) {
    print("Error: $error");
    return null;
  }
}

  Future<void> _saveFileToPost(int examsetsId, List<PlatformFile> selectedFiles) async {
  if (selectedFiles.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('บันทึกคำสั่งงานเรียบร้อย'),
      backgroundColor: Colors.green,
    ));
    return; 
  }

  // แปลง PlatformFile เป็น FileData
  List<FileData> fileDataList = selectedFiles
      .map((file) => FileData.fromPlatformFile(file))
      .toList();

  // ตอนนี้คุณสามารถใช้ fileDataList ที่เป็น List<FileData>
  for (var file in fileDataList) {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://www.edueliteroom.com/connect/upfile_question.php'),
      );

      request.fields['examsets_id'] = examsetsId.toString();
      print('Uploading file for examsetsId: $examsetsId');

      request.files.add(http.MultipartFile.fromBytes(
        'file',
        file.bytes,
        filename: file.name,
      ));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        print('File uploaded successfully: $responseData');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('บันทึกคำสั่งงานเรียบร้อย'),
            backgroundColor: Colors.green,));
      } else {
        throw 'Error uploading file: ${response.statusCode}, ${response.reasonPhrase}';
      }
    } catch (e) {
      print('Error: $e');
    }
  }
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

  void _submitAssignment() async {
  if (formKey.currentState!.validate()) {
    formKey.currentState!.save();
    print("Direction: $_direction, Full Mark: $_fullMarks, Deadline: $_dueDate");

    if (_direction != null && _fullMarks != null && _dueDate != null) {
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

        if (examsetsId != null) {
          await _saveFileToPost(examsetsId, selectedFiles.cast<PlatformFile>());

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AssignWork_class_T(
                username: widget.username, thfname: widget.thfname, thlname: widget.thlname,
                classroomMajor: widget.classroomMajor,
                classroomName: widget.classroomName,
                classroomNumRoom: widget.classroomNumRoom,
                classroomYear: widget.classroomYear,
              )),);
        }
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('กรุณากรอกข้อมูลให้ครบถ้วน'),
        backgroundColor: Colors.red,
      ));
    }
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
            onChanged: (value) => link = value,
            decoration: InputDecoration(hintText: 'กรุณาใส่ลิงค์'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  if (link.isNotEmpty) _links.add(link);
                });
                Navigator.of(context).pop();
              },
              child: Text('ตกลง'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('ยกเลิก'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'เขียนคำสั่งงานของคุณ'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'กรุณากรอกคำสั่งงาน'
                      : null,
                  onSaved: (value) => _direction = value,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: fullMarksController,
                        decoration: const InputDecoration(labelText: 'คะแนนเต็ม'),
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            value == null || value.isEmpty ? 'กรุณากรอกคะแนนเต็ม' : null,
                        onSaved: (value) => _fullMarks = int.tryParse(value!) ?? 0,
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
                        validator: (value) =>
                            _dueDate == null ? 'กรุณาเลือกวันที่กำหนดส่ง' : null,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          allowMultiple: true,
                        );
                        if (result != null) {
                          setState(() {
                            selectedFiles = result.files;
                          });
                        }
                      },
                      icon: Icon(Icons.upload, size: 30),
                    ),
                    IconButton(
                      onPressed: _showLinkDialog,
                      icon: Icon(Icons.link, size: 30),
                    ),
                  ],
                ),
                ...selectedFiles.map((file) => ListTile(
                      title: Text(file.name),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => setState(() => selectedFiles.remove(file)),
                      ),
                    )),
                ElevatedButton(
                  onPressed: _submitAssignment,
                  child: Text('มอบหมายงาน'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
