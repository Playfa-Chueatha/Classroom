import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Profile/ProfileT.dart';
import 'package:http/http.dart' as http;

Future getUserTeacher(dynamic widget) async{

    String url = "http://localhost/edueliteroom01/get_user_teacher.php";
    //String url = "https://edueliteroom.com/connect/get_user_teacher.php";
    
    final Map<String, dynamic> queryParams = {
      "id_teacher": widget.id_teacher,
      "room_teacher": widget.room_teacher.toString(),
      "numroom_teacher": widget.numroom_teacher.toString(),
    };
    http.Response response =
        await http.get(Uri.parse(url).replace(queryParameters: queryParams));
    if(response.statusCode == 200){
      var getusert = jsonDecode(response.body);
      return getusert;
    }else{
      return [];
    }
  }

class DataProflieteacher  {
  final int id_teacher;
  final String thaifirstname_teacher;
  final String thailastname_teacher;
  final String email_teacher;
  final String engfirstname_teacher;
  final String englastname_teacher;
  final String username_teacher;
  final String password_teacher;
  final int room_teacher;
  final int numroom_teacher;
  final String phone_teacher;
  final String subject_teacher;
  
   DataProflieteacher({ 
    required this.id_teacher,
    required this.thaifirstname_teacher, 
    required this.thailastname_teacher, 
    required this.email_teacher,
    required this.engfirstname_teacher,
    required this.englastname_teacher,
    required this.username_teacher,
    required this.password_teacher,
    required this.room_teacher,
    required this.numroom_teacher,
    required this.phone_teacher,
    required this.subject_teacher
  });
}

// List <DataProflieteacher>  datauserteacher = [
//  DataProflieteacher(
//   thaifirstname_teacher: 'ปฃายฟ้า', 
//   thailastname_teacher: 'เชื้อถา', 
//   email_teacher: 'paiyfa.11@gmail.com', 
//   engfirstname_teacher: '', 
//   englastname_teacher: englastname_teacher, 
//   username_teacher: username_teacher, 
//   password_teacher: password_teacher, 
//   room_teacher: room_teacher, 
//   numroom_teacher: numroom_teacher, 
//   phone_teacher: phone_teacher, 
//   subject_teacher: subject_teacher)
// ];
