import 'package:flutter/material.dart';

class DataTodolist extends StatefulWidget {
  const DataTodolist({super.key});

  @override
  State<DataTodolist> createState() => _DatatodoState();
}

class _DatatodoState extends State<DataTodolist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 170, 205, 238),
      body: SizedBox(
        width: 600,
        height: 600,
        child: ListView.builder(
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
                      leading: Icon(Icons.check_box),
                      title: Text(data[index].Title,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        decoration: TextDecoration.lineThrough,
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
        ),
      ),
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
  var FirstDate;
  var LastDate;
}

List<Todoclass> data = [
  Todoclass(
    Title: "ทำโปรเจค",
    Detail: "ทำหน้าสร้างห้อง", 
    FirstDate: "08/08/2567", 
    LastDate:"08/08/2567")
  

];
