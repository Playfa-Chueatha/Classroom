import 'package:flutter/material.dart';

void  main()  => runApp(const Repass());

class Repassword extends StatelessWidget {
  const Repassword({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Repassword",
      home: Scaffold(
        body: Center(
          child: Dialog(),
        ),
      ),
    );
  }
}
class Repass extends StatelessWidget {
  const Repass({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}