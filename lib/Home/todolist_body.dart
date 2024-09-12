import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Data/Data_todolist.dart';
import 'package:flutter_esclass_2/Home/Todolist_alert.dart';

class todocalss extends StatefulWidget {
  const todocalss({super.key});

  @override
  State<todocalss> createState() => _todocalssState();
}

class _todocalssState extends State<todocalss> {
  

  void _addTodo(Todoclass todo) {
    setState(() {
      data.add(todo); // เพิ่มรายการใหม่ใน ListView
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 350,
        width: 600,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 170, 205, 238),
          borderRadius: BorderRadius.circular(20)
        ),
        child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('สิ่งที่ต้องทำ',style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),),
              Padding(
                padding: EdgeInsets.fromLTRB(380, 15, 0, 10),
                child: IconButton(
                    color: Color.fromARGB(255, 0, 0, 0),
                    icon: const Icon(Icons.add),
                    iconSize: 20,
                    onPressed: (){
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => Alert_addtodo(
                          onAddTodo: _addTodo,
                        ),
                      );
                    },
                    style: IconButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 147, 185, 221),
                      highlightColor: Color.fromARGB(255, 56, 105, 151),
                    ),
                    tooltip: 'เพิ่มกิจกรรม', 
                ),
              ),
            ],
          ),      

          SingleChildScrollView(
            scrollDirection: Axis.vertical,
          child: 
            SizedBox(
              height: 400,
              width: 590,
              child: DataTodolist()// Data_todolist_today.dart
            ),
          )
        ]
      ),
    );
  }
}

