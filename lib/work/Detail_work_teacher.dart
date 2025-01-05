import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:flutter_esclass_2/work/auswer/Check%20work_teacher.dart';
import 'package:flutter_esclass_2/work/auswer/QuestionListDialog.dart';
import 'package:flutter_esclass_2/work/manychoice/manychoice_dialog.dart';
import 'package:flutter_esclass_2/work/onechoice/onechoice_dialog.dart';
import 'package:flutter_esclass_2/work/upfile/chech_work_upfile.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
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
  List<Map<String, dynamic>> liststudentssubmitonechoice  = [];
  List<Map<String, dynamic>> liststudentschecksuccess = [];
  late Future<Map<String, dynamic>> futureData; 
  String errorMessage = '';  
  String? currentFileUrl;

  


Future<void> fetchStudentData() async {
  if (widget.exam.type == 'auswer' || widget.exam.type == 'upfile') {
    await fetchStudentDataFORauswerandupfile();
  } else if (widget.exam.type == 'onechoice'|| widget.exam.type == 'manychoice') {
    await fetchStudentDataFORonechoiceandmanychoice();
  } else {
    throw Exception('Invalid exam type');
  }
}



Future<void> fetchStudentDataFORauswerandupfile() async {
  const String apiUrl = "https://www.edueliteroom.com/connect/submission_studentstatusforauswerandupfile.php"; 
  try {
    final response = await http.post(Uri.parse(apiUrl), body: {
      'exam_autoId': widget.exam.autoId.toString(),
      'exam_type': widget.exam.type,
    });

    

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // แปลงข้อมูลจาก API ให้เป็น List ที่มีค่าของ users_number เป็น string
      final studentsSubmitted = List<Map<String, dynamic>>.from(data['students_submitted'].map((student) {
        student['users_number'] = student['users_number'].toString();  
        return student;
      }));

      final studentsNotSubmitted = List<Map<String, dynamic>>.from(data['students_not_submitted'].map((student) {
        student['users_number'] = student['users_number'].toString(); 
        return student;
      }));

      final studentsCheckSuccess = List<Map<String, dynamic>>.from(data['students_check_success'].map((student) {
        student['users_number'] = student['users_number'].toString(); 
        return student;
      }));

      // อัปเดตสถานะใน State
      setState(() {
        liststudentssubmit = studentsSubmitted;
        liststudentsnotsubmit = studentsNotSubmitted;
        liststudentschecksuccess = studentsCheckSuccess;
      });

    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    throw Exception('Failed to load data: $e');
  }
}

