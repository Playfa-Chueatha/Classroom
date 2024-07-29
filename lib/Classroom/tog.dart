import 'package:flutter/material.dart';

/// Flutter code sample for [ToggleButtons].

const List<Widget> fruits = <Widget>[
  Text('หน้าหลัก'),
  Text('ห้องเรียน'),
  Text('งานที่มอบหมาย'),
  Text('รายชื่อนักเรียน')
];

void main() => runApp(const ToggleButtonsSample());


class ToggleButtonsSample extends StatefulWidget {
  const ToggleButtonsSample({super.key});


  @override
  State<ToggleButtonsSample> createState() => _ToggleButtonsSampleState();
}

class _ToggleButtonsSampleState extends State<ToggleButtonsSample> {
  final List<bool> _selectedFruits = <bool>[true, false, false,false];

  bool vertical = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("t")),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 5),
              ToggleButtons(
                direction: vertical ? Axis.vertical : Axis.horizontal,
                onPressed: (int index) {
                  setState(() {
                    // The button that is tapped is set to true, and the others to false.
                    for (int i = 0; i < _selectedFruits.length; i++) {
                      _selectedFruits[i] = i == index;
                    }
                  });
                },
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                selectedBorderColor: Colors.red[700],
                selectedColor: Colors.white,
                fillColor: Colors.red[200],
                color: Colors.red[400],
                constraints: const BoxConstraints(
                  minHeight: 40.0,
                  minWidth: 150.0,
                ),
                isSelected: _selectedFruits,
                children: fruits,
              ),
            ],
          ),
        ),
      ),
      );
        }
  }

