import 'dart:convert';

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
        debugShowCheckedModeBanner: false,
        home: Login_class());
  }
}