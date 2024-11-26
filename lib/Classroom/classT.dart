import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Classroom/add_announce.dart';
import 'package:flutter_esclass_2/Classroom/comment.dart';
import 'package:flutter_esclass_2/Classroom/setting_calss.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:flutter_esclass_2/Home/homeT.dart';
import 'package:flutter_esclass_2/Login/login.dart';
import 'package:flutter_esclass_2/Model/Chat.dart';
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

  @override
  void initState() {
    super.initState();
    futurePosts = fetchPosts();
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 195, 238, 250),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 152, 186, 218),
        title: Text('ห้องเรียน ${widget.classroomName} ${widget.classroomYear}/${widget.classroomNumRoom} (${widget.classroomMajor})'),
        actions: [
          appbarteacher(context, widget.thfname, widget.thlname, widget.username),
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
                        width: 750,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            Padding(
                              padding: EdgeInsets.fromLTRB(650,5,5,5),
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
                            Container(
                              height: 800,
                              width: 700,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                              child: FutureBuilder<List<dynamic>>(
                                future: futurePosts,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Center(child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(child: Text('Error: ${snapshot.error}'));
                                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                    return Center(child: Text('No announcements available.'));
                                  } else {
                                    final dataAnnounce = snapshot.data!;
                                    return ListView.builder(
                                      itemCount: dataAnnounce.length,
                                      itemBuilder: (context, index) {
                                        final post = dataAnnounce[index];
                                        


                                        //ไฟล์ 
                                        final files = post['files'] != null
                                            ? (post['files'] as List).map<Widget>((file) {
                                                final fileName = file['file_name'] ?? 'Unknown';
                                                final fileSize = file['file_size'] ?? ' ';
                                                final fileUrl = file['file_url'] ?? '';
                                                return GestureDetector(
                                                  onTap: () => _openFile(fileUrl),
                                                  child: Text(
                                                    "$fileName ($fileSize)",
                                                    style: TextStyle(color: Colors.blue,fontSize: 16),
                                                  ),
                                                );
                                              }).toList()
                                            : [Text('ไม่มีไฟล์แนบ',style: TextStyle(fontSize: 14,color: Color.fromARGB(255, 80, 79, 79)),)]; 



                                        return Card(
                                          margin: EdgeInsets.all(5),
                                          color: Color.fromARGB(255, 152, 186, 218),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12.0),
                                          ),
                                          elevation: 8,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [

                                              Padding(
                                                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                                                child: Image.asset("assets/images/ครู.png", height: 50, width: 50),
                                              ),


                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                  "โดย ${post['usert_thfname']} ${post['usert_thlname']}}",
                                                  style: TextStyle( fontSize: 14,color: const Color.fromARGB(255, 66, 65, 65)),
                                                ),
                                                SizedBox(height: 10),
                                                Container(
                                                  width: 550,
                                                  padding: EdgeInsets.all(20),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(20),
                                                    color: Colors.white
                                                  ),
                                                  child:Text(post['posts_title'], style: TextStyle(fontSize: 20)),
                                                ),
                                                Text("ลิงค์ที่แนบมา:", style: TextStyle(fontSize: 18)),
                                                SizedBox(height: 10),

                                                InkWell(
                                                  onTap: post['posts_link'] != null
                                                      ? () {
                                                          _launchURL(post['posts_link']);
                                                        }
                                                      : null, // ไม่สามารถกดได้ถ้าไม่มีลิงก์
                                                  child: Text(
                                                    post['posts_link'] ?? 'ไม่มี',
                                                    style: TextStyle(
                                                      color: post['posts_link'] != null
                                                          ? Colors.blue // สีลิงก์เมื่อมีลิงก์
                                                          : Color.fromARGB(255, 80, 79, 79), // สีเทาเมื่อไม่มีลิงก์
                                                    ),
                                                  ),
                                                ),

                                                Text("ไฟล์ที่แนบมา:", style: TextStyle(fontSize: 18)), 
                                                SizedBox(height: 10),
                                                Column(crossAxisAlignment: CrossAxisAlignment.start,children: files),
                                                ],
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
                                                  print("Username: ${widget.username}");
                                                  print('ClassroomID: ${post['classroom_id']}');
                                                  print('PostID: ${post['posts_auto']}');
                                                },
                                                icon: Icon(Icons.comment, size: 25),
                                              )
                                              
                                            ],
                                          )
                                                          
                                          );
                                      
                                        
                                      },
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 50),
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
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            Text(
                              'งานที่มอบหมาย',
                              style: TextStyle(fontSize: 30),
                            ),
                            SizedBox(height: 20),
                            IconButton(
                              color: Color.fromARGB(255, 0, 0, 0),
                              icon: const Icon(Icons.add),
                              iconSize: 30,
                              onPressed: () {
                                // showDialog(
                                //   context: context,
                                //   builder: (BuildContext context) =>
                                //       AssignWorkT(
                                //     username: widget.username,
                                //     classroomMajor: widget.classroomMajor,
                                //     classroomName: widget.classroomName,
                                //     classroomNumRoom: widget.classroomNumRoom,
                                //     classroomYear: widget.classroomYear,
                                //     thfname: '',
                                //     thlname: '',
                                //   ),
                                // );
                              },
                              style: IconButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 147, 185, 221),
                                highlightColor: Color.fromARGB(255, 56, 105, 151),
                              ),
                              tooltip: 'เพิ่มงาน',
                            ),
                          ],
                        ),
                      ),
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
