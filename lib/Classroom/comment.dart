import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Comment_inclass extends StatefulWidget {
  final String username;
  final String postId;
  final String ClassroomID;

  const Comment_inclass({
    super.key, 
    required this.username,
    required this.postId,
    required this.ClassroomID,
  }); 

  @override
  State<Comment_inclass> createState() => _CommentState();
}

class _CommentState extends State<Comment_inclass> {
  TextEditingController textdatacomment = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<dynamic> comments = [];
  bool isLoading = false;

  Future<void> addcomment(String commentTitle, String postId, String classroomId, String username) async {
    setState(() {
      isLoading = true;
    });
    
    final url = Uri.parse('https://www.edueliteroom.com/connect/save_comment.php');
    final response = await http.post(url, body: {
      'commentTitle': commentTitle,
      'postId': postId,
      'classroomId': classroomId,
      'Username': username,
    });

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      print('Comment_inclass added successfully');
      _fetchComments();
      textdatacomment.clear();  
      FocusScope.of(context).unfocus(); // Hide keyboard after comment is added
    } else {
      print('Failed to add comment');
    }
  }

  Future<void> _fetchComments() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('https://www.edueliteroom.com/connect/fetch_comment.php'),
        body: {
          'postId': widget.postId.toString(),
          'classroomId': widget.ClassroomID.toString(),
        },
      );

      setState(() {
        isLoading = false;
      });
      print(response.body);

      if (response.statusCode == 200) {
        try {
          final data = json.decode(response.body); // Decode JSON response

          if (data is List) {
            setState(() {
              comments = List.from(data); // Update comments list
            });
          } else {
            print("Error: Expected list but got something else");
          }
        } catch (e) {
          print("Error parsing response body: $e");
        }
      } else {
        throw Exception('Failed to load comments. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error during HTTP request: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<Map<String, dynamic>> deleteComment(String username, int commentAuto) async {
  final response = await http.post(
    Uri.parse('https://www.edueliteroom.com/connect/delete_comment.php'),
    body: {
      'username': username,
      'comment_auto': commentAuto.toString(),
    },
  );


  if (response.statusCode == 200) {
    // ตรวจสอบว่าตอบกลับเป็น JSON หรือไม่
    try {
      final data = json.decode(response.body);
      if (data['success'] == true) {
        setState(() {
          _fetchComments();  // ดึงข้อมูลคอมเมนต์ใหม่
        });
        return data;
      } else {
        return {'success': false, 'error': data['error'] ?? 'Unknown error'};
      }
    } catch (e) {
      print('Error decoding JSON: $e');
      // ตรวจสอบ response.body ว่าเป็น HTML หรือไม่
      print('Response body: ${response.body}');
      return {'success': false, 'error': 'Invalid JSON format'};
    }
  } else {
    return {'success': false, 'error': 'Failed to connect to API'};
  }
}



  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return AlertDialog(
      content: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: formKey,
            child: Container(
              height: screenHeight * 0.8,
              width: screenWidth * 0.8,
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('ความคิดเห็น', style: TextStyle(fontSize:  20),),
                  Container(
                    height: screenHeight * 0.7,
                    width: screenWidth * 0.75,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 152, 186, 218),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: isLoading 
                      ? Center(child: CircularProgressIndicator())
                      : comments.isEmpty
                        ? Center(
                            child: Text(
                              '- ยังไม่มีการแสดงความคิดเห็น -',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          )
                        : ListView.builder(
                          itemCount: comments.length,
                          itemBuilder: (context, index) {

                            bool canDelete = comments[index]["comment_username"] == widget.username;

                            return Card(
                              margin: EdgeInsets.all(10),
                              color: Color.fromARGB(255, 156, 204, 219),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              elevation: 8,
                              child: Stack(
                                children: [
                                  // ส่วนของ Row ที่มีข้อมูลของคอมเมนต์
                                          Padding(padding: EdgeInsets.all(10),
                                          child:  Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('By: ${comments[index]["thfname"]} ${comments[index]["thlname"]}', style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),
                                              Text(comments[index]["comment_title"], style: TextStyle(fontSize: 20)),
                                            ],
                                          )),
                                        
                                  
                                  // ปุ่มลบที่มุมขวาล่าง
                                  if (canDelete)
                                    Positioned(
                                      bottom: 8,
                                      right: 8,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0), 
                                        child: IconButton(
                                          icon: Icon(Icons.delete, color: Colors.red),
                                          onPressed: () async {
                                            var response = await deleteComment(widget.username, comments[index]["comment_auto"]);
                                            
                                            if (response['success']) {
                                              // หากลบสำเร็จ ให้ทำการอัปเดต UI
                                              print('Comment deleted successfully');
                                            } else {
                                              // หากลบไม่สำเร็จ แสดงข้อความผิดพลาด
                                              print('Failed to delete comment');
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 40,
                    width: screenWidth * 0.75,
                    child: TextFormField(
                      controller: textdatacomment,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'แสดงความคิดเห็นของคุณ',
                        contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        suffixIcon: isLoading
                            ? CircularProgressIndicator()
                            : IconButton(
                                onPressed: () {
                                  String commentTitle = textdatacomment.text;
                                  String postId = widget.postId;
                                  String classroomId = widget.ClassroomID;
                                  String usertUsername = widget.username;

                                  addcomment(commentTitle, postId, classroomId, usertUsername);
                                },
                                icon: Icon(Icons.send),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); 
            },
            child: Text('ปิด'),
          ),
          
        ],
      
    );
  }
}
