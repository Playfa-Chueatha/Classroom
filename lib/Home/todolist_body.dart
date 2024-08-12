import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Data/Data_todolist.dart';

class Todolistclass extends StatelessWidget {
  const Todolistclass({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: todocalss(),
    );
  }
}
class todocalss extends StatefulWidget {
  const todocalss({super.key});

  @override
  State<todocalss> createState() => _todocalssState();
}

class _todocalssState extends State<todocalss> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color.fromARGB(255, 170, 205, 238),
      body: Container(
        height: 400,
        width: 600,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 170, 205, 238),
          borderRadius: BorderRadius.circular(20)
        ),
        child: Column(
        children: const [
          SizedBox(height: 10),
          Text('To do list to day',style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),),

          SingleChildScrollView(
            scrollDirection: Axis.vertical,

          child: 
            SizedBox(
              height: 350,
              width: 1350,
              child: DataTodolist()
            ),
          )
        ]
      )
      ),
    );
  }
}