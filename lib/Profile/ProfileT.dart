import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Profile/repass.dart';

class Profile_T extends StatefulWidget {
  const Profile_T({super.key});

  @override
  State<Profile_T> createState() => _Profile_TState();
}

class _Profile_TState extends State<Profile_T> {
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
                            onPressed: (){
                              showDialog(
                                context: context, 
                                builder: (BuildContext context) => repass());
                            },
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
                                margin: EdgeInsets.fromLTRB(250, 50, 0, 50),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text("ชื่อ-นามสกุล(ภาษาไทย):",style: TextStyle(fontSize: 20),),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text('ชื่อ-นามสกุล(ภาษาอังกฤษ):',style: TextStyle(fontSize: 20),),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text('ครูประจำชั้นมัธยมศึกษาปีที่:',style: TextStyle(fontSize: 20),),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text('ห้อง:',style: TextStyle(fontSize: 20),),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text('เบอร์โทร:',style: TextStyle(fontSize: 20),)
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text('E-mail:',style: TextStyle(fontSize: 20),),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text('วิชาที่สอน:',style: TextStyle(fontSize: 20),),
                                    ),
                                                                     
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
