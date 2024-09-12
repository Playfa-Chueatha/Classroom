import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_esclass_2/work/ListviweSearch.dart';

class Alertwork extends StatefulWidget {
  const Alertwork({super.key});

  @override
  State<Alertwork> createState() => _AlertworkState();
}

class _AlertworkState extends State<Alertwork> {

  final TextEditingController _questionController = TextEditingController();

  bool _isChecked = false; 

  final TextEditingController _dateController = TextEditingController();
  

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // วันที่เริ่มต้นที่จะแสดง
      firstDate: DateTime(2000), // วันที่เริ่มต้นที่สามารถเลือกได้
      lastDate: DateTime(2101), // วันที่สิ้นสุดที่สามารถเลือกได้
    );

    List<String> questions = [];
    void addQuestion() {
    if (_questionController.text.isNotEmpty) {
      setState(() {
        questions.add(_questionController.text);
        _questionController.clear();
      });
    }
  }

    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.toLocal()}".split(' ')[0]; // แสดงวันที่ในฟอร์แมตที่ต้องการ
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return AlertDialog(
      title: Text('มอบหมายงาน'),
      actions: [

                Column(
                  children: [
// --------------------------------------------คะแนน--------------------------------------------------
                  Container( 
                    padding: EdgeInsets.all(20),
                    height: screenHeight * 0.6,
                    width: screenWidth *0.3, // ปรับตามขนาดหน้าจอ
                    margin: EdgeInsets.fromLTRB(30, 10, 50, 30),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 142, 217, 238),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child:
                      Column(
                      children: [

                        //-----------คะแนนเต็ม---------------------------------------------------------------  
                              Row(
                                children: [
                                  Container(
                                    alignment: Alignment.centerRight,
                                    height: 50,
                                    width: 150,
                                    child: Text("คะแนนเต็ม :  ", style: TextStyle(fontSize: 20)),
                                  ),
                                  SizedBox(
                                    height: 50,
                                    width: 150,                 
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

                              //------------------------กำหนดส่ง--------------------------------
                              Row(
                                children: [
                                  Container(
                                    alignment: Alignment.centerRight,
                                    height: 50,
                                    width: 150,
                                    child: Text("กำหนดส่ง :  ", style: TextStyle(fontSize: 20)),
                                  ),
                                  SizedBox(
                                    height: 50,
                                    width: 150,                
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


                              //--------------------------ปิดรับงานเมื่อครบกำหนด-------------------------------------------
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

                              //---------------เลือกห้องเรียน
                              Container(
                                height: screenHeight *0.3,
                                width: screenWidth *0.4,
                                margin: EdgeInsets.only(top: 20),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 191, 240, 233),
                                  borderRadius: BorderRadius.circular(20)                
                                ),
                                child: Classroom_addwork(),//ListviweSearch.dart
                              ),
                            ]
                        )  )
                              
                    ),

                    //-----------------ปุ่มมอบหมายงาน----------------------------------------------------------------------------
              TextButton.icon(
                  onPressed: (){
                                  
                  }, 
                  label: Text('มอบหมายงาน',style: TextStyle(color: const Color.fromARGB(255, 19, 80, 95)),),
                  icon: Icon(Icons.assessment,color: const Color.fromARGB(255, 74, 184, 228),)
                )
                  ]                 
              ),       
      ],
    );
  }
}