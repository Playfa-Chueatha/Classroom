import 'package:flutter/material.dart';


class DataCalssroom extends StatefulWidget {
  const DataCalssroom({super.key});

  @override
  State<DataCalssroom> createState() => _DataCalssroomState();
}

class _DataCalssroomState extends State<DataCalssroom> {


  @override
  Widget build(BuildContext context) {
    return  Container(
              width: 350,
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
                              height: 40,
                              width: 300,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 195, 238, 250),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20)
                                )
                              
                              ),
                              child: FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: Color.fromARGB(255, 195, 238, 250),
                                  foregroundColor: Colors.black
                                  
                                ),
                                onPressed: (){}, 
                                
                                child: Text("${data[index].Name_class} ม.${data[index].Room_year} ห้อง ${data[index].Room_No}",style: TextStyle(fontSize: 16),)
                                
                              )
                            ),
                            // Text("${data[index].Name_class} ม.${data[index].Room_year} ห้อง ${data[index].Room_No}",style: TextStyle(fontSize: 20),), 
                            // Text("แผนการเรียน ${data[index].Section_class} ",style: TextStyle(fontSize: 14),),
                            // Text("ปีการศึกษา ${data[index].School_year} ", style: TextStyle(fontSize: 14),),
                            // Text(data[index].Detail,style: TextStyle(fontSize: 14),),
                          ],
                        )
                      
                      
                      
                      
                    );
                  },
                
            ),

            
    );
  }
}


//Model

class ClassroomData{
  ClassroomData({
    required this.Name_class,
    required this.Section_class,
    required this.Room_year,
    required this.Room_No,
    required this.School_year,
    required this.Detail
  });
  String Name_class;    //ชื่อห้องเรียน
  String Section_class;  //แผนการเรียน
  int Room_year;        //ชั้นปี
  int Room_No;          //ห้อง
  int School_year;      //ปีการศึกษา
  String Detail;        //รายละเอียด
}

List<ClassroomData> data = [
  ClassroomData(
    Name_class: "คณิตศาสตร์", 
    Section_class: "วิทยาศาสตร์-คณิตศาสตร์", 
    Room_year: 4, 
    Room_No: 9, 
    School_year: 2567, 
    Detail: " ")
];




