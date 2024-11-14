// import 'package:flutter/material.dart';
// import 'package:flutter_esclass_2/Profile/ProfileT.dart';

// class alertprofile_T extends StatefulWidget {
//   const alertprofile_T({super.key});

//   @override
//   State<alertprofile_T> createState() => _alertprofile_TState();
// }

// class _alertprofile_TState extends State<alertprofile_T> {
//   final double coverHeight = 280;

//   final TextEditingController _thaiNameController = TextEditingController();
//   final TextEditingController _engNameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _schoolYearController = TextEditingController();
//   final TextEditingController _roomNoController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _subjectsController = TextEditingController();

//   @override
// void initState() {
//   super.initState();
//   _thaiNameController.text = dataprofileT[0].thainame_teacher;
//   _engNameController.text = dataprofileT[0].Engname_teacher;
//   _emailController.text = dataprofileT[0].email_teacher;
//   _schoolYearController.text = dataprofileT[0].school_year.toString();
//   _roomNoController.text = dataprofileT[0].room_no.toString();
//   _phoneController.text = dataprofileT[0].phone.toString();
//   _subjectsController.text = dataprofileT[0].subjects;
// }
  
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//           title: Text('แก้ไขข้อมูล'),
//           content: SingleChildScrollView(
//             child: Column(
//               children: [
//                 TextField(
//                   controller: _thaiNameController,
//                   decoration: InputDecoration(labelText: 'ชื่อ-นามสกุล(ภาษาไทย)'),
//                 ),
//                 TextField(
//                   controller: _engNameController,
//                   decoration: InputDecoration(labelText: 'ชื่อ-นามสกุล(ภาษาอังกฤษ)'),
//                 ),
//                 TextField(
//                   controller: _emailController,
//                   decoration: InputDecoration(labelText: 'E-mail'),
//                 ),
//                 TextField(
//                   controller: _schoolYearController,
//                   decoration: InputDecoration(labelText: 'ครูประจำชั้นมัธยมศึกษาปีที่'),
//                   keyboardType: TextInputType.number,
//                 ),
//                 TextField(
//                   controller: _roomNoController,
//                   decoration: InputDecoration(labelText: 'ห้อง'),
//                   keyboardType: TextInputType.number,
//                 ),
//                 TextField(
//                   controller: _phoneController,
//                   decoration: InputDecoration(labelText: 'เบอร์โทร'),
//                   keyboardType: TextInputType.phone,
//                 ),
//                 TextField(
//                   controller: _subjectsController,
//                   decoration: InputDecoration(labelText: 'วิชาที่สอน'),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('ยกเลิก'),
//             ),
//             TextButton(
//               onPressed: () {
//                   final updatedProfile = dataprofile_T(
//                     id_teacher: dataprofileT[0].id_teacher, // เก็บค่า ID เดิมไว้
//                     thainame_teacher: _thaiNameController.text,
//                     Engname_teacher: _engNameController.text,
//                     email_teacher: _emailController.text,
//                     school_year: int.parse(_schoolYearController.text),
//                     room_no: int.parse(_roomNoController.text),
//                     phone: _phoneController.text,
//                     subjects: _subjectsController.text,
//                   );
//                 Navigator.of(context).pop(updatedProfile);
//               },
//               child: Text('บันทึก'),
//             ),
//           ],
//         );
//   }
// }