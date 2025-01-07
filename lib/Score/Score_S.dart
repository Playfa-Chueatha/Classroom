import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:flutter_esclass_2/Home/homeS.dart';
import 'package:flutter_esclass_2/Login/login.dart';
import 'package:flutter_esclass_2/Model/appbar_students.dart';
import 'package:flutter_esclass_2/Profile/ProfileS.dart';
import 'package:flutter_esclass_2/Score/Menu_listclassroom_S_score.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


class Score_S extends StatefulWidget {
  final String thfname;
  final String thlname;
  final String username;
  final String classroomName;
  final String classroomMajor;
  final String classroomYear;
  final String classroomNumRoom;
  const Score_S({
    super.key, 
    required this.thfname, 
    required this.thlname, 
    required this.username,
    required this.classroomName, 
    required this.classroomMajor, 
    required this.classroomYear, 
    required this.classroomNumRoom
  });

  @override
  State<Score_S> createState() => _Score_SState();
}

class _Score_SState extends State<Score_S> {
  late final Map<DateTime, List<Map<String, String>>> _events = {};
  int unreadCount = 0; 
  List<Even_teacher> dataevent = [];
  bool hasTodayEvent = false; 
  bool isLoading = true; 
  

  Future<void> _getUnreadNotifications() async {
    Notification notificationService = Notification();
    try {
      // ส่ง username ที่ได้รับมาจาก widget
      List<NotificationData> fetchedNotifications =
          await notificationService.fetchNotifications(widget.username);

      if (fetchedNotifications.isNotEmpty) {
        // นับจำนวนการแจ้งเตือนที่ยังไม่ได้อ่าน
        int count = fetchedNotifications
            .where((notification) => notification.user == 'notread')
            .length;
        setState(() {
          unreadCount = count;
        });
      } else {
        print("ไม่มีข้อมูลการแจ้งเตือน");
      }
    } catch (e) {
      print("เกิดข้อผิดพลาดในการดึงข้อมูลการแจ้งเตือน: $e");
    }
  }

  

  Future<void> fetchEvents() async {
    final url = Uri.parse('https://www.edueliteroom.com/connect/event_assignment_students.php?usert_username=${widget.username}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['status'] == 'success') {
          setState(() {
            dataevent.clear();
            isLoading = false;
            hasTodayEvent = false;

            for (var event in responseData['data_assignment']) {
              dataevent.add(Even_teacher(
                Title: event['event_assignment_title'] ?? '',
                Date: event['event_assignment_duedate'] ?? '',
                Time: event['event_assignment_time'] ?? '',
                Class: event['classroom_name'] ?? '',
                Major: event['classroom_major'] ?? '',
                Year: event['classroom_year'] ?? '',
                Room: event['classroom_numroom'] ?? '',
                ClassID: event['event_assignment_classID'] ?? '',
              ));
            }

            // Sort events: Today first, then future events
            dataevent.sort((a, b) {
              final dateA = DateTime.parse(a.Date);
              final dateB = DateTime.parse(b.Date);
              return dateA.compareTo(dateB);
            });

            // Check if today has any events
            for (var event in dataevent) {
              if (isToday(event.Date)) {
                hasTodayEvent = true;
                break;
              }
            }
          });
        } else {
          setState(() {
            isLoading = false;
          });
          print('Error: ${responseData['message']}');
        }
      } else {
        setState(() {
          isLoading = false;
        });
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Network error: $e');
    }
  }




  bool isToday(String eventDate) {
    final today = DateTime.now();
    final eventDateTime = DateTime.parse(eventDate); // Assuming the date is in ISO 8601 format (yyyy-MM-dd)
    return today.year == eventDateTime.year &&
           today.month == eventDateTime.month &&
           today.day == eventDateTime.day;
  }

  bool isFuture(String date) {
    DateTime eventDate = DateTime.parse(date);
    DateTime currentDate = DateTime.now();
    
    
    return eventDate.isAfter(currentDate);
  }


  void showStatusConfirmationDialog(BuildContext context, String title, String message, 
    VoidCallback onConfirm) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // ปิด Dialog
          child: Text('ยกเลิก'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // ปิด Dialog
            onConfirm(); // เรียกฟังก์ชันเมื่อยืนยัน
          },
          child: Text('ยืนยัน'),
        ),
      ],
    ),
  );
}
  
  Future<ScoreForStudents> fetchExamsetsAndScores({
    required String classroomName,
    required String classroomYear,
    required String classroomNumRoom,
    required String classroomMajor,
    required String username,
  }) async {
    final url = Uri.parse("https://www.edueliteroom.com/connect/get_scoreforstudents.php");

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'classroomName': classroomName,
        'classroomYear': classroomYear,
        'classroomNumRoom': classroomNumRoom,
        'classroomMajor': classroomMajor,
        'username': username,
      }),
    );
    // print(response.body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        return ScoreForStudents.fromJson(data);
      } else {
        throw Exception(data['message']);
      }
    } else {
      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
  }

