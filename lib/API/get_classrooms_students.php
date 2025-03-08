<?php
header("Access-Control-Allow-Origin: *");
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
header('Access-Control-Allow-Headers: *');
header('Access-Control-Max-Age: 86400');

include "connect.php";

try {
    // เชื่อมต่อฐานข้อมูล
    $conn = new PDO("mysql:host=$servername;dbname=$dbname;charset=utf8", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // ตรวจสอบว่ามีการส่ง username เข้ามาหรือไม่
    if (!isset($_GET['username'])) {
        echo json_encode(['error' => 'Username parameter is missing']);
        exit;
    }

    $loginUsername = $_GET['username'];

    // Query เพื่อดึงข้อมูลจาก students_inclass โดยกรองเฉพาะข้อมูลที่มี inclass_type != 1
    $stmt = $conn->prepare("SELECT classroom_id, users_username FROM students_inclass WHERE users_username = :loginUsername AND inclass_type != 1");
    $stmt->bindParam(':loginUsername', $loginUsername);
    $stmt->execute();
    $studentData = $stmt->fetchAll(PDO::FETCH_ASSOC);

    $classroomDetails = [];

    foreach ($studentData as $student) {
        // ดึงข้อมูลห้องเรียนจาก classroom โดยใช้ classroom_id ที่ได้จาก students_inclass
        $stmtClassroom = $conn->prepare("SELECT classroom_id, classroom_name, classroom_major, classroom_year, classroom_subjectsID, classroom_numroom, classroom_detail, classroom_type, usert_username FROM classroom WHERE classroom_id = :classroomId  AND classroom_type = 0");
        $stmtClassroom->bindParam(':classroomId', $student['classroom_id']);
        $stmtClassroom->execute();
        $classroomInfo = $stmtClassroom->fetch(PDO::FETCH_ASSOC);

        if ($classroomInfo) {
            $classroomDetails[] = $classroomInfo;
        }
    }

    // ส่งผลลัพธ์กลับในรูปแบบ JSON
    echo json_encode($classroomDetails);

} catch (PDOException $e) {
    error_log("Connection failed: " . $e->getMessage());
    echo json_encode(['error' => 'Connection failed.']);
}
?>
