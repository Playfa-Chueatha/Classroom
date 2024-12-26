import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:flutter_esclass_2/work/Detail_work_students.dart';
import 'package:flutter_esclass_2/work/asign_work_S.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Successonechoice extends StatefulWidget {
  final Examset exam;
  final String username;
  final String thfname;
  final String thlname;
  final String type;

  const Successonechoice({
    super.key,
    required this.exam,
    required this.username,
    required this.thfname, 
    required this.thlname, 
    required this.type,
  });

  @override
  State<Successonechoice> createState() => _SuccessonechoiceState();
}

class _SuccessonechoiceState extends State<Successonechoice> {
  late Future<List<SubmitOneChoice>> _data;

  @override
  void initState() {
    super.initState();
    _data = fetchData();
  }

  // ฟังก์ชันที่ดึงข้อมูลจาก API
  Future<List<SubmitOneChoice>> fetchData() async {
    final response = await http.get(Uri.parse(
      'https://www.edueliteroom.com/connect/fetch_submit_onechoice.php?username=${widget.username}&examsetsId=${widget.exam.autoId.toString()}')
    );

    print(response.body);

    if (response.statusCode == 200) {
      print(response.body);  
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => SubmitOneChoice.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }


  // ฟังก์ชันที่บันทึกคะแนนลงฐานข้อมูล
  Future<void> saveScoreToDatabase(double totalScore) async {
    final response = await http.post(
      Uri.parse('https://www.edueliteroom.com/connect/save_totalscore.php'), // URL ที่จะใช้บันทึกข้อมูล
      body: {
        'examsets_id': widget.exam.autoId.toString(),
        'score_total': totalScore.toString(),
        'users_username': widget.username,
        'score_type': widget.type  // แก้ไขให้ใช้ widget.type
      },
    );

    // พิมพ์ข้อมูล response
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}'); // เพิ่มการพิมพ์ body ของ response เพื่อดูข้อมูลที่กลับมา

    if (response.statusCode == 200) {
      // ข้อมูลถูกบันทึกสำเร็จ
      print('Data saved successfully');
    } else {
      // หากมีข้อผิดพลาด
      print('Failed to save data: ${response.body}');
      throw Exception('Failed to save data');
    }
  }

  // ฟังก์ชันที่คำนวณผลรวมของคะแนน
  double calculateTotalScore(List<SubmitOneChoice> items) {
    return items.fold(0.0, (total, item) => total + item.submitOneChoiceScore);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<List<SubmitOneChoice>>(
          future: _data,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              // ดึงข้อมูล item แรกจาก snapshot.data!
              final firstItem = snapshot.data!.first;
              // คำนวณผลรวมของคะแนน
              double totalScore = calculateTotalScore(snapshot.data!);

              // บันทึกคะแนนลงฐานข้อมูลหลังจากคำนวณแล้ว
              saveScoreToDatabase(totalScore);

              return Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blueAccent,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'ทำข้อสอบสำเร็จ!',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                      SizedBox(height: 10), // เพิ่มระยะห่าง
                      Text(
                        'คะแนนของคุณคือ: $totalScore/${firstItem.examsetsFullmark}',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      SizedBox(height: 20),
                      IconButton(
                        icon: Icon(Icons.arrow_back),  
                        onPressed: () {
                          Navigator.push(context,
                           MaterialPageRoute(builder: (context) => work_body_S(thfname: widget.thfname,thlname: widget.thlname,username: widget.username,classroomMajor: '',classroomName: '',classroomNumRoom: '',classroomYear: '',))
                           );
                        },
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Text('No data available');
            }
          },
        ),
      ),
    );
  }
}
