import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:flutter_esclass_2/work/auswer/QuestionListDialog.dart';
import 'package:flutter_esclass_2/work/auswer/chcekworkaftersubmitscoreauswer.dart';
import 'package:flutter_esclass_2/work/auswer/doAuswerStudents.dart';
import 'package:flutter_esclass_2/work/auswer/getsubmitauswer.dart';
import 'package:flutter_esclass_2/work/manychoice/DoManychoiceStudents.dart';
import 'package:flutter_esclass_2/work/manychoice/chcekscoremanychoice.dart';
import 'package:flutter_esclass_2/work/manychoice/manychoice_dialog.dart';
import 'package:flutter_esclass_2/work/onechoice/DoonechoiceStudents.dart';
import 'package:flutter_esclass_2/work/onechoice/chcekscoreonechoice.dart';
import 'package:flutter_esclass_2/work/upfile/chcekworkaftersubmitscoreupfile.dart';
import 'package:flutter_esclass_2/work/upfile/getsubmitscoreupfile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class Detail_work_S extends StatefulWidget {
  final Examset exam;
  final String thfname;
  final String thlname;
  final String username;
  const Detail_work_S({
    super.key, 
    required this.exam, 
    required this.thfname, 
    required this.thlname, 
    required this.username,
  });

  @override
  State<Detail_work_S> createState() => _Detail_workState();
}

class _Detail_workState extends State<Detail_work_S> {
  final List<String> links = [];
  List<Upfile> fileData = [];
  List<AuswerQuestion> questionData = [];
  List<PlatformFile> selectedFiles = [];
  bool hasSubmitted = false;
  bool isLoading = true;
  bool status = false;
  String submitTime = '';

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

  Future<bool> _checkSubmit() async {
  try {
    final response = await http.post(
      Uri.parse('https://www.edueliteroom.com/connect/check_submit_auswer.php'),
      body: {
        'username': widget.username,
        'examType': widget.exam.type,
        'examId': widget.exam.autoId.toString(),
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Decoded Data: $data');
      
      // เก็บค่าจาก response
      hasSubmitted = data['exists'] == true;
      status = data['status'] ?? false;
      submitTime = data['submitTime'];
     

      return hasSubmitted;
    } else {
      throw Exception('Server Error: ${response.statusCode}');
    }
  } catch (e) {
    debugPrint('Error in _checkSubmit: $e');
    return false;
  }
}





  void _openFile(Upfile file) async {
    final url = file.upfileUrl; 
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'ไม่สามารถเปิดไฟล์ได้';
    }
  }

  @override
void initState() {
  super.initState();
  setState(() {
    isLoading = true;
  });
  _fetchData();
  _checkSubmit().then((value) {
    setState(() {
      hasSubmitted = value;
      isLoading = false;
    });
  }).catchError((error) {
    setState(() {
      isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('เกิดข้อผิดพลาด: $error')),
    );
  });
}

@override
void didUpdateWidget(covariant Detail_work_S oldWidget) {
  super.didUpdateWidget(oldWidget);
  if (widget.exam != oldWidget.exam) {
    setState(() {
      isLoading = true;
      hasSubmitted = false;
      fileData.clear();
      questionData.clear();
    });
    _fetchData();
    _checkSubmit().then((value) {
      setState(() {
        hasSubmitted = value;
        isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาด: $error')),
      );
    });
  }
}

  Future<void> _saveFileToPost(int examsetsId, List<PlatformFile> selectedFiles) async {
  if (selectedFiles.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('บันทึกคำสั่งงานเรียบร้อย'),
      backgroundColor: Colors.green,
    ));
    return; 
  }

  List<FileData> fileDataList = selectedFiles
      .map((file) => FileData.fromPlatformFile(file))
      .toList();

  for (var file in fileDataList) {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://www.edueliteroom.com/connect/submit_upfile.php'),
      );

      
      request.fields['examsets_id'] = examsetsId.toString();
      request.fields['username'] = widget.username; 

      print('Uploading file for examsetsId: $examsetsId and username: ${widget.username}');

