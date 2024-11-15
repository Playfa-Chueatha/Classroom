//Announct--------------------------------
class DataAnnounce {
  final String annonceid;
  final String annoncetext;
  final String file;
  final String link;
  final String usertThfname;
  final String usertThlname;
  final String classroomid;

  DataAnnounce({
    required this.annonceid,
    required this.annoncetext,
    required this.file,
    required this.link,
    required this.usertThfname,
    required this.usertThlname,
    required this.classroomid
  });
}


List<DataAnnounce> dataAnnounce = [];

// comment----------------------------------------
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


