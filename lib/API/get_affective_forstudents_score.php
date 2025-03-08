<?php
include "connect.php"; // เชื่อมต่อฐานข้อมูล

header('Content-Type: application/json; charset=utf-8');

try {
    // รับค่าจาก Flutter
    $classroomName = $_POST['classroomName'] ?? '';
    $classroomMajor = $_POST['classroomMajor'] ?? '';
    $classroomYear = $_POST['classroomYear'] ?? '';
    $classroomNumRoom = $_POST['classroomNumRoom'] ?? '';
    $username = $_POST['username'] ?? '';

    // ตรวจสอบค่าที่รับมาว่าครบถ้วน
    if (empty($classroomName) || empty($classroomMajor) || empty($classroomYear) || empty($classroomNumRoom) || empty($username)) {
        echo json_encode(['error' => 'Missing parameters.']);
        exit;
    }

    // หา classroom_id
    $stmt = $conn->prepare("
        SELECT classroom_id 
        FROM classroom 
        WHERE classroom_name = :classroomName 
        AND classroom_major = :classroomMajor 
        AND classroom_year = :classroomYear 
        AND classroom_numroom = :classroomNumRoom
    ");
    $stmt->execute([
        ':classroomName' => $classroomName,
        ':classroomMajor' => $classroomMajor,
        ':classroomYear' => $classroomYear,
        ':classroomNumRoom' => $classroomNumRoom,
    ]);

    $classroom = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$classroom) {
        echo json_encode(['error' => 'Classroom not found.']);
        exit;
    }

    $classroom_id = $classroom['classroom_id'];

    // ดึงข้อมูลจากตาราง checkin_classroom
    $stmt = $conn->prepare("
        SELECT checkin_classroom_auto, checkin_classroom_date, users_username, checkin_classroom_classID, checkin_classroom_status 
        FROM checkin_classroom 
        WHERE checkin_classroom_classID = :classroom_id 
        AND users_username = :username
    ");
    $stmt->execute([
        ':classroom_id' => $classroom_id,
        ':username' => $username,
    ]);

    $checkinData = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // ส่งผลลัพธ์กลับไปที่ Flutter
    echo json_encode([
        'classroom_id' => $classroom_id,
        'checkin_data' => $checkinData,
    ]);
} catch (Exception $e) {
    error_log("Error: " . $e->getMessage());
    echo json_encode(['error' => 'An error occurred.']);
    exit;
}
