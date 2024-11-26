import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:flutter_esclass_2/work/auswer/QuestionListDialog.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class Detail_work extends StatefulWidget {
  final Examset exam;
  const Detail_work({super.key, required this.exam});

  @override
  State<Detail_work> createState() => _Detail_workState();
}

class _Detail_workState extends State<Detail_work> {
  final List<String> links = [];
  List<Upfile> fileData = [];
  List<AuswerQuestion> questionData = [];

  Future<void> _fetchData() async {
    final exam = widget.exam;
    final response = await http.post(
      Uri.parse('https://www.edueliteroom.com/connect/fetch_upfileindetail.php'),
      body: {
        'type': exam.type,
        'autoId': exam.autoId.toString(),
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        if (exam.type == 'auswer') {
          questionData = List<AuswerQuestion>.from(
            data['auswer_question'].map((item) => AuswerQuestion.fromJson(item)),
          ).cast<AuswerQuestion>();
        } else if (exam.type == 'upfile') {
          fileData = List<Upfile>.from(
            data['upfile'].map((item) => Upfile.fromJson(item)),
          ).cast<Upfile>();
        }
      });
    } else {
      // Handle error
    }
  }

  void _openFile(Upfile file) async {
    final url = file.upfileUrl; // เปลี่ยนเป็น URL ที่ถูกต้องจาก Upfile
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'ไม่สามารถเปิดไฟล์ได้';
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void didUpdateWidget(covariant Detail_work oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.exam != oldWidget.exam) {
      _fetchData(); // รีเฟรชข้อมูลใหม่เมื่อ `exam` เปลี่ยนแปลง
    }
  }

  @override
  Widget build(BuildContext context) {
    final exam = widget.exam;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${exam.autoId}'),
            Text(
              'คำสั่งงาน:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(' ${exam.direction}'),
            SizedBox(height: 16),
            Text(
              'คะแนนเต็ม:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8),
            Text('${exam.fullMark}'),
            SizedBox(height: 16),
            Text(
              'วันที่ครบกำหนด:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(' ${exam.deadline}'),
            SizedBox(height: 16),

            if (exam.type == 'upfile') ...[
              Text('ไฟล์ที่แนบมา:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              SizedBox(height: 8),
              fileData.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true, // ใช้เพื่อให้ ListView ไม่ใช้พื้นที่ทั้งหมดใน UI
                      itemCount: fileData.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(fileData[index].upfileName),
                          leading: Icon(Icons.attach_file),
                          onTap: () {
                            // แสดงไฟล์ที่ถูกเลือก หรือเปิดไฟล์
                            _openFile(fileData[index]);
                          },
                        );
                      },
                    )
                  : Text('ไม่มีไฟล์แนบ'),
            ],
            if (exam.type == 'auswer') ...[
              Text('ไฟล์ที่แนบมา:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              SizedBox(height: 8),
              Text('ไม่มีไฟล์แนบ'),
              Row(
                mainAxisAlignment: MainAxisAlignment.end, 
                children: [
                  OutlinedButton(
                    onPressed: () {
                      
                      showDialog(
                        context: context,
                        builder: (context) {
                          return QuestionListDialog(
                            questions: questionData,
                          );
                        },
                      );
                    },
                    child: Text('แสดงตัวอย่างข้อสอบ'),
                  ),
                ],
              ),
            ],
            if (exam.type == 'onechoice') ...[
              Text('ไฟล์ที่แนบมา:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              SizedBox(height: 8),
              Text('ไม่มีไฟล์แนบ'),
              Row(
                mainAxisAlignment: MainAxisAlignment.end, 
                children: [
                  OutlinedButton(
                    onPressed: () {
                      // ฟังก์ชันเมื่อกดปุ่ม
                    },
                    child: Text('แสดงตัวอย่างข้อสอบ'),
                  ),
                ],
              ),
            ],
            if (exam.type == 'manychoice') ...[
              Text('ไฟล์ที่แนบมา:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              SizedBox(height: 8),
              Text('ไม่มีไฟล์แนบ'),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,  
                children: [
                  OutlinedButton(
                    onPressed: () {

                    },
                    child: Text('แสดงตัวอย่างข้อสอบ'),
                  ),
                ],
              ),
            ],



            SizedBox(height: 16),
            Text(
              'รายชื่อนักเรียนที่ส่งงานแล้ว:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'รายชื่อนักเรียนที่ยังไม่ได้ส่งงาน:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}



