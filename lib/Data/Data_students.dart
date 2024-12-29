


//------------------------------------------------------------------------------------------------------------>>>>>

//settingclassroom
class Student {
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

  Student({
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
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      usersAuto: json['users_auto'],
      usersUsername: json['users_username'],
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