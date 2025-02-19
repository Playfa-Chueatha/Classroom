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
    'สายศิลป์-จีน',
    'สายศิลป์-อังกฤษ',
    'วิทยาศาสตร์คอมพิวเตอร์',
    'วิทยาศาสตร์สิ่งแวดล้อม',
    'ศิลป์-ทั่วไป',
    'ศิลป์​-พาณิชย์​'
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
  final double fullMark;
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
      fullMark: double.tryParse(json['examsets_fullmark']?.toString() ?? '') ?? 0,
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
      upfileAuto: _parseInt(json['upfile_auto']),
      examsetsId: _parseInt(json['examsets_id']),
      upfileName: json['upfile_name'] ?? '',
      upfileSize: _parseInt(json['upfile_size']),
      upfileType: json['upfile_type'] ?? '',
      upfileUrl: json['upfile_url'] ?? '',
    );
  }

  // Helper function เพื่อใช้ซ้ำ
  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0; // ค่าดีฟอลต์เมื่อไม่สามารถแปลงได้
  }
}

//---------------------------------------------------------------
class UpfileLink {
  final int upfileLinkAuto;
  final int examsetsId;
  final String upfileLinkUrl;

  UpfileLink({
    required this.upfileLinkAuto,
    required this.examsetsId,
    required this.upfileLinkUrl,
  });

  factory UpfileLink.fromJson(Map<String, dynamic> json) {
    return UpfileLink(
      upfileLinkAuto: _parseInt(json['upfile_link_auto']),
      examsetsId: _parseInt(json['examsets_id']),
      upfileLinkUrl: json['upfile_link_url'] ?? '',
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0; // Default value
  }
}


//------------------------------------------------------------

class AuswerQuestion {
  final int questionAuto;
  final int examsetsId;
  String questionDetail; // เปลี่ยนเป็น String ธรรมดา
  final double questionMark;

  AuswerQuestion({
    required this.questionAuto,
    required this.examsetsId,
    required this.questionDetail,
    required this.questionMark,
  });

  factory AuswerQuestion.fromJson(Map<String, dynamic> json) {
    return AuswerQuestion(
      questionAuto: int.parse(json['question_auto']),
      examsetsId: int.parse(json['examsets_id']),
      questionDetail: json['question_detail'],
      questionMark: double.parse(json['auswer_question_score']),
    );
  }

