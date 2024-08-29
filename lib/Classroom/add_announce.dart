import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Classroom/calssT_body.dart';
import 'package:flutter_esclass_2/Classroom/classT.dart';
import 'package:flutter_esclass_2/Data/Data_announce.dart';
import 'package:file_picker/file_picker.dart';

class AnnounceClass extends StatefulWidget {
  const AnnounceClass({super.key});

  @override
  State<AnnounceClass> createState() => _AnnounceClassState();
}

class _AnnounceClassState extends State<AnnounceClass> {
  final formKey = GlobalKey<FormState>();
  String annoncetext = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromARGB(255, 152, 186, 218),
      title: Center(child: Text("สร้างประกาศใหม่")),
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
              Wrap(
                spacing: 8.0,
                children: [
                  IconButton(
                    icon: Icon(Icons.format_bold_outlined, size: 20),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.format_italic, size: 20),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.format_underline, size: 20),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.format_color_text_outlined, size: 20),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.format_size_outlined, size: 20),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.format_list_bulleted, size: 20),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.format_align_left_outlined, size: 20),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.format_align_center_outlined, size: 20),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.format_align_right_outlined, size: 20),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.format_align_justify_outlined, size: 20),
                    onPressed: () {},
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.link, size: 30)),


                  //uploadfile
                  IconButton(
                    onPressed: () async {
                      FilePickerResult? result = await FilePicker.platform.pickFiles();

                      if (result != null) {
                        // แสดงไฟล์ที่เลือก
                        PlatformFile file = result.files.first;
                        print('File name: ${file.name}');
                        print('File size: ${file.size}');
                        print('File path: ${file.path}');
                        // สามารถทำการอัพโหลดไฟล์ที่นี่
                      }
                      else {
                        // ผู้ใช้ยกเลิกการเลือกไฟล์
                        print('No file selected');
                      }
                    }, 
                    icon: Icon(Icons.upload, size: 30)),
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
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          dataAnnounce.add(
                            DataAnnounce(annoncetext: annoncetext),
                          );
                          formKey.currentState!.reset();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (ctx) => const ClassT()),
                          );
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
}
