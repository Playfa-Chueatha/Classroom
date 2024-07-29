import 'package:flutter/material.dart';

void  main()  => runApp(const AddFrom());

class AddFrom extends StatefulWidget {
  const AddFrom({super.key});

  @override
  State<AddFrom> createState() => _FromState();
}

class _FromState extends State<AddFrom> {
  int _value = 1;

  final _formkey = GlobalKey<FormState>();
  // ignore: unused_field
  String _name = '';
  // ignore: unused_field
  String _last = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "ESclass",
      home: Scaffold(
        // appBar: AppBar(
        //   title: const Text("สร้างชื่อผู้ใช้งาน"),
        //   backgroundColor: Color.fromARGB(255, 118, 232, 240),
        //   centerTitle: true,
        // ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(700,150,700,100),
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                Text("สมัครสมาชิก", style: TextStyle(fontSize: 30),),
                TextFormField(
                  maxLength: 20,
                  decoration: const InputDecoration(
                    label: Text("กรุณาระบุชื่อจริง", style: TextStyle(fontSize: 20),)
                  ),
                  onSaved: (Valuue){
                    _name=Valuue!;
                  },
                  validator: (value){
                    if(value==null || value.isEmpty){
                      return "กรุณาป้อนชื่อของคุณ";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  maxLength: 20,
                  decoration: const InputDecoration(
                    label: Text("กรุณาระบุนามสกุล", style: TextStyle(fontSize: 20),)
                  ),
                  onSaved: (Valuue){
                    _last=Valuue!;
                  },
                  validator: (value){
                    if(value==null || value.isEmpty){
                      return "กรุณาระบุนามสกุล";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  maxLength: 40,
                  decoration: const InputDecoration(
                    label: Text("กรุณากรรอก E-mail", style: TextStyle(fontSize: 20),)
                  ),
                  validator: (value){
                    if(value==null || value.isEmpty){
                      return "กรุณาระบุนามสกุล";
                    }
                    return null;
                  },
                ),
                Row(children: [
                  Text("คุณเป็นนักเรียนหรือครู", style: TextStyle(fontSize: 20),)
                ],),
                Row(children: [
                  Radio(value: 1, groupValue: _value, onChanged: (value){
                    setState(() {
                      _value = value!;
                    });
                  },),
                  SizedBox(width: 20.0,),
                  Text("ครู"),
                ],),
                Row(children: [
                  Radio(value: 2, groupValue: _value, onChanged: (value){
                    setState(() {
                      _value = value!;
                    });
                  },),
                  SizedBox(width: 20.0,),
                  Text("นักเรียน"),
                ],),
                TextFormField(
                  maxLength: 20,
                  decoration: const InputDecoration(
                    label: Text("กรุณากรอกรหัสผ่าน", style: TextStyle(fontSize: 20),)
                  ),
                ),
                TextFormField(
                  maxLength: 20,
                  decoration: const InputDecoration(
                    label: Text("กรุณายืนยันรหัสผ่าน", style: TextStyle(fontSize: 20),)
                  ),
                ),
                const SizedBox(height: 20,),
                FilledButton(
                  onPressed: (){
                    _formkey.currentState!.validate();
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.green
                  ),
                  child: const Text("สมัตรสมาชิก", style: TextStyle(fontSize: 20),)
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
