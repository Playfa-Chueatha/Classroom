import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Classroom/classT.dart';
import 'package:flutter_esclass_2/Data/Data_assignwork.dart';
import 'package:flutter_esclass_2/Home/homeS.dart';
import 'package:flutter_esclass_2/Home/homeT.dart';
import 'package:flutter_esclass_2/Login/login.dart';
import 'package:flutter_esclass_2/Login/loginS.dart';
import 'package:flutter_esclass_2/Login/loginT.dart';
import 'package:flutter_esclass_2/Profile/ProfileT.dart';
import 'package:flutter_esclass_2/Rgister/registerS.dart';
import 'package:flutter_esclass_2/Rgister/registerT.dart';
import 'package:flutter_esclass_2/Score/Score_S.dart';
import 'package:flutter_esclass_2/Score/Score_T.dart';
import 'package:flutter_esclass_2/test.dart';
import 'package:flutter_esclass_2/work/add_worktype.dart';
import 'package:flutter_esclass_2/work/asign_work_T.dart';
import 'package:flutter_esclass_2/work/work_type/auswerQ.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:Login_class()
    );  }
}
 