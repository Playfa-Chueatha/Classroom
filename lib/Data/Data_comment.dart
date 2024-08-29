import 'package:flutter/material.dart';

// Model
class Datacomment {
  Datacomment({
    required this.datacommenttext,
  });
  String datacommenttext;
}

// Global list to hold comments
List<Datacomment> datacommenttext = [
  Datacomment(datacommenttext: 'รับทราบค่ะ')
];

class DataComment extends StatefulWidget {
  const DataComment({super.key});

  @override
  State<DataComment> createState() => _DataCommentState();
}

class _DataCommentState extends State<DataComment> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 600,
      alignment: AlignmentDirectional.center,
      child: ListView.builder(
        itemCount: datacommenttext.length,
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
                    Text(" ${datacommenttext[index].datacommenttext}", style: TextStyle(fontSize: 20)),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}