  // Setter method สำหรับการปรับปรุงค่า questionDetail
  set setQuestionDetail(String newDetail) {
    questionDetail = newDetail;
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


//--------------------onechoice-------------------------
class OneChoice {
  final int onechoiceAuto;
  final int examsetsId;
  final String onechoiceQuestion;
  final String onechoiceA;
  final String onechoiceB;
  final String onechoiceC;
  final String onechoiceD;
  final String onechoiceAnswer;
  final double onechoiceQuestionScore;  

  OneChoice({
    required this.onechoiceAuto,
    required this.examsetsId,
    required this.onechoiceQuestion,
    required this.onechoiceA,
    required this.onechoiceB,
    required this.onechoiceC,
    required this.onechoiceD,
    required this.onechoiceAnswer,
    required this.onechoiceQuestionScore, 
  });

  // ฟังก์ชันสำหรับแปลง JSON เป็น OneChoice Object
  factory OneChoice.fromJson(Map<String, dynamic> json) {
    return OneChoice(
      onechoiceAuto: json['onechoice_auto'] is int
          ? json['onechoice_auto']
          : int.parse(json['onechoice_auto'].toString()), 
      examsetsId: json['examsets_id'] is int
          ? json['examsets_id']
          : int.parse(json['examsets_id'].toString()),  
      onechoiceQuestion: json['onechoice_question'],
      onechoiceA: json['onechoice_a'],
      onechoiceB: json['onechoice_b'],
      onechoiceC: json['onechoice_c'],
      onechoiceD: json['onechoice_d'],
      onechoiceAnswer: json['onechoice_answer'],
      onechoiceQuestionScore: json['onechoice_question_score'] is double
          ? json['onechoice_question_score']
          : double.parse(json['onechoice_question_score'].toString()), 
    );
  }

  // ฟังก์ชันสำหรับแปลง OneChoice Object เป็น JSON
  Map<String, dynamic> toJson() {
    return {
      'onechoice_auto': onechoiceAuto,
      'examsets_id': examsetsId,
      'onechoice_question': onechoiceQuestion,
      'onechoice_a': onechoiceA,
      'onechoice_b': onechoiceB,
      'onechoice_c': onechoiceC,
      'onechoice_d': onechoiceD,
      'onechoice_answer': onechoiceAnswer,
      'onechoice_question_score': onechoiceQuestionScore, // เพิ่มใน toJson
    };
  }
}

//-----------------manychoice--------------------------------
class Manychoice {
  final String manychoiceAuto;
  final String examsetsId;
  String manychoiceQuestion;  // เปลี่ยนจาก final เป็น String
  String manychoiceA;
  String manychoiceB;
  String manychoiceC;
  String manychoiceD;
  String manychoiceE;
  String manychoiceF;
  String manychoiceG;
  String manychoiceH;
  final String manychoiceAnswer;
  double manychoiceQuestionScore;

  Manychoice({
    required this.manychoiceAuto,
    required this.examsetsId,
    required this.manychoiceQuestion,
    required this.manychoiceA,
    required this.manychoiceB,
    required this.manychoiceC,
    required this.manychoiceD,
    required this.manychoiceE,
    required this.manychoiceF,
    required this.manychoiceG,
    required this.manychoiceH,
    required this.manychoiceAnswer,
    required this.manychoiceQuestionScore,
  });

  factory Manychoice.fromJson(Map<String, dynamic> json) {
    return Manychoice(
      manychoiceAuto: json['manychoice_auto'],
      examsetsId: json['examsets_id'],
      manychoiceQuestion: json['manychoice_question'],
      manychoiceA: json['manychoice_a'],
      manychoiceB: json['manychoice_b'],
      manychoiceC: json['manychoice_c'],
      manychoiceD: json['manychoice_d'],
      manychoiceE: json['manychoice_e'],
      manychoiceF: json['manychoice_f'],
      manychoiceG: json['manychoice_g'],
      manychoiceH: json['manychoice_h'],
      manychoiceAnswer: json['manychoice_answer'],
      manychoiceQuestionScore: double.tryParse(json['manychoice_question_score'].toString()) ?? 0.0,
    );
  }

   void updateQuestion(String newQuestion) {
    manychoiceQuestion = newQuestion;
  }

  void updateScore(double newScore) {
    manychoiceQuestionScore = newScore;
  }

  // เพิ่มฟังก์ชัน update สำหรับตัวเลือก
  void updateChoice(String choiceKey, String choiceValue) {
    switch (choiceKey) {
      case 'ก':
        manychoiceA = choiceValue;
        break;
      case 'ข':
        manychoiceB = choiceValue;
        break;
      case 'ค':
        manychoiceC = choiceValue;
        break;
      case 'ง':
        manychoiceD = choiceValue;
        break;
      case 'จ':
        manychoiceE = choiceValue;
        break;
      case 'ฉ':
        manychoiceF = choiceValue;
        break;
      case 'ช':
        manychoiceG = choiceValue;
        break;
      case 'ซ':
        manychoiceH = choiceValue;
        break;
    }
  }
}

//-------------------------SubmitOneChoice-------------------------------

class SubmitOneChoice {
  final int submitOneChoiceAuto;
  final int examsetsId;
  final int questionId;
  final String submitOneChoiceReply;
  final double submitOneChoiceScore;
  final String submitOneChoiceTime;
  final String usersUsername;
  final double examsetsFullmark; 

  SubmitOneChoice({
    required this.submitOneChoiceAuto,
    required this.examsetsId,
    required this.questionId,
    required this.submitOneChoiceReply,
    required this.submitOneChoiceScore,
    required this.submitOneChoiceTime,
    required this.usersUsername,
    required this.examsetsFullmark, 
  });

  // ฟังก์ชันสำหรับแปลง JSON เป็นอ็อบเจ็กต์
  factory SubmitOneChoice.fromJson(Map<String, dynamic> json) {
  return SubmitOneChoice(
    submitOneChoiceAuto: json['submit_onechoice_auto'] is int
        ? json['submit_onechoice_auto']
        : int.parse(json['submit_onechoice_auto']),
    examsetsId: json['examsets_id'] is int
        ? json['examsets_id']
        : int.parse(json['examsets_id']),
    questionId: json['question_id'] is int
        ? json['question_id']
        : int.parse(json['question_id']),
    submitOneChoiceReply: json['submit_onechoice_reply'],
    submitOneChoiceScore: json['submit_onechoice_score'] is double
        ? json['submit_onechoice_score']
        : double.parse(json['submit_onechoice_score'].toString()),
    submitOneChoiceTime: json['submit_onechoice_time'],
    usersUsername: json['users_username'],
    examsetsFullmark: json['examsets_fullmark'] is double
        ? json['examsets_fullmark']
        : double.parse(json['examsets_fullmark'].toString()),
  );
}


  // ฟังก์ชันสำหรับแปลงอ็อบเจ็กต์เป็น JSON
  Map<String, dynamic> toJson() {
    return {
      'submit_onechoice_auto': submitOneChoiceAuto,
      'examsets_id': examsetsId,
      'question_id': questionId,
      'submit_onechoice_reply': submitOneChoiceReply,
      'submit_onechoice_score': submitOneChoiceScore,
      'submit_onechoice_time': submitOneChoiceTime,
      'users_username': usersUsername,
      'examsets_fullmark': examsetsFullmark, 
    };
  }
}

//--------------------------------------------------------------------
class SubmitManyChoice {
  final int submitManyChoiceAuto;
  final int examsetsId;
  final int questionId;
  final List<String> submitManyChoiceReply;
  final double submitManyChoiceScore;
  final String submitManyChoiceTime;
  final String usersUsername;

  SubmitManyChoice({
    required this.submitManyChoiceAuto,
    required this.examsetsId,
    required this.questionId,
    required this.submitManyChoiceReply,
    required this.submitManyChoiceScore,
    required this.submitManyChoiceTime,
    required this.usersUsername,
  });

  factory SubmitManyChoice.fromJson(Map<String, dynamic> json) {
    List<String> replyList = [];
    try {
      var replies = json['submit_manychoice_reply'];
      if (replies == null) {
        replyList = [];
      } else if (replies is List) {
        replyList = List<String>.from(replies);
      } else if (replies is Map) {
        replyList = replies.values.map((e) => e.toString()).toList();
      } else if (replies is String) {
        replyList = [replies];
      } else {
        debugPrint("Unexpected type for submit_manychoice_reply: ${replies.runtimeType}");
      }
    } catch (e) {
      debugPrint("Error parsing submit_manychoice_reply: $e");
    }

    // บังคับค่า submitManyChoiceScore ให้เป็นทศนิยม 2 ตำแหน่ง
    double score = 0.0;
    try {
      score = double.parse((json['submit_manychoice_score'] ?? 0).toString());
      score = double.parse(score.toStringAsFixed(2)); // แปลงให้เป็นทศนิยม 2 ตำแหน่ง
    } catch (e) {
      debugPrint("Error parsing submit_manychoice_score: $e");
    }

    return SubmitManyChoice(
      submitManyChoiceAuto: json['submit_manychoice_auto'] ?? 0,
      examsetsId: json['examsets_id'] ?? 0,
      questionId: json['question_id'] ?? 0,
      submitManyChoiceReply: replyList,
      submitManyChoiceScore: score,
      submitManyChoiceTime: json['submit_manychoice_time'] ?? '',
      usersUsername: json['users_username'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'submit_manychoice_auto': submitManyChoiceAuto,
      'examsets_id': examsetsId,
      'question_id': questionId,
      'submit_manychoice_reply': submitManyChoiceReply,
      'submit_manychoice_score': submitManyChoiceScore.toStringAsFixed(2), // บังคับทศนิยม 2 ตำแหน่ง
      'submit_manychoice_time': submitManyChoiceTime,
      'users_username': usersUsername,
    };
  }
}

//---------------------------------------------------------------


class NotificationData_sumit {
  final int id;
  final String title;
  final String classId;
  final String time;
  final String user;
  final bool readStatus;
  final String classroomName;
  final String classroomMajor;
  final String classroomYear;
  final String classroomNumRoom;

  NotificationData_sumit({
    required this.id,
    required this.title,
    required this.classId,
    required this.time,
    required this.user,
    required this.readStatus,
    required this.classroomName,
    required this.classroomMajor,
    required this.classroomYear,
    required this.classroomNumRoom,
  });

  factory NotificationData_sumit.fromMap(Map<String, dynamic> map) {
    return NotificationData_sumit(
      id: int.parse(map['notification_sibmit_auto']),
      title: map['notification_sibmit_title'],
      classId: map['notification_sibmit_classID'],
      time: map['notification_sibmit_time'],
      user: map['notification_sibmit_users'],
      readStatus: map['notification_sibmit_readstatus'] == 'Alreadyread',
      classroomName: map['classroom_name'] ?? '',
      classroomMajor: map['classroom_major'] ?? '',
      classroomYear: map['classroom_year'] ?? '',
      classroomNumRoom: map['classroom_numroom'] ?? '',
    );
  }
}
//--------------------------------------------------------------------------------

class Upfile_submit {
  final int upfileAuto;
  final int examsetsId;
  final String upfileName;
  final int upfileSize;
  final String upfileType;
  final String upfileUrl;

  Upfile_submit({
    required this.upfileAuto,
    required this.examsetsId,
    required this.upfileName,
    required this.upfileSize,
    required this.upfileType,
    required this.upfileUrl,
  });

  // Safe parsing of integers with default value of 0
  static int _parseInt(dynamic value) {
    if (value == null) return 0; // Default to 0 if value is null
    return int.tryParse(value.toString()) ?? 0; // Return 0 if parsing fails
  }

  factory Upfile_submit.fromJson(Map<String, dynamic> json) {
  print('Parsing JSON: $json'); // พิมพ์ข้อมูล JSON ที่จะถูกแปลง
  return Upfile_submit(
    upfileAuto: _parseInt(json['submit_upfile_auto']),
    examsetsId: _parseInt(json['examsets_id']),
    upfileName: json['submit_upfile_name'],
    upfileSize: _parseInt(json['submit_upfile_size']),
    upfileType: json['submit_upfile_type'],
    upfileUrl: json['submit_upfile_url'],
  );
}

}



//-------------------------------------------------------

class CheckworkUpfile {
  final int checkworkUpfileAuto;
  final int examsetsId;
  final String questionDetail;
  final double checkworkUpfileScore;
  final String usersUsername;
  final String checkworkUpfileTime;
  final String checkworkUpfileComments;

  CheckworkUpfile({
    required this.checkworkUpfileAuto,
    required this.examsetsId,
    required this.questionDetail,
    required this.checkworkUpfileScore,
    required this.usersUsername,
    required this.checkworkUpfileTime,
    required this.checkworkUpfileComments,
  });

  factory CheckworkUpfile.fromJson(Map<String, dynamic> json) {
    return CheckworkUpfile(
      checkworkUpfileAuto: int.parse(json['checkwork_upfile_auto']),
      examsetsId: int.parse(json['examsets_id']),
      questionDetail: json['question_detail'],
      checkworkUpfileScore: double.parse(json['checkwork_upfile_score']),
      usersUsername: json['users_username'],
      checkworkUpfileTime: json['checkwork_upfile_time'],
      checkworkUpfileComments: json['checkwork_upfile_comments'],
    );
  }
}

//-------------------------------------------------------------------------

class UserSubmission {
  final String usersUsername;
  final List<Submission> submissions;

  UserSubmission({
    required this.usersUsername,
    required this.submissions,
  });

  factory UserSubmission.fromJson(Map<String, dynamic> json) {
    return UserSubmission(
      usersUsername: json['user']['users_username'],
      submissions: (json['submissions'] as List)
          .map((submission) => Submission.fromJson(submission))
          .toList(),
    );
  }
}

class Submission {
  final int examsetsId;
  final int questionId;
  final String questionDetail;
  final String submitAuswerReply;
  final double questionMark;


  Submission({
    required this.examsetsId,
    required this.questionId,
    required this.questionDetail,
    required this.submitAuswerReply,
    required this.questionMark,
  });

  factory Submission.fromJson(Map<String, dynamic> json) {
    return Submission(
      examsetsId: int.tryParse(json['examsets_id'].toString()) ?? 0,
      questionId: int.tryParse(json['question_id'].toString()) ?? 0,
      questionDetail: json['question_details']['question_detail'] ?? 'No details available',
      submitAuswerReply: json['submit_auswer_reply'] ?? '',
      questionMark: double.tryParse(json['question_details']['auswer_question_score'].toString()) ?? 0,
    );
  }
}



//-----------------------------------------------------------------------------

class AnswerData {
  final int questionId;
  final String questionDetail;
  final double checkworkAuswerScore;
  final String submitAuswerReply;
  final String submitAuswerTime;
  final double? auswerQuestionScore;  

  AnswerData({
    required this.questionId,
    required this.questionDetail,
    required this.checkworkAuswerScore,
    required this.submitAuswerReply,
    required this.submitAuswerTime,
    this.auswerQuestionScore,
  });

  factory AnswerData.fromJson(Map<String, dynamic> json) {
    return AnswerData(
      questionId: json['question_id'] != null ? int.parse(json['question_id']) : 0, // ตรวจสอบค่า null
      questionDetail: json['question_detail'] ?? '', // หาก null ให้เป็นค่าว่าง
      checkworkAuswerScore: json['checkwork_auswer_score'] != null
          ? double.parse(json['checkwork_auswer_score'])
          : 0, // ตรวจสอบค่า null และแปลงเป็น int
      submitAuswerReply: json['submit_auswer_reply'] ?? '', // หาก null ให้เป็นค่าว่าง
      submitAuswerTime: json['submit_auswer_time'] ?? '', // หาก null ให้เป็นค่าว่าง
      auswerQuestionScore: json['auswer_question_score'] != null
          ? double.parse(json['auswer_question_score'])
          : null, // ใช้ null เมื่อไม่มีคะแนน
    );
  }
}//---------------------------------------------------------------------

class GetsubmitauswerData {
  final int questionId;
  final String submitAuswerReply;
  final String submitAuswerTime;
  final double auswerQuestionScore;
  final String questionDetail;

  GetsubmitauswerData({
    required this.questionId,
    required this.submitAuswerReply,
    required this.submitAuswerTime,
    required this.auswerQuestionScore,
    required this.questionDetail,
  });

  // ฟังก์ชันในการแปลง JSON เป็น GetsubmitauswerData
  factory GetsubmitauswerData.fromJson(Map<String, dynamic> json) {
    return GetsubmitauswerData(
      questionId: int.tryParse(json['question_id'].toString()) ?? 0, // แปลง String เป็น int หรือใช้ค่า 0 ถ้าไม่สามารถแปลงได้
      submitAuswerReply: json['submit_auswer_reply'] ?? '',  // ใช้ค่าเริ่มต้นเป็นค่าว่าง ถ้าไม่มีข้อมูล
      submitAuswerTime: json['submit_auswer_time'] ?? '',  // ใช้ค่าเริ่มต้นเป็นค่าว่าง ถ้าไม่มีข้อมูล
      auswerQuestionScore: double.tryParse(json['auswer_question_score'].toString()) ?? 0.0, // แปลง String เป็น double หรือใช้ 0.0 ถ้าไม่สามารถแปลงได้
      questionDetail: json['question_detail'] ?? '',  // ใช้ค่าเริ่มต้นเป็นค่าว่าง ถ้าไม่มีข้อมูล
    );
  }

  // ฟังก์ชันในการแปลง GetsubmitauswerData เป็น JSON
  Map<String, dynamic> toJson() {
    return {
      'question_id': questionId,
      'submit_auswer_reply': submitAuswerReply,
      'submit_auswer_time': submitAuswerTime,
      'auswer_question_score': auswerQuestionScore,
      'question_detail': questionDetail,
    };
  }
}

//--------------------------------------------------

class Chcekscoreonechoicedata {
  final List<OnechoiceData> onechoiceData;
  final List<SubmitOnechoiceData> submitOnechoiceData;

  Chcekscoreonechoicedata({required this.onechoiceData, required this.submitOnechoiceData});

  factory Chcekscoreonechoicedata.fromJson(Map<String, dynamic> json) {
    return Chcekscoreonechoicedata(
      onechoiceData: List<OnechoiceData>.from(json['onechoice_data'].map((x) => OnechoiceData.fromJson(x))),
      submitOnechoiceData: List<SubmitOnechoiceData>.from(json['submit_onechoice_data'].map((x) => SubmitOnechoiceData.fromJson(x))),
    );
  }
}

class OnechoiceData {
  final int onechoiceAuto;
  final int examsetsId;
  final String onechoiceQuestion;
  final String onechoiceA;
  final String onechoiceB;
  final String onechoiceC;
  final String onechoiceD;
  final String onechoiceAnswer;
  final int onechoiceQuestionScore;

  OnechoiceData({
    required this.onechoiceAuto,
    required this.examsetsId,
    required this.onechoiceQuestion,
    required this.onechoiceA,
    required this.onechoiceB,
    required this.onechoiceC,
    required this.onechoiceD,
    required this.onechoiceAnswer,
    required this.onechoiceQuestionScore,
  });

  factory OnechoiceData.fromJson(Map<String, dynamic> json) {
    return OnechoiceData(
      onechoiceAuto: int.tryParse(json['onechoice_auto'].toString()) ?? 0,
      examsetsId: int.tryParse(json['examsets_id'].toString()) ?? 0,
      onechoiceQuestion: json['onechoice_question'] ?? 'N/A',
      onechoiceA: json['onechoice_a'] ?? 'N/A',
      onechoiceB: json['onechoice_b'] ?? 'N/A',
      onechoiceC: json['onechoice_c'] ?? 'N/A',
      onechoiceD: json['onechoice_d'] ?? 'N/A',
      onechoiceAnswer: json['onechoice_answer'] ?? 'N/A',
      onechoiceQuestionScore: int.tryParse(json['onechoice_question_score'].toString()) ?? 0,
    );
  }
}

class SubmitOnechoiceData {
  final int submitOnechoiceAuto;
  final int examsetsId;
  final int questionId;
  final String submitOnechoiceReply;
  final int submitOnechoiceScore;
  final String submitOnechoiceTime;
  final String usersUsername;

  SubmitOnechoiceData({
    required this.submitOnechoiceAuto,
    required this.examsetsId,
    required this.questionId,
    required this.submitOnechoiceReply,
    required this.submitOnechoiceScore,
    required this.submitOnechoiceTime,
    required this.usersUsername,
  });

  factory SubmitOnechoiceData.fromJson(Map<String, dynamic> json) {
    return SubmitOnechoiceData(
      submitOnechoiceAuto: int.tryParse(json['submit_onechoice_auto'].toString()) ?? 0,
      examsetsId: int.tryParse(json['examsets_id'].toString()) ?? 0,
      questionId: int.tryParse(json['question_id'].toString()) ?? 0,
      submitOnechoiceReply: json['submit_onechoice_reply'] ?? 'N/A',
      submitOnechoiceScore: int.tryParse(json['submit_onechoice_score'].toString()) ?? 0,
      submitOnechoiceTime: json['submit_onechoice_time'] ?? 'N/A',
      usersUsername: json['users_username'] ?? 'N/A',
    );
  }
}

//-------------------------------------------------------------------------------
class Chcekscoremanychoicedata {
  final List<ManychoiceData> manychoiceData;
  final List<SubmitManychoiceData> submitManychoiceData;

  Chcekscoremanychoicedata({
    required this.manychoiceData,
    required this.submitManychoiceData,
  });

  factory Chcekscoremanychoicedata.fromJson(Map<String, dynamic> json) {
    return Chcekscoremanychoicedata(
      manychoiceData: (json['manychoice_data'] as List<dynamic>)
          .map((item) => ManychoiceData.fromJson(item as Map<String, dynamic>))
          .toList(),
      submitManychoiceData: (json['submit_manychoice_data'] as List<dynamic>)
          .map((item) =>
              SubmitManychoiceData.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ManychoiceData {
  final int manychoiceAuto;
  final int examsetsId;
  final String manychoiceQuestion;
  final String manychoiceA;
  final String manychoiceB;
  final String manychoiceC;
  final String manychoiceD;
  final String? manychoiceE;
  final String? manychoiceF;
  final String? manychoiceG;
  final String? manychoiceH;
  final String manychoiceAnswer;
  final double manychoiceQuestionScore;

  ManychoiceData({
    required this.manychoiceAuto,
    required this.examsetsId,
    required this.manychoiceQuestion,
    required this.manychoiceA,
    required this.manychoiceB,
    required this.manychoiceC,
    required this.manychoiceD,
    this.manychoiceE,
    this.manychoiceF,
    this.manychoiceG,
    this.manychoiceH,
    required this.manychoiceAnswer,
    required this.manychoiceQuestionScore,
  });

  factory ManychoiceData.fromJson(Map<String, dynamic> json) {
    return ManychoiceData(
      manychoiceAuto: int.tryParse(json['manychoice_auto'].toString()) ?? 0, // แปลงจาก String เป็น int
      examsetsId: int.tryParse(json['examsets_id'].toString()) ?? 0, // แปลงจาก String เป็น int
      manychoiceQuestion: json['manychoice_question'] as String,
      manychoiceA: json['manychoice_a'] as String,
      manychoiceB: json['manychoice_b'] as String,
      manychoiceC: json['manychoice_c'] as String,
      manychoiceD: json['manychoice_d'] as String,
      manychoiceE: json['manychoice_e'] as String?,
      manychoiceF: json['manychoice_f'] as String?,
      manychoiceG: json['manychoice_g'] as String?,
      manychoiceH: json['manychoice_h'] as String?,
      manychoiceAnswer: json['manychoice_answer'] as String,
      manychoiceQuestionScore:
          (json['manychoice_question_score'] is String
              ? double.tryParse(json['manychoice_question_score'].toString()) ?? 0.0
              : (json['manychoice_question_score'] as num).toDouble()), // แปลงจาก String เป็น double
    );
  }
}

class SubmitManychoiceData {
  final int submitManychoiceAuto;
  final int examsetsId;
  final int questionId;
  final String submitManychoiceReply;
  final double submitManychoiceScore;
  final String submitManychoiceTime;
  final String usersUsername;

  SubmitManychoiceData({
    required this.submitManychoiceAuto,
    required this.examsetsId,
    required this.questionId,
    required this.submitManychoiceReply,
    required this.submitManychoiceScore,
    required this.submitManychoiceTime,
    required this.usersUsername,
  });

  factory SubmitManychoiceData.fromJson(Map<String, dynamic> json) {
    return SubmitManychoiceData(
      submitManychoiceAuto: int.tryParse(json['submit_manychoice_auto'].toString()) ?? 0, // แปลงจาก String เป็น int
      examsetsId: int.tryParse(json['examsets_id'].toString()) ?? 0, // แปลงจาก String เป็น int
      questionId: int.tryParse(json['question_id'].toString()) ?? 0, // แปลงจาก String เป็น int
      submitManychoiceReply: json['submit_manychoice_reply'] as String,
      submitManychoiceScore: (json['submit_manychoice_score'] is String
          ? double.tryParse(json['submit_manychoice_score'].toString()) ?? 0.0
          : (json['submit_manychoice_score'] as num).toDouble()), // แปลงจาก String เป็น double
      submitManychoiceTime: json['submit_manychoice_time'] as String,
      usersUsername: json['users_username'] as String,
    );
  }
}
//-------------------------------------------------------------------------------------------------------------------------


// class สำหรับเก็บข้อมูลนักเรียน
class liststudents {
  final String studentNumber;
  final String studentId;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String username;
  final String checkinStatus;

  liststudents({
    required this.studentNumber,
    required this.studentId,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.username,
    required this.checkinStatus,
  });

  factory liststudents.fromJson(Map<String, dynamic> json) {
    return liststudents(
      studentNumber: json['users_number'] ?? '',
      studentId: json['users_id'] ?? '',
      firstName: json['users_thfname'] ?? '',
      lastName: json['users_thlname'] ?? '',
      phoneNumber: json['users_phone'] ?? '',
      username: json['users_username'] ?? '',
      checkinStatus: json['checkin_status'] ?? '-',
    );
  }
}

//-------------------------------------------------------------------------------

class HistoryCheckin {
  final String checkinClassroomAuto;
  final String checkinClassroomDate;
  final String usersUsername;
  final String checkinClassroomClassID;
  final String checkinClassroomStatus;
  final String usersPrefix;
  final String usersThfname;
  final String usersThlname;
  final String usersNumber;
  final String usersId;
  final String usersPhone;
  final double affectiveDomainScore; 

  HistoryCheckin({
    required this.checkinClassroomAuto,
    required this.checkinClassroomDate,
    required this.usersUsername,
    required this.checkinClassroomClassID,
    required this.checkinClassroomStatus,
    required this.usersPrefix,
    required this.usersThfname,
    required this.usersThlname,
    required this.usersNumber,
    required this.usersId,
    required this.usersPhone,
    required this.affectiveDomainScore,
  });

  factory HistoryCheckin.fromJson(Map<String, dynamic> json) {
    return HistoryCheckin(
      checkinClassroomAuto: json['checkin_classroom_auto'],
      checkinClassroomDate: json['checkin_classroom_date'],
      usersUsername: json['users_username'],
      checkinClassroomClassID: json['checkin_classroom_classID'],
      checkinClassroomStatus: json['checkin_classroom_status'],
      usersPrefix: json['users_prefix'],
      usersThfname: json['users_thfname'],
      usersThlname: json['users_thlname'],
      usersNumber: json['users_number'],
      usersId: json['users_id'],
      usersPhone: json['users_phone'],
      affectiveDomainScore: double.tryParse(json['affective_domain_score']?.toString() ?? '0.0') ?? 0.0,
    );
  }
}

//-------------------------------------------------------------
class UserDetails {
  final String usersThfname;
  final String usersThlname;
  final String usersId;
  final int usersNumber;  
  final String usersUsername;

  UserDetails({
    required this.usersThfname,
    required this.usersThlname,
    required this.usersId,
    required this.usersNumber,
    required this.usersUsername,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      usersThfname: json['users_thfname'],
      usersThlname: json['users_thlname'],
      usersId: json['users_id'].toString(), // แปลงให้เป็น String
      usersNumber: int.parse(json['users_number'].toString()), // แปลงให้เป็น int
      usersUsername: json['users_username'],
    );
  }
}

class ExamsetDetails {
  final int examsetId;
  final String examsetDirection;
  final String examsetFullMark;
  final String examsetTime;
  final String examsetType;

  ExamsetDetails({
    required this.examsetId,
    required this.examsetDirection,
    required this.examsetFullMark,
    required this.examsetTime,
    required this.examsetType,
  });

  factory ExamsetDetails.fromJson(Map<String, dynamic> json) {
    return ExamsetDetails(
      examsetId: int.parse(json['examsets_auto'].toString()), // แปลงให้เป็น int
      examsetDirection: json['examsets_direction'],
      examsetFullMark: json['examsets_fullmark'].toString(), // แปลงให้เป็น String
      examsetTime: json['examsets_time'],
      examsetType: json['examsets_type'],
    );
  }

  String getFormattedExamsetTime() {
    if (examsetTime.isEmpty) {
      return 'Invalid Date'; // ถ้าเป็น null หรือว่าง ให้คืนค่าที่เหมาะสม
    }

    try {
      DateTime parsedDate = DateTime.parse(examsetTime);
      return DateFormat('dd-MM-yyyy').format(parsedDate);
    } catch (e) {
      return 'Invalid Date'; // กรณีที่ไม่สามารถแปลงเป็นวันที่ได้
    }
  }
}

class Score {
  final int examsetId;
  final String username;
  final String scoreTotal;
  final String scoreType;

  Score({
    required this.examsetId,
    required this.username,
    required this.scoreTotal,
    required this.scoreType,
  });

  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      examsetId: json['examsets_id'] != null ? int.parse(json['examsets_id'].toString()) : 0, // ตรวจสอบค่า null
      username: json['users_username'] ?? '', 
      scoreTotal: json['score_total']?.toString() ?? '0',
      scoreType: json['score_type'] ?? '', 
    );
  }
}

class ScoreStudentsInClass {
  final List<UserDetails> userDetails;
  final List<ExamsetDetails> examsetsDetails;
  final List<Score> scores;

  ScoreStudentsInClass({
    required this.userDetails,
    required this.examsetsDetails,
    required this.scores,
  });

  factory ScoreStudentsInClass.fromJson(Map<String, dynamic> json) {
    return ScoreStudentsInClass(
      userDetails: (json['userDetails'] as List)
          .map((item) => UserDetails.fromJson(item))
          .toList(),
      examsetsDetails: (json['examsetsDetails'] as List)
          .map((item) => ExamsetDetails.fromJson(item))
          .toList(),
      scores: (json['scores'] as List)
          .map((item) => Score.fromJson(item))
          .toList(),
    );
  }
}

//-----------------------------------------------------------------------------

class Studentdetailwork {
  String usersUsername;
  String usersNumber;
  String usersPrefix;
  String usersThfname;
  String usersThlname;

  Studentdetailwork({
    required this.usersUsername,
    required this.usersNumber,
    required this.usersPrefix,
    required this.usersThfname,
    required this.usersThlname,
  });

  // สร้าง factory constructor เพื่อแปลงจาก Map (ข้อมูลที่ได้จาก API)
  factory Studentdetailwork.fromJson(Map<String, dynamic> json) {
    return Studentdetailwork(
      usersUsername: json['users_username'],
      usersNumber: json['users_number'].toString(),
      usersPrefix: json['users_prefix'] ?? '',
      usersThfname: json['users_thfname'] ?? '',
      usersThlname: json['users_thlname'] ?? '',
    );
  }

  // แปลงเป็น Map เพื่อใช้ในการแสดงผลหรือติดต่อกับ API
  Map<String, dynamic> toJson() {
    return {
      'users_username': usersUsername,
      'users_number': usersNumber,
      'users_prefix': usersPrefix,
      'users_thfname': usersThfname,
      'users_thlname': usersThlname,
    };
  }
}

//--------------------------------------------------------------------------------------------------------

class ScoreForStudents {
  final List<ExamSet> examsets;
  final List<Scoretostudents> scores;

  ScoreForStudents({
    required this.examsets,
    required this.scores,
  });

  factory ScoreForStudents.fromJson(Map<String, dynamic> json) {
    try {
      return ScoreForStudents(
        examsets: (json['examsets'] as List)
            .map((exam) => ExamSet.fromJson(exam))
            .toList(),
        scores: (json['scores'] as List)
            .map((score) => Scoretostudents.fromJson(score))
            .toList(),
      );
    } catch (e) {
      print("Error while parsing ScoreForStudents: $e");
      return ScoreForStudents(examsets: [], scores: []);
    }
  }
}

class ExamSet {
  final int examsetsAuto;
  final String direction;
  final double fullmark;
  final String deadline;
  final int classroomId;

  ExamSet({
    required this.examsetsAuto,
    required this.direction,
    required this.fullmark,
    required this.deadline,
    required this.classroomId,
  });

  factory ExamSet.fromJson(Map<String, dynamic> json) {
    try {
      return ExamSet(
        examsetsAuto: json['examsets_auto'] is String 
            ? int.tryParse(json['examsets_auto']) ?? 0 
            : json['examsets_auto'],
        direction: json['examsets_direction'] ?? 'N/A',
        fullmark: json['examsets_fullmark'] is String 
            ? double.tryParse(json['examsets_fullmark']) ?? 0.0 
            : json['examsets_fullmark'],
        deadline: json['examsets_deadline'] ?? 'N/A',
        classroomId: json['classroom_id'] is String
            ? int.tryParse(json['classroom_id']) ?? 0
            : json['classroom_id'],
      );
    } catch (e) {
      print("Error while parsing ExamSet: $e");
      return ExamSet(
        examsetsAuto: 0,
        direction: 'N/A',
        fullmark: 0.0,
        deadline: 'N/A',
        classroomId: 0,
      );
    }
  }
}

class Scoretostudents {
  final int scoreAuto;
  final int examsetsId;
  final double scoreTotal;
  final String scoreType;
  final String username;

  Scoretostudents({
    required this.scoreAuto,
    required this.examsetsId,
    required this.scoreTotal,
    required this.scoreType,
    required this.username,
  });

  factory Scoretostudents.fromJson(Map<String, dynamic> json) {
    try {
      return Scoretostudents(
        scoreAuto: json['score_auto'] is String
            ? int.tryParse(json['score_auto']) ?? 0
            : json['score_auto'],
        examsetsId: json['examsets_id'] is String
            ? int.tryParse(json['examsets_id']) ?? 0
            : json['examsets_id'],
        scoreTotal: json['score_total'] is String
            ? double.tryParse(json['score_total']) ?? 0.0
            : json['score_total'],
        scoreType: json['score_type'] ?? 'N/A',
        username: json['users_username'] ?? 'N/A',
      );
    } catch (e) {
      print("Error while parsing Scoretostudents: $e");
      return Scoretostudents(
        scoreAuto: 0,
        examsetsId: 0,
        scoreTotal: 0.0,
        scoreType: 'N/A',
        username: 'N/A',
      );
    }
  }
}

//--------------------------------------------------------------------------
class AffectiveForStudents {
  final int checkinAuto;
  final String checkinDate;
  final String username;
  final int classroomId;
  final String checkinStatus;

  AffectiveForStudents({
    required this.checkinAuto,
    required this.checkinDate,
    required this.username,
    required this.classroomId,
    required this.checkinStatus,
  });

  // ฟังก์ชันแปลง JSON เป็น Object
  factory AffectiveForStudents.fromJson(Map<String, dynamic> json) {
    return AffectiveForStudents(
      checkinAuto: int.parse(json['checkin_classroom_auto']),
      checkinDate: json['checkin_classroom_date'],
      username: json['users_username'],
      classroomId: int.parse(json['checkin_classroom_classID']),
      checkinStatus: json['checkin_classroom_status'],
    );
  }

  // ฟังก์ชันแปลง Object เป็น JSON (ถ้าต้องการ)
  Map<String, dynamic> toJson() {
    return {
      'checkin_classroom_auto': checkinAuto,
      'checkin_classroom_date': checkinDate,
      'users_username': username,
      'checkin_classroom_classID': classroomId,
      'checkin_classroom_status': checkinStatus,
    };
  }
}

//-------------------------------------------------------------------
class DataProfileT {
  final int usertAuto;
  final String usertUsername;
  final String usertPassword;
  final String usertPrefix;
  final String usertThfname;
  final String usertThlname;
  final String usertEnfname;
  final String usertEnlname;
  final String usertClassroom;
  final String usertNumroom;
  final String usertPhone;
  final String usertEmail;
  final String usertSubjects;

  DataProfileT({
    required this.usertAuto,
    required this.usertUsername,
    required this.usertPassword,
    required this.usertPrefix,
    required this.usertThfname,
    required this.usertThlname,
    required this.usertEnfname,
    required this.usertEnlname,
    required this.usertClassroom,
    required this.usertNumroom,
    required this.usertPhone,
    required this.usertEmail,
    required this.usertSubjects,
  });

  // ฟังก์ชันจาก JSON มาเป็น object
  factory DataProfileT.fromJson(Map<String, dynamic> json) {
  return DataProfileT(
    usertAuto: int.tryParse(json['usert_auto']?.toString() ?? '0') ?? 0,
    usertUsername: json['usert_username'] ?? '',
    usertPassword: json['usert_password'] ?? '',
    usertPrefix: json['usert_prefix'] ?? '',
    usertThfname: json['usert_thfname'] ?? '',
    usertThlname: json['usert_thlname'] ?? '',
    usertEnfname: json['usert_enfname'] ?? '',
    usertEnlname: json['usert_enlname'] ?? '',
    usertClassroom: json['usert_classroom'] ?? '',
    usertNumroom: json['usert_numroom'] ?? '',
    usertPhone: json['usert_phone'] ?? '',
    usertEmail: json['usert_email'] ?? '',
    usertSubjects: json['usert_subjects'] ?? '',
  );
}


  // ฟังก์ชันแปลงเป็น JSON
    Map<String, dynamic> toJson() {
    return {
      'usert_auto': usertAuto,
      'usert_username': usertUsername,
      'usert_password': usertPassword,
      'usert_prefix': usertPrefix,
      'usert_thfname': usertThfname,
      'usert_thlname': usertThlname,
      'usert_enfname': usertEnfname,
      'usert_enlname': usertEnlname,
      'usert_classroom': usertClassroom,
      'usert_numroom': usertNumroom,
      'usert_phone': usertPhone,
      'usert_email': usertEmail,
      'usert_subjects': usertSubjects,
    }..removeWhere((key, value) => value == null || value == ''); 
  }
}

//-------------------------------------------------------------------------------------

class Studentclass {
  final String usersAuto;
  final String usersUsername;
  final String usersId;
  final String usersPrefix;
  final String usersThfname;
  final String usersThlname;
  final String usersEnfname;
  final String usersEnlname;
  final String usersClassroom;
  final String usersNumroom;
  final String usersNumber;
  final String usersMajor;
  final String usersPhone;
  final String usersParentphone;
  final String usersEmail;
  final String usertUsername;

  Studentclass({
    required this.usersAuto,
    required this.usersUsername,
    required this.usersId,
    required this.usersPrefix,
    required this.usersThfname,
    required this.usersThlname,
    required this.usersEnfname,
    required this.usersEnlname,
    required this.usersClassroom,
    required this.usersNumroom,
    required this.usersNumber,
    required this.usersMajor,
    required this.usersPhone,
    required this.usersParentphone, 
    required this.usersEmail,
    required this.usertUsername,
  });

  factory Studentclass.fromJson(Map<String, dynamic> json) {
  return Studentclass(
    usersAuto: json['users_auto'] ?? '',
    usersUsername: json['users_username'] ?? '',
    usersId: json['users_id'] ?? '',
    usersPrefix: json['users_prefix'] ?? '',
    usersThfname: json['users_thfname'] ?? '',
    usersThlname: json['users_thlname'] ?? '',
    usersEnfname: json['users_enfname'] ?? '',
    usersEnlname: json['users_enlname'] ?? '',
    usersClassroom: json['users_classroom'] ?? '',
    usersNumroom: json['users_numroom'] ?? '',
    usersNumber: json['users_number'] ?? '',
    usersMajor: json['users_major'] ?? '',
    usersPhone: json['users_phone'] ?? '',
    usersParentphone: json['users_parentphone'] ?? '',
    usersEmail: json['users_email'] ?? '',
    usertUsername: json['usert_username'] ?? '',
  );
}
}
//---------------------------------------------------------------------------

class UserTeacher {
  final int userAuto;
  final String username;
  final String password;
  final String prefix;
  final String thFName;
  final String thLName;
  final String enFName;
  final String enLName;
  final String classroom;
  final String numRoom;
  final String phone;
  final String email;
  final String subjects;

  UserTeacher({
    required this.userAuto,
    required this.username,
    required this.password,
    required this.prefix,
    required this.thFName,
    required this.thLName,
    required this.enFName,
    required this.enLName,
    required this.classroom,
    required this.numRoom,
    required this.phone,
    required this.email,
    required this.subjects,
  });

  // ฟังก์ชันสำหรับแปลง JSON เป็นอ็อบเจกต์
  factory UserTeacher.fromJson(Map<String, dynamic> json) {
  return UserTeacher(
    userAuto: int.tryParse(json['usert_auto'].toString()) ?? 0, // แปลง String เป็น int
    username: json['usert_username'] ?? '',
    password: json['usert_password'] ?? '',
    prefix: json['usert_prefix'] ?? '',
    thFName: json['usert_thfname'] ?? '',
    thLName: json['usert_thlname'] ?? '',
    enFName: json['usert_enfname'] ?? '',
    enLName: json['usert_enlname'] ?? '',
    classroom: json['usert_classroom'] ?? '',
    numRoom: json['usert_numroom'] ?? '',
    phone: json['usert_phone'] ?? '',
    email: json['usert_email'] ?? '',
    subjects: json['usert_subjects'] ?? '',
  );
}
}
//---------------------------------------------------------------------------------
class UserStudents {
  final int usersAuto;
  final String usersUsername;
  final String usersPassword;
  final String usersId;
  final String usersPrefix;
  final String usersThfname;
  final String usersThlname;
  final String usersEnfname;
  final String usersEnlname;
  final String usersClassroom;
  final String usersNumroom;
  final String usersNumber;
  final String usersMajor;
  final String usersPhone;
  final String usersParentphone;
  final String usersEmail;
  final String usertUsername;

  UserStudents({
    required this.usersAuto,
    required this.usersUsername,
    required this.usersPassword,
    required this.usersId,
    required this.usersPrefix,
    required this.usersThfname,
    required this.usersThlname,
    required this.usersEnfname,
    required this.usersEnlname,
    required this.usersClassroom,
    required this.usersNumroom,
    required this.usersNumber,
    required this.usersMajor,
    required this.usersPhone,
    required this.usersParentphone,
    required this.usersEmail,
    required this.usertUsername,
  });

  // สร้างเมธอด factory เพื่อแปลงข้อมูล JSON เป็นอ็อบเจ็กต์ UserStudents
  factory UserStudents.fromJson(Map<String, dynamic> json) {
    return UserStudents(
      usersAuto: int.tryParse(json['users_auto'].toString()) ?? 0,
      usersUsername: json['users_username'],
      usersPassword: json['users_password'],
      usersId: json['users_id'],
      usersPrefix: json['users_prefix'],
      usersThfname: json['users_thfname'],
      usersThlname: json['users_thlname'],
      usersEnfname: json['users_enfname'],
      usersEnlname: json['users_enlname'],
      usersClassroom: json['users_classroom'],
      usersNumroom: json['users_numroom'],
      usersNumber: json['users_number'],
      usersMajor: json['users_major'],
      usersPhone: json['users_phone'],
      usersParentphone: json['users_parentphone'],
      usersEmail: json['users_email'],
      usertUsername: json['usert_username'],
    );
  }
}
