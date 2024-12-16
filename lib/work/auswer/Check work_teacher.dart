import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:flutter_esclass_2/work/asign_work_T.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CheckworkTeacher extends StatefulWidget {
  final Map<String, dynamic> studentData;
  final String username;
  final String thfname;
  final String thlname;

  const CheckworkTeacher({
    super.key,
    required this.studentData,
    required this.username, 
    required this.thfname, 
    required this.thlname, 
  });

  @override
  State<CheckworkTeacher> createState() => _CheckworkTeacherState();
}

class _CheckworkTeacherState extends State<CheckworkTeacher> {
  late Future<UserSubmission> userSubmissionFuture;
   final Map<int, TextEditingController> controllers = {};


  Future<void> submitScore({
    required int questionId,
    required String questionDetail,
    required String checkworkScore,
    required String usersUsername,
  }) async {
    const url = 'https://www.edueliteroom.com/connect/submit_score_auswer.php';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'action': 'save_checkwork',
          'question_id': questionId.toString(),
          'question_detail': questionDetail,
          'checkwork_auswer_score': checkworkScore,
          'users_username': usersUsername,
        },
      );

      final data = json.decode(response.body);
      if (data['success'] == true) {
        print('Score saved successfully.');
      } else {
        print('Error: ${data['error']}');
        throw Exception(data['error']);
      }
    } catch (e) {
      print('Failed to save score: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('เกิดข้อผิดพลาด: $e'),
          backgroundColor: Colors.red, 
        ),
        
      );
    }
  }



  @override
  void initState() {
    super.initState();
    userSubmissionFuture = ApiService().fetchUserSubmission(
      usersPrefix: widget.studentData['users_prefix'],
      usersThfname: widget.studentData['users_thfname'],
      usersThlname: widget.studentData['users_thlname'],
      usersNumber: widget.studentData['users_number'].toString(),
    );
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
      body: Column(
        children: [
          Expanded(
            child:  FutureBuilder<UserSubmission>(
              future: userSubmissionFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final userSubmission = snapshot.data!;
                  return ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: userSubmission.submissions.length,
                    itemBuilder: (context, index) {
                      final submission = userSubmission.submissions[index];

                      if (!controllers.containsKey(submission.questionId)) {
                      controllers[submission.questionId] = TextEditingController();
                    }

                    final controller = controllers[submission.questionId]!;

  
                     return Card(
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
                              'คะแนน: ${submission.questionMark}',
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
                            ),
                          ],
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
        ),


         Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                try {
                  final submissions = await userSubmissionFuture;
                  for (final submission in submissions.submissions) {
                    final controller = controllers[submission.questionId];
                    if (controller == null || controller.text.isEmpty) {
                      continue;
                    }

                    await submitScore(
                      questionId: submission.questionId,
                      questionDetail: submission.questionDetail,
                      checkworkScore: controller.text,
                      usersUsername: submissions.usersUsername,
                    );
                  }

                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('บันทึกข้อมูลสำเร็จ!'),
                      backgroundColor: Colors.green, 
                    ),
                  );

                 
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => AssignWork_class_T(
                      classroomMajor: '',
                      classroomName: '',
                      classroomNumRoom: '',
                      classroomYear: '',
                      thfname: widget.thfname,
                      thlname: widget.thlname,
                      username: widget.username,

                    )),
                  );
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
            ),
          )

        ],
      )
      
     
    );
  }
}

class ScoreInputForm extends StatelessWidget {
  final int maxMark;
  final TextEditingController controller;

  const ScoreInputForm({
    super.key,
    required this.maxMark,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'กรอกคะแนน',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          TextInputFormatter.withFunction((oldValue, newValue) {
            
            if (newValue.text.isNotEmpty) {
              final newValueInt = int.tryParse(newValue.text);
              if (newValueInt != null && newValueInt > maxMark) {
                return oldValue; 
              }
            }
            return newValue;
          }),
        ],
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'กรุณากรอกคะแนนเต็ม';
          }
          return null;
        },
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
  }) async {
    const url = 'https://www.edueliteroom.com/connect/fetch_submitforcheck.php';
    
    // ตรวจสอบค่าก่อนส่งคำขอ
    print('usersPrefix: $usersPrefix');
    print('usersThfname: $usersThfname');
    print('usersThlname: $usersThlname');
    print('usersNumber: $usersNumber');

    final response = await http.post(
      Uri.parse(url),
      body: {
        'users_prefix': usersPrefix,
        'users_thfname': usersThfname,
        'users_thlname': usersThlname,
        'users_number': usersNumber,
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('API Response: $data');
      if (data['error'] != null) {
        throw Exception(data['error']);
      }
      return UserSubmission.fromJson(data);
    } else {
      throw Exception('Failed to connect to the server.');
    }
  }
}


class UserSubmission {
  final String usersUsername;
  final List<Submission> submissions;

  UserSubmission({
    required this.usersUsername,
    required this.submissions,
  });

  factory UserSubmission.fromJson(Map<String, dynamic> json) {
    return UserSubmission(
      usersUsername: json['user']['users_username'],
      submissions: (json['submissions'] as List)
          .map((submission) => Submission.fromJson(submission))
          .toList(),
    );
  }
}

class Submission {
  final int examsetsId;
  final int questionId;
  final String questionDetail;
  final String submitAuswerReply;
  final int questionMark;

  Submission({
    required this.examsetsId,
    required this.questionId,
    required this.questionDetail,
    required this.submitAuswerReply,
    required this.questionMark,
  });

  factory Submission.fromJson(Map<String, dynamic> json) {
    print(json);  // ตรวจสอบข้อมูลแต่ละ submission
    return Submission(
      examsetsId: int.tryParse(json['examsets_id'].toString()) ?? 0,
      questionId: int.tryParse(json['question_id'].toString()) ?? 0,
      questionDetail: json['question_details']['question_detail'] ?? 'No details available',
      submitAuswerReply: json['submit_auswer_reply'] ?? '',
      questionMark: int.tryParse(json['question_details']['auswer_question_score'].toString()) ?? 0,
    );
  }
}
