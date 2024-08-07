// ignore_for_file: unused_label

import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_esclass_2/Data/Data_todolist.dart';
import 'package:flutter_esclass_2/Home/homeT.dart';
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
  State<add_todo> createState() => add_todoState();
}

class add_todoState extends State<add_todo> {

final formKey = GlobalKey<FormState>();
String Title = '';
String Detail = '';
var FirstDate = '';
var LastDate = '';


TextEditingController _date = TextEditingController();
TextEditingController _date2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text("เพิ่มกิจกรรมของคุณ")),
      content: const Text("เพิ่มกิจกรรมของคุณ"),
      actions: [
        Form(
          key: formKey,
          child: Column(
          children: [ 
            Container(
              height: 300,
              width: 500,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
              ),
                child: Column(
                  children: [
                    Container(  
                      margin: EdgeInsets.fromLTRB(10, 10, 0, 10),
                      child: 
                        TextFormField(
                          decoration: InputDecoration(
                            label: Text("หัวข้อ", style: TextStyle(fontSize: 20),)),
                            onSaved: (value){
                                Title=value!;
                            },
                        ),
                    ),
                    SizedBox(height: 10),
                    Container(
                        height: 100,
                        width: 500,
                        margin: EdgeInsets.fromLTRB(10, 10, 0, 10),
                        child:                  
                          TextFormField(                         
                                    decoration: InputDecoration(
                                      label: Text("รายละเอียด", style: TextStyle(fontSize: 20),)),
                                    onSaved: (value){
                                    Detail=value!;}   
                          )
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        SizedBox(
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
                                  onSaved: (value){
                                  FirstDate=value!;
                                };
                                
                              },
                            ),
                        ),
                        SizedBox(
                          height: 50,
                          width: 200,
                            child: TextFormField(
                              controller: _date2,
                              decoration: InputDecoration(
                                icon: Icon(Icons.calendar_month),
                                label: Text("ถึงวันที่",style: TextStyle(fontSize: 20),),
                              ),
                              onTap: ()async {
                                DateTime? pickeddate = await showDatePicker(
                                  context: context, 
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2023), 
                                  lastDate: DateTime(2100));

                                  if  (pickeddate != null){
                                        setState(() {
                                          _date2.text = DateFormat('yyyy-MM-dd').format(pickeddate);
                                        });
                                      }
                                  onSaved: (value){
                                  LastDate=value!;
                                  };
                                
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
                          onPressed: () {
                            formKey.currentState!.save();
                            data.add(
                              Todoclass(
                                Title: Title, 
                                Detail: Detail, 
                                FirstDate: FirstDate, 
                                LastDate: LastDate)
                            );
                            formKey.currentState!.reset();
                            print(data.length);
                            Navigator.pushReplacement(context,MaterialPageRoute(
                              builder: (ctx)=>const main_home_T())
                          );
                          },
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
        )
        ),                  
      ],
    );
  }
}