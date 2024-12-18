import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class Comment {
  final String commentTime;
  final String commentTitle;
  final String commentUsername;
  final String thfname;
  final String thlname;

  Comment({
    required this.commentTime,
    required this.commentTitle,
    required this.commentUsername,
    required this.thfname,
    required this.thlname,
  });

  // แปลงข้อมูลจาก JSON เป็น Comment object
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentTime: json['comment_time'],
      commentTitle: json['comment_title'],
      commentUsername: json['comment_username'],
      thfname: json['thfname'] ?? 'ไม่พบข้อมูล',  // กรณีไม่มีข้อมูล
      thlname: json['thlname'] ?? 'ไม่พบข้อมูล',  // กรณีไม่มีข้อมูล
    );
  }
}


//------------------------------------------------
class Post {
  final String ClassroomID;
  final String postID;
  final String postsTitle;
  final String postsLink;
  final String usertThFname;
  final String usertThLname;
  final List<PostFile> files;

  Post({
    required this.ClassroomID,
    required this.postID,
    required this.postsTitle,
    required this.postsLink,
    required this.usertThFname,
    required this.usertThLname,
    required this.files,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      ClassroomID: json['classroom_id'],
      postID: json['posts_auto'],
      postsTitle: json['posts_title'],
      postsLink: json['posts_link'] ?? 'ไม่มี',
      usertThFname: json['usert_thfname'],
      usertThLname: json['usert_thlname'],
      files: (json['files'] as List)
          .map((fileJson) => PostFile.fromJson(fileJson))
          .toList(),
    );
  }
}

class PostFile {
  final String fileName;
  final int fileSize;
  final String fileUrl;

  PostFile({
    required this.fileName,
    required this.fileSize,
    required this.fileUrl,
  });

  factory PostFile.fromJson(Map<String, dynamic> json) {
    return PostFile(
      fileName: json['file_name'],
      fileSize: json['file_size'] ?? 0,
      fileUrl: json['file_url'],
    );
  }
}
//----------------------------------------
//classroom
class ClassroomData{
  ClassroomData({
    required this.Name_class,
    required this.Section_class,
    required this.Room_year,
    required this.Room_No,
    required this.School_year,
    required this.Detail
  });
  String Name_class;    //ชื่อห้องเรียน
  String Section_class;  //แผนการเรียน
  int Room_year;        //ชั้นปี
  int Room_No;          //ห้อง
  int School_year;      //ปีการศึกษา
  String Detail;        //รายละเอียด
}

List<ClassroomData> data = [];



final List<String> sectionOptions = [
    'วิทยาศาสตร์-คณิตศาสตร์',
    'ภาษาอังกฤษ-คณิตศาสตร์',
    'ภาษาอังกฤษ-ภาษาจีน',
    'ภาษาอังกฤษ-ภาษาฝรั่งเศส',
    'ภาษาอังกฤษ-ภาษาญี่ปุ่น',
    'สายศิลป์-สังคม',
  ];


//-------------------------------------------
class FileData {
  final String name;
  final List<int> bytes;

  FileData({required this.name, required this.bytes});

  // สร้าง constructor ที่ใช้แปลงจาก PlatformFile เป็น FileData
  FileData.fromPlatformFile(PlatformFile file)
      : name = file.name,
        bytes = file.bytes!;
}

//-----------------------------------------------------

class Examset {
  final int autoId;
  final String direction;
  final int fullMark;
  final String deadline;
  final String time;
  final String type;
  final String closed;
  final String inspectionStatus;
  final int classroomId;
  final String usertUsername;

  Examset({
    required this.autoId,
    required this.direction,
    required this.fullMark,
    required this.deadline,
    required this.time,
    required this.type,
    required this.closed,
    required this.inspectionStatus,
    required this.classroomId,
    required this.usertUsername,
  });

  factory Examset.fromJson(Map<String, dynamic> json) {
    return Examset(
      autoId: int.tryParse(json['examsets_auto']?.toString() ?? '') ?? 0, 
      direction: json['examsets_direction'] ?? 'N/A',
      fullMark: int.tryParse(json['examsets_fullmark']?.toString() ?? '') ?? 0,
      deadline: json['examsets_deadline'] ?? 'N/A',
      time: json['examsets_time'] ?? 'N/A',
      type: json['examsets_type'] ?? 'N/A',
      closed: json['examsets_closed'] ?? 'N/A',
      inspectionStatus: json['examsets_Inspection_status'] ?? 'N/A',
      classroomId: int.tryParse(json['classroom_id']?.toString() ?? '') ?? 0,
      usertUsername: json['usert_username'] ?? 'N/A',
    );
  }
}