Future<void> fetchStudentDataFORonechoiceandmanychoice() async {
  const String apiUrl = "https://www.edueliteroom.com/connect/submission_studentstatusforonechoice.php"; 

  try {
    final response = await http.post(Uri.parse(apiUrl), body: {
      'exam_autoId': widget.exam.autoId.toString(),
      'exam_type': widget.exam.type,
    });


    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      
      List<Map<String, dynamic>> transformStudents(List<dynamic> students) {
        return List<Map<String, dynamic>>.from(students.map((student) {
          student['users_number'] = student['users_number'].toString();
          return student;
        }));
      }

      
      final studentsSubmitted = transformStudents(data['students_submitted'] ?? []);
      final studentsNotSubmitted = transformStudents(data['students_not_submitted'] ?? []);

      
      setState(() {
        liststudentssubmit = studentsSubmitted;
        liststudentsnotsubmit = studentsNotSubmitted;
      });

    } else {
      throw Exception('Failed to load data, status code: ${response.statusCode}');
    }
  } catch (e) {
    // Display an error message
    setState(() {
      // Optionally, you can set an error state to display a message to the user
      print('Error: $e');
    });
    throw Exception('Failed to load data: $e');
  }
}



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

    final int examAutoId = widget.exam.autoId;
    if (examAutoId > 0) {
      
    } else {
      print("exam_autoId is null or invalid");
    }
  }
}


  @override
  Widget build(BuildContext context) {
    final exam = widget.exam;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Text(exam.fullMark.toStringAsFixed(2)),

            SizedBox(height: 16),
            Text(
              'วันที่ครบกำหนด:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(' ${exam.deadline}'),
            SizedBox(height: 16),



            //อัพไฟล์
            if (widget.exam.type == 'upfile') ...[
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
                  SizedBox(height: 16),
                  Text(
                  'สถานะการปิดรับงาน :',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              if (exam.closed == 'Yes') ...[
                SizedBox(height: 16),
                Text(
                  'ปิดรับงานเมื่อครบกำหนดส่ง',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ],
              if (exam.closed == 'No') ...[
                SizedBox(height: 16),
                Text(
                  'ไม่มีการปิดรับงานเมื่อครบกำหนดส่ง',
                  style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0), fontSize: 16),
                ),
              ],
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
                  DateTime deadlineDate = DateFormat('yyyy-MM-dd').parse(widget.exam.deadline);  
                  DateTime submitDate = DateFormat('yyyy-MM-dd HH:mm:ss').parse(student['submit_time']); 

                  Duration difference = submitDate.difference(deadlineDate);

                  // กรณีส่งงานก่อนกำหนด (ไม่แสดงข้อความ "เลยกำหนด")
                  if (difference.isNegative) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${student['users_prefix']} ${student['users_thfname']} ${student['users_thlname']} เลขที่: ${student['users_number']}',
                            ),
                            // ปุ่ม "ตรวจงาน"
                            Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 102, 161, 209),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChechWorkUpfile(
                                        thfname: widget.thfname,
                                        thlname: widget.thlname,
                                        username: widget.username,
                                        studentData: {
                                          'users_prefix': student['users_prefix'],
                                          'users_thfname': student['users_thfname'],
                                          'users_thlname': student['users_thlname'],
                                          'users_number': student['users_number'],
                                        },
                                        exam: widget.exam,
                                        
                                      ),
                                    ),
                                  ).then((_) {
                                    // รีเซ็ตข้อมูลเมื่อกลับมาจากหน้า ChechWorkUpfile
                                    setState(() {
                                      currentFileUrl = null;
                                    });
                                  });
                                },
                                style: ButtonStyle(
                                  side: MaterialStateProperty.all(
                                    BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                                  ),
                                ),
                                child: Text('ตรวจงาน', style: TextStyle(color: Colors.black)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // กรณีส่งงานหลังวันกำหนด (แสดงจำนวนวันที่เลยกำหนด)
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // ข้อมูลนักเรียน
                          Text(
                            '${student['users_prefix']} ${student['users_thfname']} ${student['users_thlname']} เลขที่: ${student['users_number']} (เลยกำหนด ${difference.inDays} วัน)',
                          ),
                          // ปุ่ม "ตรวจงาน"
                          Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 102, 161, 209),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChechWorkUpfile(
                                      thfname: widget.thfname,
                                      thlname: widget.thlname,
                                      username: widget.username,
                                      studentData: {
                                        'users_prefix': student['users_prefix'],
                                        'users_thfname': student['users_thfname'],
                                        'users_thlname': student['users_thlname'],
                                        'users_number': student['users_number'],
                                      },
                                      exam: widget.exam,
                                    ),
                                  ),
                                ).then((_) {
                                  // รีเซ็ตข้อมูลเมื่อกลับมาจากหน้า ChechWorkUpfile
                                  setState(() {
                                    currentFileUrl = null;
                                  });
                                });
                              },
                              style: ButtonStyle(
                                side: MaterialStateProperty.all(
                                  BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                                ),
                              ),
                              child: Text('ตรวจงาน', style: TextStyle(color: Colors.black)),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                SizedBox(height: 16),
              Text(
                'รายชื่อนักเรียนที่ตรวจงานแล้ว (${liststudentschecksuccess.length}):',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              liststudentschecksuccess.isEmpty
                  ? Center(child: Text('ยังไม่มีงานที่ตรวจแล้ว'))
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: liststudentschecksuccess.length,
                      itemBuilder: (context, index) {
                      final student = liststudentschecksuccess[index];
                          return ListTile(
                              title: Text(
                                  '${student['users_prefix']} ${student['users_thfname']} ${student['users_thlname']} เลขที่: ${student['users_number']}',
                                ),
                              );
                              
                      },
                    ),                 

                
            ],


            //ถาม-ตอบ
            if (widget.exam.type == 'auswer') ...[

              SizedBox(height: 16),
              Text(
                  'สถานะการปิดรับงาน :',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              if (exam.closed == 'Yes') ...[
                SizedBox(height: 16),
                Text(
                  'ปิดรับงานเมื่อครบกำหนดส่ง',
                  style: TextStyle(color: Colors.red,fontSize: 16),
                ),
              ],
              if (exam.closed == 'No') ...[
                SizedBox(height: 16),
                Text(
                  'ไม่มีการปิดรับงานเมื่อครบกำหนดส่ง',
                  style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0), fontSize: 16),
                ),
              ],
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return QuestionListDialog(
                            exam: widget.exam, 
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

                        DateTime deadlineDate = DateFormat('yyyy-MM-dd').parse(widget.exam.deadline);  
                        DateTime submitDate = DateFormat('yyyy-MM-dd HH:mm:ss').parse(student['submit_time']); 

                        Duration difference = submitDate.difference(deadlineDate);
                        if (difference.isNegative) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${student['users_prefix']} ${student['users_thfname']} ${student['users_thlname']} เลขที่: ${student['users_number']}',
                                  ),
                                  // ปุ่ม "ตรวจงาน"
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 102, 161, 209),
                                      borderRadius: BorderRadius.circular(20),
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
                                              exam: widget.exam,
                                            ),
                                          ),
                                        ).then((_) {
                                          // รีเซ็ตข้อมูลเมื่อกลับมาจากหน้า ChechWorkUpfile
                                          setState(() {
                                            currentFileUrl = null;
                                          });
                                        });
                                      },
                                      style: ButtonStyle(
                                        side: MaterialStateProperty.all(
                                          BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                                        ),
                                      ),
                                      child: Text('ตรวจงาน', style: TextStyle(color: Colors.black)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        // กรณีส่งงานหลังวันกำหนด (แสดงจำนวนวันที่เลยกำหนด)
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // ข้อมูลนักเรียน
                          Text(
                            '${student['users_prefix']} ${student['users_thfname']} ${student['users_thlname']} เลขที่: ${student['users_number']} (เลยกำหนด ${difference.inDays} วัน)',
                          ),
                          // ปุ่ม "ตรวจงาน"
                          Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 102, 161, 209),
                              borderRadius: BorderRadius.circular(20),
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
                                      exam: widget.exam,
                                    ),
                                  ),
                                ).then((_) {
                                  // รีเซ็ตข้อมูลเมื่อกลับมาจากหน้า ChechWorkUpfile
                                  setState(() {
                                    currentFileUrl = null;
                                  });
                                });
                              },
                              style: ButtonStyle(
                                side: MaterialStateProperty.all(
                                  BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                                ),
                              ),
                              child: Text('ตรวจงาน', style: TextStyle(color: Colors.black)),
                            ),
                          ),
                        ],
                      ),
                    ),
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

              SizedBox(height: 16),
              Text(
                'รายชื่อนักเรียนที่ตรวจงานแล้ว (${liststudentschecksuccess.length}):',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              liststudentschecksuccess.isEmpty
                  ? Center(child: Text('ยังไม่มีงานที่ตรวจแล้ว'))
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: liststudentschecksuccess.length,
                      itemBuilder: (context, index) {
                      final student = liststudentschecksuccess[index];
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
              SizedBox(height: 16),
              Text(
                  'สถานะการปิดรับงาน (${liststudentssubmit.length}):',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              if (exam.closed == 'Yes') ...[
                SizedBox(height: 16),
                Text(
                  'ปิดรับงานเมื่อครบกำหนดส่ง',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ],
              if (exam.closed == 'No') ...[
                SizedBox(height: 16),
                Text(
                  'ไม่มีการปิดรับงานเมื่อครบกำหนดส่ง',
                  style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0), fontSize: 16),
                ),
              ],
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end, 
                children: [
                  OutlinedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return OnechoiceDialog(exam: widget.exam,
                            
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
                    'รายชื่อนักเรียนที่ทำแบบทดสอบแล้ว (${liststudentssubmit.length}):',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  liststudentssubmit.isEmpty
                      ? Center(child: Text('ยังไม่มีนักเรียนที่ทำแบบทดสอบ'))
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
                                  Text(' ${student['score_total']} คะแนน')
                                ],
                              )
                            );
                            
                          },
                        ),
                  SizedBox(height: 16),
                  Text(
                    'รายชื่อนักเรียนที่ยังไม่ได้ทำแบบทดสอบ (${liststudentsnotsubmit.length}):',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  liststudentsnotsubmit.isEmpty
                      ? Center(child: Text('ทุกคนได้ทำแบบทดสอบแล้ว'))
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


            //หลายตัวเลือก
            if (exam.type == 'manychoice') ...[
              SizedBox(height: 16),
              Text(
                  'สถานะการปิดรับงาน :',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              if (exam.closed == 'Yes') ...[
                SizedBox(height: 16),
                Text(
                  'ปิดรับงานเมื่อครบกำหนดส่ง',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ],
              if (exam.closed == 'No') ...[
                SizedBox(height: 16),
                Text(
                  'ไม่มีการปิดรับงานเมื่อครบกำหนดส่ง',
                  style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0), fontSize: 16),
                ),
              ],
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [
                  OutlinedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return ManychoiceDialog(exam: widget.exam, thfname: widget.thfname, thlname: widget.thlname,username: widget.username,
                            
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
                    'รายชื่อนักเรียนที่ทำแบบทดสอบแล้ว (${liststudentssubmit.length}):',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  liststudentssubmit.isEmpty
                      ? Center(child: Text('ยังไม่มีนักเรียนที่ทำแบบทดสอบ'))
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
                                  Text(' ${student['score_total']} คะแนน')
                                ],
                              )
                            );
                            
                          },
                        ),
                  SizedBox(height: 16),
                  Text(
                    'รายชื่อนักเรียนที่ยังไม่ได้ทำแบบทดสอบ (${liststudentsnotsubmit.length}):',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  liststudentsnotsubmit.isEmpty
                      ? Center(child: Text('ทุกคนได้ทำแบบทดสอบแล้ว'))
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

             
              
          ],
        ),
      ),
    );
  }
}


