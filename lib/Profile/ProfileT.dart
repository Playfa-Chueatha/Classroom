import 'package:flutter/material.dart';
void main() => runApp(const Profile()); 
class Profile_T extends StatelessWidget {
  const Profile_T({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile',
      home: Profile(),
    );
  }
}

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final double coverHeight = 280;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              height: 1500,
              width: 1500,
              margin: EdgeInsets.all(50),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 147, 185, 221),
                borderRadius: BorderRadius.circular(20)
              ),
              
              child: SingleChildScrollView(
                // scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    Container(
                    child: Row(
                      children: [
                        SizedBox(width: 1100),
                        SizedBox(
                          height: 50,
                          width: 200,
                          child: FilledButton(
                            onPressed: (){},
                            style: FilledButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 228, 223, 153),
                            foregroundColor: Colors.black
                          ), 
                            child: Text("เปลี่ยนรหัสผ่าน", style: TextStyle(fontSize: 20))),
                        ),
                        SizedBox(width: 10),
                        SizedBox(
                          height: 50,
                          width: 150,
                          child: FilledButton(
                            onPressed: (){},
                            style: FilledButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 10, 82, 104)
                          ), 
                            child: Text("แก้ไขข้อมูล", style: TextStyle(fontSize: 20))),
                        ),
                      ]
                    )
                  ),
                    SizedBox(height: 50),

                    Container(
                      height: 300,
                      width: 300,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(2, 2),
                              blurRadius: 10
                            )
                          ],
                          image: DecorationImage(
                          image: AssetImage(
                            "assets/images/ครู.png"
                          ))
                      ),
                    ),

                    SizedBox(height: 10),

                    SizedBox(
                      height: 50,
                      width: 150,
                      child: FilledButton(
                          onPressed: (){},
                          style: FilledButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 10, 82, 104)
                          ), 
                          child: Text("แก้ไขโปรไฟล์", style: TextStyle(fontSize: 20)),),
                  ),
                  SizedBox(height: 50),
                  Container(
                          height: 700,
                          width: 1200,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(200, 50, 0, 50),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: const [
                                    Text("ชื่อ-นามสกุล(ภาษาไทย):"),
                                    Text('ชื่อ-นามสกุล(ภาษาอังกฤษ):'),
                                    Text('ครูประจำชั้นมัธยมศึกษาปีที่:'),
                                    Text('ห้อง:'),
                                    Text('เบอร์โทร:'),
                                    Text('E-mail:'),
                                    Text('วิชาที่สอน:'),
                                  ],
                                ),
                              )
                              
                            ],
                          ),
                  ),
                  SizedBox(height: 50,)
                  ],
                ),
              ),
          ),
        ),     
      ),
    );
  }
}
