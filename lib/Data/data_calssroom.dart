import 'package:flutter/material.dart';

class DataCalssroom extends StatelessWidget {
  const DataCalssroom({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Data_class(),
    );
  }
}

class Data_class extends StatefulWidget {
  const Data_class({super.key});

  @override
  State<Data_class> createState() => _Data_classState();
}

class _Data_classState extends State<Data_class> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
            backgroundColor: Color.fromARGB(255, 147, 185, 221),
            body: Container(
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
                      margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                      padding: EdgeInsets.fromLTRB(0,5,5,5),
                      child: 
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 30,
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




