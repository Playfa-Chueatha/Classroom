import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';




//datadotolist show'สิ่งที่ต้องทำวันนี้'

class DataTodolist extends StatefulWidget {
  const DataTodolist({super.key});

  @override
  State<DataTodolist> createState() => _DatatodoState();
}

class _DatatodoState extends State<DataTodolist> {

  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
          itemCount: data.length,
          itemBuilder: (context,index){
            return Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
              padding: EdgeInsets.fromLTRB(0,5,5,5),
              child: 
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(  
                    width: 600,                 
                    child:  ListTile(
                      onTap: (){},
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      tileColor: Colors.white,
                      leading: Icon(Icons.check_box_outline_blank),
                      title: Text(data[index].Title,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      
                      ),),
                      trailing: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5) 
                        ),
                        child: IconButton(
                          color: Colors.red,
                          iconSize: 20,
                          onPressed: (){
                            
                          }, 
                          icon: Icon(Icons.cancel_outlined)),
                      ),
                    )

                  )
                ],
              ),
            );
          },
      
    );
  }
}




//datatodolist show 'สิ่งที่ต้องทำทั้งหมด' menu
class datatodolistmenu extends StatefulWidget {
  const datatodolistmenu({super.key});

  @override
  State<datatodolistmenu> createState() => _datatodolistmenuState();
}

class _datatodolistmenuState extends State<datatodolistmenu> {


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context,index){
        return Container(
          height: 70,
          width: 300,
          margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
          padding: EdgeInsets.fromLTRB(20,5,5,5),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 195, 238, 250),
            borderRadius: BorderRadius.circular(20)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(" ${data[index].Title} ",style: TextStyle(fontSize: 16),),
              Row(
                children: [
                  Text(" ${data[index].FirstDate}",style: TextStyle(fontSize: 12),),
                  Text(" to ${data[index].LastDate}",style: TextStyle(fontSize: 12),),
                ],
              ),  
              Text(" ${data[index].Detail}",style: TextStyle(fontSize: 12,color: const Color.fromARGB(255, 119, 118, 118)),)
              

            ],
          ) 
        );
      },
    );
  }
}







//Model
class Todoclass {
  Todoclass({
    required this.Title,
    required this.Detail,
    required this.FirstDate,
    required this.LastDate
  });
  String Title;
  String Detail;
  DateTime FirstDate;
  DateTime LastDate;
}

List<Todoclass> data = [
  Todoclass(
    Title: "ทำโปรเจค",
    Detail: "ทำหน้าสร้างห้อง", 
    FirstDate: DateTime(2024, 8, 20), 
    LastDate: DateTime(2024, 8, 21)
    ),
    
  

];