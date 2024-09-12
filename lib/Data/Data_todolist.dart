import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Home/todolist_body.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';




//datadotolist show'สิ่งที่ต้องทำวันนี้'

class DataTodolist extends StatefulWidget {
  const DataTodolist({super.key});

  @override
  State<DataTodolist> createState() => _DatatodoState();
}

class _DatatodoState extends State<DataTodolist> {
  void _toggleTodoStatus(int index) {
    setState(() {
      data[index].toggleDone(); // เปลี่ยนสถานะของรายการ
      _sortTodos(); // เรียงลำดับรายการใหม่
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

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
                  width: 600,
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
    );
  }
}

//Model
class Todoclass {
  Todoclass({required this.Title, required this.Detail, this.isDone = false});
  String Title;
  String Detail;
  bool isDone;

  void toggleDone() {
    isDone = !isDone;
  }
}

List<Todoclass> data = [
  Todoclass(
    Title: "ทำโปรเจค",
    Detail: "ทำหน้าสร้างห้อง",
  ),
];
