import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_esclass_2/Data/data_calssroom.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AnnounceClass extends StatefulWidget {
  final String thfname;
  final String thlname;
  final String username;
  final String classroomName;
  final String classroomMajor;
  final String classroomYear;
  final String classroomNumRoom;

  const AnnounceClass({
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
  State<AnnounceClass> createState() => _AnnounceClassState();
}

class _AnnounceClassState extends State<AnnounceClass> {
  final formKey = GlobalKey<FormState>();
  String annoncetext = '';
  String? filePath;
  String? link;
  TextEditingController linkController = TextEditingController();
  var fileBytes;

  Future<void> _sendDataToPHP(String title, String? filePath, String? link) async {
  String classroomName = widget.classroomName;
  String classroomMajor = widget.classroomMajor;
  String classroomYear = widget.classroomYear;
  String classroomNumRoom = widget.classroomNumRoom;
  String usertUsername = widget.username;

  try {
    var request = http.MultipartRequest('POST', Uri.parse('https://www.edueliteroom.com/connect/save_post.php'));

    // Add text fields
    request.fields['title'] = title;
    request.fields['link'] = link ?? '';
    request.fields['classroom_name'] = classroomName;
    request.fields['classroom_major'] = classroomMajor;
    request.fields['classroom_year'] = classroomYear;
    request.fields['classroom_numroom'] = classroomNumRoom;
    request.fields['usert_username'] = usertUsername;

    // Handle file upload
    if (filePath != null) {
      if (kIsWeb && fileBytes != null) {
        var file = http.MultipartFile.fromBytes('file', fileBytes!, filename: 'uploadfile');
        request.files.add(file);
        print("File path: $filePath");
        print("File bytes length: ${fileBytes?.length}");
      } else {
        var file = await http.MultipartFile.fromPath('file', filePath);
        request.files.add(file);
        print("No file selected");
      }
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Data saved successfully');
      // Optionally, capture the response body if needed
      var responseBody = await response.stream.bytesToString();
      print(responseBody);
    } else {
      print('Failed to save data');
    }
  } catch (e) {
    print('Error: $e');
  }
}




  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromARGB(255, 152, 186, 218),
      title: Center(child: Text("สร้างประกาศใหม่ใน วิชา ${widget.classroomName} ${widget.classroomYear}/${widget.classroomNumRoom} (${widget.classroomMajor}) ")),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8, 
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: 10,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'เขียนประกาศของคุณ',
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  isCollapsed: true,
                  isDense: true,
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onSaved: (value) {
                  annoncetext = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกประกาศของคุณ';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      _showLinkDialog();
                    },
                    icon: Icon(Icons.link, size: 30),
                  ),
                  IconButton(
                    onPressed: () async {
                    FilePickerResult? result = await FilePicker.platform.pickFiles();
                    if (result != null) {
                      if (kIsWeb) {
                        fileBytes = result.files.first.bytes;
                        setState(() {});
                      } else {
                        filePath = result.files.first.path;
                        setState(() {});
                      }
                    }
                    }, 
                    icon: Icon(Icons.upload, size: 30),
                  ),
                ],
              ),
              // แสดงตัวอย่างลิงค์ที่เพิ่มไป
              if (link != null && link!.isNotEmpty) 
                Text("ลิงค์ที่เพิ่ม: $link"),
              SizedBox(height: 10),
              // แสดงตัวอย่างไฟล์ที่เลือก
              if (filePath != null) 
                Text("ไฟล์ที่เลือก: ${filePath!.split('/').last}"),
              if (kIsWeb && fileBytes != null)
                Text("ไฟล์ที่เลือก (Web): ${fileBytes.length} bytes"),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                    width: 200,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 45, 124, 155),
                      ),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                           await _sendDataToPHP(annoncetext, filePath, link);
                          formKey.currentState!.reset();
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบถ้วน')),
                          );
                        }
                      },
                      child: Text("สร้างประกาศ", style: TextStyle(fontSize: 20)),
                    ),
                  ),
                  SizedBox(width: 20),
                  SizedBox(
                    height: 50,
                    width: 150,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 192, 85, 103),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("ยกเลิก", style: TextStyle(fontSize: 20)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ฟังก์ชันแสดง dialog สำหรับเพิ่มลิงค์
  void _showLinkDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("เพิ่มลิงค์"),
          content: TextField(
            controller: linkController,
            decoration: InputDecoration(hintText: 'ใส่ลิงค์ที่นี่'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  link = linkController.text; // กำหนดลิงค์ที่เพิ่ม
                });
                Navigator.pop(context);
              },
              child: Text("ตกลง"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("ยกเลิก"),
            ),
          ],
        );
      },
    );
  }
}


