import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:flutter_esclass_2/work/asign_work_S.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Successmanychoice extends StatefulWidget {
  final Examset exam;
  final String username;
  final String thfname;
  final String thlname;
  final String type;

  const Successmanychoice({
    super.key,
    required this.exam,
    required this.username,
    required this.thfname, 
    required this.thlname, 
    required this.type,
  });

  @override
  State<Successmanychoice> createState() => _SuccessmanychoiceState();
}

class _SuccessmanychoiceState extends State<Successmanychoice> {
  late Future<List<SubmitManyChoice>> _data;
  

  @override
  void initState() {
    super.initState();
    _data = fetchData();
  }

  Future<List<SubmitManyChoice>> fetchData() async {
  final url = 'https://www.edueliteroom.com/connect/fetch_submit_manychoice.php?username=${widget.username}&examsetsId=${widget.exam.autoId.toString()}';

  debugPrint("Request URL: $url");

  try {
    final response = await http.get(Uri.parse(url));
    debugPrint("Response Status Code: ${response.statusCode}");
    debugPrint("API Response: ${response.body}");

    if (response.statusCode == 200) {
      try {
        var data = json.decode(response.body);

        // ตรวจสอบว่า data เป็น Map หรือ List
        if (data is List) {
          debugPrint("Data is List");
          return data.map((item) => SubmitManyChoice.fromJson(item)).toList();
        } else if (data is Map) {
          if (data.containsKey('message')) {
            debugPrint("Received message: ${data['message']}");
            if (data['message'] == 'No results found') {
              return [];
            }
          }
          return [];
        } else {
          debugPrint("Unexpected data type received");
          return [];
        }
      } catch (e) {
        debugPrint('Error parsing JSON: $e');
        return [];
      }
    } else {
      debugPrint('Request failed with status: ${response.statusCode}');
      throw Exception('Failed to load data');
    }
  } catch (e) {
    debugPrint('Error occurred: $e');
    return [];
  }
}

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
  double calculateTotalScore(List<SubmitManyChoice> items) {
  return items.fold(0.0, (total, item) {
    if (item.submitManyChoiceScore > 0) {
      return total + item.submitManyChoiceScore;
    }
    return total;
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<List<SubmitManyChoice>>(
          future: _data,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              // คำนวณผลรวมของคะแนน
              double totalScore = calculateTotalScore(snapshot.data!);
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
                        'คะแนนของคุณคือ: $totalScore/${widget.exam.fullMark}', // ใช้คะแนนสูงสุดจาก submitManyChoiceScore
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      SizedBox(height: 20),
                      IconButton(
                        icon: Icon(Icons.arrow_back),  
                        onPressed: () {
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) => work_body_S(
                              thfname: widget.thfname,
                              thlname: widget.thlname,
                              username: widget.username,
                              classroomMajor: '',
                              classroomName: '',
                              classroomNumRoom: '',
                              classroomYear: '',
                            ))
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

