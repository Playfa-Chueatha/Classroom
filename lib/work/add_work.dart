import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
class add_wprk_T extends StatefulWidget {
  const add_wprk_T({super.key});

  @override
  State<add_wprk_T> createState() => _add_workState();
}

class _add_workState extends State<add_wprk_T> {
  List<PlatformFile> selectedFiles = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          keyboardType: TextInputType.multiline,
                          maxLines: 50,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'เขียนอะไรหน่อย',
                              contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
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
                        child: Column(
                          children: [
                            SizedBox(height: 50),
                            Row (
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: 50),
                                Text("คะแนนเต็ม :  ", style: TextStyle(fontSize: 20)),
                                SizedBox(
                                  height: 30,
                                  width: 100,
                                  child: TextField(
                                    maxLength: 3,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 7),
                                      counterText: "",
                                      isCollapsed: true,
                                      isDense: true,
                                      filled: true,
                                      fillColor: Colors.white,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10)
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10)
                                      )
                                    ),
                                  ),
                                )
                              ]
                            ),
                            SizedBox(height: 10),
                            Row (
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                SizedBox(width: 50),
                                Text("วันที่ :            ", style: TextStyle(fontSize: 20)),
                                SizedBox(
                                  height: 30,
                                  width: 100,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      prefix: Icon(Icons.calendar_today),
                                      isCollapsed: true,
                                      isDense: true,
                                      filled: true,
                                      fillColor: Colors.white,
                                      
                                      
                                      
                                      )
                                    ),
                                    
                                  )
                              ]
                            )
                              ]
                            )
                        )
                    ],                                                              
                      )                                       
              ),       
            ),
          )        
        );  
  }
}

