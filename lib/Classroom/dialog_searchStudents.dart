import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Data/Data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DialogSearchstudents extends StatefulWidget {
  final String thfname;
  final String thlname;
  final String username;
  final String classroomName;
  final String classroomMajor;
  final String classroomYear;
  final String classroomNumRoom;

  const DialogSearchstudents({
    super.key,
    required this.thfname,
    required this.thlname,
    required this.username,
    required this.classroomName,
    required this.classroomMajor,
    required this.classroomYear,
    required this.classroomNumRoom,
  });

  @override
  State<DialogSearchstudents> createState() => _DialogSearchstudentsState();
}

class _DialogSearchstudentsState extends State<DialogSearchstudents> {
  List<dynamic> studentlist = [];
  List<dynamic> filteredStudents = [];
  bool isLoading = true;
  List<String> usersAuto = [];
  List<String> addedStudentIds = [];
  

  String? selectedSection;
  String? sectionClass;
  TextEditingController idController = TextEditingController();
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController numRoomController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchStudents();
    fetchClassroomData();
  }
  //เพิ่มนักเรียนเข้าห้องเรียน
  Future<void> addStudentToClass(Map<String, dynamic> student) async {
  final response = await http.get(
    Uri.parse(
      'https://www.edueliteroom.com/connect/add_student_toclass.php?' 
      'classroomName=${widget.classroomName}&classroomMajor=${widget.classroomMajor}'
      '&classroomYear=${widget.classroomYear}&classroomNumRoom=${widget.classroomNumRoom}'
      '&usersId=${student['users_id']}',
    ),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    if (data['status'] == 'success') {
      
      setState(() {
        // เพิ่ม users_id ของนักเรียนที่เพิ่มลงในห้องเรียน
        usersAuto.add(student['users_auto']);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ไม่สามารถเพิ่มนักเรียนได้')),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('เกิดข้อผิดพลาดในการเพิ่มนักเรียน')),
    );
  }
}


  


  Future<void> fetchClassroomData() async {
    final uri = Uri.parse(
        'https://www.edueliteroom.com/connect/fetch_classroom_data.php?classroomName=${widget.classroomName}&classroomMajor=${widget.classroomMajor}&classroomYear=${widget.classroomYear}&classroomNumRoom=${widget.classroomNumRoom}');
    
    final response = await http.get(uri);
    print(response.body);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        setState(() {
          isLoading = false;
          usersAuto = List<String>.from(data['users_auto']);
          
        });
      } else {
        setState(() {
          isLoading = false;
        });
        _showErrorAlert('ไม่พบข้อมูลห้องเรียน');
      }
    } else {
      setState(() {
        isLoading = false;
      });
      _showErrorAlert('เกิดข้อผิดพลาดในการเชื่อมต่อกับเซิร์ฟเวอร์');
    }
  }

  void _showErrorAlert(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('เกิดข้อผิดพลาด'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ปิด'),
          ),
        ],
      ),
    );
  }
  
  Future<void> fetchStudents() async {
    final response = await http.get(
      Uri.parse(
        'https://www.edueliteroom.com/connect/searchstudents_inclass.php?classroomName=${widget.classroomName}&classroomMajor=${widget.classroomMajor}&classroomYear=${widget.classroomYear}&classroomNumRoom=${widget.classroomNumRoom}',
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        studentlist = data['students'] ?? [];
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load students')),
      );
    }
  }


  //แสดงนักเรียนค้นหาจากตัวกรอก
  Future<void> searchStudents() async {
    final queryParams = {
      if (idController.text.isNotEmpty) 'id': idController.text,
      if (fnameController.text.isNotEmpty) 'fname': fnameController.text,
      if (lnameController.text.isNotEmpty) 'lname': lnameController.text,
      if (numRoomController.text.isNotEmpty) 'numRoom': numRoomController.text,
      if (sectionClass != null) 'classPlan': sectionClass,
      if (selectedSection != null) 'section': selectedSection,
    };

    final uri = Uri.parse('https://www.edueliteroom.com/connect/searchstudents_inclass.php')
        .replace(queryParameters: queryParams);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // print(response.body);
      setState(() {
        filteredStudents = data['students'] ?? [];
        if (filteredStudents.isEmpty) _showNoDataAlert();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Unable to search students')),
      );
    }
  }

  void _showNoDataAlert() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.yellow),
            const SizedBox(width: 12),
            const Text(
              'ไม่มีข้อมูลที่ตรงกับการค้นหา',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 1), () => Navigator.of(context).pop());
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        'ค้นหานักเรียน ${widget.classroomName} ${widget.classroomYear}/${widget.classroomNumRoom} (${widget.classroomMajor})',
      ),
      content: SingleChildScrollView(
        child: SizedBox(
        height: screenHeight * 1,
        width: screenWidth * 1,
        child: Column(
          children: [
            _buildSearchFields(),
            SizedBox(height: screenHeight * 0.01),
            _buildStudentList(),
          ],
        ),
      )),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('ปิด'),
        ),
      ],
    );
  }

  Widget _buildSearchFields() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
        height: screenHeight * 0.26,
        width: screenWidth * 0.9,
        alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromARGB(255, 121, 192, 219),
      ),
      child: Column(
        children: [
          _buildTextFieldsRow(),
          _buildDropdownsRow(),
          _buildSearchButtons(),
        ],
      ),
    );
  }

  Row _buildTextFieldsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTextField(controller: idController, label: 'รหัสนักเรียน'),
        _buildTextField(controller: fnameController, label: 'ชื่อ'),
        _buildTextField(controller: lnameController, label: 'นามสกุล'),
      ],
    );
  }

  Row _buildDropdownsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDropdownField(
          label: 'ชั้นปี',
          value: selectedSection,
          items: ["ชั้นมัธยมศึกษาปีที่ 4", "ชั้นมัธยมศึกษาปีที่ 5", "ชั้นมัธยมศึกษาปีที่ 6"],
          onChanged: (value) => setState(() => selectedSection = value),
        ),
        _buildTextField(controller: numRoomController, label: 'ห้อง'),
        _buildDropdownField(
          label: 'แผนการเรียน',
          value: sectionClass,
          items: sectionOptions,
          onChanged: (value) => setState(() => sectionClass = value),
        ),
      ],
    );
  }

  Widget _buildSearchButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildButton('ค้นหา', searchStudents),
        _buildButton('ล้าง', _clearFields),
      ],
    );
  }

  Widget _buildStudentList() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
        height: screenHeight * 0.7,
        width: screenWidth * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromARGB(255, 147, 185, 221),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildDataTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildDataTable() {
    final students = filteredStudents.isNotEmpty ? filteredStudents : studentlist;
    return students.isEmpty
        ? const Center(child: Text('ไม่มีข้อมูลที่ตรงกับการค้นหา'))
        : DataTable(
            columns: const [
              DataColumn(label: Text('รหัสนักเรียน')),
              DataColumn(label: Text('ชื่อ')),
              DataColumn(label: Text('นามสกุล')),
              DataColumn(label: Text('ชั้นปี')),
              DataColumn(label: Text('ห้อง')),
              DataColumn(label: Text('สาขา')),
              DataColumn(label: Text('เพิ่มเข้าห้องเรียน')),
            ],
            rows: students.map((student) => _buildDataRow(student)).toList(),
          );
  }

  DataRow _buildDataRow(Map<String, dynamic> student) {
  // ตรวจสอบว่า users_auto ของนักเรียนตรงกับค่าที่ได้จาก fetchClassroomData หรือ searchStudents หรือไม่
  bool isStudentAlreadyInClass = usersAuto.contains(student['users_auto']);

  return DataRow(
    cells: [
      DataCell(Text(student['users_id'])),
      DataCell(Text(student['users_thfname'])),
      DataCell(Text(student['users_thlname'])),
      DataCell(Text(student['users_classroom'])),
      DataCell(Text(student['users_numroom'])),
      DataCell(Text(student['users_major'])),
      DataCell(
        isStudentAlreadyInClass
            ? Icon(Icons.check, color: Colors.green) // แสดงเครื่องหมายเช็คถูก
            : IconButton(
                onPressed: () {
                  // เปลี่ยนสถานะเป็น true ทันทีเพื่อแสดงเครื่องหมายเช็คถูก
                  setState(() {
                    isStudentAlreadyInClass = true; // เปลี่ยนค่าทันที
                  });
                  addStudentToClass(student); // เมื่อไม่ตรงให้เพิ่มนักเรียน
                },
                icon: const Icon(Icons.add),
              ),
      )

    ],
  );
}



  Widget _buildTextField({required TextEditingController controller, required String label}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight * 0.06,
      width: screenWidth * 0.2,
      margin: const EdgeInsets.all(10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 60,
      width: 200,
      margin: const EdgeInsets.all(10),
      child: DropdownButtonFormField<String>(
        value: value,
        onChanged: onChanged,
        items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  Widget _buildButton(String label, VoidCallback onPressed) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }

  void _clearFields() {
    setState(() {
      idController.clear();
      fnameController.clear();
      lnameController.clear();
      numRoomController.clear();
      selectedSection = null;
      sectionClass = null;
      filteredStudents.clear();
    });
  }
}
