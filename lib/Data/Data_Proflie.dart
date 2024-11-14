import 'dart:convert';
import 'package:http/http.dart' as http;

// Function to get user teacher data
Future<List<dataprofile_T>> getUserTeacher(dynamic widget) async {
  String url = "https://www.edueliteroom.com/connect/teacher/get_user_teacher.php";
  
  // Prepare query parameters
  final Map<String, dynamic> queryParams = {
    "usert_username": widget.usert_username,
  };

  // Send the GET request
  final response = await http.get(Uri.parse(url).replace(queryParameters: queryParams));

  // Check if the request is successful
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);

    // Check if the data is not empty and is a list
    if (data != null && data is List) {
      // Convert JSON data to a list of dataprofile_T objects
      List<dataprofile_T> teacherList = data.map((teacher) {
        return dataprofile_T.fromJson(teacher);
      }).toList();

      return teacherList;
    } else {
      // Return empty list if data is not valid
      return [];
    }
  } else {
    // Log error or throw exception if there is a problem with the request
    throw Exception('Failed to load teacher data');
  }
}

// Data model for teacher profile
class dataprofile_T {
  final String thainame_teacher;
  final String Engname_teacher;
  final String email_teacher;
  final int school_year;
  final int room_no;
  final String phone;
  final String subjects;

  dataprofile_T({
    required this.thainame_teacher,
    required this.Engname_teacher,
    required this.email_teacher,
    required this.school_year,
    required this.room_no,
    required this.phone,
    required this.subjects,
  });

  // Factory method to create dataprofile_T object from JSON
  factory dataprofile_T.fromJson(Map<String, dynamic> json) {
    return dataprofile_T(
      thainame_teacher: json['thainame_teacher'],
      Engname_teacher: json['Engname_teacher'],
      email_teacher: json['email_teacher'],
      school_year: json['school_year'],
      room_no: json['room_no'],
      phone: json['phone'],
      subjects: json['subjects'],
    );
  }
}
