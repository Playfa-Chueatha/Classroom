import 'package:flutter/material.dart';

class AnnounceClass extends StatelessWidget {
  const AnnounceClass({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Announce',
      home: AnnounceClass_work(),
    );
  }
}

class AnnounceClass_work extends StatefulWidget {
  const AnnounceClass_work({super.key});

  @override
  State<AnnounceClass_work> createState() => _AnnounceClass_workState();
}

class _AnnounceClass_workState extends State<AnnounceClass_work> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text("สร้างประกาศใหม่")),
      actions: [
        Container(
            height:260,
            width: 500,
            margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child:Column(
              children: [
                SizedBox(
                  height: 100,
                  width: 500,
                  child: 
                  TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 50,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'เขียนประกาศของคุณ',
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
                

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      IconButton(
                        icon: Icon(Icons.format_bold_outlined,size: 20),
                          onPressed: (){}, 
                          style: IconButton.styleFrom(
                                
                          ),
                      ),
                        IconButton(
                          icon: Icon(Icons.format_italic,size: 20),
                          onPressed: (){}, 
                          style: IconButton.styleFrom(
                                
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.format_underline,size: 20),
                          onPressed: (){}, 
                          style: IconButton.styleFrom(
                                
                          ),
                            ),
                            IconButton(
                              icon: Icon(Icons.format_color_text_outlined,size: 20),
                              onPressed: (){}, 
                              style: IconButton.styleFrom(
                                
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.format_size_outlined,size: 20),
                              onPressed: (){}, 
                              style: IconButton.styleFrom(
                                
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.format_list_bulleted,size: 20),
                              onPressed: (){}, 
                              style: IconButton.styleFrom(
                                
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.format_align_left_outlined,size: 20),
                              onPressed: (){}, 
                              style: IconButton.styleFrom(
                                
                              ),
                              ),
                            IconButton(
                              icon: Icon(Icons.format_align_center_outlined,size: 20),
                              onPressed: (){}, 
                              style: IconButton.styleFrom(
                                
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.format_align_right_outlined,size: 20),
                              onPressed: (){}, 
                              style: IconButton.styleFrom(
                                
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.format_align_justify_outlined,size: 20),
                              onPressed: (){}, 
                              style: IconButton.styleFrom(

                              ),
                            ),
                          ],
                        ),
                      Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(onPressed: (){}, icon: Icon(Icons.link,size: 30,)),
                          IconButton(onPressed: (){}, icon: Icon(Icons.upload,size: 30,))
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                        height: 50,
                        width: 200,
                        child: FilledButton( 
                            style: FilledButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 45, 124, 155)
                            ),                     
                            onPressed: (){}, 
                            child:Text("สร้างประกาศ",style: TextStyle(fontSize: 20),))
                      ),
                      SizedBox(width: 50),
                      SizedBox(
                        height: 50,
                        width: 200,
                        child: FilledButton( 
                            style: FilledButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 192, 85, 103)
                            ),                     
                            onPressed: (){ Navigator.pop(context);}, 
                            child:Text("ยกเลิก",style: TextStyle(fontSize: 20),))
                      )
                        ],
                      )      
              ],
            )
                
                
        ),
      ],
    );
  }
}