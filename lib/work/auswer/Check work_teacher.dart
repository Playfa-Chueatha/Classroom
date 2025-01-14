import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:flutter_esclass_2/work/asign_work_T.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CheckworkTeacher extends StatefulWidget {
  final Map<String, dynamic> studentData;
  final Examset exam;
  final String username;
  final String thfname;
  final String thlname;
  final String classroomName;
  final String classroomMajor;
  final String classroomYear;
  final String classroomNumRoom;

  const CheckworkTeacher({
    super.key,
    required this.exam,
    required this.studentData,
    required this.username, 
    required this.thfname, 
    required this.thlname, 
    required this.classroomName, 
    required this.classroomMajor, 
    required this.classroomYear, 
    required this.classroomNumRoom, 
  });

  @override
  State<CheckworkTeacher> createState() => _CheckworkTeacherState();
}

class _CheckworkTeacherState extends State<CheckworkTeacher> {
  late Future<UserSubmission> userSubmissionFuture;
  UserSubmission? userSubmissionData;
  Map<int, TextEditingController> controllers = {};
  double total = 0.0;
  
  // FocusNode สำหรับควบคุมการโฟกัส
  final Map<int, FocusNode> focusNodes = {};

  Future<void> submitScore({
  required int questionId,
  required String questionDetail,
  required String checkworkScore,
  required String usersUsername,
  required String examAutoId,
  required double total,
}) async {
  final url = Uri.parse('https://www.edueliteroom.com/connect/submit_score_auswer.php');
  

  // แปลงคะแนนเป็นทศนิยม 2 ตำแหน่ง
  String formattedScore = double.tryParse(checkworkScore) != null
      ? double.parse(checkworkScore).toStringAsFixed(2)
      : '0.00';

  String formattedTotal = total.toStringAsFixed(2); // แปลงคะแนนรวมเป็นทศนิยม 2 ตำแหน่ง

  final body = {
    'action': 'save_checkwork',
    'question_id': questionId.toString(),
    'question_detail': questionDetail,
    'checkwork_auswer_score': formattedScore,
    'users_username': usersUsername,
    'examsets_id': examAutoId,
    'total_score': formattedTotal,
  };
  print(body);

  try {
    final response = await http.post(url, body: body);

    try {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        print('Data saved successfully!');
      } else {
        print('Error: ${data['error']}');
      }
    } catch (e) {
      print('Error decoding JSON: $e');
    }

  } catch (e) {
    print('Error: $e');
  }
}


  void _calculateTotal() {
    double newTotal = 0.0;
    controllers.forEach((questionId, controller) {
      final scoreText = controller.text;
      if (scoreText.isNotEmpty) {
        final score = double.tryParse(scoreText);
        if (score != null) {
          newTotal += score;
        }
      }
    });

    setState(() {
      total = newTotal; 
    });
  }

  @override
  void initState() {
    super.initState();
    userSubmissionFuture = ApiService().fetchUserSubmission(
      usersPrefix: widget.studentData['users_prefix'],
      usersThfname: widget.studentData['users_thfname'],
      usersThlname: widget.studentData['users_thlname'],
      usersNumber: widget.studentData['users_number'].toString(),
      examAutoId: widget.exam.autoId.toString(),
    );
    debugPrint = (String? message, {int? wrapWidth}) {};
  }

  @override
  void dispose() {
    // Dispose of focus nodes and controllers
    focusNodes.forEach((key, node) {
      node.dispose();
    });
    controllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'ตรวจงาน ${widget.studentData['users_prefix']} '
          '${widget.studentData['users_thfname']} '
          '${widget.studentData['users_thlname']} '
          'เลขที่: ${widget.studentData['users_number']}'
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
      body: SingleChildScrollView( // ทำให้สามารถเลื่อน UI ได้
        child: Column(
          children: [
            FutureBuilder<UserSubmission>(
              future: userSubmissionFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  userSubmissionData = snapshot.data;
                  return ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: userSubmissionData!.submissions.length,
                    shrinkWrap: true, // ให้สามารถเลื่อนรายการได้โดยไม่ต้องใช้ Expand
                    itemBuilder: (context, index) {
                      final submission = userSubmissionData!.submissions[index];

                      // สร้าง FocusNode และ TextEditingController ใหม่หากยังไม่มี
                      if (!controllers.containsKey(submission.questionId)) {
                        controllers[submission.questionId] = TextEditingController();
                        focusNodes[submission.questionId] = FocusNode();
                      }

                      final controller = controllers[submission.questionId]!;
                      final focusNode = focusNodes[submission.questionId]!;

                      return GestureDetector(
                        onTap: () {
                          FocusScope.of(context).requestFocus(focusNode);
                        },
                        child: Card(
                          elevation: 4.0,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'คำถาม: ${submission.questionDetail.isNotEmpty ? submission.questionDetail : 'No details available'}',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  'คำตอบ: ${submission.submitAuswerReply}',
                                  style: TextStyle(fontSize: 16.0, color: Colors.grey[700]),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'คะแนน: ${submission.questionMark.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                ScoreInputForm(
                                  maxMark: submission.questionMark,
                                  controller: controller,
                                  focusNode: focusNode,
                                  onChanged: (value) {
                                    _calculateTotal(); // เรียกฟังก์ชันคำนวณผลรวมเมื่อมีการกรอกข้อมูล
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: Text('No data found.'));
                }
              },
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('คะแนนรวม: '),
                  Text(total.toStringAsFixed(2)),
                  Text('/${widget.exam.fullMark}'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    final submissions = await userSubmissionFuture;
                    bool allScoresEntered = true;  // ตัวแปรตรวจสอบการกรอกคะแนน

                    for (final submission in submissions.submissions) {
                      final controller = controllers[submission.questionId];

                      // ตรวจสอบว่า controller.text ว่างหรือไม่
                      if (controller == null || controller.text.isEmpty) {
                        allScoresEntered = false;
                        break; // ออกจากลูปหากพบคำถามที่ไม่มีการกรอกคะแนน
                      }
                    }

                    // หากไม่มีการกรอกคะแนนในคำถามใดๆ แสดง SnackBar แจ้งเตือน
                    if (!allScoresEntered) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('กรุณากรอกคะแนนให้ครบทุกคำถาม'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;  // หยุดการดำเนินการหากไม่มีการกรอกคะแนน
                    }

                    // หากทุกคำถามกรอกคะแนนแล้ว, ทำการบันทึกข้อมูล
                    for (final submission in submissions.submissions) {
                      final controller = controllers[submission.questionId];
                      if (controller != null && controller.text.isNotEmpty) {
                        await submitScore(
                          questionId: submission.questionId,
                          questionDetail: submission.questionDetail,
                          checkworkScore: controller.text,
                          usersUsername: submissions.usersUsername,
                          examAutoId: widget.exam.autoId.toString(),
                          total: total,
                        );
                      }
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('บันทึกข้อมูลสำเร็จ!'),
                        backgroundColor: Colors.green, 
                      ),
                    );

                  Navigator.pop(context, 'refresh');
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('เกิดข้อผิดพลาด: $e'),
                        backgroundColor: Colors.red, 
                      ),
                    );
                  }
                },
                child: Text('บันทึกคะแนนทั้งหมด'),
              )
            ),
          ],
        ),
      ),
    );
  }
}

