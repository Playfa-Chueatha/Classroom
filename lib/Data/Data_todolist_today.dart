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

  void _toggleTodoStatus(int index) {
    setState(() {
      data[index].toggleDone();
    });
  }
  
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
                      hoverColor: Colors.blue,
                      leading: Checkbox(
                        value: data[index].isDone, 
                        onChanged: (bool? value){
                          _toggleTodoStatus(index);
                        }
                      ),
                      title: 
                        Tooltip(
                        message: data[index].Detail,
                        child: Container(
                          alignment: AlignmentDirectional.centerStart,
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(data[index].Title,style: 
                            TextStyle(
                              fontSize: 16,
                              color: data[index].isDone ? Colors.grey : Colors.black,
                              decoration: data[index].isDone
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                              
                            )),
                        ),
                        ),
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
                            setState(() {
                              data.removeAt(index);
                            });
                          }, 
                          icon: Icon(Icons.cancel_outlined)),
                      ),
                      

                    

                  ))
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
         String displayText = data[index].LastDate.isNotEmpty
            ? " to ${data[index].LastDate}"
            : " ";
        return Container(
          alignment: AlignmentDirectional.centerStart,
          height: 60,
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
                      // Text(" to ${data[index].LastDate}",style: TextStyle(fontSize: 12),),
                      Text(
                        displayText,
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),              
              // Text(" ${data[index].Detail}",style: TextStyle(fontSize: 12,color: const Color.fromARGB(255, 119, 118, 118)),),
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
    required this.LastDate,
    this.isDone = false
  });
  String Title;
  String Detail;
  String FirstDate;
  String LastDate;
  bool isDone;

  void toggleDone(){
    isDone = !isDone;
  }
}

List<Todoclass> data = [
  Todoclass(
    Title: "ทำโปรเจค",
    Detail: "ทำหน้าสร้างห้อง", 
    FirstDate: "20/08/2024", 
    LastDate: "21/08/2024"
    ),
];