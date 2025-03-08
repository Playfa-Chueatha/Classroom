<?php
include "connect.php";

// เช็คว่า 'username' มีค่าหรือไม่ใน $_GET
if (!isset($_GET['username']) || empty($_GET['username'])) {
    echo json_encode(['error' => 'Username parameter is missing or empty']);
    exit;
}

// รับค่า username ที่ส่งมาจาก Flutter
$user = $_GET['username'];

// เตรียม Query ด้วย PDO โดยเพิ่มเงื่อนไข classroom_type = 0
$sql = "SELECT classroom_id, classroom_name, classroom_major, classroom_year, classroom_subjectsID, classroom_numroom, classroom_detail, classroom_type, usert_username 
        FROM classroom 
        WHERE usert_username = :username AND classroom_type = 0";  // เพิ่มเงื่อนไขนี้

// เตรียม statement และ bind ค่า
$stmt = $conn->prepare($sql);
$stmt->bindParam(':username', $user, PDO::PARAM_STR);

// Execute query และเก็บผลลัพธ์
$stmt->execute();
$classrooms = $stmt->fetchAll(PDO::FETCH_ASSOC);

// ส่งข้อมูลในรูปแบบ JSON
echo json_encode($classrooms);
?>
