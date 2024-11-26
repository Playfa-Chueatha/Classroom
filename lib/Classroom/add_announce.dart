import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show Uint8List;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

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
  late String annoncetext ;
  String? link;
  List<PlatformFile> selectedFiles = []; // เปลี่ยนจาก single file เป็น list
  TextEditingController linkController = TextEditingController();

Future<void> _sendDataToPHP(String title, List<PlatformFile> files, String? link) async {
  String classroomName = widget.classroomName;
  String classroomMajor = widget.classroomMajor;
  String classroomYear = widget.classroomYear;
  String classroomNumRoom = widget.classroomNumRoom;
  String usertUsername = widget.username;

  try {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://www.edueliteroom.com/connect/save_post.php'),
    );

    // เพิ่มข้อมูลฟอร์ม
    request.fields.addAll({
      'posts_title': title,
      'posts_link': link ?? 'ไม่มี',
      'classroom_name': classroomName,
      'classroom_major': classroomMajor,
      'classroom_year': classroomYear,
      'classroom_numroom': classroomNumRoom,
      'usert_username': usertUsername,
    });

    // ส่งคำขอไปที่เซิร์ฟเวอร์
    final response = await request.send();
    
    // ตรวจสอบผลลัพธ์จากการตอบกลับ
    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      
      // แปลงข้อมูล JSON ที่ได้รับจากเซิร์ฟเวอร์
      var jsonResponse = json.decode(responseBody);
      int postId = int.parse(jsonResponse['post_id']); 

      print('Post saved successfully, Post ID: $postId');

      // อัปโหลดไฟล์ที่เกี่ยวข้องกับโพสต์
      for (var file in files) {
        await _saveFileToPost(postId, file);  // ส่งไฟล์ไปยังเซิร์ฟเวอร์
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('บันทึกข้อมูลสำเร็จ')));
    } else {
      throw 'Server error: ${response.statusCode}';
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
    );
    print('Error: $e');
  }
}

Future<void> _saveFileToPost(int postId, PlatformFile file) async {
  try {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://www.edueliteroom.com/connect/save_file.php'),
    );


    request.fields['post_id'] = postId.toString();


    request.files.add(http.MultipartFile.fromBytes(
      'file',
      file.bytes!,
      filename: file.name,
    ));

    // ส่งคำขอไปที่เซิร์ฟเวอร์
    final response = await request.send();
    
    if (response.statusCode == 200) {
      print('File uploaded successfully');
    } else {
      throw 'Error uploading file: ${response.statusCode}';
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
                      FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true); // allowMultiple: true เพื่อเลือกหลายไฟล์
                      if (result != null) {
                        setState(() {
                          selectedFiles = result.files; 
                        });
                      }
                    },
                    icon: Icon(Icons.upload, size: 30),
                  ),
                ],
              ),
              SizedBox(height: 10),
              // แสดงชื่อไฟล์ที่เลือก
              if (selectedFiles.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...selectedFiles.map((file) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("ไฟล์ที่เลือก: ${file.name}"),
                          IconButton(
                            icon: Icon(Icons.delete, size: 20),
                            onPressed: () {
                              setState(() {
                                selectedFiles.remove(file); 
                              });
                            },
                          ),
                        ],
                      );
                    }),
                  ],
                ),
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
                          await _sendDataToPHP(annoncetext, selectedFiles, link);
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
                  link = linkController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text("ตกลง"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("ยกเลิก"),
            ),
          ],
        );
      },
    );
  }
}
