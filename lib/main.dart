import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Login/login.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
<<<<<<< HEAD
      // title: 'Eduelite',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: main_home_T(),
    );  }
=======
        debugShowCheckedModeBanner: false,
        home: Login_class());
  }
>>>>>>> 923485a14a4cc1f313495cac2ae65753a43c76aa
}
