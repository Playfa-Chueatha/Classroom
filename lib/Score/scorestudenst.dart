import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_esclass_2/Data/Data_students.dart';

class Scorestudenst extends StatefulWidget {
  const Scorestudenst({super.key});

  @override
  State<Scorestudenst> createState() => _ScorestudentsState();
}

class _ScorestudentsState extends State<Scorestudenst> {
  List<List<TextEditingController>> scoreControllers = [];
  List<String> scoreColumnNames = ["คะแนน 1"];
  bool isEditing = true; // Add this variable to control the editing state

  @override
  void initState() {
    super.initState();
    // Initialize scoreControllers for each student
    scoreControllers = dataliststudents.map((student) {
      return scoreColumnNames.map((name) => TextEditingController()).toList();
    }).toList();
  }

  @override
  void dispose() {
    // Dispose controllers
    for (var controllers in scoreControllers) {
      for (var controller in controllers) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  void addScoreColumn() {
    setState(() {
      scoreColumnNames.add("คะแนน ${scoreColumnNames.length + 1}");
      // Add a new TextEditingController for each student
      for (var controllers in scoreControllers) {
        controllers.add(TextEditingController());
      }
    });
  }

  void removeScoreColumn(int index) {
    setState(() {
      scoreColumnNames.removeAt(index);
      for (var controllers in scoreControllers) {
        controllers.removeAt(index);
      }
    });
  }

  void editScoreColumn(int index) async {
    TextEditingController columnNameController = TextEditingController(text: scoreColumnNames[index]);
    bool shouldUpdate = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('แก้ไขหัวข้อคะแนน'),
          content: TextField(
            controller: columnNameController,
            decoration: const InputDecoration(
              labelText: 'ชื่อหัวข้อคะแนน',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('ตกลง'),
            ),
          ],
        );
      }
    );

    if (shouldUpdate) {
      setState(() {
        scoreColumnNames[index] = columnNameController.text;
      });
    }
  }

  void toggleEditing() {
    setState(() {
      isEditing = !isEditing; // Toggle the editing state
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text('รายชื่อนักเรียน'),
        backgroundColor: Colors.white,
        actions: [
          OutlinedButton(
            onPressed: () {
              toggleEditing(); // Toggle editing state when saving
            },
            child: Text(isEditing ? 'บันทึกคะแนน' : 'แก้ไขคะแนน'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  ElevatedButton(
                    onPressed: addScoreColumn,
                    child: const Text('เพิ่มช่องคะแนน'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DataTable(
                columnSpacing: 20.0,
                columns: [
                  DataColumn(
                    label: SizedBox(
                      width: 60,
                      child: const Text('เลขที่ห้อง'),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: 150,
                      child: const Text('รหัสนักเรียน'),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: 150,
                      child: const Text('ชื่อ'),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: 150,
                      child: const Text('นามสกุล'),
                    ),
                  ),
                  // Add columns for scores dynamically
                  ...scoreColumnNames.asMap().entries.map((entry) {
                    int index = entry.key;
                    String name = entry.value;
                    return DataColumn(
                      label: SizedBox(
                        width: 150,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(name),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, size: 16),
                                  onPressed: () => editScoreColumn(index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, size: 16),
                                  onPressed: () => removeScoreColumn(index),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
                rows: dataliststudents.asMap().entries.map((entry) {
                  var student = entry.value;
                  var controllers = scoreControllers[entry.key];
                  return DataRow(
                    cells: [
                      DataCell(Text(student.numroom.toString())),
                      DataCell(Text(student.IDstudents.toString())),
                      DataCell(Text(student.firstnamestudents)),
                      DataCell(Text(student.lastnamestudents)),
                      // Add cells for scores dynamically
                      ...controllers.map((controller) => DataCell(
                        Center(child: 
                        TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(8.0),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(3),
                          ],
                          readOnly: !isEditing, // Set readOnly based on isEditing
                        ),)
                      )),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
