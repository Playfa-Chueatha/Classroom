import 'package:flutter/material.dart';

class Detail_work extends StatefulWidget {
  const Detail_work({super.key});

  @override
  State<Detail_work> createState() => _Detail_workState();
}

class _Detail_workState extends State<Detail_work> {
  // สมมติว่าคุณมีข้อมูลที่ต้องแสดง
  final String direction = 'รายละเอียดของงาน';
  final String fullMarks = '100';
  final String dueDate = '30 ก.ย. 2024';
  final List<String> files = [];
  final List<String> links = [];

  @override
  Widget build(BuildContext context) {
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
            Text(direction),
            SizedBox(height: 16),
            Text(
              'คะแนนเต็ม:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(fullMarks),
            SizedBox(height: 16),
            Text(
              'วันที่ครบกำหนด:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(dueDate),
            SizedBox(height: 16),
            Text(
              'ไฟล์ที่แนบมา:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8),
            files.isNotEmpty
                ? Container(
                    constraints: BoxConstraints(maxHeight: 200), // ความสูงสูงสุดของ ListView
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: files.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(files[index]),
                          leading: Icon(Icons.attach_file),
                          onTap: () {
                            // เพิ่มฟังก์ชันเพื่อเปิดไฟล์ถ้าต้องการ
                          },
                        );
                      },
                    ),
                  )
                : Text('ไม่มีไฟล์แนบ'),
            SizedBox(height: 16),
            Text(
              'ลิงค์ที่แนบมา:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8),
            links.isNotEmpty
                ? Container(
                    constraints: BoxConstraints(maxHeight: 200), // ความสูงสูงสุดของ ListView
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: links.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            links[index],
                            style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                          ),
                          leading: Icon(Icons.link),
                          onTap: () {
                            // เพิ่มฟังก์ชันเพื่อเปิดลิงค์ถ้าต้องการ
                          },
                        );
                      },
                    ),
                  )
                : Text('ไม่มีลิงค์แนบ'),
            SizedBox(height: 16),
            Text(
              'รายชื่อนักเรียนที่ส่งงานแล้ว:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'รายชื่อนักเรียนที่ยนังไม่ได้ส่งงาน:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
              
          ],
        ),
      ),
    );
  }
}
