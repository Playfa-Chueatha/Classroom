import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Classroom/add_announce.dart';
import 'package:flutter_esclass_2/Classroom/comment.dart';
import 'package:flutter_esclass_2/Classroom/setting_calss.dart';
import 'package:flutter_esclass_2/Data/Data_announce.dart';
import 'package:flutter_esclass_2/Home/homeT.dart';
import 'package:flutter_esclass_2/Login/login.dart';
import 'package:flutter_esclass_2/Model/Chat.dart';
import 'package:flutter_esclass_2/Model/appbar_teacher.dart';
import 'package:flutter_esclass_2/Model/menu_t.dart';
import 'package:flutter_esclass_2/Profile/ProfileT.dart';
import 'package:flutter_esclass_2/work/add_worktype.dart';
import 'package:flutter_esclass_2/work/asign_work_T.dart';
import 'package:flutter_esclass_2/work/work_type/Detail_work.dart';
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
          appbarteacher(context, widget.thfname, widget.thlname, widget.username),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(height: 10,),
            Column(
              children: [
                SizedBox(height: 30),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // menu
                      Container(
                        height: 1000,
                        width: 400,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 147, 185, 221),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20)
                          ),
                        ),
                        child: Menuu_class(thfname: widget.thfname, thlname: widget.thlname, username: widget.username,),
                      ),
                      SizedBox(width: 50,),


                      // ประกาศ
                      Container(
                        height: 1000,
                        width: 750,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 20,),
                            SizedBox(
                              height: 50,
                              width: 700,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${widget.classroomName} ${widget.classroomYear}/${widget.classroomNumRoom} (${widget.classroomMajor})', style: TextStyle(fontSize: 20)),
                                  IconButton(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    icon: const Icon(Icons.add),
                                    iconSize: 30,
                                    onPressed: () {
                                      showDialog(
                                        context: context, 
                                        builder: (BuildContext context) => AnnounceClass(
                                          username: widget.username, 
                                          classroomMajor: widget.classroomMajor, 
                                          classroomName: widget.classroomName, 
                                          classroomNumRoom: widget.classroomNumRoom, 
                                          classroomYear: widget.classroomYear, 
                                          thfname: '', 
                                          thlname: '',
                                        )
                                      );
                                    },
                                    style: IconButton.styleFrom(
                                      backgroundColor: Color.fromARGB(255, 147, 185, 221),
                                      highlightColor: Color.fromARGB(255, 56, 105, 151),
                                    ),
                                    tooltip: 'เพิ่มประกาศ',
                                  ),
                                ],
                              ),
                            ),

                            Text("ประกาศ", style: TextStyle(fontSize: 40),),
                            SizedBox(height: 20),
                            Container(
                              height: 800,
                              width: 700,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color.fromARGB(255, 255, 255, 255)
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
                                                'โดย: ${dataAnnounce[index].usertThfname} ${dataAnnounce[index].usertThlname}',
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
                                                ClassroomID: dataAnnounce[index].classroomid

                                              ),
                                            );
                                          },
                                          icon: Icon(Icons.comment, size: 25),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ]
                        ),
                      ),
                      SizedBox(width: 50,),


                      // งานที่มอบหมาย
                      Container(
                        height: 1000,
                        width: 650,
                        margin: EdgeInsets.all(20),
                        alignment: Alignment.topCenter,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 152, 186, 218),
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(width: 560,height: 80),
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Type_work(username: widget.username, thfname: widget.thfname,thlname: widget.thlname,)),
                                    );
                                  },
                                  tooltip: 'มอบหมายงาน',
                                  icon: Icon(Icons.add_circle_outline_sharp, size: 50),
                                )
                              ],
                            ),
                            Text("งานที่มอบหมาย", style: TextStyle(fontSize: 30),),
                            Container(
                              alignment: Alignment.center,
                              height: 400,
                              width: 600,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: 20),
                                  Text("ไม่มีงานที่มอบหมาย", style: TextStyle(fontSize: 20),),
                                ],
                              ),
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
