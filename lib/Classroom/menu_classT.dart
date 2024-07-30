import 'package:flutter/material.dart';

class Mennu_classT extends StatefulWidget {
  const Mennu_classT({super.key});

  @override
  State<Mennu_classT> createState() => _Mennu_classTState();
}

class _Mennu_classTState extends State<Mennu_classT> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
            SizedBox(height: 20),
          Container(                        
            width: 280,
            height: 200,                            
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20)
              ),
            ),
            ),
        ],
      ),
    );
  }
}
