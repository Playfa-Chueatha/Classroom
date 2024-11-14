//Model

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


