<?php
include "connect.php";

// ตรวจสอบการรับค่าจาก UI ผ่าน GET
$classroom_name = isset($_GET['classroomName']) ? $_GET['classroomName'] : null;
$classroom_major = isset($_GET['classroomMajor']) ? $_GET['classroomMajor'] : null;
$classroom_year = isset($_GET['classroomYear']) ? $_GET['classroomYear'] : null;
$classroom_numroom = isset($_GET['classroomNumRoom']) ? $_GET['classroomNumRoom'] : null;
$users_id = isset($_GET['usersId']) ? $_GET['usersId'] : null;

// ตรวจสอบว่าได้รับค่าทั้งหมดหรือไม่
if ($classroom_name === null || $classroom_major === null || $classroom_year === null || $classroom_numroom === null || $users_id === null) {
    echo json_encode(['status' => 'error', 'message' => 'ข้อมูลไม่ครบถ้วน']);
    exit();
}

try {
    // เชื่อมต่อฐานข้อมูล
    $conn = new PDO("mysql:host=$servername;dbname=$dbname;charset=utf8", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // ค้นหาค่า classroom_id จาก classroom
    $stmt = $conn->prepare("SELECT classroom_id FROM classroom WHERE classroom_name = :classroom_name 
                            AND classroom_major = :classroom_major AND classroom_year = :classroom_year
                            AND classroom_numroom = :classroom_numroom");
    $stmt->execute([
        ':classroom_name' => $classroom_name,
        ':classroom_major' => $classroom_major,
        ':classroom_year' => $classroom_year,
        ':classroom_numroom' => $classroom_numroom,
    ]);
    $classroom = $stmt->fetch(PDO::FETCH_ASSOC);

    // ตรวจสอบว่าได้ classroom_id หรือไม่
    if (!$classroom) {
        echo json_encode(['status' => 'error', 'message' => 'ไม่พบข้อมูลห้องเรียน']);
        exit();
    }

    $classroom_id = $classroom['classroom_id'];

    // ค้นหาค่า users_username จาก users_id
    $stmt = $conn->prepare("SELECT users_username FROM user_students WHERE users_id = :users_id");
    $stmt->execute([':users_id' => $users_id]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);

    // ตรวจสอบว่าได้ users_username หรือไม่
    if (!$user) {
        echo json_encode(['status' => 'error', 'message' => 'ไม่พบข้อมูลผู้ใช้']);
        exit();
    }

    $users_username = $user['users_username'];

    // บันทึกข้อมูลลงใน students_inclass
    $stmt = $conn->prepare("INSERT INTO students_inclass (classroom_id, users_username, inclass_type) 
                            VALUES (:classroom_id, :users_username, 0)");
    $stmt->execute([
        ':classroom_id' => $classroom_id,
        ':users_username' => $users_username,
    ]);

    echo json_encode(['status' => 'success', 'message' => 'เพิ่มนักเรียนลงในห้องเรียนสำเร็จ']);
} catch (PDOException $e) {
    echo json_encode(['status' => 'error', 'message' => $e->getMessage()]);
}
?>
