import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Classroom/calssT_body.dart';
import 'package:flutter_esclass_2/Classroom/classT.dart';
import 'package:flutter_esclass_2/Data/Data_comment.dart';

class Comment extends StatefulWidget {
  const Comment({super.key});

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {

  TextEditingController textdatacomment = TextEditingController();

  final formKey = GlobalKey<FormState>();
  String datacommenttext = '';
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        Form(   
          key: formKey,  
          child: Container(
            height: 700,
            width: 600,
            margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                Container(
                  height: 600,
                  width: 550,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 152, 186, 218),
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: DataComment()
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    SizedBox (
                        height: 40,
                        width: 600,
                        child: TextFormField(
                          controller: textdatacomment,
                            keyboardType: TextInputType.multiline,
                            maxLines: 50,
                            decoration: InputDecoration(
                              hintText: 'แสดงความคิดเห็นของคุณ',
                              contentPadding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                              suffixIcon: IconButton(
                                onPressed: (){
                                  datacommenttext.add(
                                    datacomment(datacommenttext: datacommenttext),
                                  );
                                  print('save');
                                  formKey.currentState!.reset();
                                  setState(() {
                                    
                                  });
                                  // Navigator.push(context,MaterialPageRoute(
                                  //   builder: (ctx)=>const ClassT()));
                                  
                                }, 
                                icon: Icon(Icons.send))
                            ),
                            onSaved: (value){
                              datacommenttext=value!;},             
                          ),
                      ),
                  ],
                ),
              Text(datacommenttext,style: TextStyle(fontSize: 20),)
            ]
        
            )
        )
        
        )

      ],
    );
  }
}

extension on String {
  void add(datacomment datacomment) {}
}