List<Map<String, dynamic>> mergeExamsetsAndScores(List<ExamSet> examsets, List<Scoretostudents> scores) {
  return examsets.map((examset) {
    // ค้นหาคะแนนที่ตรงกับ examsets_id
    final matchingScore = scores.firstWhere(
      (score) => score.examsetsId == examset.examsetsAuto,
      orElse: () => Scoretostudents(
        scoreAuto: 0,
        examsetsId: 0,
        scoreTotal: 0.0,
        scoreType: 'N/A',
        username: 'N/A',
      ),
    );

    
    final scoreTotal = matchingScore.scoreTotal != 0.0 ? matchingScore.scoreTotal : null;

    return {
      'direction': examset.direction, 
      'fullmark': examset.fullmark,            
      'scoreTotal': scoreTotal,                
    };
  }).toList();
}

  Future<List<AffectiveForStudents>> affective({
  required String classroomName,
  required String classroomMajor,
  required String classroomYear,
  required String classroomNumRoom,
  required String username,
}) async {
  try {
    final response = await http.post(
      Uri.parse('https://www.edueliteroom.com/connect/get_affective_forstudents_score.php'),
      body: {
        'classroomName': classroomName,
        'classroomMajor': classroomMajor,
        'classroomYear': classroomYear,
        'classroomNumRoom': classroomNumRoom,
        'username': username,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['error'] != null) {
        throw Exception(data['error']);
      }

      // แปลงข้อมูล JSON เป็น List ของ AffectiveForStudents
      final checkinData = data['checkin_data'] as List;
      return checkinData.map((item) => AffectiveForStudents.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    throw Exception('Failed to make request: $e');
  }
}

Text _getStatusText(String status) {
    String statusText = '';
    Color statusColor = Colors.black;

    switch (status) {
      case 'present':
        statusText = 'มาเรียน';
        statusColor = Colors.green;
        break;
      case 'late':
        statusText = 'มาสาย';
        statusColor = const Color.fromARGB(255, 165, 149, 2);
        break;
      case 'absent':
        statusText = 'ขาดเรียน';
        statusColor = Colors.red;
        break;
      case 'sick leave':
        statusText = 'ลาป่วย';
        statusColor = Colors.blue;
        break;
      case 'personal leave':
        statusText = 'ลากิจ';
        statusColor = Colors.purple;
        break;
      default:
        statusText = 'ยังไม่ได้เช็คชื่อ';
        statusColor = const Color.fromARGB(255, 66, 66, 66);
        break;
    }

    return Text(statusText, style: TextStyle(color: statusColor));
  }


  @override
  void initState() {
    super.initState();
    fetchEvents();
    _getUnreadNotifications();
  }



  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 195, 238, 250),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 152, 186, 218),
        title: Text(
          'คะแนน ${widget.classroomName.isNotEmpty ? widget.classroomName : ''} '
          '${widget.classroomYear.isNotEmpty ? '${widget.classroomYear}/' : ''}'
          '${widget.classroomNumRoom.isNotEmpty ? widget.classroomNumRoom : ''} '
          '${widget.classroomMajor.isNotEmpty ? '(${widget.classroomMajor})' : ''}',
        ),
        actions: [
          appbarstudents(
            thfname: widget.thfname,
            thlname: widget.thlname,
            username: widget.username,
            unreadCount: unreadCount, 
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(height: 10),
            Column(
              children: [
                SizedBox(height: 30),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        height: 1000,
                        width: 400,
                        alignment: Alignment.topCenter,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 195, 238, 250),
                          borderRadius: BorderRadius.only(
                            topRight:Radius.circular(20),
                            bottomRight: Radius.circular(20)
                          ),
                        ),
                        child: Scaffold(
                          backgroundColor: Color.fromARGB(255, 195, 238, 250),
                          body: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                              height: 550,
                              width: 350,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white
                              ),
                              child: Column(
                                children: [
                                  
                                  
                                  SizedBox(
                                    height: 500,
                                    width: 350,
                                    child: MenuListclassroomSScore(thfname: widget.thfname, thlname: widget.thlname, username: widget.username) // Menu_listclassroom.dart
                                  ),

                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Container(
                                height: 420,
                                width: 350,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 20),
                                    const Text(
                                      'งานที่ได้รับ',
                                      style: TextStyle(fontSize: 20),
                                    ),

                                    
                                    if (!hasTodayEvent) 
                                    Container(
                                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const ListTile(
                                        title: Text('- ไม่มีงานที่ต้องส่งในวันนี้ -'),
                                      ),
                                    ),

                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: dataevent.length,
                                        itemBuilder: (context, index) {
                                          final event = dataevent[index];
                                          final isEventToday = isToday(event.Date); 
                                          final isEventInFuture = isFuture(event.Date); 

                                          
                                          if (isEventToday || isEventInFuture) {
                                            return Container(
                                              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                              decoration: BoxDecoration(
                                                color: isEventToday
                                                    ? Colors.blue 
                                                    : const Color.fromARGB(255, 195, 238, 250), 
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: ListTile(
                                                title: Text(event.Title),
                                                subtitle: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text('วันที่สุดท้ายของการส่งงาน: ${event.Date}'),
                                                    Text('วิชา: ${event.Class} (${event.Year}/${event.Room})'),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }
                                          return SizedBox(); 
                                        },
                                      ),
                                    ),
                                  ],
                                ), 
                              ),
                          ],
                        ),

                      )
                      ),
                      SizedBox(width: 50,),
                      Container(
                                height: 1000,
                                width: 1440,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: 
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    widget.classroomName.isEmpty ||
                                            widget.classroomMajor.isEmpty ||
                                            widget.classroomYear.isEmpty ||
                                            widget.classroomNumRoom.isEmpty
                                        ? Column(
                                          children: [
                                            SizedBox(height: 50),
                                            Center(
                                            child: Text(
                                              ' ✿ กรุณาเลือกห้องเรียน ✿',
                                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                            ),
                                          )

                                          ],
                                        )
                                           
                                    : Padding(
                                      padding: EdgeInsets.all(20),
                                      child: Column(
                                        children: [
                                          
                                         FutureBuilder<ScoreForStudents>(
                                            future: fetchExamsetsAndScores(
                                              classroomName: widget.classroomName,
                                              classroomYear: widget.classroomYear,
                                              classroomNumRoom: widget.classroomNumRoom,
                                              classroomMajor: widget.classroomMajor,
                                              username: widget.username,
                                            ),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState == ConnectionState.waiting) {
                                                return const Center(child: CircularProgressIndicator());
                                              } else if (snapshot.hasError) {
                                                return Center(child: Text('Error: ${snapshot.error}'));
                                              } else {
                                                final scoreForStudents = snapshot.data!;
                                                final mergedData = mergeExamsetsAndScores(
                                                  scoreForStudents.examsets,
                                                  scoreForStudents.scores,
                                                );

                                                // คำนวณผลรวมของ fullmark และ scoreTotal
                                                double totalFullmark = 0;
                                                double totalScore = 0;
                                                for (var data in mergedData) {
                                                  totalFullmark += data['fullmark'] ?? 0;
                                                  totalScore += data['scoreTotal'] ?? 0;
                                                }

                                                return SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: DataTable(
                                                    columnSpacing: 5.0,
                                                    columns: [
                                                      DataColumn(label: Container(
                                                        width: 1000,
                                                        height: 50,
                                                        alignment: Alignment.center,
                                                        decoration: BoxDecoration(
                                                          color: const Color.fromARGB(255, 71, 136, 190),
                                                        ),
                                                        child: Text('รายละเอียดงาน',style: TextStyle(color: Colors.white),)),
                                                      ), 
                                                      DataColumn(label: Container(
                                                        width: 150,
                                                        height: 50,
                                                        alignment: Alignment.center,
                                                        decoration: BoxDecoration(
                                                          color: const Color.fromARGB(255, 71, 136, 190),
                                                        ),
                                                        child: Text('คะแนนเต็ม',style: TextStyle(color: Colors.white),)),
                                                      ),
                                                      DataColumn(label: Container(
                                                        width: 150,
                                                        height: 50,
                                                        alignment: Alignment.center,
                                                        decoration: BoxDecoration(
                                                          color: const Color.fromARGB(255, 71, 136, 190),
                                                        ),
                                                        child: Text('คะแนนของคุณ',style: TextStyle(color: Colors.white),)),
                                                      ),
                                                      
                                                    ],
                                                    rows: [
                                                      ...mergedData.map((data) {
                                                        return DataRow(cells: [
                                                          DataCell(
                                                            SizedBox(
                                                              width: 1000,
                                                              child: Text(
                                                                data['direction'] ?? '-',
                                                                textAlign: TextAlign.left,
                                                                softWrap: true, 
                                                                overflow: TextOverflow.visible, 
                                                              ),
                                                            ),
                                                          ),
                                                          DataCell(
                                                            Container(
                                                              width: 150,
                                                              alignment: Alignment.center,
                                                              child:  Text(
                                                              (data['fullmark'] == null || data['fullmark'] == 0)
                                                                  ? '-' 
                                                                  : data['fullmark'].toStringAsFixed(2),
                                                            ))),
                                                          DataCell(
                                                            Container(
                                                              alignment: Alignment.center,
                                                              width: 150,
                                                              child: Text(
                                                                (data['scoreTotal'] == null) 
                                                                    ? '-' 
                                                                    : data['scoreTotal'].toString(), 
                                                              ))),
                                                        ]);
                                                      }),

                                                      
                                                      DataRow(cells: [
                                                        DataCell(
                                                          Container(
                                                            width: 1000,
                                                            height: 50,
                                                            alignment: Alignment.center,
                                                            decoration: BoxDecoration(
                                                              color: const Color.fromARGB(255, 71, 136, 190),
                                                            ),
                                                            child: Text('ผลรวม',style: TextStyle(color: Colors.white),)
                                                          ),
                                                        ),
                                                         DataCell(
                                                          Container(
                                                            width: 150,
                                                            height: 50,
                                                            alignment: Alignment.center,
                                                            decoration: BoxDecoration(
                                                              color: const Color.fromARGB(255, 71, 136, 190),
                                                            ),
                                                            child: Text(totalFullmark == 0 ? '-' : totalFullmark.toStringAsFixed(2),style: TextStyle(color: Colors.white),)
                                                          ),
                                                        ),
                                                        DataCell(
                                                          Container(
                                                            width: 150,
                                                            height: 50,
                                                            alignment: Alignment.center,
                                                            decoration: BoxDecoration(
                                                              color: const Color.fromARGB(255, 71, 136, 190),
                                                            ),
                                                            child: Text(totalScore == 0 ? '-' : totalScore.toStringAsFixed(2),style: TextStyle(color: Colors.white),)
                                                          ),
                                                        ),
                                                       
                                                      ]),
                                                    ],
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                          SizedBox(height: 20),
                                          Text('สถานะการเช็คชื่อ:',style: TextStyle(
                                            fontSize: 20
                                          ),),

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            // ตารางแสดงประวัติการเช็คชื่อ
                                            FutureBuilder<List<AffectiveForStudents>>(
                                              future: affective(
                                                classroomName: widget.classroomName,
                                                classroomYear: widget.classroomYear,
                                                classroomNumRoom: widget.classroomNumRoom,
                                                classroomMajor: widget.classroomMajor,
                                                username: widget.username,
                                              ),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState == ConnectionState.waiting) {
                                                  return const CircularProgressIndicator();
                                                } else if (snapshot.hasError) {
                                                  return Text('Error: ${snapshot.error}');
                                                } else {
                                                  final data = snapshot.data!;

                                                  return SingleChildScrollView(
                                                    scrollDirection: Axis.horizontal,
                                                    child: DataTable(
                                                      columnSpacing: 20.0,
                                                      columns: [
                                                        DataColumn(label: Container(
                                                          width: 200,
                                                          alignment: Alignment.center,
                                                          child: 
                                                          Text('วันที่เช็คชื่อ', style: TextStyle(fontWeight: FontWeight.bold)))),
                                                        const DataColumn(label: Text('สถานะเช็คชื่อ', style: TextStyle(fontWeight: FontWeight.bold))),
                                                      ],
                                                      rows: data.map((item) {
                                                        return DataRow(cells: [
                                                          DataCell(Container(
                                                            alignment: Alignment.centerLeft,
                                                            width: 200,
                                                            child: 
                                                              Text(item.checkinDate))),
                                                          DataCell(_getStatusText(item.checkinStatus)),
                                                        ]);
                                                      }).toList(),
                                                    ),
                                                  );
                                                }
                                              },
                                            ),

                                            const SizedBox(width: 50),

                                            // ตารางแสดงจำนวนสถานะการเช็คชื่อ
                                            Container(
                                              height: 200,
                                              width: 400,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                color: const Color.fromARGB(255, 195, 238, 250),
                                              ),
                                              child: FutureBuilder<List<AffectiveForStudents>>(
                                                future: affective(
                                                  classroomName: widget.classroomName,
                                                  classroomYear: widget.classroomYear,
                                                  classroomNumRoom: widget.classroomNumRoom,
                                                  classroomMajor: widget.classroomMajor,
                                                  username: widget.username,
                                                ),
                                                builder: (context, snapshot) {
                                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                                    return const CircularProgressIndicator();
                                                  } else if (snapshot.hasError) {
                                                    return Text('Error: ${snapshot.error}');
                                                  } else {
                                                    final data = snapshot.data!;

                                                    // คำนวณจำนวนแต่ละสถานะ
                                                    final presentCount = data.where((item) => item.checkinStatus == 'present').length;
                                                    final lateCount = data.where((item) => item.checkinStatus == 'late').length;
                                                    final absentCount = data.where((item) => item.checkinStatus == 'absent').length;
                                                    final sickLeaveCount = data.where((item) => item.checkinStatus == 'sick leave').length;
                                                    final personalLeaveCount = data.where((item) => item.checkinStatus == 'personal leave').length;

                                                    return SingleChildScrollView(
                                                      scrollDirection: Axis.horizontal,
                                                      child: DataTable(
                                                        columnSpacing: 20.0,
                                                        columns: const [
                                                          DataColumn(label: Text('มาเรียน', style: TextStyle(fontWeight: FontWeight.bold))),
                                                          DataColumn(label: Text('มาสาย', style: TextStyle(fontWeight: FontWeight.bold))),
                                                          DataColumn(label: Text('ขาดเรียน', style: TextStyle(fontWeight: FontWeight.bold))),
                                                          DataColumn(label: Text('ลาป่วย', style: TextStyle(fontWeight: FontWeight.bold))),
                                                          DataColumn(label: Text('ลากิจ', style: TextStyle(fontWeight: FontWeight.bold))),
                                                        ],
                                                        rows: [
                                                          DataRow(cells: [
                                                            DataCell(Text(presentCount.toString())),
                                                            DataCell(Text(lateCount.toString())),
                                                            DataCell(Text(absentCount.toString())),
                                                            DataCell(Text(sickLeaveCount.toString())),
                                                            DataCell(Text(personalLeaveCount.toString())),
                                                          ]),
                                                        ],
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                )
                              ),
                            ],
                          ),
                        ),]
                      ),
                    ],
                  ),
                )
        );
  }
}



//------------------------------------------------------
class Notification {
  final String apiUrl = 'https://www.edueliteroom.com/connect/notification_assingment.php';

  Future<List<NotificationData>> fetchNotifications(String username) async {
    try {
      // ส่งข้อมูล username ไปยัง API
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {'username': username},
      );


      if (response.statusCode == 200) {

        var data = json.decode(response.body);


        List<dynamic> notifications = data['notifications'];

        return notifications.map((item) => NotificationData.fromMap(item)).toList();
      } else {
        throw Exception('Failed to load notifications: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching notifications: $e');
      return [];
    }
  }
}





