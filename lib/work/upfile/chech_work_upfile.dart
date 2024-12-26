import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:flutter_esclass_2/work/asign_work_T.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:ui_web' as ui;  

class ChechWorkUpfile extends StatefulWidget {
  final Map<String, dynamic> studentData;
  final Examset exam;
  final String username;
  final String thfname;
  final String thlname;

  const ChechWorkUpfile({
    super.key,
    required this.exam,
    required this.studentData,
    required this.username,
    required this.thfname,
    required this.thlname,
  });

  @override
  State<ChechWorkUpfile> createState() => _ChechWorkUpfileState();
}

class _ChechWorkUpfileState extends State<ChechWorkUpfile> {
  List<Upfile_submit> fileData = [];
  String? currentFileUrl;
  late IFrameElement _iFrameElement;

  TextEditingController fullMark = TextEditingController();
  TextEditingController comment = TextEditingController();

  // ฟังก์ชันสำหรับการโหลดข้อมูลไฟล์
  Future<void> fetchDatasubmit_upfile() async {
    final exam = widget.exam;
    final studentData = widget.studentData;

    if (studentData['users_thfname'] == '' || exam.autoId == 0) {
      print('Error: Missing parameters');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('กรุณาตรวจสอบข้อมูล studentData หรือ autoId')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('https://www.edueliteroom.com/connect/fetch_upfileforcheckscore.php'),
        body: {
          'users_prefix': studentData['users_prefix'],
          'users_thfname': studentData['users_thfname'],
          'users_thlname': studentData['users_thlname'],
          'users_number': studentData['users_number'],
          'autoId': exam.autoId.toString(),
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);

        if (json.containsKey('upfile')) {
          final List<dynamic> data = json['upfile'];
          setState(() {
            fileData = data.map((e) => Upfile_submit.fromJson(e)).toList();
          });
        } else {
          throw Exception('No "upfile" key found in response');
        }
      } else {
        throw Exception('Failed to load files');
      }
    } catch (e) {
      print('$e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล: $e')),
      );
    }
  }

  // ฟังก์ชันเปิดไฟล์ใน iframe
  void _openFile(Upfile_submit file) {
    setState(() {
      currentFileUrl = file.upfileUrl; // อัปเดต URL
      _iFrameElement = IFrameElement()
        ..src = currentFileUrl!
        ..style.height = '100%'
        ..style.width = '100%'
        ..style.border = 'none';

      // ลงทะเบียน viewType ใหม่ทุกครั้งที่ URL เปลี่ยน
      ui.platformViewRegistry.registerViewFactory(
        'iframeElement_${currentFileUrl.hashCode}', // ใช้ hashCode เพื่อสร้างชื่อที่ไม่ซ้ำ
        (int viewId) => _iFrameElement,
      );
    });
  }


  Future<void> saveCheckWorkUpfile() async {
    final exam = widget.exam;
    final studentData = widget.studentData;

    // ตรวจสอบว่ามีข้อมูลครบถ้วนหรือไม่
    if (exam.autoId == 0 || fullMark.text.isEmpty || comment.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบถ้วน')),
      );
      return;
    }

    try {
      
      final response = await http.post(
        Uri.parse('https://www.edueliteroom.com/connect/get_user_usernameforsavescore.php'),
        body: {
          'users_prefix': studentData['users_prefix'],
          'users_thfname': studentData['users_thfname'],
          'users_thlname': studentData['users_thlname'],
          'users_number': studentData['users_number'],
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        
        if (json.containsKey('users_username')) {
          final usersUsername = json['users_username'];

          // บันทึกข้อมูลลงใน checkwork_upfile
          final saveResponse = await http.post(
            Uri.parse('https://www.edueliteroom.com/connect/save_checkwork_upfile.php'),
            body: {
              'examsets_id': exam.autoId.toString(),
              'question_detail': exam.direction,
              'checkwork_upfile_score': fullMark.text,
              'users_username': usersUsername,
              'checkwork_upfile_time': DateTime.now().toIso8601String(), // timestamp
              'checkwork_upfile_comments': comment.text,
            },
          );

          if (saveResponse.statusCode == 200) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('บันทึกข้อมูลสำเร็จ')),
            );
          } else {
            throw Exception('ไม่สามารถบันทึกข้อมูลได้');
          }
        } else {
          throw Exception('ไม่พบผู้ใช้ที่ตรงกับข้อมูล');
        }
      } else {
        throw Exception('ไม่สามารถค้นหาผู้ใช้ได้');
      }
    } catch (e) {
      print('$e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการบันทึกข้อมูล: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDatasubmit_upfile();
    _iFrameElement = IFrameElement(); // เริ่มต้น IFrame ใหม่
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          currentFileUrl = null; // รีเซ็ตค่า URL เมื่อกดปุ่ม back
        });
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'ตรวจงาน ${widget.studentData['users_prefix']} '
            '${widget.studentData['users_thfname']} '
            '${widget.studentData['users_thlname']} '
            'เลขที่: ${widget.studentData['users_number']}',
          ),
          actions: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Text(
                  'ของ',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 300,
                height: 900,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'ไฟล์',
                        style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: fileData.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(fileData[index].upfileName),
                            leading: Icon(Icons.attach_file, color: Colors.white),
                            onTap: () {
                              _openFile(fileData[index]);
                            },
                          );
                        },
                      ),
                    ),
                    if (fileData.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'คลิกชื่อไฟล์เพื่อดูไฟล์',
                          style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.white),
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'คะแนน: ',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: fullMark,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'กรอกคะแนน',
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            '/${widget.exam.fullMark}',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: TextFormField(
                        controller: comment, 
                        keyboardType: TextInputType.multiline,
                        maxLines: 3, 
                        decoration: InputDecoration(
                          labelText: 'กรอกคอมเมนต์',
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(padding: EdgeInsets.all(20),
                        child:  OutlinedButton(
                          onPressed: (){
                              saveCheckWorkUpfile();
                               Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AssignWork_class_T( 
                                          thfname: widget.thfname,
                                          thlname: widget.thlname,
                                          username: widget.username, 
                                          classroomMajor: '',
                                          classroomName: '',
                                          classroomNumRoom: '',     
                                          classroomYear: '',                               
                                          
                                        ),        
                                      ),
                                    ).then((_) {
                                      // รีเซ็ตข้อมูลเมื่อกลับมาจากหน้า ChechWorkUpfile
                                      setState(() {
                                        currentFileUrl = null;  // รีเซ็ต URL ของไฟล์
                                      });
                                    });

                          }, 
                           style: ButtonStyle(
                                    side: MaterialStateProperty.all(BorderSide(color: const Color.fromARGB(255, 0, 0, 0))),
                                  ),
                          child: Text('ตรวจงานเสร็จสิ้น', style: TextStyle(color: Colors.black))
                        ),
                      )
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 900,
                width: 1500,
                child: currentFileUrl != null
                    ? HtmlElementView(
                        viewType: 'iframeElement_${currentFileUrl.hashCode}', // ใช้ viewType เฉพาะ
                      )
                    : Center(child: Text('กรุณาคลิกไฟล์เพื่อดูรายละเอียด')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
