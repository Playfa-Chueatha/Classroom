import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Alert_addtodo extends StatelessWidget {
  const Alert_addtodo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: add_todo(),
    );
  }
}
class add_todo extends StatefulWidget {

  const add_todo({super.key});

  @override
  State<add_todo> createState() => _add_todoState();
}

class _add_todoState extends State<add_todo> {







TextEditingController _date = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text("เพิ่มกิจกรรมของคุณ")),
      content: const Text("เพิ่มกิจกรรมของคุณ"),
      actions: [
        Column(
          children: [ 
            Container(
              height: 500,
              width: 500,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
              ),
                child: Column(
                  children: [
                    Container(  
                      margin: EdgeInsets.fromLTRB(10, 10, 100, 10),
                      child: 
                        TextFormField(
                          decoration: InputDecoration(
                            label: Text("หัวข้อ", style: TextStyle(fontSize: 20),)),
                        ),
                    ),
                    SizedBox(height: 10),
                    Container(
                        height: 100,
                        width: 500,
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child:                  
                          TextField(
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
                            )                   
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          height: 50,
                          width: 200,
                            child: TextFormField(
                              controller: _date,
                              decoration: InputDecoration(
                                icon: Icon(Icons.calendar_month),
                                label: Text("วันที่",style: TextStyle(fontSize: 20),),
                              ),
                              onTap: ()async {
                                DateTime? pickeddate = await showDatePicker(
                                  context: context, 
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2023), 
                                  lastDate: DateTime(2100));

                                  if  (pickeddate != null){
                                        setState(() {
                                          _date.text = DateFormat('yyyy-MM-dd').format(pickeddate);
                                        });
                                      }
                                
                              },
                            ),
                        ),
                        Container(
                          height: 50,
                          width: 200,
                            child: TextFormField(
                              controller: _date,
                              decoration: InputDecoration(
                                icon: Icon(Icons.calendar_month),
                                label: Text("วันที่",style: TextStyle(fontSize: 20),),
                              ),
                              onTap: ()async {
                                DateTime? pickeddate = await showDatePicker(
                                  context: context, 
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2023), 
                                  lastDate: DateTime(2100));

                                  if  (pickeddate != null){
                                        setState(() {
                                          _date.text = DateFormat('yyyy-MM-dd').format(pickeddate);
                                        });
                                      }
                                
                              },
                            ),
                        ),                    
                      ],
                    ),
                             
                    SizedBox(height: 10),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                      TextButton(
                          onPressed: () => Navigator.pop(context, 'OK'),
                          child: const Text('OK'),
                          style: TextButton.styleFrom(
                            foregroundColor: Color.fromARGB(255, 63, 124, 238)
                          ),
                      ),
                      TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Cancel'),
                          style: TextButton.styleFrom(
                            foregroundColor: Color.fromARGB(255, 238, 108, 115)
                          ),
                      ),  
                        ],
                    )
                       
                  ],
                )         
            ),
          ]
        ),                  
      ],
    );
  }
}