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
      actions: [
        SingleChildScrollView(
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
                  Container(
                    height: screenHeight * 0.6,
                    width: screenWidth * 0.75,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 152, 186, 218),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: isLoading 
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            return Card(
                              margin: EdgeInsets.all(10),
                              color: Color.fromARGB(255, 156, 204, 219),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              elevation: 8,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(20, 5, 0, 5),
                                        child: Image.asset("assets/images/นักเรียน.png", height: 50, width: 50),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('By: ${comments[index]["thfname"]} ${comments[index]["thlname"]}', style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),
                                          Text(comments[index]["comment_title"], style: TextStyle(fontSize: 20)),
                                        ],
                                      ),
                                    ],
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
        )
      ],
    );
  }
}
