import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:flutter_esclass_2/work/auswer/QuestionListDialog.dart';
import 'package:flutter_esclass_2/work/auswer/doAuswerStudents.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class Detail_work_S extends StatefulWidget {
  final Examset exam;
  final String thfname;
  final String thlname;
  final String username;
  const Detail_work_S({super.key, required this.exam, required this.thfname, required this.thlname, required this.username});

  @override
  State<Detail_work_S> createState() => _Detail_workState();
}

class _Detail_workState extends State<Detail_work_S> {
  final List<String> links = [];
  List<Upfile> fileData = [];
  List<AuswerQuestion> questionData = [];
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



  Future<bool> _checkSubmitAuswer() async {
  final response = await http.post(
    Uri.parse('https://www.edueliteroom.com/connect/check_submit_auswer.php'),
    body: {
      'username': widget.username,
      'examType': widget.exam.type,
      'examId': widget.exam.autoId.toString(),
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['exists'] == true; 
  } else {
    throw Exception('Failed to check data in submit_auswer');
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
    _fetchData();
     _checkSubmitAuswer().then((value) {
    setState(() {
      hasSubmitted = value;
      isLoading = false;
    });
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
      _checkSubmitAuswer().then((value) {
        setState(() {
          hasSubmitted = value;
          isLoading = false;
        });
      });
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
                            // แสดงไฟล์ที่ถูกเลือก หรือเปิดไฟล์
                            _openFile(fileData[index]);
                          },
                        );
                      },
                    )
                  : Text('ไม่มีไฟล์แนบ'),
            ],
            if (exam.type == 'auswer') ...[
              Text('ไฟล์ที่แนบมา:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              SizedBox(height: 8),
              Text('ไม่มีไฟล์แนบ'),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
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

            if (exam.type == 'onechoice') ...[
              Text('ไฟล์ที่แนบมา:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              SizedBox(height: 8),
              Text('ไม่มีไฟล์แนบ'),
              Row(
                mainAxisAlignment: MainAxisAlignment.end, 
                children: [
                  OutlinedButton(
                    onPressed: () {
                      
                    },
                    child: Text('แสดงตัวอย่างข้อสอบ'),
                  ),
                ],
              ),
            ],
            if (exam.type == 'manychoice') ...[
              Text('ไฟล์ที่แนบมา:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              SizedBox(height: 8),
              Text('ไม่มีไฟล์แนบ'),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,  // ชิดขวา
                children: [
                  OutlinedButton(
                    onPressed: () {
                      // ฟังก์ชันเมื่อกดปุ่ม
                    },
                    child: Text('แสดงตัวอย่างข้อสอบ'),
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
