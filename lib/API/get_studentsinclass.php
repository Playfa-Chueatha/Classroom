<?php
include 'connect.php';

// สร้างการเชื่อมต่อ
$conn = new mysqli($servername, $username, $password, $dbname);

// ตรวจสอบการเชื่อมต่อ
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// ดึงค่าพารามิเตอร์จาก URL
$classroom_name = $_GET['classroom_name'] ?? '';
$classroom_major = $_GET['classroom_major'] ?? '';
$classroom_year = $_GET['classroom_year'] ?? '';
$classroom_numroom = $_GET['classroom_numroom'] ?? '';

// คำสั่ง SQL สำหรับดึงข้อมูลนักเรียนที่อยู่ในห้องเรียนและถูกลบ
$query = "
SELECT 
    us.users_number,
    us.users_id,
    us.users_thfname,
    us.users_thlname,
    us.users_major,
    sic.inclass_type
FROM
    user_students us
JOIN
    students_inclass sic ON us.users_username = sic.users_username
JOIN
    classroom c ON sic.classroom_id = c.classroom_id
WHERE
    c.classroom_name = '$classroom_name'
    AND c.classroom_major = '$classroom_major'
    AND c.classroom_year = '$classroom_year'
    AND c.classroom_numroom = '$classroom_numroom';
";

$result = $conn->query($query);

$studentsInClass = [];
$removedStudents = [];

if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        if ($row['inclass_type'] == 0) {
            // นักเรียนในห้องเรียน
            $studentsInClass[] = $row;
        } else {
            // นักเรียนที่ถูกลบออก
            $removedStudents[] = $row;
        }
    }
}

// แสดงผลข้อมูลในรูปแบบ JSON
echo json_encode([
    'students_in_class' => $studentsInClass,
    'removed_students' => $removedStudents
]);

// ปิดการเชื่อมต่อ
$conn->close();
?>
