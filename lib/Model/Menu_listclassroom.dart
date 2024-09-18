import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Classroom/setting_calss.dart';
import 'package:flutter_esclass_2/Data/data_calssroom.dart';

class List_student extends StatefulWidget {
  const List_student({super.key});

  @override
  State<List_student> createState() => _List_studentState();
}

class _List_studentState extends State<List_student> {
  @override
  Widget build(BuildContext context) {
    return Container(
              width: 300,
              height: 900,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20)
                ),
              ),
              child: 
                ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context,index){
                    return Container(
                      padding: EdgeInsets.fromLTRB(0,5,5,5),
                      child: 
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 50,
                              width: 300,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 195, 238, 250),
                                borderRadius: BorderRadius.circular(20)
                              
                              ),
                              child: FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: Color.fromARGB(255, 195, 238, 250),
                                  foregroundColor: Colors.black
                                  
                                ),
                                onPressed: (){}, 
                                
                                child: Column(
                                  children: [
                                    Text("${data[index].Name_class} ม.${data[index].Room_year} ห้อง ${data[index].Room_No}",style: TextStyle(fontSize: 16),),
                                    Text(" ${data[index].Section_class}", style: TextStyle(fontSize: 14,color: const Color.fromARGB(255, 77, 77, 77)),)
                                  ],
                                )

                                
                              )
                            )
                          ],
                        )
                      
                      
                      
                      
                    );
                  },
                
            ),

    );
  }
}