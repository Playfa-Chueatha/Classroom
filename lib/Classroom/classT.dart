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
  List<dynamic> posts = [];
  

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
  print(response.body);

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


  Future<void> updatePostTitle(
  BuildContext context, 
  String postId, 
  String newTitle, 
  String username, 
  Function fetchPosts) async {
  
  try {
    final response = await http.post(
      Uri.parse('https://www.edueliteroom.com/connect/update_posts.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'postId': postId,
        'newTitle': newTitle,
        'username': username,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      if (responseData['success'] != null) {
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('อัปเดตโพสต์สำเร็จ!'),
            backgroundColor: Colors.green, // เพิ่มสีเขียว
          ),
        );


        
        List<dynamic> newPosts = await fetchPosts();
   
        setState(() {
          posts = newPosts; 
          futurePosts = fetchPosts();
        });
        
      } else {
        throw Exception(responseData['error'] ?? 'Unknown error occurred.');
      }
    } else {
      throw Exception('Failed to update post. Status code: ${response.statusCode}');
    }
  } catch (e) {
    // หากเกิดข้อผิดพลาด แสดงข้อความแจ้งเตือน
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('เกิดข้อผิดพลาด: $e'),backgroundColor: Colors.red,),
    );
  }
}

Future<void> deletePost(String postId, String username) async {
  try {
    final response = await http.post(
      Uri.parse('https://www.edueliteroom.com/connect/delete_post.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'postId': postId,
        'username': username,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      if (responseData['success'] != null) {
        // แสดงข้อความแจ้งเตือนการลบสำเร็จ
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('โพสต์ถูกลบแล้ว!'),backgroundColor: Colors.green,),
        );

        // รีเฟรชข้อมูลโพสต์หลังจากลบสำเร็จ
        setState(() {
          futurePosts = fetchPosts();
        });
      } else {
        throw Exception(responseData['error'] ?? 'เกิดข้อผิดพลาดในการลบโพสต์');
      }
    } else {
      throw Exception('ลบโพสต์ไม่สำเร็จ สถานะโค้ด: ${response.statusCode}');
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('เกิดข้อผิดพลาด: $e'),backgroundColor: Colors.red,),
    );
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
          appbarteacher(
            thfname: widget.thfname,
            thlname: widget.thlname,
            username: widget.username,
            classroomMajor: widget.classroomMajor, 
            classroomName: widget.classroomName, 
            classroomYear: widget.classroomYear, 
            classroomNumRoom: widget.classroomNumRoom,
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
                      Container(
                        height: screenHeight * 0.9,
                        width: screenWidth * 0.18,
                        alignment: Alignment.topCenter,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 195, 238, 250),
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
                      Container(
                        height: screenHeight * 0.9,
                        width: screenWidth * 0.8,
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(width: 10),
                                Padding(
                                padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
                                child: IconButton(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  icon: const Icon(Icons.add),
                                  iconSize: 30,
                                  onPressed: () async {
                                    // แสดง Dialog และรอฟังค่าที่ส่งกลับ
                                    final result = await showDialog<bool>(
                                      context: context,
                                      builder: (BuildContext context) => AnnounceClass(
                                        username: widget.username,
                                        classroomMajor: widget.classroomMajor,
                                        classroomName: widget.classroomName,
                                        classroomNumRoom: widget.classroomNumRoom,
                                        classroomYear: widget.classroomYear,
                                        thfname: widget.thfname,
                                        thlname: widget.thlname,
                                      ),
                                    );

                                    // ถ้าค่าที่ส่งกลับเป็น true ให้รีโหลดข้อมูล
                                    if (result == true) {
                                      setState(() {
                                        futurePosts = fetchPosts();
                                      });
                                    }
                                  },
                                  style: IconButton.styleFrom(
                                    backgroundColor: Color.fromARGB(255, 147, 185, 221),
                                    highlightColor: Color.fromARGB(255, 56, 105, 151),
                                  ),
                                  tooltip: 'เพิ่มประกาศ',
                                ),
                              ),
                              ],
                            ),
                            
                            
                            Text(
                              "ประกาศ",
                              style: TextStyle(fontSize: 40),
                            ),
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
                                                                            leading: const Icon(Icons.file_copy),
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
                                                top: 8,
                                                right: 8,
                                                child: Row(
                                                  children: [
                                                    IconButton(
                                                      icon: const Icon(Icons.edit, size: 25),
                                                      onPressed: () {
                                                        showEditDialog(
                                                          context,
                                                          post['posts_title'],
                                                          (newTitle) {
                                                            updatePostTitle(
                                                              context, 
                                                              post['posts_auto'], 
                                                              newTitle, 
                                                              widget.username,
                                                              fetchPosts, 
                                                            );
                                                          },
                                                        );
                                                      },
                                                    ),
                                                    IconButton(
                                                      icon: const Icon(Icons.delete, size: 25, color: Colors.red),
                                                      onPressed: () {
                                                        // แสดง Dialog ยืนยันการลบโพสต์
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return AlertDialog(
                                                              title: const Text('ยืนยันการลบโพสต์'),
                                                              content: const Text('คุณแน่ใจว่าจะลบโพสต์นี้?'),
                                                              actions: [
                                                                // ปุ่มยกเลิก
                                                                TextButton(
                                                                  onPressed: () {
                                                                    Navigator.of(context).pop(); // ปิด Dialog
                                                                  },
                                                                  child: const Text('ยกเลิก'),
                                                                ),
                                                                // ปุ่มยืนยันการลบ
                                                                ElevatedButton(
                                                                  onPressed: () async {
                                                                    // ส่งคำขอลบโพสต์ไปยัง API
                                                                    await deletePost(post['posts_auto'], widget.username);
                                                                    Navigator.of(context).pop(); // ปิด Dialog หลังจากลบโพสต์
                                                                  },
                                                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                                                  child: const Text('ใช่'),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
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
                                      },
                                    );
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),     
          ],
      ))
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
//------------------------------------------------------------------------------------------
void showEditDialog(BuildContext context, String currentTitle, Function(String) onUpdate) {
  final TextEditingController controller = TextEditingController(text: currentTitle);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('แก้ไขโพสต์'),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'กรุณาแก้ไขข้อความ',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); 
            },
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                onUpdate(controller.text); 
                Navigator.of(context).pop(); 
              }
            },
            child: const Text('บันทึก'),
          ),
        ],
      );
    },
  );
}
