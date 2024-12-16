import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:flutter_esclass_2/work/asign_work_T.dart';
import 'package:flutter_esclass_2/work/auswer/ClassroomSearchDialog.dart';
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
  bool isCheckeddueDate = false;
  final List<Map<String, dynamic>> _selectedClassrooms = [];

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
  required String isClosed,
  
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
        "isClosed": isClosed,
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

  void _submitAssignment() async {
  if (formKey.currentState!.validate()) {
    formKey.currentState!.save();

    final isClosed = isCheckeddueDate ? 'Yes' : 'No'; 
    print("Direction: $_direction, Full Mark: $_fullMarks, Deadline: $_dueDate");

    if (_direction != null && _fullMarks != null && _dueDate != null) {
      try {
        // เริ่มการวนลูปผ่านห้องเรียนที่เลือก
        for (var classroom in _selectedClassrooms) {
          final examsetsId = await saveAssignment(
            direction: _direction!,
            fullMark: _fullMarks!,
            deadline: _dueDate!,
            username: widget.username,
            classroomName: classroom['classroom_name'],
            classroomMajor: classroom['classroom_major'],
            classroomYear: classroom['classroom_year'],
            classroomNumRoom: classroom['classroom_numroom'],
            isClosed: isClosed, 
          );

          if (examsetsId != null) {
            // บันทึกไฟล์ที่เลือกในแต่ละห้องเรียน
            await _saveFileToPost(examsetsId, selectedFiles.cast<PlatformFile>());
          } else {
            // ถ้าไม่สามารถบันทึกการบ้านได้ ให้แสดงข้อความ
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('ไม่สามารถบันทึกการบ้านสำหรับห้องเรียน ${classroom['classroom_name']} ได้'),
              backgroundColor: Colors.red,
            ));
            return; // หยุดการทำงานเมื่อเกิดข้อผิดพลาด
          }
        }

        // ถ้าบันทึกสำเร็จแล้ว ไปที่หน้าถัดไป
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
