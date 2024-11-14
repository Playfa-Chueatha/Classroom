import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Data/Data_todolist.dart';
import 'package:flutter_esclass_2/Home/Todolist_alert.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;



class Todocalss_S extends StatefulWidget {
  final String username;

  const Todocalss_S({super.key, required this.username});

  @override
  State<Todocalss_S> createState() => _TodocalssState();
}

class _TodocalssState extends State<Todocalss_S> {
  List<TodoClass> datatodolist_t = []; // รายการ To-Do

  @override
  void initState() {
    super.initState();
    fetchTodosFromDatabase(); // เรียกข้อมูล To-Do เมื่อเริ่มต้น
  }

  // ฟังก์ชันสำหรับเพิ่ม To-Do ลงในฐานข้อมูล
  Future<void> addTodoToDatabase(String title, String details, String username) async {
    const url = 'https://www.edueliteroom.com/connect/todolist_students.php';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'action': 'add',
          'todolist_users_title': title,
          'todolist_users_details': details,
          'users_username': username,
          'todolist_users_status': 'Not Started',
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('เพิ่ม To-Do สำเร็จ!'),
            backgroundColor: Colors.green,
          ),
        );
        fetchTodosFromDatabase(); 
      } else {
        final responseData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('เพิ่มกิจกรรมไม่สำเร็จ: ${responseData['error'] ?? 'Unknown error'}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('เกิดข้อผิดพลาด: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> fetchTodosFromDatabase() async {
    const url = 'https://www.edueliteroom.com/connect/todolist_students.php';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'action': 'fetch',
          'users_username': widget.username,
        }),
      );
      
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data is List) {
          setState(() {
            datatodolist_t = data.map((item) => TodoClass(
              title: item['todolist_users_title'],
              detail: item['todolist_users_details'],
              status: item['todolist_users_status'] ?? 'Not Started',
              autoId: int.tryParse(item['todolist_users_auto'].toString()) ?? 0, // ดึง ID
            )).toList();
          });
        } else {
          print('Expected a list but got a map: $data');
        }
      } else {
        print('Failed to fetch todos: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _updateTodoStatus(int index, String newStatus) async {
  const url = 'https://www.edueliteroom.com/connect/todolist_students.php'; // URL สำหรับอัพเดตสถานะ

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'action': 'update',
          'todolist_users_auto': datatodolist_t[index].autoId, // ส่ง ID ของ To-Do
          'todolist_users_status': newStatus,
        }),
      );

      if (response.statusCode == 200) {
        print('อัพเดตสถานะเป็น $newStatus สำเร็จ!'); // ใช้ print แทน ScaffoldMessenger
        setState(() {
          datatodolist_t[index] = TodoClass(
            title: datatodolist_t[index].title,
            detail: datatodolist_t[index].detail,
            status: newStatus,
            autoId: datatodolist_t[index].autoId,
          ); // อัพเดตสถานะใน UI
        });
      } else {
        final responseData = json.decode(response.body);
        print('ไม่สามารถอัพเดตสถานะได้: ${responseData['error'] ?? 'Unknown error'}'); // ใช้ print แทน ScaffoldMessenger
      }
    } catch (error) {
      print('เกิดข้อผิดพลาด: $error'); // ใช้ print แทน ScaffoldMessenger
      print('Error: $error');
    }
  }



  void _addTodo(TodoClass todo) {
    setState(() {
      datatodolist_t.add(todo);
      addTodoToDatabase(todo.title, todo.detail, widget.username);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      width: 1000,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 170, 205, 238),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'สิ่งที่ต้องทำ',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(1150, 15, 0, 10),
                child: IconButton(
                  color: Color.fromARGB(255, 0, 0, 0),
                  icon: const Icon(Icons.add),
                  iconSize: 20,
                  onPressed: () {
                    // เปิด Dialog สำหรับเพิ่ม To-Do
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
                  tooltip: 'เพิ่ม todolist',
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
                itemCount: datatodolist_t.where((todo) => todo.status != 'Inactive').toList().length,
                itemBuilder: (context, index) {
                  final filteredTodos = datatodolist_t.where((todo) => todo.status != 'Inactive').toList();
                  return Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    padding: EdgeInsets.fromLTRB(0, 5, 5, 5),
                    child: SizedBox(
                      width: 1350,
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        tileColor: Colors.white,
                        leading: Checkbox(
                          value: filteredTodos[index].status == 'Completed',
                          onChanged: (bool? value) {
                            if (value != null) {
                              if (value) {
                                _updateTodoStatus(datatodolist_t.indexOf(filteredTodos[index]), 'Completed'); // เปลี่ยนสถานะในฐานข้อมูล
                              } else {
                                _updateTodoStatus(datatodolist_t.indexOf(filteredTodos[index]), 'Not Started'); // เปลี่ยนสถานะกลับ
                              }
                            }
                          },
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, // จัดเรียงข้อความไปทางซ้าย
                          children: [
                            Text(
                              filteredTodos[index].title,
                              style: TextStyle(
                                fontSize: 16,
                                color: filteredTodos[index].status == 'Completed' ? Colors.grey : Colors.black,
                                decoration: filteredTodos[index].status == 'Completed' ? TextDecoration.lineThrough : TextDecoration.none,
                              ),
                            ),
                            SizedBox(height: 4), // เว้นระยะระหว่าง title และ detail
                            Text(
                              filteredTodos[index].detail, // แสดง detail
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54, // เปลี่ยนสีให้เหมาะสม
                              ),
                            ),
                          ],
                        ),
                        trailing: Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                          child: IconButton(
                            color: Colors.red,
                            iconSize: 20,
                            onPressed: () {
                              _updateTodoStatus(datatodolist_t.indexOf(filteredTodos[index]), 'Inactive');
                              setState(() {
                                 datatodolist_t.remove(filteredTodos[index]);
                              });
                            },
                            icon: Icon(Icons.cancel_outlined),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
