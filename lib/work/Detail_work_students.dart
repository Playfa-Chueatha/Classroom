import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:flutter_esclass_2/work/auswer/QuestionListDialog.dart';
import 'package:flutter_esclass_2/work/auswer/doAuswerStudents.dart';
import 'package:flutter_esclass_2/work/manychoice/DoManychoiceStudents.dart';
import 'package:flutter_esclass_2/work/manychoice/manychoice_dialog.dart';
import 'package:flutter_esclass_2/work/onechoice/DoonechoiceStudents.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class Detail_work_S extends StatefulWidget {
  final Examset exam;
  final String thfname;
  final String thlname;
  final String username;
  const Detail_work_S({
    super.key, 
    required this.exam, 
    required this.thfname, 
    required this.thlname, 
    required this.username
  });

  @override
  State<Detail_work_S> createState() => _Detail_workState();
}

class _Detail_workState extends State<Detail_work_S> {
  final List<String> links = [];
  List<Upfile> fileData = [];
  List<AuswerQuestion> questionData = [];
  List<PlatformFile> selectedFiles = [];
  bool hasSubmitted = false;
  bool isLoading = true;

  Future<void> _fetchData() async {
    final exam = widget.exam;
    final response = await http.post(
      Uri.parse('https://www.edueliteroom.com/connect/fetch_upfileindetail.php'),
      body: {
        'type': exam.type,
        'autoId': exam.autoId.toString(),
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        if (exam.type == 'auswer') {
          questionData = List<AuswerQuestion>.from(
            data['auswer_question'].map((item) => AuswerQuestion.fromJson(item)),
          ).cast<AuswerQuestion>();
        } else if (exam.type == 'upfile') {
          fileData = List<Upfile>.from(
            data['upfile'].map((item) => Upfile.fromJson(item)),
          ).cast<Upfile>();
        }
      });
    } else {
      // Handle error
    }
  }

  Future<bool> _checkSubmit() async {
  try {
    final response = await http.post(
      Uri.parse('https://www.edueliteroom.com/connect/check_submit_auswer.php'),
      body: {
        'username': widget.username,
        'examType': widget.exam.type,
        'examId': widget.exam.autoId.toString(),
      },
    );
    print('API Response: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Decoded Data: $data');
      return data['exists'] == true;
    } else {
      throw Exception('Server Error: ${response.statusCode}');
    }
  } catch (e) {
    debugPrint('Error in _checkSubmitAuswer: $e');
    return false; // Return false if there's an error
  }
}



  void _openFile(Upfile file) async {
    final url = file.upfileUrl; 
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'ไม่สามารถเปิดไฟล์ได้';
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    _fetchData();
    _checkSubmit().then((value) {
      setState(() {
        hasSubmitted = value;
        isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาด: $error')),
      );
    });
  }

  
  @override
  void didUpdateWidget(covariant Detail_work_S oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.exam != oldWidget.exam) {
      setState(() {
        isLoading = true;
        hasSubmitted = false;
        fileData.clear();
        questionData.clear();
      });
      _fetchData();
      _checkSubmit().then((value) {
        setState(() {
          hasSubmitted = value;
          isLoading = false;
        });
      });
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

  List<FileData> fileDataList = selectedFiles
      .map((file) => FileData.fromPlatformFile(file))
      .toList();

  for (var file in fileDataList) {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://www.edueliteroom.com/connect/submit_upfile.php'),
      );

      
      request.fields['examsets_id'] = examsetsId.toString();
      request.fields['username'] = widget.username; 

      print('Uploading file for examsetsId: $examsetsId and username: ${widget.username}');

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
          backgroundColor: Colors.green,
        ));
      } else {
        throw 'Error uploading file: ${response.statusCode}, ${response.reasonPhrase}';
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}

  

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    final exam = widget.exam;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${exam.autoId}'),
            Text(
              'คำสั่งงาน:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(' ${exam.direction}'),
            SizedBox(height: 16),
            Text(
              'คะแนนเต็ม:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8),
            Text('${exam.fullMark}'),
            SizedBox(height: 16),
            Text(
              'วันที่ครบกำหนด:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(' ${exam.deadline}'),
            SizedBox(height: 16),



            //upfile
            if (exam.type == 'upfile') ...[
              Text('ไฟล์ที่แนบมา:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              SizedBox(height: 8),
              fileData.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: fileData.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(fileData[index].upfileName),
                          leading: Icon(Icons.attach_file),
                          onTap: () {
                            _openFile(fileData[index]);
                          },
                        );
                      },
                    )
                  : Text('ไม่มีไฟล์แนบ'),
              hasSubmitted
                  ? Text(
                      'คุณได้ส่งไฟล์เรียบร้อยแล้ว',
                      style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                    )
                  : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                        // แสดงไฟล์ที่ถูกเลือก
                        ...selectedFiles.map((file) => ListTile(
                          title: Text(file.name),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => setState(() => selectedFiles.remove(file)),
                          ),
                        )),
                        // ตรวจสอบว่า selectedFiles มีไฟล์ที่เลือกแล้วหรือไม่
                        selectedFiles.isNotEmpty
                            ? ElevatedButton(
                                onPressed: () async {
                                  await _saveFileToPost(exam.autoId, selectedFiles);
                                  setState(() {
                                    hasSubmitted = true;
                                  });
                                },
                                child: Text('ส่งงาน'),
                              )
                            : Container(), // ถ้าไม่มีไฟล์ที่เลือกให้ไม่แสดงปุ่ม
                      ],
                    ),
            ],



            //auswer
            if (exam.type == 'auswer') ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  hasSubmitted
                      ? Text(
                          'คุณตอบคำถามเรียบร้อยแล้ว',
                          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                        )
                      : OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Doauswerstudents(
                                  thfname: widget.thfname,
                                  thlname: widget.thlname,
                                  username: widget.username,
                                  exam: widget.exam,
                                  questions: questionData,
                                ),
                              ),
                            );
                          },
                          child: Text('ไปตอบคำถาม'),
                        ),
                ],
              ),
            ],


            //onechoice
            if (exam.type == 'onechoice') ...[
                hasSubmitted
                    ? Text(
                        'คุณได้ทำข้อสอบเรียบร้อยแล้ว',
                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Doonechoicestudents(
                                    exam: widget.exam,
                                    username: widget.username,
                                    thfname: widget.thfname,
                                    thlname: widget.thlname,
                                  ),
                                ),
                              );
                            },
                            child: Text('ไปทำข้อสอบ'),
                          ),
                        ],
                      ),
              ],




            //manychoice
            if (exam.type == 'manychoice') ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  hasSubmitted
                      ? Text(
                          'คุณได้ทำข้อสอบเรียบร้อยแล้ว',
                          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                        )
                      : OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Domanychoicestudents(
                                  exam: widget.exam,
                                  username: widget.username,
                                  thfname: widget.thfname,
                                  thlname: widget.thlname,
                                ),
                              ),
                            );
                          },
                          child: Text('ไปทำข้อสอบ'),
                        ),
                ],
              ),
            ],
        
          ],
        ),
      ),
    );
  }
}


//-------------------------------------------------

class Assignment {
  final String title;
  final String time;
  final String duedate;
  final String classID;

  Assignment({
    required this.title,
    required this.time,
    required this.duedate,
    required this.classID,
  });

  // ฟังก์ชันสำหรับแปลงข้อมูลจาก JSON
  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      title: json['event_assignment_title'],
      time: json['event_assignment_time'],
      duedate: json['event_assignment_duedate'],
      classID: json['event_assignment_classID'],
    );
  }
}
