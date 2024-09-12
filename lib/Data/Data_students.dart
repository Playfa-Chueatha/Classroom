class liststudents {
  final String firstnamestudents;
  final String lastnamestudents;
  final int numroom;
  final int IDstudents;
  final String email;

  liststudents({
    required this.firstnamestudents,
    required this.lastnamestudents,
    required this.numroom,
    required this.IDstudents,
    required this.email,
  });
}

List<liststudents> dataliststudents = [
  liststudents(
    firstnamestudents: 'ปลายฟ้า', 
    lastnamestudents: 'เชื้อถา', 
    numroom: 1,
    IDstudents: 631432060285, 
    email:'paiyfa.1@gmail.com', 
  ),

  liststudents(
    firstnamestudents: 'เลิศรัตนโสภาพิบูรณ์', 
    lastnamestudents: 'ชัยศรีรัตน์ศิริกุล', 
    numroom: 2, 
    IDstudents: 631432060295, 
    email:'copter.test@gmail.com',
  ),

  liststudents(
    firstnamestudents: 'อัครวุติ', 
    lastnamestudents: 'สวัสดิรักษา', 
    numroom: 3,
    IDstudents: 631432060305, 
    email:'doae.test@gmail.com', 
  )
];


