import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

void  main()  => runApp(const AddFrom());

class AddFrom extends StatefulWidget {
  const AddFrom({super.key});

  @override
  State<AddFrom> createState() => _FromState();
}

class _FromState extends State<AddFrom> {
  int _value = 1;
  @override
  final formKey = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();
  TextEditingController surname = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController type = TextEditingController();

  Future sing_up() async{
    String url = "http://192.168.1.102/classroom/register.php";
    final respone = await http.post(Uri.parse(url),body: {
      'name': name.text,
      'surname': surname.text,
      'password': pass.text,
      'email': email.text,
      'type': type.text,
      
    });
    var data = json.decode(respone.body);
    if(data == "Error"){
      Navigator.pushNamed(context, 'register');
    }else{
      Navigator.pushNamed(context, 'login');
    }
  }

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
            key: formKey,
            child: Column(
              children: [
                Text("สมัครสมาชิก", style: TextStyle(fontSize: 30),),
                TextFormField(
                  maxLength: 20,
                  decoration: const InputDecoration(
                    label: Text("กรุณาระบุชื่อจริง", style: TextStyle(fontSize: 20),)
                  ),
                  validator: (val){
                    if(val == null){
                      return 'กรุณากรอกระบุชื่อจริง';
                    }
                    return null;
                  },
                  controller: name,
                ),
                TextFormField(
                  maxLength: 20,
                  decoration: const InputDecoration(
                    label: Text("กรุณาระบุนามสกุล", style: TextStyle(fontSize: 20),)
                  ),
                  validator: (val){
                    if(val == null){
                      return 'กรุณากรอกระบุนามสกุล';
                    }
                    return null;
                  },
                  controller: surname,
                ),
                TextFormField(
                  maxLength: 40,
                  decoration: const InputDecoration(
                    label: Text("กรุณากรอก E-mail", style: TextStyle(fontSize: 20),)
                  ),
                  validator: (val){
                    if(val == null){
                      return 'กรุณากรอก E-mail';
                    }
                    return null;
                  },
                  controller: email,
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
                  validator: (val){
                    if(val!.isEmpty){
                      return 'กรุณากรอกรหัสผ่าน';
                    }
                    return null;
                  },
                  controller: pass,
                ),
                TextFormField(
                  maxLength: 20,
                  decoration: const InputDecoration(
                    label: Text("กรุณายืนยันรหัสผ่าน", style: TextStyle(fontSize: 20),)
                  ),
                  validator: (val){
                    if(val!.isEmpty){
                      return 'กรุณากรอกยืนยันรหัสผ่าน';
                    }else if(val != pass.text){
                      return 'รหัสผ่านไม่ตรงกัน';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20,),
                FilledButton(
                  onPressed: (){
                    bool pass = formKey.currentState!.validate();
                  
                    if(pass){
                      sing_up();
                    }
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.green
                  ),
                  child: const Text("สมัครสมาชิก", style: TextStyle(fontSize: 20),)
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
