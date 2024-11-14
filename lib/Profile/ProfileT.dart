import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_esclass_2/Data/Data_Proflie.dart';
import 'package:flutter_esclass_2/Profile/repass.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class Profile_T extends StatefulWidget {
  const Profile_T({super.key});

  @override
  State<Profile_T> createState() => _Profile_TState();
}

class _Profile_TState extends State<Profile_T> {
  File? _image;
  Future<List<dataprofile_T>>? futureProfileData;

  @override
  void initState() {
    super.initState();
    futureProfileData = getUserTeacher('usetname');  // Fetch teacher profile data
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final buttonStyle = FilledButton.styleFrom(
      backgroundColor: Color.fromARGB(255, 10, 82, 104),
    );
    final textStyle = TextStyle(fontSize: 20);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: size.width * 0.9,
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 147, 185, 221),
              borderRadius: BorderRadius.circular(20),
            ),
            child: FutureBuilder<List<dataprofile_T>>(
              future: futureProfileData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text("No data found");
                } else {
                  var dataprofileT = snapshot.data!;
                  return Column(
                    children: [
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _buildButton(
                            context,
                            "เปลี่ยนรหัสผ่าน",
                            () => showDialog(
                              context: context,
                              builder: (BuildContext context) => repass(),
                            ),
                            Color.fromARGB(255, 228, 223, 153),
                            size.width * 0.25,
                          ),
                          SizedBox(width: 10),
                          _buildButton(
                            context,
                            "แก้ไขข้อมูล",
                            () async {
                              // Add edit profile logic
                            },
                            buttonStyle.backgroundColor as Color,
                            size.width * 0.2,
                          ),
                        ],
                      ),
                      SizedBox(height: 50),
                      _buildProfileImage(size),
                      SizedBox(height: 10),
                      SizedBox(
                        height: 50,
                        width: size.width * 0.2,
                        child: FilledButton(
                          onPressed: _pickImage,
                          style: buttonStyle,
                          child: Text("แก้ไขโปรไฟล์", style: textStyle),
                        ),
                      ),
                      SizedBox(height: 50),
                      _buildProfileDetails(size, dataprofileT),
                      SizedBox(height: 50),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, VoidCallback onPressed, Color bgColor, double width) {
    final textStyle = TextStyle(fontSize: 20);
    return SizedBox(
      height: 50,
      width: width,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: Colors.black,
        ),
        child: Text(text, style: textStyle),
      ),
    );
  }

  Widget _buildProfileImage(Size size) {
    return Container(
      height: size.height * 0.3,
      width: size.width * 0.3,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(2, 2),
            blurRadius: 10,
          ),
        ],
        image: _image == null
            ? DecorationImage(
                image: AssetImage("assets/images/ครู.png"),
              )
            : DecorationImage(
                image: FileImage(_image!),
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  Widget _buildProfileDetails(Size size, List<dataprofile_T> dataprofileT) {
    final textStyle = TextStyle(fontSize: 20);

    return Container(
      height: size.height * 0.7,
      width: size.width * 0.7,
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildProfileLabels(textStyle),
          _buildProfileValues(textStyle, dataprofileT),
        ],
      ),
    );
  }

  Widget _buildProfileLabels(TextStyle textStyle) {
    return SizedBox(
      height: double.infinity,
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var label in [
            "ชื่อ-นามสกุล(ภาษาไทย): ",
            "ชื่อ-นามสกุล(ภาษาอังกฤษ): ",
            "ครูประจำชั้นมัธยมศึกษาปีที่: ",
            "ห้อง: ",
            "เบอร์โทร: ",
            "E-mail: ",
            "วิชาที่สอน: ",
          ])
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(label, style: textStyle),
            ),
        ],
      ),
    );
  }

  Widget _buildProfileValues(TextStyle textStyle, List<dataprofile_T> dataprofileT) {
    return SizedBox(
      height: double.infinity,
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(" ${dataprofileT[0].thainame_teacher}", style: textStyle),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(' ${dataprofileT[0].Engname_teacher}', style: textStyle),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(' ${dataprofileT[0].school_year}', style: textStyle),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(' ${dataprofileT[0].room_no}', style: textStyle),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(' ${dataprofileT[0].phone}', style: textStyle),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(' ${dataprofileT[0].email_teacher}', style: textStyle),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(' ${dataprofileT[0].subjects}', style: textStyle),
          ),
        ],
      ),
    );
  }
}

// Add your dataprofile_T model and getUserTeacher function below or import them
