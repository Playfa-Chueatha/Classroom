
// comment----------------------------------------
import 'dart:typed_data';

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

  Examset({
    required this.autoId,
    required this.direction,
    required this.fullMark,
    required this.deadline,
    required this.time,
    required this.type,
  });

  factory Examset.fromJson(Map<String, dynamic> json) {
    return Examset(
      autoId: int.parse(json['examsets_auto']),
      direction: json['examsets_direction'],
      fullMark: int.parse(json['examsets_fullmark']),
      deadline: json['examsets_deadline'],
      time: json['examsets_time'],
      type: json['examsets_type'],
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

  AuswerQuestion({
    required this.questionAuto,
    required this.examsetsId,
    required this.questionDetail,
  });

  factory AuswerQuestion.fromJson(Map<String, dynamic> json) {
    return AuswerQuestion(
      questionAuto: int.parse(json['question_auto']),
      examsetsId: int.parse(json['examsets_id']),
      questionDetail: json['question_detail'],
    );
  }
}