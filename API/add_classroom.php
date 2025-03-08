<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");

include "connect.php"; // รวมไฟล์เชื่อมต่อฐานข้อมูล

// รับข้อมูล JSON ที่ส่งมาจาก Flutter
$data = json_decode(file_get_contents("php://input"), true);

// ตรวจสอบว่ามีข้อมูลครบถ้วนหรือไม่
if (!isset($data['classroom_major']) || !isset($data['classroom_subjectsID']) || !isset($data['classroom_year']) || !isset($data['classroom_numroom']) || !isset($data['classroom_name']) || !isset($data['classroom_detail']) || !isset($data['usert_username'])) {
    echo json_encode(['status' => 'error', 'message' => 'Incomplete data']);
    exit;
}

// ดึงข้อมูลจาก JSON
$classroom_name = $data['classroom_name'];
$classroom_major = $data['classroom_major'];
$classroom_year = $data['classroom_year'];
$classroom_numroom = $data['classroom_numroom'];
$classroom_schoolyear = $data['classroom_schoolyear'];
$classroom_detail = $data['classroom_detail'];
$usert_username = $data['usert_username'];
$classroom_subjectsID = $data['classroom_subjectsID'];
// ตรวจสอบห้องเรียนที่มีข้อมูลตรงกับ 4 ฟิลด์ที่ได้รับมา
$checkSql = "SELECT * FROM classroom WHERE classroom_name = :classroom_name AND classroom_subjectsID = :classroom_subjectsID AND classroom_major = :classroom_major AND classroom_year = :classroom_year AND classroom_numroom = :classroom_numroom AND classroom_schoolyear = :classroom_schoolyear";
$checkStmt = $conn->prepare($checkSql);

// Execute คำสั่ง SQL ตรวจสอบข้อมูล
$checkStmt->execute([
    ':classroom_name' => $classroom_name,
    ':classroom_major' => $classroom_major,
    ':classroom_year' => $classroom_year,
    ':classroom_numroom' => $classroom_numroom,
    ':classroom_schoolyear' => $classroom_schoolyear,
    ':classroom_subjectsID'=> $classroom_subjectsID,
]);

// ถ้าพบข้อมูลห้องเรียนที่ตรงกับ 4 ฟิลด์นี้แล้ว
if ($checkStmt->rowCount() > 0) {
    echo json_encode(['status' => 'error', 'message' => 'Classroom already exists']);
    exit; // หยุดการทำงาน
}

// ถ้าไม่พบข้อมูลซ้ำกัน ให้ทำการเพิ่มข้อมูลห้องเรียนใหม่
$insertSql = "INSERT INTO classroom (classroom_name, classroom_subjectsID, classroom_major, classroom_year, classroom_numroom, classroom_schoolyear ,classroom_detail, classroom_type, usert_username) 
              VALUES (:classroom_name, :classroom_subjectsID, :classroom_major, :classroom_year, :classroom_numroom, :classroom_schoolyear, :classroom_detail, 0, :usert_username)";

// เตรียมคำสั่ง SQL สำหรับการเพิ่มข้อมูล
$insertStmt = $conn->prepare($insertSql);

// Execute คำสั่ง SQL
$insertStmt->execute([
    ':classroom_name' => $classroom_name,
    ':classroom_major' => $classroom_major,
    ':classroom_year' => $classroom_year,
    ':classroom_numroom' => $classroom_numroom,
    ':classroom_schoolyear' => $classroom_schoolyear,
    ':classroom_detail' => $classroom_detail,
    ':usert_username' => $usert_username,
    ':classroom_subjectsID'=>$classroom_subjectsID
]);

// ตรวจสอบผลการทำงาน
if ($insertStmt->rowCount() > 0) {
    echo json_encode(['status' => 'success']);
} else {
    echo json_encode(['status' => 'error', 'message' => 'Failed to add classroom']);
}
?>
