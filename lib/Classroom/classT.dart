import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Classroom/add_announce.dart';
import 'package:flutter_esclass_2/Classroom/comment.dart';
import 'package:flutter_esclass_2/Classroom/setting_calss.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:flutter_esclass_2/Home/homeT.dart';
import 'package:flutter_esclass_2/Login/login.dart';
import 'package:flutter_esclass_2/Model/appbar_teacher.dart';
import 'package:flutter_esclass_2/Model/menu_t.dart';
import 'package:flutter_esclass_2/Profile/ProfileT.dart';
import 'package:flutter_esclass_2/work/add_worktype.dart';
import 'package:flutter_esclass_2/work/asign_work_T.dart';
import 'package:flutter_esclass_2/work/Detail_work_teacher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class ClassT extends StatefulWidget {
  final String thfname;
  final String thlname;
  final String username;
  final String classroomName;
  final String classroomMajor;
  final String classroomYear;
  final String classroomNumRoom;

  const ClassT({
    super.key,
    required this.thfname,
    required this.thlname,
    required this.username,
    required this.classroomName,
    required this.classroomMajor,
    required this.classroomYear,
    required this.classroomNumRoom,
  });

  @override
  State<ClassT> createState() => ClassTState();
}

class ClassTState extends State<ClassT> {
  late Future<List<dynamic>> futurePosts;
  int unreadCount = 0;

  @override
  void initState() {
    super.initState();
    futurePosts = fetchPosts();
    _getUnreadNotifications();
  }

