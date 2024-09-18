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

List<ClassroomData> data = [
  ClassroomData(
    Name_class: "คณิตศาสตร์", 
    Section_class: "วิทยาศาสตร์-คณิตศาสตร์", 
    Room_year: 4, 
    Room_No: 9, 
    School_year: 2567, 
    Detail: " "),

    ClassroomData(
    Name_class: "ภาษาไทย", 
    Section_class: "อังกฤษ-สังคม", 
    Room_year: 4, 
    Room_No: 1, 
    School_year: 2567, 
    Detail: " "),

    ClassroomData(
    Name_class: "ภาษาจีน", 
    Section_class: "อังกฤษ-จีน", 
    Room_year: 4, 
    Room_No: 4, 
    School_year: 2567, 
    Detail: " เวลา 09.00-10.00 น."),

    ClassroomData(
    Name_class: "เคมี", 
    Section_class: "วิทยาศาสตร์-คณิตศาสตร์", 
    Room_year: 4, 
    Room_No: 10, 
    School_year: 2567, 
    Detail: " ")
];