      request.files.add(http.MultipartFile.fromBytes(
        'file',
        file.bytes,
        filename: file.name,
      ));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        print('File uploaded successfully: $responseData');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('บันทึกคำสั่งงานเรียบร้อย'),
          backgroundColor: Colors.green,
        ));
      } else {
        throw 'Error uploading file: ${response.statusCode}, ${response.reasonPhrase}';
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}

  

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    final exam = widget.exam;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            
              if (exam.closed == 'Yes') ...[
                SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      Icons.warning,  // หรือเลือก icon ที่คุณต้องการ
                      color: Colors.red,
                      size: 20,
                    ),
                    SizedBox(width: 8),  // เพิ่มระยะห่างระหว่าง icon กับข้อความ
                    Text(
                      'ปิดรับงานเมื่อครบกำหนดส่ง',
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ],
                ),
              ],
              SizedBox(height: 16),


            //upfile
            if (exam.type == 'upfile') ...[
                Text('ไฟล์ที่แนบมา:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                SizedBox(height: 8),
                (fileData.isNotEmpty)
                    ? ListView.builder(
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
                      )
                    : Text('ไม่มีไฟล์แนบ', style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 16),
                    Text('สถานะการส่งงาาน:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    SizedBox(height: 8),
                            if (hasSubmitted) 
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  if (submitTime.isNotEmpty && widget.exam.deadline.isNotEmpty) 
                                  Builder(builder: (context){
                                    final submitDate = DateTime.parse(submitTime);
                                    final deadlineDate = DateTime.parse(widget.exam.deadline);

                                    // เปรียบเทียบเฉพาะวัน (ไม่สนใจเวลา)
                                    if (submitDate.year == deadlineDate.year &&
                                        submitDate.month == deadlineDate.month &&
                                        submitDate.day == deadlineDate.day) {
                                      // กรณีส่งในวันเดียวกัน
                                      return Text(
                                        'คุณได้ส่งไฟล์เรียบร้อยแล้ว ',
                                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                                      );
                                    } else if (!submitDate.isAfter(deadlineDate)) {
                                      // กรณีส่งตรงเวลา หรือก่อนเวลา
                                      return Text(
                                        'คุณได้ส่งไฟล์เรียบร้อยแล้ว ',
                                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                                      );
                                    } else {
                                      // กรณีส่งช้ากว่ากำหนด
                                      final overdueDays = submitDate.difference(deadlineDate).inDays;
                                      return Text(
                                        'คุณได้ส่งไฟล์ช้ากว่ากำหนด $overdueDays วัน',
                                        style: TextStyle(color: const Color.fromARGB(255, 177, 136, 2), fontWeight: FontWeight.bold),
                                      );
                                    }
                                  },
                                  )else
                                  Text(
                                    'ข้อมูลเวลาไม่ถูกต้อง',
                                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                  ),
                                  
                                  SizedBox(width: 8),
                                  // แสดง TextButton พร้อม Icon ข้างหน้า
                                  status
                                      ? TextButton.icon(
                                          icon: Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                          ),
                                          label: Text(
                                            'งานได้รับการตรวจแล้ว',
                                            style: TextStyle(color: Colors.green, fontSize: 16),
                                          ),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Chcekworkaftersubmitscoreupfile(
                                                  exam: widget.exam,
                                                  username: widget.username,
                                                ); 
                                              },
                                            );
                                          },
                                        )
                                      : TextButton.icon(
                                          icon: Icon(
                                            Icons.hourglass_empty,
                                            color: Colors.orange,
                                          ),
                                          label: Text(
                                            'กำลังรอตรวจงาน',
                                            style: TextStyle(color: Colors.orange, fontSize: 16),
                                          ),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Getsubmitscoreupfile(
                                                  exam: widget.exam,
                                                  username: widget.username,
                                                ); 
                                              },
                                            );
                                            

                                          },
                                        ),
                                ],
                              ) else Builder(
                                    builder: (context) {
                                      if (exam.closed == 'Yes') {
                                        DateTime currentDate = DateTime.now();
                                        DateTime deadlineDate = DateTime.parse(exam.deadline);

                                        // ทำให้เวลาเป็น 00:00:00 ของวันเพื่อเปรียบเทียบเฉพาะวัน
                                        DateTime currentDateOnly = DateTime(currentDate.year, currentDate.month, currentDate.day);
                                        DateTime deadlineDateOnly = DateTime(deadlineDate.year, deadlineDate.month, deadlineDate.day);

                                        Duration difference = currentDateOnly.difference(deadlineDateOnly);

                                        if (currentDateOnly.isAfter(deadlineDateOnly)) {
                                          // หากวันที่ปัจจุบันเลยวันครบกำหนดแล้ว
                                          return Text(
                                            'คุณไม่สามารถส่งงานได้เนื่องจากเลยวันครบกำหนดมา ${difference.inDays} วันแล้ว',
                                            style: TextStyle(color: Colors.red, fontSize: 16),
                                          );
                                        } else {
                                          // หากยังไม่ถึงวันครบกำหนดให้แสดงปุ่ม
                                          return Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('คุณยังไม่ได้ส่งงาน'),
                                              IconButton(
                                                onPressed: () async {
                                                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                                                    allowMultiple: true,
                                                  );
                                                  if (result != null) {
                                                    setState(() {
                                                      selectedFiles = result.files;
                                                    });
                                                  }
                                                },
                                                icon: Icon(Icons.upload, size: 30),
                                              ),
                                            ],
                                          );
                                        }
                                      } else {
                                        // หาก exam.closed == 'No' แสดงปุ่มส่งงาน
                                        DateTime currentDate = DateTime.now();
                                        DateTime deadlineDate = DateTime.parse(exam.deadline);


                                        Duration difference = currentDate.difference(deadlineDate);
                                        if (difference.isNegative) {
                                  
                                        return Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            IconButton(
                                              onPressed: () async {
                                                FilePickerResult? result = await FilePicker.platform.pickFiles(
                                                  allowMultiple: true,
                                                );
                                                if (result != null) {
                                                  setState(() {
                                                    selectedFiles = result.files;
                                                  });
                                                }
                                              },
                                              icon: Icon(Icons.upload, size: 30),
                                            )

                                          ],);
                                        } else if (difference.inDays == 0){
                                          return Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('กำหนดส่งวันนี้วันสุดท้ายกรุณาส่งงานโดยเร็ว!', style: TextStyle(color: Colors.orange, fontSize: 14),),
                                              IconButton(
                                              onPressed: () async {
                                                FilePickerResult? result = await FilePicker.platform.pickFiles(
                                                  allowMultiple: true,
                                                );
                                                if (result != null) {
                                                  setState(() {
                                                    selectedFiles = result.files;
                                                  });
                                                }
                                              },
                                              icon: Icon(Icons.upload, size: 30),
                                            ),
                                            ],
                                          );

                                        } else {
                                          return Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('เลยวันครบกำหนดมา ${difference.inDays} วันแล้วรีบส่งงานโดยเร็ว!', style: TextStyle(color: Colors.orange, fontSize: 14),),
                                            IconButton(
                                              onPressed: () async {
                                                FilePickerResult? result = await FilePicker.platform.pickFiles(
                                                  allowMultiple: true,
                                                );
                                                if (result != null) {
                                                  setState(() {
                                                    selectedFiles = result.files;
                                                  });
                                                }
                                              },
                                              icon: Icon(Icons.upload, size: 30),
                                            ),
                                            

                                          ],);

                                        }
                                      }
                                    },
                                  ),
                            // แสดงไฟล์ที่ถูกเลือก
                            ...selectedFiles.map((file) => ListTile(
                              title: Text(file.name),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => setState(() => selectedFiles.remove(file)),
                              ),
                            )),
                            // ตรวจสอบว่า selectedFiles มีไฟล์ที่เลือกแล้วหรือไม่
                            selectedFiles.isNotEmpty
                                ? ElevatedButton(
                                    onPressed: () async {
                                      await _saveFileToPost(exam.autoId, selectedFiles);
                                      setState(() {
                                        hasSubmitted = true;
                                      });
                                    },
                                    child: Text('ส่งงาน'),
                                  )
                                : Container(), // ถ้าไม่มีไฟล์ที่เลือกให้ไม่แสดงปุ่ม
                          ],




            //auswer
            if (exam.type == 'auswer') ...[
              SizedBox(height: 16),
              Text('สถานะการส่งงาน:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              SizedBox(height: 8),
              hasSubmitted
                  ? Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  if (submitTime.isNotEmpty && widget.exam.deadline.isNotEmpty) 
                                  Builder(builder: (context){
                                    final submitDate = DateTime.parse(submitTime);
                                    final deadlineDate = DateTime.parse(widget.exam.deadline);

                                    // เปรียบเทียบเฉพาะวัน (ไม่สนใจเวลา)
                                    if (submitDate.year == deadlineDate.year &&
                                        submitDate.month == deadlineDate.month &&
                                        submitDate.day == deadlineDate.day) {
                                      // กรณีส่งในวันเดียวกัน
                                      return Text(
                                        'คุณได้ตอบคำถามเรียบร้อยแล้ว ',
                                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                                      );
                                    } else if (!submitDate.isAfter(deadlineDate)) {
                                      // กรณีส่งตรงเวลา หรือก่อนเวลา
                                      return Text(
                                        'คุณได้ตอบคำถามเรียบร้อยแล้ว ',
                                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                                      );
                                    } else {
                                      // กรณีส่งช้ากว่ากำหนด
                                      final overdueDays = submitDate.difference(deadlineDate).inDays;
                                      return Text(
                                        'คุณได้ตอบคำถามช้ากว่ากำหนด $overdueDays วัน',
                                        style: TextStyle(color: const Color.fromARGB(255, 177, 136, 2), fontWeight: FontWeight.bold),
                                      );
                                    }
                                  },
                                  )else
                                  Text(
                                    'ข้อมูลเวลาไม่ถูกต้อง',
                                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: 8),
                                  // แสดง TextButton พร้อม Icon ข้างหน้า
                                  status
                                      ? TextButton.icon(
                                          icon: Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                          ),
                                          label: Text(
                                            'งานได้รับการตรวจแล้ว',
                                            style: TextStyle(color: Colors.green, fontSize: 16),
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => Chcekworkaftersubmitscoreauswer(
                                                exam: widget.exam,
                                                username: widget.username,
                                              ))
                                            );
                                            print('TextButton with check icon clicked');
                                          },
                                        )
                                      : TextButton.icon(
                                          icon: Icon(
                                            Icons.hourglass_empty,
                                            color: Colors.orange,
                                          ),
                                          label: Text(
                                            'กำลังรอตรวจงาน',
                                            style: TextStyle(color: Colors.orange, fontSize: 16),
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => Getsubmitauswer(
                                                exam: widget.exam,
                                                username: widget.username,
                                              ))
                                            );
                                          },
                                        ),])
                                                
                                  : Builder(
                                      builder: (context) {
                                        DateTime currentDate = DateTime.now();
                                        DateTime deadlineDate = DateTime.parse(exam.deadline);

                                        Duration difference = currentDate.difference(deadlineDate);

                                        if (exam.closed == 'Yes') {
                                        DateTime currentDate = DateTime.now();
                                        DateTime deadlineDate = DateTime.parse(exam.deadline);

                                        // ทำให้เวลาเป็น 00:00:00 ของวันเพื่อเปรียบเทียบเฉพาะวัน
                                        DateTime currentDateOnly = DateTime(currentDate.year, currentDate.month, currentDate.day);
                                        DateTime deadlineDateOnly = DateTime(deadlineDate.year, deadlineDate.month, deadlineDate.day);

                                        Duration difference = currentDateOnly.difference(deadlineDateOnly);

                                        if (currentDateOnly.isAfter(deadlineDateOnly)) {
                                          // หากวันที่ปัจจุบันเลยวันครบกำหนดแล้ว
                                          return Text(
                                            'คุณไม่สามารถส่งงานได้เนื่องจากเลยวันครบกำหนดมา ${difference.inDays} วันแล้ว',
                                            style: TextStyle(color: Colors.red, fontSize: 16),
                                          );
                                        } else {
                                          // หากยังไม่ถึงวันครบกำหนดให้แสดงปุ่ม
                                          return Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('คุณยังไม่ได้ส่งงาน'),
                                              OutlinedButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => Doauswerstudents(
                                                          thfname: widget.thfname,
                                                          thlname: widget.thlname,
                                                          username: widget.username,
                                                          exam: widget.exam,
                                                          questions: questionData,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Text('ไปตอบคำถาม'),
                                                ),
                                              
                                            ],
                                          );
                                        }
                                        } else {
                                          // งานยังเปิดรับ
                                          if (difference.isNegative) {
                                            // ยังไม่ถึงวันครบกำหนด
                                            return Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text('คุณยังไม่ได้ส่งงาน'),
                                                OutlinedButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => Doauswerstudents(
                                                          thfname: widget.thfname,
                                                          thlname: widget.thlname,
                                                          username: widget.username,
                                                          exam: widget.exam,
                                                          questions: questionData,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Text('ไปตอบคำถาม'),
                                                ),
                                              ],
                                            );
                                          } else if (difference.inDays == 0){
                                          return Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('กำหนดส่งวันนี้วันสุดท้ายกรุณาส่งงานโดยเร็ว!', style: TextStyle(color: Colors.orange, fontSize: 14),),
                                              IconButton(
                                              onPressed: () async {
                                                FilePickerResult? result = await FilePicker.platform.pickFiles(
                                                  allowMultiple: true,
                                                );
                                                if (result != null) {
                                                  setState(() {
                                                    selectedFiles = result.files;
                                                  });
                                                }
                                              },
                                              icon: Icon(Icons.upload, size: 30),
                                            ),
                                            ],
                                          );
                                          } else {
                                            // เลยวันครบกำหนดมาแล้ว
                                            return Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  'เลยวันครบกำหนดมา ${difference.inDays} วันแล้วรีบส่งงานโดยเร็ว',
                                                  style: TextStyle(color: Colors.orange, fontSize: 14),
                                                ),
                                                OutlinedButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => Doauswerstudents(
                                                          thfname: widget.thfname,
                                                          thlname: widget.thlname,
                                                          username: widget.username,
                                                          exam: widget.exam,
                                                          questions: questionData,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Text('ไปตอบคำถาม'),
                                                ),
                                              ],
                                            );
                                          }
                                        }
                                      },
                                    ),
                            ],



                            //onechoice
                            if (exam.type == 'onechoice') ...[
                              SizedBox(height: 16),
                              Text('สถานะการส่งงาาน:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                              SizedBox(height: 8),
                                hasSubmitted
                                    ? Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        if (submitTime.isNotEmpty && widget.exam.deadline.isNotEmpty) 
                                  Builder(builder: (context){
                                    final submitDate = DateTime.parse(submitTime);
                                    final deadlineDate = DateTime.parse(widget.exam.deadline);

                                    // เปรียบเทียบเฉพาะวัน (ไม่สนใจเวลา)
                                    if (submitDate.year == deadlineDate.year &&
                                        submitDate.month == deadlineDate.month &&
                                        submitDate.day == deadlineDate.day) {
                                      // กรณีส่งในวันเดียวกัน
                                      return Text(
                                        'คุณได้ทำข้อสอบเรียบร้อยแล้ว ',
                                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                                      );
                                    } else if (!submitDate.isAfter(deadlineDate)) {
                                      // กรณีส่งตรงเวลา หรือก่อนเวลา
                                      return Text(
                                        'คุณได้ทำข้อสอบเรียบร้อยแล้ว ',
                                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                                      );
                                    } else {
                                      // กรณีส่งช้ากว่ากำหนด
                                      final overdueDays = submitDate.difference(deadlineDate).inDays;
                                      return Text(
                                        'คุณได้ทำข้อสอบช้ากว่ากำหนด $overdueDays วัน',
                                        style: TextStyle(color: const Color.fromARGB(255, 177, 136, 2), fontWeight: FontWeight.bold),
                                      );
                                    }
                                  },
                                  )else
                                  Text(
                                    'ข้อมูลเวลาไม่ถูกต้อง',
                                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                  ),
                                      TextButton.icon(
                                          icon: Icon(
                                            Icons.search,
                                            color: const Color.fromARGB(255, 0, 0, 0),
                                          ),
                                          label: Text(
                                            'ตรวจสอบ',
                                            style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0), fontSize: 16),
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => Chcekscoreonechoice(
                                                exam: widget.exam,
                                                username: widget.username,
                                              ))
                                            );
                                          },
                                        )

                                    ],
                                  )              
                                  : Builder(builder: (context){
                                      if (exam.closed == 'Yes') {
                                        DateTime currentDate = DateTime.now();
                                        DateTime deadlineDate = DateTime.parse(exam.deadline);

                                        // ทำให้เวลาเป็น 00:00:00 ของวันเพื่อเปรียบเทียบเฉพาะวัน
                                        DateTime currentDateOnly = DateTime(currentDate.year, currentDate.month, currentDate.day);
                                        DateTime deadlineDateOnly = DateTime(deadlineDate.year, deadlineDate.month, deadlineDate.day);

                                        Duration difference = currentDateOnly.difference(deadlineDateOnly);

                                        if (currentDateOnly.isAfter(deadlineDateOnly)) {
                                          // หากวันที่ปัจจุบันเลยวันครบกำหนดแล้ว
                                          return Text(
                                            'คุณไม่สามารถทำข้อสอบได้เนื่องจากเลยวันครบกำหนดมา ${difference.inDays} วันแล้ว',
                                            style: TextStyle(color: Colors.red, fontSize: 16),
                                          );
                                        } else {
                                          // หากยังไม่ถึงวันครบกำหนดให้แสดงปุ่ม
                                          return Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('คุณยังไม่ได้ทำข้อสอบ'),
                                              OutlinedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => Doonechoicestudents(
                                                      exam: widget.exam,
                                                      username: widget.username,
                                                      thfname: widget.thfname,
                                                      thlname: widget.thlname,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Text('ไปทำข้อสอบ'),
                                            ),
                                            ],
                                          );
                                        }
                                      } else {
                                        DateTime currentDate = DateTime.now();
                                        DateTime deadlineDate = DateTime.parse(exam.deadline);

                                        Duration difference = currentDate.difference(deadlineDate);
                                        if (difference.isNegative) {
                                          return Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('คุณยังไม่ได้ทำข้อสอบ'),
                                          OutlinedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => Doonechoicestudents(
                                                    exam: widget.exam,
                                                    username: widget.username,
                                                    thfname: widget.thfname,
                                                    thlname: widget.thlname,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Text('ไปทำข้อสอบ'),
                                          ),
                                          
                                        ]);

                                        } else if (difference.inDays == 0){
                                          return Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('กำหนดส่งวันนี้วันสุดท้ายกรุณาทำข้อสอบโดยเร็ว!', style: TextStyle(color: Colors.orange, fontSize: 14),),
                                              IconButton(
                                              onPressed: () async {
                                                FilePickerResult? result = await FilePicker.platform.pickFiles(
                                                  allowMultiple: true,
                                                );
                                                if (result != null) {
                                                  setState(() {
                                                    selectedFiles = result.files;
                                                  });
                                                }
                                              },
                                              icon: Icon(Icons.upload, size: 30),
                                            ),
                                            ],
                                          );

                                        } else {
                                          return Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('เลยวันครบกำหนดมา ${difference.inDays} วันแล้วรีบทำข้อสอบโดยเร็ว',style: TextStyle(color: Colors.orange, fontSize: 14),),
                                          OutlinedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => Doonechoicestudents(
                                                    exam: widget.exam,
                                                    username: widget.username,
                                                    thfname: widget.thfname,
                                                    thlname: widget.thlname,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Text('ไปทำข้อสอบ'),
                                          ),
                                          
                                          
                                        ]);

                                        }
                                        
                                      }
                                      }) 
                                      
                            ],




                            //manychoice
                            if (exam.type == 'manychoice') ...[
                              SizedBox(height: 16),
                              Text('สถานะการส่งงาาน:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                              SizedBox(height: 8),
                                  hasSubmitted
                                      ? Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        if (submitTime.isNotEmpty && widget.exam.deadline.isNotEmpty) 
                                  Builder(builder: (context){
                                    final submitDate = DateTime.parse(submitTime);
                                    final deadlineDate = DateTime.parse(widget.exam.deadline);

                                    // เปรียบเทียบเฉพาะวัน (ไม่สนใจเวลา)
                                    if (submitDate.year == deadlineDate.year &&
                                        submitDate.month == deadlineDate.month &&
                                        submitDate.day == deadlineDate.day) {
                                      // กรณีส่งในวันเดียวกัน
                                      return Text(
                                        'คุณได้ทำข้อสอบเรียบร้อยแล้ว ',
                                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                                      );
                                    } else if (!submitDate.isAfter(deadlineDate)) {
                                      // กรณีส่งตรงเวลา หรือก่อนเวลา
                                      return Text(
                                        'คุณได้ทำข้อสอบเรียบร้อยแล้ว ',
                                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                                      );
                                    } else {
                                      // กรณีส่งช้ากว่ากำหนด
                                      final overdueDays = submitDate.difference(deadlineDate).inDays;
                                      return Text(
                                        'คุณได้ทำข้อสอบกว่ากำหนด $overdueDays วัน',
                                        style: TextStyle(color: const Color.fromARGB(255, 177, 136, 2), fontWeight: FontWeight.bold),
                                      );
                                    }}
                                  ) else
                                  Text(
                                    'ข้อมูลเวลาไม่ถูกต้อง',
                                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                  ),
                                      TextButton.icon(
                                          icon: Icon(
                                            Icons.search,
                                            color: const Color.fromARGB(255, 0, 0, 0),
                                          ),
                                          label: Text(
                                            'ตรวจสอบ',
                                            style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0), fontSize: 16),
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => Chcekscoremanychoice(
                                                          exam: widget.exam,
                                                          username: widget.username,
                                                        ),
                                                      ),
                                                    );
                                            
                                          },
                                        )

                                    ],
                                  )
                                    : Builder(builder: (context){
                                      if (exam.closed == 'Yes') {
                                        DateTime currentDate = DateTime.now();
                                        DateTime deadlineDate = DateTime.parse(exam.deadline);

                                        // ทำให้เวลาเป็น 00:00:00 ของวันเพื่อเปรียบเทียบเฉพาะวัน
                                        DateTime currentDateOnly = DateTime(currentDate.year, currentDate.month, currentDate.day);
                                        DateTime deadlineDateOnly = DateTime(deadlineDate.year, deadlineDate.month, deadlineDate.day);

                                        Duration difference = currentDateOnly.difference(deadlineDateOnly);

                                        if (currentDateOnly.isAfter(deadlineDateOnly)) {
                                          // หากวันที่ปัจจุบันเลยวันครบกำหนดแล้ว
                                          return Text(
                                            'คุณไม่สามารถทำข้อสอบได้เนื่องจากเลยวันครบกำหนดมา ${difference.inDays} วันแล้ว',
                                            style: TextStyle(color: Colors.red, fontSize: 16),
                                          );
                                        } else {
                                          // หากยังไม่ถึงวันครบกำหนดให้แสดงปุ่ม
                                          return Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('คุณยังไม่ได้ทำข้อสอบ'),
                                              IconButton(
                                                onPressed: () async {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => Domanychoicestudents(
                                                          exam: widget.exam,
                                                          username: widget.username,
                                                          thfname: widget.thfname,
                                                          thlname: widget.thlname,
                                                        ),
                                                      ),
                                                    );
                                                  
                                                },
                                                icon: Icon(Icons.upload, size: 30),
                                              ),
                                            ],
                                          );
                                        }

                                        } else {
                                          DateTime currentDate = DateTime.now();
                                          DateTime deadlineDate = DateTime.parse(exam.deadline);

                                          Duration difference = currentDate.difference(deadlineDate);
                                          if (difference.isNegative) {
                                            return Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text('คุณยังไม่ได้ทำข้อสอบ'),
                                                OutlinedButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => Domanychoicestudents(
                                                          exam: widget.exam,
                                                          username: widget.username,
                                                          thfname: widget.thfname,
                                                          thlname: widget.thlname,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Text('ไปทำข้อสอบ'),
                                                )
                                              ],
                                            ); 
                                          } else if (difference.inDays == 0){
                                          return Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('กำหนดส่งวันนี้วันสุดท้ายกรุณาทำข้อสอบโดยเร็ว!', style: TextStyle(color: Colors.orange, fontSize: 14),),
                                              IconButton(
                                              onPressed: () async {
                                                FilePickerResult? result = await FilePicker.platform.pickFiles(
                                                  allowMultiple: true,
                                                );
                                                if (result != null) {
                                                  setState(() {
                                                    selectedFiles = result.files;
                                                  });
                                                }
                                              },
                                              icon: Icon(Icons.upload, size: 30),
                                            ),
                                            ],
                                          );

                                        } else {
                                            return Row(
                                              children: [
                                                OutlinedButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => Domanychoicestudents(
                                                          exam: widget.exam,
                                                          username: widget.username,
                                                          thfname: widget.thfname,
                                                          thlname: widget.thlname,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Text('ไปทำข้อสอบ'),
                                                ),
                                                Text('เลยวันครบกำหนดมา ${difference.inDays} วันแล้วรีบทำข้อสอบโดยเร็ว', style: TextStyle(color: Colors.orange, fontSize: 14),),

                                              ],
                                            );


                          }

                        }

                      })
                      
                      
                      
        
            ],
        
          ],
        ),
      ),
    );
  }
}


//-------------------------------------------------

class Assignment {
  final String title;
  final String time;
  final String duedate;
  final String classID;

  Assignment({
    required this.title,
    required this.time,
    required this.duedate,
    required this.classID,
  });

  // ฟังก์ชันสำหรับแปลงข้อมูลจาก JSON
  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      title: json['event_assignment_title'],
      time: json['event_assignment_time'],
      duedate: json['event_assignment_duedate'],
      classID: json['event_assignment_classID'],
    );
  }
}
