import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Chcekworkaftersubmitscoreupfile extends StatefulWidget {
  final Examset exam;
  final String username;

  const Chcekworkaftersubmitscoreupfile({
    super.key,
    required this.exam, 
    required this.username,
  });

  @override
  State<Chcekworkaftersubmitscoreupfile> createState() => _ChcekworkaftersubmitscoreupfileState();
}

class _ChcekworkaftersubmitscoreupfileState extends State<Chcekworkaftersubmitscoreupfile> {
  List<Upfile_submit> fileData = [];
  List<CheckworkUpfile> checkworkData = [];

  // Fetch data for file uploads
  Future<List<Upfile_submit>> fetchFileData(int examsetsId, String username) async {
    try {
      final response = await http.get(Uri.parse('https://www.edueliteroom.com/connect/get_submit_upfile.php?examsets_id=$examsetsId&username=$username'));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => Upfile_submit.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load files. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching file data: $e');
      throw Exception('Failed to load submit files');
    }
  }

  // Fetch data for checkwork upfiles
  Future<List<CheckworkUpfile>> fetchCheckworkUpfiles(int examsetsId, String username) async {
    final response = await http.get(Uri.parse('https://www.edueliteroom.com/connect/get_checkwork_upfile.php?examsets_id=$examsetsId&username=$username'));

    print(response.body);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => CheckworkUpfile.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load checkwork files');
    }
  }

  @override
  void initState() {
    super.initState();

    fetchFileData(widget.exam.autoId, widget.username).then((files) {
      setState(() {
        fileData = files;
      });
    }).catchError((e) {
      print('Error loading files: $e');
    });

    fetchCheckworkUpfiles(widget.exam.autoId, widget.username).then((checkworks) {
      setState(() {
        checkworkData = checkworks;
      });
    }).catchError((e) {
      print('Error loading checkwork files: $e');
    });
  }

  // Function to open file via URL
  void _openFile(Upfile_submit file) async {
    final url = file.upfileUrl; 
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'ไม่สามารถเปิดไฟล์ได้';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('ตรวจสอบงาน'),
      content: Container(
        height: 500,
        width: 500,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 81, 160, 224),
          borderRadius: BorderRadius.circular(20)
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ไฟล์ที่ส่ง :', style: TextStyle(fontSize: 20, color: Colors.black)),
              (fileData.isEmpty)
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: fileData.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(fileData[index].upfileName),
                        leading: Icon(Icons.attach_file),
                        onTap: () {
                          _openFile(fileData[index]);
                        },
                      );
                    },
                  ),
              SizedBox(height: 16),
              Text('การตรวจสอบงาน:', style: TextStyle(fontSize: 20, color: Colors.black)),
              (checkworkData.isNotEmpty)
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: checkworkData.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('คะแนนที่ตรวจแล้ว ${checkworkData[index].checkworkUpfileScore} คะแนน จากคะแนนเต็ม ${widget.exam.fullMark} คะแนน'),
                        subtitle: Text('ความคิดเห็น: ${checkworkData[index].checkworkUpfileComments}', style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0))),
                      );
                    },
                  )
                : Text('ไม่มีข้อมูลการตรวจสอบ', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('ปิด'),
        ),
      ],
    );
  }
}