  Future<List<dynamic>> fetchPosts() async {
    final response = await http.post(
      Uri.parse('https://www.edueliteroom.com/connect/fetch_posts.php'),
      body: {
        'classroomName': widget.classroomName,
        'classroomMajor': widget.classroomMajor,
        'classroomYear': widget.classroomYear,
        'classroomNumRoom': widget.classroomNumRoom,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load posts');
    }
  }

  void _openFile(String fileUrl) {
    launch(fileUrl);
  }


  void _launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'ไม่สามารถเปิดลิงค์ได้: $url';
  }
}

  Future<void> _getUnreadNotifications() async {
    Notification notificationService = Notification();
    try {
      // ส่ง username ที่ได้รับมาจาก widget
      List<NotificationData_sumit> fetchedNotifications =
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
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 195, 238, 250),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 152, 186, 218),
        title: Text(
          'ห้องเรียน ${widget.classroomName.isNotEmpty ? widget.classroomName : ''} '
          '${widget.classroomYear.isNotEmpty ? '${widget.classroomYear}/' : ''}'
          '${widget.classroomNumRoom.isNotEmpty ? widget.classroomNumRoom : ''} '
          '${widget.classroomMajor.isNotEmpty ? '(${widget.classroomMajor})' : ''}',
        ),
        actions: [
          appbarteacher(
            thfname: widget.thfname,
            thlname: widget.thlname,
            username: widget.username,
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
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 147, 185, 221),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: Menuu_class(
                          thfname: widget.thfname,
                          thlname: widget.thlname,
                          username: widget.username,
                        ),
                      ),
                      SizedBox(width: 50),


                      
                      Container(
                        height: 1000,
                        width: 1450,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            Padding(
                              padding: EdgeInsets.fromLTRB(1350,5,5,5),
                              child:  IconButton(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    icon: const Icon(Icons.add),
                                    iconSize: 30,
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AnnounceClass(
                                          username: widget.username,
                                          classroomMajor: widget.classroomMajor,
                                          classroomName: widget.classroomName,
                                          classroomNumRoom: widget.classroomNumRoom,
                                          classroomYear: widget.classroomYear,
                                          thfname: widget.thfname,
                                          thlname: widget.thlname,
                                        ),
                                      );
                                    },
                                    style: IconButton.styleFrom(
                                      backgroundColor: Color.fromARGB(255, 147, 185, 221),
                                      highlightColor: Color.fromARGB(255, 56, 105, 151),
                                    ),
                                    tooltip: 'เพิ่มประกาศ',
                                  ),
                            ),
                            
                            Text(
                              "ประกาศ",
                              style: TextStyle(fontSize: 40),
                            ),
                            SizedBox(height: 20),
                            widget.classroomName.isEmpty ||
                                widget.classroomMajor.isEmpty ||
                                widget.classroomYear.isEmpty ||
                                widget.classroomNumRoom.isEmpty
                            ? const Center(
                                child: Text(
                                  ' ✿ กรุณาเลือกห้องเรียน ✿',
                                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                              )
                            : Expanded(
                              child: FutureBuilder<List<dynamic>>(
                                future: futurePosts,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                     return const Center(child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(child: Text('Error: ${snapshot.error}'));
                                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                    return const Center(child: Text('ยังไม่มีประกาศในห้องนี้.'));
                                  } else {
                                    final dataAnnounce = snapshot.data!;
                                    return ListView.builder(
                                      itemCount: dataAnnounce.length,
                                      itemBuilder: (context, index) {
                                        final post = dataAnnounce[index];


                                        return Card(
                                          margin: const EdgeInsets.all(30),
                                          color: const Color.fromARGB(255, 152, 186, 218),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12.0),
                                          ),
                                          elevation: 8,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(20),
                                                child: Image.asset(
                                                  "assets/images/ครู.png",
                                                  height: 50,
                                                  width: 50,
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(padding: EdgeInsets.all(10),
                                                    child: 
                                                    Text(
                                                      "โดย ${post['usert_thfname']} ${post['usert_thlname']}",
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Color.fromARGB(255, 66, 65, 65),
                                                      ),
                                                    )),
                                                    const SizedBox(height: 10),
                                                    Container(
                                                      width: double.infinity,
                                                      padding: const EdgeInsets.all(20),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(20),
                                                        color: Colors.white,
                                                      ),
                                                      child: Text(
                                                        post['posts_title'],
                                                        style: const TextStyle(fontSize: 20),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 16),
                                                    const Text("ลิงค์ที่แนบมา:", style: TextStyle(fontSize: 18)),
                                                    const SizedBox(height: 10),
                                                    InkWell(
                                                      onTap: post['posts_link'] != null
                                                          ? () => _launchURL(post['posts_link'])  
                                                          : null,  
                                                      child: post['posts_link'] != null
                                                          ? ListTile(
                                                              leading: const Icon(Icons.link, color: Colors.blue),  
                                                              title: Text(
                                                                post['posts_link'],  
                                                                style: TextStyle(
                                                                  color: Colors.blue,  
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                            )
                                                          : const Text(
                                                              'ไม่มีลิงค์แนบ',  
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: Color.fromARGB(255, 80, 79, 79),  
                                                              ),
                                                            ),
                                                    ),
                                                    const SizedBox(height: 16),
                                                    const Text("ไฟล์ที่แนบมา:", style: TextStyle(fontSize: 18)),
                                                    const SizedBox(height: 10),
                                                    post['files'] != null && post['files'].isNotEmpty
                                                        ? ListView.builder(
                                                            shrinkWrap: true,
                                                            itemCount: post['files'].length,
                                                            physics: NeverScrollableScrollPhysics(), // เพื่อไม่ให้ ListView ภายในเลื่อนเอง
                                                            itemBuilder: (context, index) {
                                                              final file = post['files'][index];
                                                              final fileName = file['file_name'] ?? 'Unknown';
                                                              final fileSize = file['file_size'] ?? ' ';
                                                              final fileUrl = file['file_url'] ?? '';

                                                              return ListTile(
                                                                leading: const Icon(Icons.attach_file),
                                                                title: Text(
                                                                  "$fileName ($fileSize)",
                                                                  style: const TextStyle(color: Colors.blue, fontSize: 16),
                                                                ),
                                                                onTap: () => _openFile(fileUrl),
                                                              );
                                                            },
                                                          )
                                                        : const Text(
                                                            'ไม่มีไฟล์แนบ',
                                                            style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 80, 79, 79)),
                                                          ),
                                                        
                                                        SizedBox(height: 20)
                                                  ],
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) => Comment_inclass(
                                                      username: widget.username,
                                                      postId: post['posts_auto'],
                                                      ClassroomID: post['classroom_id'],
                                                    ),
                                                  );
                                                },
                                                icon: const Icon(Icons.comment, size: 25),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    );
                                  }
                                  
                                }
                              )
                              )







                          ],
                        ),
                      ),
                      SizedBox(width: 50),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class Notification {
  final String apiUrl = 'https://www.edueliteroom.com/connect/notification_submit.php';

  Future<List<NotificationData_sumit>> fetchNotifications(String username) async {
    try {
      // ส่งข้อมูล username ไปยัง API
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {'username': username},
      );


      if (response.statusCode == 200) {

        var data = json.decode(response.body);


        List<dynamic> notifications = data['notifications'];

        return notifications.map((item) => NotificationData_sumit.fromMap(item)).toList();
      } else {
        throw Exception('Failed to load notifications: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching notifications: $e');
      return [];
    }
  }
}