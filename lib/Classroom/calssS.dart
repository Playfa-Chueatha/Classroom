
import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Classroom/comment.dart';
import 'package:flutter_esclass_2/Data/Data_announce.dart';
import 'package:flutter_esclass_2/Model/appbar_students.dart';
import 'package:flutter_esclass_2/Model/menu_t.dart';
import 'package:flutter_esclass_2/Model/menu_s.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class class_S_body extends StatefulWidget {
  final String thfname;
  final String thlname;
  final String username;
  final String classroomName;
  final String classroomMajor;
  final String classroomYear;
  final String classroomNumRoom;

  const class_S_body({
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
  State<class_S_body> createState() => _class_S_bodyState();
}

class _class_S_bodyState extends State<class_S_body> {

    int counter = 0;

  Future<void> fetchPosts() async {
  final response = await http.post(
    Uri.parse('https://www.edueliteroom.com/connect/fetch_posts.php'),
    body: {
      'classroomName': widget.classroomName,
      'classroomMajor': widget.classroomMajor,
      'classroomYear': widget.classroomYear,
      'classroomNumRoom': widget.classroomNumRoom,
    },
  );

  try {
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      if (responseData is List) {
        setState(() {
          dataAnnounce = responseData.map((item) {
            String file = item['posts_file'];
            String link = item['posts_link'];

            return DataAnnounce(
              classroomid: item['classroom_id'],
              annonceid:item['posts_auto'],
              annoncetext: item['posts_title'],
              file: file == 'ไม่มี' ? ' - ' : file,
              link: link == 'ไม่มี' ? ' - ' : link, 
              usertThfname: item['usert_thfname'], 
              usertThlname: item['usert_thlname'],
            );
          }).toList();
        });
      } else {
        print('Invalid response data format');
      }
    } else {
      print("Error: ${response.statusCode}");
      throw Exception('Failed to load data');
    }
  } catch (e) {
    print('Error parsing JSON: $e');
  }
}

void launchURL(String url) async {
    Uri uri = Uri.parse(url);  // Convert String to Uri
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPosts(); // เรียก fetchPosts ใน initState
  }

    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 195, 238, 250),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 152, 186, 218),
        title: Text('Edueliteroom'),
        actions: [
          appbarstudents(context, widget.thfname, widget.thlname, widget.username),
        ],
        ),
      body: SingleChildScrollView(
        scrollDirection:Axis.vertical,
        child: Column(
          children: [
            SizedBox(height: 10,),
            Column(
              children: [
                SizedBox(height: 30),
                SingleChildScrollView(
                  scrollDirection:Axis.horizontal,
                  child: Row(
                    children: [


                      //menu
                      Container(
                      height: 1000,
                      width: 400,
                      alignment: Alignment.topCenter,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 147, 185, 221),
                        borderRadius: BorderRadius.only(
                          topRight:Radius.circular(20),
                          bottomRight: Radius.circular(20)
                        ),
                      ),
                      child: Menuu_class_s(thfname: widget.thfname, thlname: widget.thlname, username: widget.username),//menu.dart,
                      ),
                      SizedBox(width: 50,),


                      //ประกาศ
                      Container(
                      height: 1000,
                      width: 750,
                      // alignment: Alignment.topCenter,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)
                        ),
                        
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(height: 20,),
                            Text('${widget.classroomName} ${widget.classroomYear}/${widget.classroomNumRoom} (${widget.classroomMajor})', style: TextStyle(fontSize: 20)),
                            Text("ประกาศ", style: TextStyle(fontSize: 40)),
                            SizedBox(height: 20),
                            Container(
                              height: 800,
                              width: 700,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: ListView.builder(
                                itemCount: dataAnnounce.length,
                                itemBuilder: (context, index) {
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
                                          padding: EdgeInsets.fromLTRB(20, 5, 0, 5),
                                          child: Image.asset("assets/images/ครู.png", height: 50, width: 50),
                                        ),




                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [


                                              Text(
                                                'โดย: ${dataAnnounce[index].usertThfname} ${dataAnnounce[index].usertThlname} ${dataAnnounce[index].annonceid}',
                                                style: TextStyle(fontSize: 14),
                                              ),



                                              Container(
                                                width: 600,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(20),
                                                  color: Colors.white
                                                ),
                                                padding: EdgeInsets.all(20),
                                                child:  Text(dataAnnounce[index].annoncetext, style: TextStyle(fontSize: 20),),
                                              ),

                                              
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(20, 10, 0, 5),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text('ลิงค์ที่แนบมา',style: TextStyle(fontSize: 16),),
                                                    dataAnnounce[index].link == ' - '
                                                      ? Text('ไม่มี',style: TextStyle(fontSize: 14,color: Color.fromARGB(255, 80, 79, 79)),) // ถ้า link เป็น 'ไม่มี' แสดงข้อความ '-'
                                                      : GestureDetector(
                                                          onTap: () {
                                                            launchURL(dataAnnounce[index].link); // เปิดลิงค์เมื่อคลิก
                                                          },
                                                          child: Text(
                                                            dataAnnounce[index].link,
                                                            style: TextStyle(fontSize: 14, color: Colors.blue),
                                                          ),
                                                        ),
                                                  ],
                                                ),
                                              ),

                                              Padding(
                                                padding: EdgeInsets.fromLTRB(20, 5, 0, 10),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text('ไฟล์ที่แนบมา',style: TextStyle(fontSize: 16),),
                                                    dataAnnounce[index].file == ' - '
                                                      ? Text('ไม่มี',style: TextStyle(fontSize: 14,color: Color.fromARGB(255, 80, 79, 79)),) 
                                                      : GestureDetector(
                                                          onTap: () {
                                                            launchURL(dataAnnounce[index].file); // ดาวน์โหลดไฟล์เมื่อคลิก
                                                          },
                                                          child: Text(
                                                            'ดาวน์โหลดไฟล์',
                                                            style: TextStyle(fontSize: 14, color: Colors.blue),
                                                          ),
                                                        ),
                                                  ],
                                                ),
                                              )                                                                               
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) => Comment_inclass(
                                                username: widget.username,
                                                postId: dataAnnounce[index].annonceid,
                                                ClassroomID : dataAnnounce[index].classroomid,
                                              ),
                                            );
                                            print('ClassroomID: ${dataAnnounce[index].classroomid}');
                                            print('PostID: ${dataAnnounce[index].annonceid}');
                                          },
                                          icon: Icon(Icons.comment, size: 25),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )
                          ]
                        ),
                      ),
                      SizedBox(width: 50,),


                      //งายที่มอบหมาย
                      Container(
                        height: 1000,
                        width: 650,
                        alignment: Alignment.topCenter,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 152, 186, 218),
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 20,),
                            Text("งานที่ได้รับ", style: TextStyle(fontSize: 30),),
                            Container(
                              alignment: Alignment.center,
                              height: 400,
                              width: 600,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)
                              ),
                            ),
                            SizedBox(height: 30),
                            Text("งานที่เลยกำหนดแล้ว", style: TextStyle(fontSize: 30),),
                            Container(
                              alignment: Alignment.center,
                              height: 400,
                              width: 600,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 20)
                    ],
                  ),
                )
              ],
            )
          ],
        ),),
    );
  }
}