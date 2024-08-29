import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Data/Data_comment.dart';

class Comment extends StatefulWidget {
  const Comment({super.key});

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  TextEditingController textdatacomment = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // ใช้ MediaQuery เพื่อดึงขนาดของหน้าจอ
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return AlertDialog(
      actions: [
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: formKey,
            child: Container(
              // ปรับความกว้างและความสูงตามขนาดหน้าจอ
              height: screenHeight * 0.8,
              width: screenWidth * 0.8,
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: screenHeight * 0.6, // ความสูงของคอมเมนต์ตามขนาดหน้าจอ
                    width: screenWidth * 0.75, // ความกว้างของคอมเมนต์ตามขนาดหน้าจอ
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 152, 186, 218),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: DataComment(), // แสดงคอมเมนต์ที่อัพเดตแล้ว
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      SizedBox(
                        height: 40,
                        width: screenWidth * 0.75, // ปรับความกว้างของ TextFormField ตามขนาดหน้าจอ
                        child: TextFormField(
                          controller: textdatacomment,
                          keyboardType: TextInputType.multiline,
                          maxLines: 5,
                          decoration: InputDecoration(
                            hintText: 'แสดงความคิดเห็นของคุณ',
                            contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                            suffixIcon: IconButton(
                              onPressed: () {
                                if (textdatacomment.text.isNotEmpty) {
                                  setState(() {
                                    datacommenttext.add(Datacomment(datacommenttext: textdatacomment.text));
                                    textdatacomment.clear();
                                  });
                                }
                              },
                              icon: Icon(Icons.send),
                            ),
                          ),
                        ),
                      ),
                    ],
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
