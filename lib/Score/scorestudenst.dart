import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Scorestudenstofrteacher extends StatefulWidget {
  final String username;
  final String thfname;
  final String thlname;
  final String classroomName;
  final String classroomMajor;
  final String classroomYear;
  final String classroomNumRoom;

  const Scorestudenstofrteacher({
    super.key,
    required this.username,
    required this.thfname,
    required this.thlname,
    required this.classroomName,
    required this.classroomMajor,
    required this.classroomYear,
    required this.classroomNumRoom,
  });

  @override
  State<Scorestudenstofrteacher> createState() => _ScorestudentsState();
}

class _ScorestudentsState extends State<Scorestudenstofrteacher> {
  late Future<ScoreStudentsInClass> futureData;
  Map<String, List<ExamsetDetails>> groupedExamsets = {};
  Map<int, double> newFullScores = {};
  bool isEditing = false;
  double? newFullMark;
  late Future<List<HistoryCheckin>> historyCheckinsFuture;
  Map<String, Map<int, String>> editedScores = {};
  List<HistoryCheckin> historyCheckins = [];
  bool _isStatusFound = false;
  String? scoreMessage;
  final Map<String, TextEditingController> _controllers = {};
  Map<String, Map<String, double>> adjustedScores = {};
  



  @override
  void initState() {
    super.initState();
    // กำหนดค่า futureData ที่จะดึงข้อมูลทันทีที่เริ่มสร้าง widget
    futureData = fetchScoreData();
    affectivefull(
    classroomName: widget.classroomName,
    classroomMajor: widget.classroomMajor,
    classroomYear: widget.classroomYear,
    classroomNumRoom: widget.classroomNumRoom,
    username: widget.username,
  ).then((data) {
    setState(() {
      
      if (data['status'] == 'found') {
        scoreMessage = data['affectivefull_domain_score'].toString(); 
        _isStatusFound = true; 
      } else {
        scoreMessage = 'ไม่พบข้อมูลคะแนน';
        _isStatusFound = false; 
      }
    });
  }).catchError((error) {
    setState(() {
      scoreMessage = 'เกิดข้อผิดพลาด: $error'; 
      _isStatusFound = false; 
    });
  });
    historyCheckinsFuture = fetchHistoryCheckin(
      widget.classroomName, widget.classroomMajor, widget.classroomYear, widget.classroomNumRoom);
  }

