import 'package:flutter/material.dart';

class AddClassroom extends StatelessWidget {
  const AddClassroom({super.key});

  @override
  Widget build(BuildContext context) {
    return Add_room();
  }
}
class Add_room extends StatefulWidget {
  const Add_room({super.key});

  @override
  State<Add_room> createState() => _Add_roomState();
}

class _Add_roomState extends State<Add_room> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text("สร้างห้องเรียนของคุณ")),
      actions: [
        Container(
          height: 450,
          width: 500,
          child: 
              Column(
                children: [
                    Container( 
                      height: 50,
                      width: 300, 
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: 
                          TextFormField(
                            decoration: InputDecoration(
                                label: Text("วิชา", style: TextStyle(fontSize: 20),)),
                          ),
                    ),
                    Container(  
                      height: 50,
                      width: 300, 
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: 
                          TextFormField(
                            decoration: InputDecoration(
                                label: Text("ชั้นปี", style: TextStyle(fontSize: 20),)),
                          ),
                    ),
                    Container(  
                      height: 50,
                      width: 300, 
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: 
                          TextFormField(
                            decoration: InputDecoration(
                                label: Text("ห้อง", style: TextStyle(fontSize: 20),)),
                          ),
                    ),
                    Container(
                      height: 50,
                      width: 300, 
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: 
                          TextFormField(
                            decoration: InputDecoration(
                                label: Text("ปีการศึกษา", style: TextStyle(fontSize: 20),)),
                          ),
                    ),
                    Container(
                      height: 50,
                      width: 300, 
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: 
                          TextFormField(
                            decoration: InputDecoration(
                              label: Text("รายละเอียดเพิ่มเติม", style: TextStyle(fontSize: 20),)),
                          ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      height: 50,
                      width: 200,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 45, 124, 155)
                        ),
                        onPressed: (){




                      }, 
                      child: Text("สร้างห้องเรียน",style: TextStyle(fontSize: 20),)),
                    )

                ]
              ) 
        )
      ],
    );
  }
}