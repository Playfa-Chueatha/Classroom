import 'package:flutter/material.dart';
import 'package:http/http.dart';



//รายชื่อนักเรียนที่อยู่ในห้อง
class Listsudent{
  Listsudent({
    required this.fristname,
    required this.lastname,
    required this.nostudent,
    required this.noroom,
    required this.name,
    required this.email
  });
  String fristname;
  String lastname;
  int nostudent;
  int noroom;
  String name;
  String email;
}

List<Listsudent> datastudent = [
  Listsudent(
    fristname: 'ปลายฟ้า', 
    lastname: 'เชื้อถา', 
    nostudent: 39840, 
    noroom: 16,
    name: 'มายด์',
    email: 'paiyfa.11@gmail.com'

  )
];

class ModelRoom extends StatefulWidget {
  const ModelRoom({super.key});

  @override
  State<ModelRoom> createState() => _ModelRoomState();
}

class _ModelRoomState extends State<ModelRoom> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      height: 350,
      width: 1300,
      decoration: BoxDecoration(
        color: Colors.white
      ),
      child: ListView.builder(
        itemCount: datastudent.length,
        itemBuilder: (context,index){
          return Container(
            margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
            padding: EdgeInsets.fromLTRB(0,5,5,5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("เลขที่",style: TextStyle(fontSize: 24),),
                    Text("รหัสนักเรียน",style: TextStyle(fontSize: 24),),
                    Text("ชื่อ",style: TextStyle(fontSize: 24),),
                    Text("นามสกุล",style: TextStyle(fontSize: 24),),
                    Text("ชื่อเล่น",style: TextStyle(fontSize: 24),),
                    Text("อีเมล์",style: TextStyle(fontSize: 24),),
                    
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(" ${datastudent[index].noroom}",style: TextStyle(fontSize: 20)),
                    Text(" ${datastudent[index].nostudent}",style: TextStyle(fontSize: 20)),
                    Text(" ${datastudent[index].fristname}",style: TextStyle(fontSize: 20)),
                    Text(" ${datastudent[index].lastname}",style: TextStyle(fontSize: 20)),
                    Text(" ${datastudent[index].name}",style: TextStyle(fontSize: 20)),
                    Text(" ${datastudent[index].email}",style: TextStyle(fontSize: 20)),
                    
                  ],
                )
                
                
              ],
            ),
          );
        }),
        
    );
  }
}