  // ฟังก์ชันการดึงข้อมูลคะแนนนักเรียน
  Future<ScoreStudentsInClass> fetchScoreData() async {
    final response = await http.post(
      Uri.parse('https://www.edueliteroom.com/connect/fetch_scorestudentsinclass.php'),
      body: {
        'classroomName': widget.classroomName,
        'classroomMajor': widget.classroomMajor,
        'classroomYear': widget.classroomYear,
        'classroomNumRoom': widget.classroomNumRoom,
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData != null) {
        return ScoreStudentsInClass.fromJson(jsonData);
      } else {
        throw Exception('ข้อมูลไม่ถูกต้อง');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  // ฟังก์ชันการบันทึกคะแนน
  Future<void> saveScores() async {
    bool hasError = false;

    for (var username in editedScores.keys) {
      for (var examsetId in editedScores[username]!.keys) {
        final score = editedScores[username]![examsetId];

        if (username.isEmpty || examsetId == 0 || score == null || score.isEmpty) {
          print('Missing required parameter: username=$username, examsetId=$examsetId, score=$score');
          hasError = true;
          continue;
        }

        final response = await http.post(
          Uri.parse('https://www.edueliteroom.com/connect/update_scorestudents.php'),
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            'username': username,
            'examsetId': examsetId,
            'scoreTotal': score,
          }),
        );

        if (response.statusCode != 200) {
          hasError = true;
          print('Error saving score for $username (Examset ID: $examsetId): ${response.body}');
        }
      }
    }

    if (!hasError) {
      setState(() {
        isEditing = false;
        editedScores.clear();
        futureData = fetchScoreData();  // ดึงข้อมูลใหม่เมื่อบันทึกคะแนน
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('บันทึกคะแนนสำเร็จ!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการบันทึกคะแนน!')),
      );
    }
  }

  // ฟังก์ชันการดึงข้อมูลการเช็คชื่อ
  Future<List<HistoryCheckin>> fetchHistoryCheckin(
      String classroomName, String classroomMajor, String classroomYear, String classroomNumRoom) async {
    final response = await http.post(
      Uri.parse('https://www.edueliteroom.com/connect/historycheckin.php'),
      body: {
        'classroomName': classroomName,
        'classroomMajor': classroomMajor,
        'classroomYear': classroomYear,
        'classroomNumRoom': classroomNumRoom,
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => HistoryCheckin.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  // ฟังก์ชันการจัดกลุ่มข้อสอบ
  void groupAndSortExamsets(List<ExamsetDetails> examsets) {
    groupedExamsets = {};
    for (var examset in examsets) {
      if (!groupedExamsets.containsKey(examset.examsetType)) {
        groupedExamsets[examset.examsetType] = [];
      }
      groupedExamsets[examset.examsetType]!.add(examset);
    }

    groupedExamsets = Map.fromEntries(
      groupedExamsets.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
  }


  Future<Map<String, dynamic>> affectivefull({
  required String classroomName,
  required String classroomMajor,
  required String classroomYear,
  required String classroomNumRoom,
  required String username,
}) async {
  try {
    final response = await http.post(
      Uri.parse('https://www.edueliteroom.com/connect/get_affectivefull_domain_score.php'), // URL ของไฟล์ PHP
      body: {
        'classroomName': classroomName,
        'classroomMajor': classroomMajor,
        'classroomYear': classroomYear,
        'classroomNumRoom': classroomNumRoom,
        'username': username,
      },
    );
    print(response.body);

    if (response.statusCode == 200) {
      
      Map<String, dynamic> data = json.decode(response.body);
      return data; 
    } else {
      
      throw Exception('Failed to load data');
    }
  } catch (e) {
    throw Exception('Failed to make request: $e');
  }
}

// Helper function
Color getExamsetColor(String? type) {
  switch (type) {
    case 'auswer':
      return Colors.blue.shade100;
    case 'onechoice':
      return Colors.green.shade100;
    case 'manychoice':
      return Colors.yellow.shade100;
    case 'upfile':
      return Colors.pink.shade100;
    default:
      return Colors.white;
  }
}

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('คะแนนนักเรียน'),
        actions: [
          if (isEditing)
            IconButton(
              icon: Icon(Icons.save),
              onPressed: saveScores,
            )
          else
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  isEditing = true;
                });
              },
            ),
        ],
      ),
      body: FutureBuilder<ScoreStudentsInClass>(
        future: futureData, // ใช้ futureData ที่กำหนดไว้แล้ว
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('ไม่มีข้อมูล'));
          }

          final data = snapshot.data!;
          Map<int, Map<String, String>> scoreMap = {};

          for (var score in data.scores) {
            if (!scoreMap.containsKey(score.examsetId)) {
              scoreMap[score.examsetId] = {};
            }
            scoreMap[score.examsetId]![score.username] = score.scoreTotal;
          }

          return FutureBuilder<List<HistoryCheckin>>(
            future: historyCheckinsFuture, // ใช้ historyCheckinsFuture ที่ดึงข้อมูล
            builder: (context, historySnapshot) {
              if (historySnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (historySnapshot.hasError) {
                return Center(child: Text('Error: ${historySnapshot.error}'));
              } else if (!historySnapshot.hasData) {
                return Center(child: Text('ไม่มีข้อมูลการเช็คชื่อ'));
              }

              historyCheckins = historySnapshot.data!;
              

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: [                  

                    Container(
                      padding: EdgeInsets.all(8.0), 
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black, 
                          width: 2, 
                        ),
                        borderRadius: BorderRadius.circular(8.0), 
                      ),
                      alignment: Alignment.center, 
                      child: Row(

                        children: [
                          Container(
                            height: 15,
                            width: 15,
                            padding: EdgeInsets.all(8.0),
                            color: Colors.blue.shade100,
                          ),
                          Text('ถาม-ตอบ', style: TextStyle(fontSize: 14)),
                          SizedBox(width: 10),
                          Container(
                            height: 15,
                            width: 15,
                            padding: EdgeInsets.all(8.0),
                            color: Colors.green.shade100,
                          ),
                          Text('ปรนัยตัวเลือกเดียว', style: TextStyle(fontSize: 14)),
                          SizedBox(width: 10),
                          Container(
                            height: 15,
                            width: 15,
                            padding: EdgeInsets.all(8.0),
                            color: Colors.yellow.shade100,
                          ),
                          Text('ปรนัยหลายตัวเลือก', style: TextStyle(fontSize: 14)),
                          SizedBox(width: 10),
                          Container(
                            height: 15,
                            width: 15,
                            padding: EdgeInsets.all(8.0),
                            color: Colors.pink.shade100,
                          ),
                          Text('ส่งไฟล์', style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                  SizedBox(height: 18),



                  
                
               DataTable(
                      columnSpacing: 5,
                      columns: [
                        const DataColumn(label: SizedBox(width: 50, child: Text('เลขที่'))),
                        const DataColumn(label: SizedBox(width: 100, child: Text('รหัสนักเรียน'))),
                        const DataColumn(label: SizedBox(width: 252, child: Text('ชื่อ-นามสกุล'))),
                        DataColumn(
                          label: SizedBox(
                            width: 100,
                            height: 40,
                            child: Column(
                              children: [
                                Text('คะแนนจิตพิสัย'),
                                _isStatusFound
                                    ? Text('($scoreMessage คะแนน)', style: TextStyle(fontSize: 12))
                                    : Text('(ยังไม่เพิ่มคะแนน)', style: TextStyle(fontSize: 12)),
                              ],
                            ),
                          ),
                        ),
                        ...data.examsetsDetails.map((examset) {
                          String formattedDate = '';
                          try {
                            DateTime parsedDate = DateTime.parse(examset.examsetTime);
                            formattedDate = DateFormat('dd-MM-yyyy').format(parsedDate);
                          } catch (e) {
                            formattedDate = 'Invalid Date';
                          }
                          Color backgroundColor = getExamsetColor(examset.examsetType);

                          return DataColumn(
                            label: Tooltip(
                              message: '${examset.examsetDirection} วันที่เพิ่มงาน: $formattedDate',
                              child: Container(
                                width: 70,
                                height: 40,
                                color: backgroundColor,
                                child: Column(
                                  children: [
                                    Text(
                                      examset.examsetDirection,
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '(${examset.examsetFullMark} คะแนน)',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                        DataColumn(
                          label: Container(
                            alignment: Alignment.center,
                            width: 70,
                            height: 40,
                            color: Colors.blue,
                            child: const Text(
                              'คะแนนรวม',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                      rows: [
                        ...data.userDetails.map((user) {
                          List<DataCell> cells = [
                            DataCell(SizedBox(width: 50, child: Text('${user.usersNumber}'))),
                            DataCell(SizedBox(width: 100, child: Text(user.usersId))),
                            DataCell(SizedBox(width: 250, child: Text('${user.usersThfname} ${user.usersThlname}'))),
                            DataCell(
                              Container(
                                width: 70,
                                alignment: Alignment.center,
                                child: Text(
                                  historyCheckins.firstWhere(
                                    (checkin) => checkin.usersUsername == user.usersUsername,
                                    orElse: () => HistoryCheckin(
                                      affectiveDomainScore: '-',
                                      usersUsername: '', checkinClassroomAuto: '', checkinClassroomDate: '', checkinClassroomClassID: '', checkinClassroomStatus: '', usersPrefix: '', usersThfname: '', usersThlname: '', usersNumber: '', usersId: '', usersPhone: '',
                                    ),
                                  ).affectiveDomainScore,
                                ),
                              ),
                            ),
                            ...data.examsetsDetails.map((examset) {
                              final currentScore =
                                  scoreMap[examset.examsetId]?[user.usersUsername] ?? '-';
                              Color backgroundColor = getExamsetColor(examset.examsetType);

                              return DataCell(
                                Container(
                                  width: 70,
                                  height: 40,
                                  color: backgroundColor,
                                  child: Center(
                                    child: isEditing
                                        ? TextFormField(
                                            initialValue: currentScore,
                                            onChanged: (value) {
                                              setState(() {
                                                editedScores.putIfAbsent(user.usersUsername, () => {})[examset.examsetId] = value;
                                              });
                                            },
                                          )
                                        : Text(currentScore),
                                  ),
                                ),
                              );
                            }),
                            DataCell(
                              Container(
                                alignment: Alignment.center,
                                height: 40,
                                width: 70,
                                decoration: BoxDecoration(color: Colors.blue),
                                child: Text(
                                  data.examsetsDetails.fold<int>(0, (sum, examset) {
                                    final currentScore = scoreMap[examset.examsetId]?[user.usersUsername] ?? '-';
                                    final score = currentScore == '-' ? 0 : int.tryParse(currentScore) ?? 0;
                                    return sum + score;
                                  }).toString(),
                                ),
                              ),
                            ),
                          ];
                          return DataRow(cells: cells);
                        }),



                        if (isEditing)
                          DataRow(
                          cells: [
                            DataCell(SizedBox(width: 50, child: Text(' '))),
                            DataCell(SizedBox(width: 100, child: Text(' '))),
                            DataCell(SizedBox(width: 250, child: Text(' '))),
                            DataCell(SizedBox(width: 70, child: Text(' '))),
                            ...data.examsetsDetails.map((examset) {
                              
                              final controller = _controllers.putIfAbsent(
                                examset.examsetId.toString(),
                                () => TextEditingController(),
                              );

                              return DataCell(
                                SizedBox(
                                  width: 70,
                                  height: 40,
                                  child: TextFormField(
                                    controller: controller,
                                    onChanged: (value) {
                                      setState(() {
                                        
                                        editedScores['new'] ??= {};
                                        editedScores['new']?[examset.examsetId] = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            }),
                            DataCell(
                              SizedBox(
                                width: 70,
                                child: IconButton(
                                  onPressed: () async {
                                    
                                    List<Map<String, dynamic>> updatedScores = []; 

                                    editedScores['new']?.forEach((examsetId, newValue) {
                                      if (newValue.isNotEmpty) {
                                        final examset = data.examsetsDetails.firstWhere((e) => e.examsetId == examsetId);
                                        final fullMark = int.tryParse(examset.examsetFullMark) ?? 1;
                                        final newScore = int.tryParse(newValue) ?? 0;

                                        
                                        final currentScores = scoreMap[examsetId]?.values.map((score) {
                                          return int.tryParse(score) ?? 0;
                                        }).toList() ?? [];

                                        
                                        for (var score in currentScores) {
                                          final adjustedScore = (score / fullMark) * newScore;
                                          
                                          print('Examset ID: $examsetId');
                                          print('Full Mark: $fullMark');
                                          print('Current Score: $score');
                                          print('New Score: $newScore');
                                          print('Adjusted Score: $adjustedScore');

                                          
                                          final user = data.scores.firstWhere(
                                            (s) => s.examsetId == examsetId && s.scoreTotal == score.toString(),
                                            orElse: () => Score(examsetId: 0, username: 'Unknown', scoreTotal: '0', scoreType: ''),
                                          );
                                          final username = user.username;
                                          print('Username: $username');

                                          
                                          updatedScores.add({
                                            'examsetId': examsetId,
                                            'username': username,
                                            'newScore': newScore,
                                            'adjustedScore': adjustedScore,
                                          });
                                        }
                                      }
                                    });

                                    
                                    if (updatedScores.isNotEmpty) {
                                      final url = Uri.parse('https://www.edueliteroom.com/connect/update_scoresfull.php'); 
                                      final response = await http.post(
                                        url,
                                        headers: {'Content-Type': 'application/json'},
                                        body: json.encode({'scores': updatedScores}),
                                      );
                                      print(response.body);

                                      if (response.statusCode == 200) {

                                        setState(() {
                                          isEditing = true;
                                          _controllers.forEach((key, controller) {
                                            controller.clear();
                                          });
                                          futureData = fetchScoreData();  // ดึงข้อมูลใหม่เมื่อบันทึกคะแนน
                                        });
                                        // ถ้าสำเร็จ
                                        print('Data saved successfully');
                                      } else {
                                        print('Failed to save data');
                                      }
                                    }

                                  },
                                  icon: Icon(Icons.save),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    )
                  ])
              );
            },
          );
        },
      ),
    );
  }
}
