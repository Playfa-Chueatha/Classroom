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
  late String annoncetext;
  List<String> links = [];  // เปลี่ยนจาก link เป็น list ของลิงค์
  List<PlatformFile> selectedFiles = []; // เปลี่ยนจาก single file เป็น list
  TextEditingController linkController = TextEditingController();

  Future<void> _sendDataToPHP(String title, List<PlatformFile> files, List<String> links) async {
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
      'posts_link': links.join(','), // เชื่อมลิงค์เป็นสตริง
      'classroom_name': classroomName,
      'classroom_major': classroomMajor,
      'classroom_year': classroomYear,
      'classroom_numroom': classroomNumRoom,
      'usert_username': usertUsername,
    });

    // ส่งคำขอไปที่เซิร์ฟเวอร์
    final response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();

      // แปลงข้อมูล JSON ที่ได้รับจากเซิร์ฟเวอร์
      var jsonResponse = json.decode(responseBody);
      int postId = int.parse(jsonResponse['post_id']);
      for (var file in files) {
        await _saveFileToPost(postId, file); 
      }

      // ส่งลิงค์ไปยัง PHP API
      for (var link in links) {
        await _sendLinkToAPI(postId, link);
      }
      Navigator.of(context).pop(true);
      
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('บันทึกข้อมูลสำเร็จ'),backgroundColor: Colors.green,));
    } else {
      throw 'Server error: ${response.statusCode}';
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('เกิดข้อผิดพลาด: $e'),backgroundColor: Colors.red,),
    );
    print('ErrorPHP: $e');
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

      
      final response = await request.send();
      print('ลิงค์: $links');

      if (response.statusCode == 200) {
        print('File uploaded successfully');
      } else {
        throw 'Error uploading file: ${response.statusCode}';
      }
    } catch (e) {
      print('Errorfile: $e');
    }
  }

  Future<void> _sendLinkToAPI(int postId, String link) async {
  try {
    var response = await http.post(
      Uri.parse('https://www.edueliteroom.com/connect/save_linkpost.php'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'posts_id': postId.toString(),
        'link': link,
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['success']) {
        print('Link uploaded successfully');
      } else {
        print('Error uploading link: ${jsonResponse['message']}');
      }
    } else {
      throw 'Error uploading link: ${response.statusCode}';
    }
  } catch (e) {
    print('Errorlink: $e');
  }
}



  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromARGB(255, 152, 186, 218),
      title: Center(child: Text(
        'สร้างประกาศใหม่ในวิชา ${widget.classroomName.isNotEmpty ? widget.classroomName : ''} '
          '${widget.classroomYear.isNotEmpty ? '${widget.classroomYear}/' : ''}'
          '${widget.classroomNumRoom.isNotEmpty ? widget.classroomNumRoom : ''} '
          '${widget.classroomMajor.isNotEmpty ? '(${widget.classroomMajor})' : ''}',
      )),
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
                      FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
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

              if (links.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...links.map((link) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.link, size: 20),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'ลิงค์ที่กรอก: $link',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, size: 20),
                            onPressed: () {
                              setState(() {
                                links.remove(link);
                              });
                            },
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              
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
                          await _sendDataToPHP(annoncetext, selectedFiles, links);
                          formKey.currentState!.reset();
                          
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบถ้วน'),backgroundColor: Colors.red,),
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
                  links.add(linkController.text); 
                });
                linkController.clear();
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
