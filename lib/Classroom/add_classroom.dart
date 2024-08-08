import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Classroom/setting_calss.dart';
import 'package:flutter_esclass_2/Data/data_calssroom.dart';

class AddClassroom extends StatelessWidget {
  const AddClassroom({super.key});

  @override
  Widget build(BuildContext context) {
    return Addroom();
  }
}
class Addroom extends StatefulWidget {
  const Addroom({super.key});

  @override
  State<Addroom> createState() => _AddroomState();
}

class _AddroomState extends State<Addroom> {

  final formKey = GlobalKey<FormState>();
  String Name_class = '';
  String Section_class = '';
  int Room_year = 100;        //ชั้นปี
  int Room_No = 15;          //ห้อง
  int School_year = 2590;     //ปีการศึกษา
  String Detail = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text("สร้างห้องเรียนของคุณ")),
      actions: [
        Form( key: formKey,
        child:
        SizedBox(
          height: 550,
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
                                onSaved: (value){
                                  Name_class=value!;
                                },
                          ),
                    ),
                    Container(  
                      height: 50,
                      width: 300, 
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: 
                          TextFormField(
                            decoration: InputDecoration(
                                label: Text("แผนการเรียน", style: TextStyle(fontSize: 20),)),
                                onSaved: (value){
                                  Section_class=value!;
                                },
                                
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
                                onSaved: (value){
                                  Room_year=int.parse(value.toString());
                                },
                                
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
                                onSaved: (value){
                                  Room_No=int.parse(value.toString());
                                },
                                
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
                                onSaved: (value){
                                  School_year=int.parse(value.toString());
                                },
                                
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
                              onSaved: (value){
                                  Detail=value!;
                                },
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
                          formKey.currentState!.save();
                          data.add(
                            ClassroomData(
                              Name_class: Name_class, 
                              Section_class: Section_class, 
                              Room_year: Room_year, 
                              Room_No: Room_No, 
                              School_year: School_year, 
                              Detail: Detail)
                          );
                          formKey.currentState!.reset();
                          Navigator.pushReplacement(context,MaterialPageRoute(
                              builder: (ctx)=>const Setting_Calss())
                          ); 


                      }, 
                      child: Text("สร้างห้องเรียน",style: TextStyle(fontSize: 20),)),
                    )

                ]
           )   ) 
        )
      ],
    );
  }
}