class ScoreInputForm extends StatelessWidget {
  final double maxMark;
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  const ScoreInputForm({
    super.key,
    required this.maxMark,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: 'กรอกคะแนน',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        inputFormatters: [
          // กรองเฉพาะตัวเลขและทศนิยมที่มีไม่เกิน 2 ตำแหน่ง
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}$')), 
          TextInputFormatter.withFunction((oldValue, newValue) {
            if (newValue.text.isNotEmpty) {
              // แปลงค่าที่กรอกเป็นทศนิยมเพื่อให้ตรวจสอบว่าไม่เกินคะแนนเต็ม
              final newValueDouble = double.tryParse(newValue.text);
              if (newValueDouble != null && newValueDouble > maxMark) {
                return oldValue;  // คืนค่ากลับหากเกิน maxMark
              }
            }
            return newValue;  // คืนค่าปกติ
          }),
        ],
      ),
    );
  }
}


class ApiService {
  Future<UserSubmission> fetchUserSubmission({
    required String usersPrefix,
    required String usersThfname,
    required String usersThlname,
    required String usersNumber,
    required String examAutoId, // เพิ่มพารามิเตอร์ examAutoId
  }) async {
    const url = 'https://www.edueliteroom.com/connect/fetch_submitforcheck.php';
    
    final response = await http.post(
      Uri.parse(url),
      body: {
        'users_prefix': usersPrefix,
        'users_thfname': usersThfname,
        'users_thlname': usersThlname,
        'users_number': usersNumber,
        'auto_id': examAutoId, // ส่งค่า examAutoId ในคำขอ
      },
    );
    print(response.body);


    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['error'] != null) {
        throw Exception(data['error']);
      }
      return UserSubmission.fromJson(data);
    } else {
      throw Exception('Failed to connect to the server.');
    }
  }
}

