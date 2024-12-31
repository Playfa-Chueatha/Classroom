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
  final int onechoiceQuestionScore;  

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
      onechoiceQuestionScore: json['onechoice_question_score'] is int
          ? json['onechoice_question_score']
          : int.parse(json['onechoice_question_score'].toString()), 
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
  final String manychoiceQuestion;
  final String manychoiceA;
  final String manychoiceB;
  final String manychoiceC;
  final String manychoiceD;
  final String manychoiceE;
  final String manychoiceF;
  final String manychoiceG;
  final String manychoiceH;
  final String manychoiceAnswer;
  final int manychoiceQuestionScore;

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
      manychoiceQuestionScore: int.parse(json['manychoice_question_score']),
    );
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
    var replies = json['submit_manychoice_reply'];
    List<String> replyList = [];

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
      replyList = [];
    }

    return SubmitManyChoice(
      submitManyChoiceAuto: json['submit_manychoice_auto'] ?? 0,
      examsetsId: json['examsets_id'] ?? 0,
      questionId: json['question_id'] ?? 0,
      submitManyChoiceReply: replyList,
      submitManyChoiceScore: (json['submit_manychoice_score'] ?? 0).toDouble(),
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
      'submit_manychoice_score': submitManyChoiceScore,
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

  factory Upfile_submit.fromJson(Map<String, dynamic> json) {
    return Upfile_submit(
      upfileAuto: int.parse(json['submit_upfile_auto']),
      examsetsId: int.parse(json['examsets_id']),
      upfileName: json['submit_upfile_name'],
      upfileSize: int.parse(json['submit_upfile_size']),
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
  final int checkworkUpfileScore;
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
      checkworkUpfileScore: int.parse(json['checkwork_upfile_score']),
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
  final int questionMark;


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
      questionMark: int.tryParse(json['question_details']['auswer_question_score'].toString()) ?? 0,
    );
  }
}



//-----------------------------------------------------------------------------

class AnswerData {
  final int questionId;
  final String questionDetail;
  final int checkworkAuswerScore;
  final String submitAuswerReply;
  final String submitAuswerTime;
  final int? auswerQuestionScore;  

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
          ? int.parse(json['checkwork_auswer_score'])
          : 0, // ตรวจสอบค่า null และแปลงเป็น int
      submitAuswerReply: json['submit_auswer_reply'] ?? '', // หาก null ให้เป็นค่าว่าง
      submitAuswerTime: json['submit_auswer_time'] ?? '', // หาก null ให้เป็นค่าว่าง
      auswerQuestionScore: json['auswer_question_score'] != null
          ? int.parse(json['auswer_question_score'])
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
  final String affectiveDomainScore; 

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
      affectiveDomainScore: json['affective_domain_score'] ?? '',
    );
  }
}

//-------------------------------------------------------------
class UserDetail {
  final String thFname;
  final String thLname;
  final String userId;
  final String userNumber;
  final String username;

  UserDetail({
    required this.thFname,
    required this.thLname,
    required this.userId,
    required this.userNumber,
    required this.username,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) {
    return UserDetail(
      thFname: json['users_thfname'],
      thLname: json['users_thlname'],
      userId: json['users_id'],
      userNumber: json['users_number'],
      username: json['users_username'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'users_thfname': thFname,
      'users_thlname': thLname,
      'users_id': userId,
      'users_number': userNumber,
      'users_username': username,
    };
  }
}

class Score {
  final String scoreId;
  final String examsetId;
  final String scoreTotal;
  final String scoreType;
  final String username;

  Score({
    required this.scoreId,
    required this.examsetId,
    required this.scoreTotal,
    required this.scoreType,
    required this.username,
  });

  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      scoreId: json['score_auto'],
      examsetId: json['examsets_id'],
      scoreTotal: json['score_total'],
      scoreType: json['score_type'],
      username: json['users_username'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'score_auto': scoreId,
      'examsets_id': examsetId,
      'score_total': scoreTotal,
      'score_type': scoreType,
      'users_username': username,
    };
  }
}

class ExamsetDetail {
  final String examsetId;
  final String examsetDirection;
  final String examsetFullMark;
  final String examsetDeadline;
  final String examsetTime;
  final String examsetType;
  final bool examsetClosed;
  final String examsetInspectionStatus;

  ExamsetDetail({
    required this.examsetId,
    required this.examsetDirection,
    required this.examsetFullMark,
    required this.examsetDeadline,
    required this.examsetTime,
    required this.examsetType,
    required this.examsetClosed,
    required this.examsetInspectionStatus,
  });

  factory ExamsetDetail.fromJson(Map<String, dynamic> json) {
    return ExamsetDetail(
      examsetId: json['examsets_auto'],
      examsetDirection: json['examsets_direction'],
      examsetFullMark: json['examsets_fullmark'],
      examsetDeadline: json['examsets_deadline'],
      examsetTime: json['examsets_time'],
      examsetType: json['examsets_type'],
      examsetClosed: json['examsets_closed'] == 1,
      examsetInspectionStatus: json['examsets_Inspection_status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'examsets_auto': examsetId,
      'examsets_direction': examsetDirection,
      'examsets_fullmark': examsetFullMark,
      'examsets_deadline': examsetDeadline,
      'examsets_time': examsetTime,
      'examsets_type': examsetType,
      'examsets_closed': examsetClosed ? 1 : 0,
      'examsets_Inspection_status': examsetInspectionStatus,
    };
  }
}

class ScoreStudentsInClass {
  final List<UserDetail> userDetails;
  final List<Score> scores;
  final List<ExamsetDetail> examsetDetails; // Add examsetDetails here

  ScoreStudentsInClass({
    required this.userDetails,
    required this.scores,
    required this.examsetDetails, // Include examsetDetails in constructor
  });

  factory ScoreStudentsInClass.fromJson(Map<String, dynamic> json) {
    return ScoreStudentsInClass(
      userDetails: (json['userDetails'] as List)
          .map((item) => UserDetail.fromJson(item))
          .toList(),
      scores: (json['scores'] as List)
          .map((item) => Score.fromJson(item))
          .toList(),
      examsetDetails: (json['examsetsDetails'] as List) // Ensure to parse examsetDetails
          .map((item) => ExamsetDetail.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userDetails': userDetails.map((item) => item.toJson()).toList(),
      'scores': scores.map((item) => item.toJson()).toList(),
      'examsetsDetails': examsetDetails.map((item) => item.toJson()).toList(),
    };
  }
}