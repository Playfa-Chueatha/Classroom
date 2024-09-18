import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qr_flutter/qr_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Classroom App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ClassroomHomePage(),
    );
  }
}

class ClassroomHomePage extends StatefulWidget {
  @override
  _ClassroomHomePageState createState() => _ClassroomHomePageState();
}

class _ClassroomHomePageState extends State<ClassroomHomePage> {
  String? _defaultClassroom;

  @override
  void initState() {
    super.initState();
    _loadDefaultClassroom();
  }

  Future<void> _loadDefaultClassroom() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _defaultClassroom = prefs.getString('defaultClassroom') ?? 'No default classroom set';
    });
  }

  Future<void> _setDefaultClassroom(String classroomName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('defaultClassroom', classroomName);
    _loadDefaultClassroom();
  }

  void _createClassroom() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateClassroomPage(onSave: (String classroomName) {
        _setDefaultClassroom(classroomName);
      })),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Classroom Home')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Default Classroom: $_defaultClassroom'),
          ElevatedButton(
            onPressed: _createClassroom,
            child: Text('Create Classroom'),
          ),
        ],
      ),
    );
  }
}

class CreateClassroomPage extends StatefulWidget {
  final Function(String) onSave;
  CreateClassroomPage({required this.onSave});

  @override
  _CreateClassroomPageState createState() => _CreateClassroomPageState();
}

class _CreateClassroomPageState extends State<CreateClassroomPage> {
  final TextEditingController _classroomNameController = TextEditingController();

  void _generateQRCode() {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Classroom')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _classroomNameController,
              decoration: InputDecoration(labelText: 'Classroom Name'),
            ),
            ElevatedButton(
              onPressed: () {
                widget.onSave(_classroomNameController.text);
                Navigator.pop(context);
              },
              child: Text('Save Classroom'),
            ),
            ElevatedButton(
              onPressed: _generateQRCode,
              child: Text('Generate QR Code'),
            ),
            // if (_generatedLink != null)
            //   QrImage(
            //     data: _generatedLink!,
            //     version: QrVersions.auto,
            //     size: 200.0,
            //   ),
          ],
        ),
      ),
    );
  }
}
