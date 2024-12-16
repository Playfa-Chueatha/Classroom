import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:flutter_esclass_2/work/auswer/Check%20work_teacher.dart';
import 'package:flutter_esclass_2/work/auswer/QuestionListDialog.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class Detail_work extends StatefulWidget {
  final Examset exam;
  final String username;
  final String thfname;
  final String thlname;
  const Detail_work({
    super.key, 
    required this.exam,
    required this.username, 
    required this.thfname, 
    required this.thlname, 
  });

  @override
  State<Detail_work> createState() => _Detail_workState();
}

class _Detail_workState extends State<Detail_work> {
  final List<String> links = [];
  List<Upfile> fileData = [];
  List<AuswerQuestion> questionData = [];
  List<dynamic> students = [];
  List<Map<String, dynamic>> liststudentsnotsubmit = [];
  List<Map<String, dynamic>> liststudentssubmit = [];
  late Future<Map<String, dynamic>> futureData;
  String errorMessage = '';  // To store any error message


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
      
    }
  }

Future<void> fetchStudentData() async {
  const String apiUrl = "https://www.edueliteroom.com/connect/submission_studentstatus.php"; 

  try {
    final response = await http.post(Uri.parse(apiUrl), body: {
      'exam_autoId': widget.exam.autoId.toString(),
      'exam_type': widget.exam.type,
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      
      final studentsSubmitted = List<Map<String, dynamic>>.from(data['students_submitted'].map((student) {
        student['users_number'] = student['users_number'].toString();  
        return student;
      }));

      final studentsNotSubmitted = List<Map<String, dynamic>>.from(data['students_not_submitted'].map((student) {
        student['users_number'] = student['users_number'].toString(); 
        return student;
      }));

      setState(() {
        liststudentssubmit = studentsSubmitted;
        liststudentsnotsubmit = studentsNotSubmitted;
      });

    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    throw Exception('Failed to load data: $e');
  }
}




Future<void> fetchStudentschecksuccess(int examAutoId) async {
  try {
    // ส่งคำขอ POST ไปยัง server
    final response = await http.post(
      Uri.parse('https://www.edueliteroom.com/connect/check_score_auswer.php'),
      body: {'exam_autoId': examAutoId.toString()},
    );

    // ตรวจสอบสถานะการตอบกลับจาก server
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Response: ${response.body}'); 
      print('Sending exam_autoId: $examAutoId');

      // ตรวจสอบว่า key 'students' มีข้อมูลหรือไม่
      if (data['students'] != null) {
        setState(() {
          students = List<Map<String, dynamic>>.from(data['students']);
        });
      } else {
        setState(() {
          errorMessage = 'ยังไม่มีนักเรียนที่ตรวจงานแล้ว';
        });
      }
    } else {
      setState(() {
        errorMessage = 'ไม่สามารถดึงข้อมูลได้. สถานะ: ${response.statusCode}';
      });
    }
  } catch (e) {
    // แสดงข้อความข้อผิดพลาดในกรณีเกิดข้อผิดพลาดในการเชื่อมต่อ
    setState(() {
      errorMessage = 'เกิดข้อผิดพลาด: $e';
    });
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
  fetchStudentData();

  final int examAutoId = widget.exam.autoId;
  if (examAutoId > 0) {
    fetchStudentschecksuccess(examAutoId);
  } else {
    print("exam_autoId is null or invalid");
  }
}



  @override
  void didUpdateWidget(covariant Detail_work oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.exam != oldWidget.exam) {
      _fetchData(); 
      fetchStudentData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final exam = widget.exam;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(' ID: ${exam.autoId}'),
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



            //อัพไฟล์
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
            ],


            //ถาม-ตอบ
            if (exam.type == 'auswer') ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return QuestionListDialog(
                            questions: questionData,
                          );
                        },
                      );
                    },
                    child: Text('แสดงตัวอย่างข้อสอบ'),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'รายชื่อนักเรียนที่ส่งงานแล้ว (${liststudentssubmit.length}):',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              liststudentssubmit.isEmpty
                  ? Center(child: Text('ยังไม่มีนักเรียนที่ส่งงานแล้ว'))
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: liststudentssubmit.length,
                      itemBuilder: (context, index) {
                        final student = liststudentssubmit[index];
                        return ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${student['users_prefix']} ${student['users_thfname']} ${student['users_thlname']} เลขที่: ${student['users_number']}',
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 102, 161, 209),
                                  borderRadius: BorderRadius.circular(20)
                                ),
                                child: OutlinedButton( 
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CheckworkTeacher( 
                                          thfname: widget.thfname,
                                          thlname: widget.thlname,
                                          username: widget.username,                                     
                                          studentData: {
                                            'users_prefix': student['users_prefix'],
                                            'users_thfname': student['users_thfname'],
                                            'users_thlname': student['users_thlname'],
                                            'users_number': student['users_number'],
                                          },
                                        ),        
                                      )
                                    );
                                  },
                                  style: ButtonStyle(
                                    side: MaterialStateProperty.all(BorderSide(color: const Color.fromARGB(255, 0, 0, 0))),
                                  ),
                                  child: Text('ตรวจงาน', style: TextStyle(color: Colors.black)),
                                ),
                              ),
                            ],
                          )
                        );
                      },
                    ),
              SizedBox(height: 16),
              Text(
                'รายชื่อนักเรียนที่ยังไม่ได้ส่งงาน (${liststudentsnotsubmit.length}):',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              liststudentsnotsubmit.isEmpty
                  ? Center(child: Text('ทุกคนได้ส่งงานแล้ว'))
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: liststudentsnotsubmit.length,
                      itemBuilder: (context, index) {
                        final student = liststudentsnotsubmit[index];
                        return ListTile(
                          title: Text(
                            '${student['users_prefix']} ${student['users_thfname']} ${student['users_thlname']} เลขที่: ${student['users_number']}',
                          ),
                        );
                      },
                    ),
            ],




            //ตัวเลือกเดียว
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


            //หลายตัวเลือก
            if (exam.type == 'manychoice') ...[
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

             SizedBox(height: 16),
              Text(
                'รายชื่อนักเรียนที่ตรวจงานแล้ว:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
               students.isEmpty
                ? Center(child: Text('ยังไม่มีงานที่ตรวจแล้ว'))
                : Expanded(
                    child: ListView.builder(
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        final student = students[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(
                                '${student['users_prefix']} ${student['users_thfname']} ${student['users_thlname']}'),
                            subtitle: Text('เลขที่: ${student['users_number']}'),
                          ),
                        );
                      },
                    ),
                  ),
              
          ],
        ),
      ),
    );
  }
}