//---------------------------------------------
class Upfile {
  final int upfileAuto;
  final int examsetsId;
  final String upfileName;
  final int upfileSize;
  final String upfileType;
  final String upfileUrl;

  Upfile({
    required this.upfileAuto,
    required this.examsetsId,
    required this.upfileName,
    required this.upfileSize,
    required this.upfileType,
    required this.upfileUrl,
  });

  factory Upfile.fromJson(Map<String, dynamic> json) {
    return Upfile(
      upfileAuto: int.parse(json['upfile_auto']),
      examsetsId: int.parse(json['examsets_id']),
      upfileName: json['upfile_name'],
      upfileSize: int.parse(json['upfile_size']),
      upfileType: json['upfile_type'],
      upfileUrl: json['upfile_url'],
    );
  }
}

//------------------------------------------------------------

class AuswerQuestion {
  final int questionAuto;
  final int examsetsId;
  final String questionDetail;
  final int questionMark;

  AuswerQuestion({
    required this.questionAuto,
    required this.examsetsId,
    required this.questionDetail,
    required this.questionMark
  });

  factory AuswerQuestion.fromJson(Map<String, dynamic> json) {
    return AuswerQuestion(
      questionAuto: int.parse(json['question_auto']),
      examsetsId: int.parse(json['examsets_id']),
      questionDetail: json['question_detail'],
      questionMark: int.parse(json['auswer_question_score']),
      
    );
  }
}

//---------------------ตัวกรองห้องเรียนเพิ่มเพิ่มงาน----------------------------------------------
class Classroom {
  final int classroomId;
  final String classroomName;
  final String classroomMajor;
  final String classroomYear;
  final String classroomNumRoom;

  Classroom({
    required this.classroomId,
    required this.classroomName,
    required this.classroomMajor,
    required this.classroomYear,
    required this.classroomNumRoom,
  });

  factory Classroom.fromJson(Map<String, dynamic> json) {
    return Classroom(
      classroomId: json['classroom_id'],
      classroomName: json['classroom_name'],
      classroomMajor: json['classroom_major'],
      classroomYear: json['classroom_year'],
      classroomNumRoom: json['classroom_numroom'],
    );
  }

  static fromMap(item) {}
}

//-----------------------------------------------------------------------------

class Even_teacher {
  String Title;        // ชื่อการมอบหมายงาน
  String Date;         // วันที่กำหนดส่ง
  String Time;         // เวลาที่กำหนด
  String Class;        // ชื่อห้องเรียน (classroom_name)
  String Major;        // สาขาวิชา (classroom_major)
  String Year;         // ชั้นปี (classroom_year)
  String Room;         // หมายเลขห้อง (classroom_numroom)
  String ClassID;      // ID ห้องเรียน (event_assignment_classID)

  Even_teacher({
    required this.Title,
    required this.Date,
    required this.Time,
    required this.Class,
    required this.Major,
    required this.Year,
    required this.Room,
    required this.ClassID,
  });
}

//-------notification-------------------

class NotificationData {
  final int id;
  final String title;
  final String classId;
  final String time;
  final String dueDate;
  final String user;
  final bool readStatus;
  final String classroomName;
  final String classroomMajor;
  final String classroomYear;
  final String classroomNumRoom;

  NotificationData({
    required this.id,
    required this.title,
    required this.classId,
    required this.time,
    required this.dueDate,
    required this.user,
    required this.readStatus,
    required this.classroomName,
    required this.classroomMajor,
    required this.classroomYear,
    required this.classroomNumRoom,
  });

  factory NotificationData.fromMap(Map<String, dynamic> map) {
    return NotificationData(
      id: int.parse(map['notification_assingment_auto']),
      title: map['notification_assingment_title'],
      classId: map['notification_assingment_classID'],
      time: map['notification_assingment_time'],
      dueDate: map['notification_assingment_duedate'],
      user: map['notification_assingment_usert'],
      readStatus: map['notification_assingment_readstatus'] == 'Alreadyread',
      classroomName: map['classroom_name'] ?? '',
      classroomMajor: map['classroom_major'] ?? '',
      classroomYear: map['classroom_year'] ?? '',
      classroomNumRoom: map['classroom_numroom'] ?? '',
    );
  }
}





//----------------------






