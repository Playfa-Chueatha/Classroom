
import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Classroom/comment.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:flutter_esclass_2/Model/appbar_students.dart';
import 'package:flutter_esclass_2/Model/menu_t.dart';
import 'package:flutter_esclass_2/Model/menu_s.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class classS extends StatefulWidget {
  final String thfname;
  final String thlname;
  final String username;
  final String classroomName;
  final String classroomMajor;
  final String classroomYear;
  final String classroomNumRoom;

  const classS({
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
  State<classS> createState() => _class_S_bodyState();
}

class _class_S_bodyState extends State<classS> {
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
    var responseJson = json.decode(response.body);
  

    // Check if the response is a map and contains an error
    if (responseJson is Map<String, dynamic> && responseJson['error'] == 'No posts found') {
      print('ไม่มีประกาศในห้องนี้');
      return []; // Return an empty list when no posts are found
    }

    // Check if the response is a list
    if (responseJson is List<dynamic>) {
      return responseJson;
    } else {
      throw Exception('Unexpected response format');
    }
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

    
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
          appbarstudents(
            thfname: widget.thfname,
            thlname: widget.thlname,
            username: widget.username,
            unreadCount: unreadCount,
            classroomMajor: widget.classroomMajor,
            classroomName: widget.classroomName,
            classroomNumRoom: widget.classroomNumRoom,
            classroomYear: widget.classroomYear,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child:  Column(
          children: [
            SizedBox(height: screenHeight * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //menu
                      Container(
                      height: screenHeight * 0.9,
                      width: screenWidth * 0.18,
                      alignment: Alignment.topCenter,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 195, 238, 250),
                        borderRadius: BorderRadius.only(
                          topRight:Radius.circular(20),
                          bottomRight: Radius.circular(20)
                        ),
                      ),
                      child: Menuu_class_s(
                        thfname: widget.thfname, 
                        thlname: widget.thlname, 
                        username: widget.username),//menu.dart,
                      ),

                      //ประกาศ
                      Container(
                      height: screenHeight * 0.9,
                      width: screenWidth * 0.8,
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)
                        ),
                        
                        child: Column(
                          children: [
                            SizedBox( height: screenHeight * 0.02,),
                            Text("ประกาศ", style: TextStyle(fontSize: 40)),
                            SizedBox( height: screenHeight * 0.02,),
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
                                    dataAnnounce.sort((a, b) => int.parse(b['posts_auto']).compareTo(int.parse(a['posts_auto'])));
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
                                          child: Stack(                                          
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(20.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Image.asset(
                                                          "assets/images/ครู.png",
                                                          height: 50,
                                                          width: 50,
                                                        ),
                                                        Expanded(
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(left: 10.0),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  "โดย ${post['usert_thfname']} ${post['usert_thlname']}",
                                                                  style: const TextStyle(
                                                                    fontSize: 14,
                                                                    color: Color.fromARGB(255, 66, 65, 65),
                                                                  ),
                                                                ),
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
                                                                 post['links'] != null && post['links'].isNotEmpty
                                                                    ? ListView.builder(
                                                                        shrinkWrap: true,
                                                                        itemCount: post['links'].length,
                                                                        physics: const NeverScrollableScrollPhysics(),
                                                                        itemBuilder: (context, index) {
                                                                          final link = post['links'][index];
                                                                          final url = link['posts_link_url'];

                                                                          return InkWell(
                                                                            onTap: () => _launchURL(url),
                                                                            child: ListTile(
                                                                              leading: const Icon(Icons.link, color: Colors.blue),
                                                                              title: Text(
                                                                                url,
                                                                                style: const TextStyle(color: Colors.blue, fontSize: 16),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                      )
                                                                    : const Text(
                                                                        'ไม่มีลิงค์แนบ',
                                                                        style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 80, 79, 79)),
                                                                      ),
                                                                const SizedBox(height: 16),
                                                                const Text("ไฟล์ที่แนบมา:", style: TextStyle(fontSize: 18)),
                                                                const SizedBox(height: 10),
                                                                post['files'] != null && post['files'].isNotEmpty
                                                                    ? ListView.builder(
                                                                        shrinkWrap: true,
                                                                        itemCount: post['files'].length,
                                                                        physics: const NeverScrollableScrollPhysics(),
                                                                        itemBuilder: (context, index) {
                                                                          final file = post['files'][index];
                                                                          final fileName = file['file_name'] ?? 'Unknown';
                                                                          final fileSize = file['file_size'] ?? '';
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
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 8,
                                                right: 16,
                                                child: IconButton(
                                                  icon: const Icon(Icons.comment, size: 25),
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
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    );
                                  }
                                  
                                }
                              )
                              ),
                    ],
                  ),
                )
              ],
            )
          
          ]))
    );
  }
}

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