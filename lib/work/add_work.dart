import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_esclass_2/work/ListviweSearch.dart';
import 'package:flutter_esclass_2/work/add_worktype.dart';


class add_wprk_T extends StatefulWidget {
  const add_wprk_T({super.key});

  @override
  State<add_wprk_T> createState() => _add_workState();
}

class _add_workState extends State<add_wprk_T> {

  final TextEditingController _dateController = TextEditingController();
  bool _isChecked = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // วันที่เริ่มต้นที่จะแสดง
      firstDate: DateTime(2000), // วันที่เริ่มต้นที่สามารถเลือกได้
      lastDate: DateTime(2101), // วันที่สิ้นสุดที่สามารถเลือกได้
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.toLocal()}".split(' ')[0]; // แสดงวันที่ในฟอร์แมตที่ต้องการ
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    // ใช้ MediaQuery เพื่อดึงขนาดของหน้าจอ
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("มอบหมายงาน"),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 195, 238, 250),
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            height: screenHeight * 0.9, 
            width: screenWidth * 0.9,  
            margin: EdgeInsets.fromLTRB(10,10,10,0),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 195, 238, 250),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2, 
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Container(
                          height: screenHeight * 0.3,
                          width: screenWidth * 0.5,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: screenHeight * 0.2,
                                width: screenWidth * 0.5,
                                padding: EdgeInsets.fromLTRB(10,10,10,0),
                                child: TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 50,
                                  decoration: InputDecoration(
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(color: Color.fromARGB(255, 2, 138, 175), width: 0.0),
                                    ),
                                    hintText: 'เขียนอะไรหน่อย',
                                  ),
                                ),
                              ),
                              Container(
                                height: 40,
                                width: screenWidth * 0.45,
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 142, 217, 238),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.format_bold_outlined, size: 20),
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.format_italic, size: 20),
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.format_underline, size: 20),
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.format_color_text_outlined, size: 20),
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.format_size_outlined, size: 20),
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.format_list_bulleted, size: 20),
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.format_align_left_outlined, size: 20),
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.format_align_center_outlined, size: 20),
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.format_align_right_outlined, size: 20),
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.format_align_justify_outlined, size: 20),
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )                          
                        )
                      ),
                      Type_work(),//ประเภทงาน add_worktype.dart
                    ],
                  ),
                ),




                // คะแนน
                  Container(
                    padding: EdgeInsets.all(20),
                    height: screenHeight * 0.9,
                    width: screenWidth *0.3, // ปรับตามขนาดหน้าจอ
                    margin: EdgeInsets.fromLTRB(30, 30, 50, 30),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child:
                      Column(
                      children: [

                        //คะแนนเต็ม
                              Row(
                                children: [
                                  Container(
                                    alignment: Alignment.centerRight,
                                    height: 50,
                                    width: 150,
                                    child: Text("คะแนนเต็ม :  ", style: TextStyle(fontSize: 20)),
                                  ),
                                  Container(
                                    height: 50,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 255, 255, 255)
                                    ),                 
                                    child: (
                                      Padding(padding: EdgeInsets.all(5),
                                      child:  TextFormField(
                                          maxLength: 3,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                      ),
                                    )
                                      ),             
                                  ),
                                  
                                ],
                              ), 

                              //กำหนดส่ง
                              Row(
                                children: [
                                  Container(
                                    alignment: Alignment.centerRight,
                                    height: 50,
                                    width: 150,
                                    child: Text("กำหนดส่ง :  ", style: TextStyle(fontSize: 20)),
                                  ),
                                  Container(
                                    height: 50,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 255, 255, 255)
                                    ),                 
                                    child: (
                                      Padding(padding: EdgeInsets.all(5),
                                      child:  TextFormField(
                                          controller: _dateController,
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            icon: Icon(Icons.calendar_today),
                                            hintText: "Enter Date",
                                          ),
                                    onTap: () => _selectDate(context),
                                      ),
                                      )
                                    ),             
                                  ),
                                  
                                ],
                              ),


                              //ปิดรับงานเมื่อครบกำหนด
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Checkbox(
                                      value: _isChecked,
                                      onChanged: (bool? newValue) {
                                        setState(() {
                                          _isChecked = newValue ?? false;
                                        });
                                      },
                                    ),
                                    Text('ปิดรับงานเมื่อครบกำหนด',style: TextStyle(fontSize: 18),),
                                  ],
                                ),

                              //เลือกห้องเรียน
                              Container(
                                height: screenHeight *0.5,
                                width: screenWidth *0.3,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 191, 240, 233),
                                  borderRadius: BorderRadius.circular(20)                
                                ),
                                child: Classroom_addwork(),//ListviweSearch.dart
                              ),



                            ]
                          )
                        ),)
              ],
            ),
          
        
          )))
    );
  }
}
