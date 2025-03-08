<?php
header("Access-Control-Allow-Origin: *");
header('Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, PATCH, DELETE');
header('Access-Control-Allow-Headers: *');
header('Access-Control-Max-Age: 86400');

$servername = "118.27.130.237"; 
$username = "zgmupszw_edueliteroom1"; 
$password = "edueliteroom1"; 
$dbname = "zgmupszw_edueliteroom01"; 

try {
    // ตั้งค่าการเชื่อมต่อฐานข้อมูล
    $conn = new PDO("mysql:host=$servername;dbname=$dbname;charset=utf8", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION); // เปิดการแสดงข้อผิดพลาด
} catch (PDOException $e) {
    error_log("Connection failed: " . $e->getMessage()); // บันทึกข้อผิดพลาดลงใน Log
    echo json_encode(['error' => 'Connection failed.']); // ส่งกลับ JSON หากเชื่อมต่อไม่สำเร็จ
    exit;
}

// รับค่าจาก POST
$examsets_id = $_POST['examsets_id'];
$score_total = $_POST['score_total'];
$users_username = $_POST['users_username'];
$score_type = $_POST['score_type'];  // แก้ไขให้ถูกต้อง

// ตรวจสอบค่าที่ได้รับ
if (!isset($examsets_id) || !isset($score_total) || !isset($users_username)) {
    echo json_encode(['error' => 'Missing required fields.']);
    exit;
}

// สร้างคำสั่ง SQL สำหรับบันทึกข้อมูลลงฐานข้อมูล
$sql = "INSERT INTO score (examsets_id, score_total, users_username, score_type) 
        VALUES (:examsets_id, :score_total, :users_username, :score_type)";

// เตรียมคำสั่ง SQL
$stmt = $conn->prepare($sql);

// ผูกค่าที่รับมาจาก POST
$stmt->bindParam(':examsets_id', $examsets_id, PDO::PARAM_INT);
$stmt->bindParam(':score_total', $score_total, PDO::PARAM_STR); 
$stmt->bindParam(':users_username', $users_username, PDO::PARAM_STR);
$stmt->bindParam(':score_type', $score_type, PDO::PARAM_STR);

// เรียกใช้คำสั่ง SQL
if ($stmt->execute()) {
    echo json_encode(['message' => 'Score saved successfully']);
} else {
    echo json_encode(['error' => 'Failed to save score']);
}

// ปิดการเชื่อมต่อ
$conn = null;
?>
