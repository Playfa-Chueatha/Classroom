import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Classroom/add_classroom.dart';

void main() => runApp(const SettingCalss());


class SettingCalss extends StatelessWidget {
  const SettingCalss({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: Setting_Calss(),
    );
  }
}

class Setting_Calss extends StatefulWidget {
  const Setting_Calss({super.key});

  @override
  State<Setting_Calss> createState() => _Setting_CalssState();
}

class _Setting_CalssState extends State<Setting_Calss> {


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 195, 238, 250),
      body: SingleChildScrollView(
        scrollDirection:Axis.vertical,
        child: Column(
          children: [
            SizedBox(height: 10,),
            Column(
              children: [
                SizedBox(height: 30),
                SingleChildScrollView(
                  scrollDirection:Axis.horizontal,
                  child: Row(
                    children: [


                      //menu
                      Container(
                      height: 1000,
                      width: 400,
                      alignment: Alignment.topCenter,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 147, 185, 221),
                        borderRadius: BorderRadius.only(
                          topRight:Radius.circular(20),
                          bottomRight: Radius.circular(20)
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(width: 350),
                              IconButton(
                                onPressed: (){
                                  showDialog(
                                    context: context, 
                                    builder: (BuildContext context) => AddClassroom(),);
                                  
                                }, 
                                icon: Icon(Icons.settings))
                            ],
                          ),
                        ],
                      ),
                      ),
                      SizedBox(width: 50,),


                      //ปฏิทิน
                      Container(
                      height: 1000,
                      width: 1440,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)
                        ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                        )
                      ),
                      SizedBox(width: 30)
                    ],
                  ),
                )
              ],
            )
          ]
        )
      ),
    );
  }
}

