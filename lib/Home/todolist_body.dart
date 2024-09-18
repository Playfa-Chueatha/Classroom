import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Data/Data_todolist.dart';
import 'package:flutter_esclass_2/Home/Todolist_alert.dart';

class todocalss extends StatefulWidget {
  const todocalss({super.key});

  @override
  State<todocalss> createState() => _todocalssState();
}

class _todocalssState extends State<todocalss> {

  void _toggleTodoStatus(int index) {
    setState(() {
      data[index].toggleDone(); // เปลี่ยนสถานะของรายการ
      _sortTodos(); // เรียงลำดับรายการใหม่
      // ลบรายการที่ทำเสร็จออก
      data.removeWhere((todo) => todo.isDone);
    });
  }

  void _sortTodos() {
    data.sort((a, b) {
      // เอารายการที่ทำแล้วไปไว้ด้านล่าง
      if (a.isDone && !b.isDone) return 1;
      if (!a.isDone && b.isDone) return -1;
      return 0;
    });
  }
  
  void _addTodo(Todoclass todo) {
    setState(() {
      data.add(todo); // เพิ่มรายการใหม่ใน ListView
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 350,
        width: 1000,
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
                padding: EdgeInsets.fromLTRB(1150, 15, 0, 10),
                child: IconButton(
                    color: Color.fromARGB(255, 0, 0, 0),
                    icon: const Icon(Icons.add),
                    iconSize: 20,
                    onPressed: () {
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
            child: SizedBox(
              height: 400,
              width: 1350,
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    padding: EdgeInsets.fromLTRB(0, 5, 5, 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: 1350,
                            child: ListTile(
                              onTap: () {},
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              tileColor: Colors.white,
                              hoverColor: Colors.blue,
                              leading: Checkbox(
                                  value: data[index].isDone,
                                  onChanged: (bool? value) {
                                    _toggleTodoStatus(index);
                                  }),
                              title: Tooltip(
                                message: data[index].Detail,
                                child: Container(
                                  alignment: AlignmentDirectional.centerStart,
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(data[index].Title,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color:
                                            data[index].isDone ? Colors.grey : Colors.black,
                                        decoration: data[index].isDone
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                      )),
                                ),
                              ),
                              trailing: Container(
                                height: 35,
                                width: 35,
                                decoration:
                                    BoxDecoration(borderRadius: BorderRadius.circular(5)),
                                child: IconButton(
                                    color: Colors.red,
                                    iconSize: 20,
                                    onPressed: () {
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
              ),
            ),
          )
        ]
      ),
    );
  }
}
