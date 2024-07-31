import 'package:flutter/material.dart';

void main() => runApp(const add_work());

class add_work extends StatefulWidget {
  const add_work({super.key});

  @override
  State<add_work> createState() => _add_workState();
}

class _add_workState extends State<add_work> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Addwork',
      home: Scaffold(
        appBar: AppBar(
          title: Text("มอบหมายงาน"),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 195, 238, 250),
        ),
        body: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              height: 750,
              width: 1500,
              margin: EdgeInsets.all(50),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 195, 238, 250),
                borderRadius: BorderRadius.circular(20)
              ),
              child: Row(
                children: [
                  Column(
                    children: [

                      SizedBox(height: 30),
                      //เขียนคำอธิบาย
                      SizedBox(
                        height: 200,
                        width: 900,    
                        child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter a search term',
                              contentPadding: EdgeInsets.symmetric(horizontal: 25,vertical: 160),
                              isCollapsed: true,
                              isDense: true,
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)
                              )
                            ),
                          ),  
                        ),
                        //ปุ่ม
                      Container(
                        alignment: Alignment.topLeft,
                        height: 50,
                        width: 800,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 142, 217, 238),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)
                          )
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 10),
                            IconButton(
                              icon: Icon(Icons.format_bold_outlined,size: 30),
                              onPressed: (){}, 
                              style: IconButton.styleFrom(
                                
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.format_italic,size: 30),
                              onPressed: (){}, 
                              style: IconButton.styleFrom(
                                
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.format_underline,size: 30),
                              onPressed: (){}, 
                              style: IconButton.styleFrom(
                                
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.format_color_text_outlined,size: 30),
                              onPressed: (){}, 
                              style: IconButton.styleFrom(
                                
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.format_size_outlined,size: 30),
                              onPressed: (){}, 
                              style: IconButton.styleFrom(
                                
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.format_list_bulleted,size: 30),
                              onPressed: (){}, 
                              style: IconButton.styleFrom(
                                
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.format_align_left_outlined,size: 30),
                              onPressed: (){}, 
                              style: IconButton.styleFrom(
                                
                              ),
                              ),
                            IconButton(
                              icon: Icon(Icons.format_align_center_outlined,size: 30),
                              onPressed: (){}, 
                              style: IconButton.styleFrom(
                                
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.format_align_right_outlined,size: 30),
                              onPressed: (){}, 
                              style: IconButton.styleFrom(
                                
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.format_align_justify_outlined,size: 30),
                              onPressed: (){}, 
                              style: IconButton.styleFrom(
                                
                              ),
                            ),
                            
                          ],
                        ),
                      ),
                      
                      //ประเภทงาน
                      Container(
                        height: 350,
                        width: 900,
                        margin: EdgeInsets.fromLTRB(50,10,50,30),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)
                        ),
                      )
                    ]
                  ),
                      //คะแนน
                      Container(
                        height: 700,
                        width: 400,
                        margin: EdgeInsets.fromLTRB(30,30,50,30),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)
                        ),
                      )
                    ],
                  ),
                  //คะแนน
              ),
              // child: Column(
              //   children: [
              //     SizedBox(height: 50),
              //     SizedBox(
              //       height: 30,
              //       width: 200,
              //       child: TextField(
              //         decoration: InputDecoration(
              //           border: OutlineInputBorder(),
              //               fillColor: Colors.white,
              //               focusColor: Colors.white,
              //               labelText: 'กรุณาใส่รหัส OTP ที่ส่งไปยังอีเมล์ของคุณ'
              //         ),
              //       ),
              //     )
              //   ],
              // ),
            
            ),
          ),
          
        ),
      );
    
  }
}