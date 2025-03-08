<?php
// ตั้งค่า CORS (Cross-Origin Resource Sharing)
header("Access-Control-Allow-Origin: *");
header('Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, PATCH, DELETE');
header('Access-Control-Allow-Headers: *');
header('Access-Control-Max-Age: 86400');

// ตั้งค่าการเชื่อมต่อกับฐานข้อมูล
$servername = "118.27.130.237"; 
$username = "zgmupszw_edueliteroom1"; 
$password = "edueliteroom1"; 
$dbname = "zgmupszw_edueliteroom01"; 

try {
    // เชื่อมต่อกับฐานข้อมูล
    $conn = new PDO("mysql:host=$servername;dbname=$dbname;charset=utf8", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION); // เปิดการแสดงข้อผิดพลาด
} catch (PDOException $e) {
    error_log("Connection failed: " . $e->getMessage()); // บันทึกข้อผิดพลาดลงใน Log
    echo json_encode(['error' => 'Connection failed.']); // ส่งกลับ JSON หากเชื่อมต่อไม่สำเร็จ
    exit;
}

// รับค่าจาก Flutter
$classroomName = $_POST['classroomName'];
$classroomMajor = $_POST['classroomMajor'];
$classroomYear = $_POST['classroomYear'];
$classroomNumRoom = $_POST['classroomNumRoom'];
$username = $_POST['username']; // ชื่อผู้ใช้ (users_username)
$status = $_POST['status']; // สถานะการมาเรียน (present, late, absent, sick leave, personal leave)
$date = date('Y-m-d'); // วันที่ปัจจุบัน

// ขั้นตอนที่ 1: ค้นหา classroom_id จากตาราง classroom
$query = "SELECT classroom_id FROM classroom 
          WHERE classroom_name = :classroomName 
          AND classroom_major = :classroomMajor 
          AND classroom_year = :classroomYear 
          AND classroom_numroom = :classroomNumRoom";

$stmt = $conn->prepare($query);
$stmt->bindParam(':classroomName', $classroomName);
$stmt->bindParam(':classroomMajor', $classroomMajor);
$stmt->bindParam(':classroomYear', $classroomYear);
$stmt->bindParam(':classroomNumRoom', $classroomNumRoom);
$stmt->execute();

$classroom = $stmt->fetch(PDO::FETCH_ASSOC);

if ($classroom) {
    $classroom_id = $classroom['classroom_id'];
} else {
    echo json_encode(['error' => 'Classroom not found']);
    exit;
}

// ขั้นตอนที่ 2: ตรวจสอบว่ามีข้อมูลที่ตรงกับ classroom_id, date และ username หรือไม่
$queryCheck = "SELECT * FROM checkin_classroom 
               WHERE checkin_classroom_classID = :checkin_classroom_classID 
               AND checkin_classroom_date = :checkin_classroom_date 
               AND users_username = :users_username";

$stmtCheck = $conn->prepare($queryCheck);
$stmtCheck->bindParam(':checkin_classroom_classID', $classroom_id);
$stmtCheck->bindParam(':checkin_classroom_date', $date);
$stmtCheck->bindParam(':users_username', $username);
$stmtCheck->execute();

$existingCheckin = $stmtCheck->fetch(PDO::FETCH_ASSOC);

// ตรวจสอบค่าของสถานะก่อนดำเนินการ
$allowed_statuses = ['present', 'late', 'absent', 'sick leave', 'personal leave'];

// ตรวจสอบว่าสถานะที่ได้รับมาถูกต้องหรือไม่
if (!in_array($status, $allowed_statuses)) {
    echo json_encode(['error' => 'Invalid status value']);
    exit;
}

if ($existingCheckin) {
    // ขั้นตอนที่ 3: ถ้ามีข้อมูลแล้ว ให้ทำการอัปเดตสถานะ
    $updateQuery = "UPDATE checkin_classroom 
                    SET checkin_classroom_status = :checkin_classroom_status 
                    WHERE checkin_classroom_classID = :checkin_classroom_classID 
                    AND checkin_classroom_date = :checkin_classroom_date 
                    AND users_username = :users_username";
                
    $stmtUpdate = $conn->prepare($updateQuery);
    $stmtUpdate->bindParam(':checkin_classroom_status', $status);
    $stmtUpdate->bindParam(':checkin_classroom_classID', $existingCheckin['checkin_classroom_classID']);
    $stmtUpdate->bindParam(':checkin_classroom_date', $date);
    $stmtUpdate->bindParam(':users_username', $username);

    if ($stmtUpdate->execute()) {
        echo json_encode(['success' => 'Data updated successfully']);
    } else {
        echo json_encode(['error' => 'Failed to update data']);
    }
} else {
    // ขั้นตอนที่ 4: หากไม่มีข้อมูลในตาราง ให้ทำการบันทึกข้อมูลใหม่
    $queryInsert = "INSERT INTO checkin_classroom (checkin_classroom_date, users_username, checkin_classroom_classID, checkin_classroom_status) 
                    VALUES (:checkin_classroom_date, :users_username, :checkin_classroom_classID, :checkin_classroom_status)";

    $stmtInsert = $conn->prepare($queryInsert);
    $stmtInsert->bindParam(':checkin_classroom_date', $date);
    $stmtInsert->bindParam(':users_username', $username);
    $stmtInsert->bindParam(':checkin_classroom_classID', $classroom_id);
    $stmtInsert->bindParam(':checkin_classroom_status', $status);

    if ($stmtInsert->execute()) {
        echo json_encode(['success' => 'Data saved successfully']);
    } else {
        echo json_encode(['error' => 'Failed to save data']);
    }
}
?>
