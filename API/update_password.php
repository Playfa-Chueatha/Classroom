<?php
header("Access-Control-Allow-Origin: *");
header('Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, PATCH, DELETE');
header('Access-Control-Allow-Headers: Content-Type');
header('Access-Control-Max-Age: 86400');

// ตั้งค่าการเชื่อมต่อกับฐานข้อมูล
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

// รับข้อมูล JSON จาก Body Request
$data = json_decode(file_get_contents("php://input"), true);

// ตรวจสอบว่ามีค่า username และ password หรือไม่
if (!isset($data['username']) || !isset($data['password'])) {
    echo json_encode(['error' => 'ข้อมูลไม่ครบถ้วน']);
    exit;
}

$usert_username = $data['username'];
$usert_password = $data['password'];

// เข้ารหัสรหัสผ่านใหม่
$hashed_password = password_hash($usert_password, PASSWORD_DEFAULT);

// คำสั่ง SQL เพื่อตรวจสอบว่า username มีในฐานข้อมูลหรือไม่
$sql = "SELECT * FROM user_teacher WHERE usert_username = :username";
$stmt = $conn->prepare($sql);
$stmt->bindParam(':username', $usert_username);
$stmt->execute();

// ถ้าพบ username ในฐานข้อมูล
if ($stmt->rowCount() > 0) {
    // คำสั่ง SQL เพื่ออัปเดตรหัสผ่าน
    $update_sql = "UPDATE user_teacher SET usert_password = :password WHERE usert_username = :username";
    $update_stmt = $conn->prepare($update_sql);
    $update_stmt->bindParam(':password', $hashed_password);
    $update_stmt->bindParam(':username', $usert_username);
    
    // การดำเนินการอัปเดตรหัสผ่าน
    if ($update_stmt->execute()) {
        echo json_encode(['message' => 'รหัสผ่านถูกอัปเดตเรียบร้อยแล้ว']);
    } else {
        echo json_encode(['error' => 'เกิดข้อผิดพลาดในการอัปเดตรหัสผ่าน']);
    }
} else {
    echo json_encode(['error' => 'ไม่พบชื่อผู้ใช้นี้ในระบบ']);
}
?>
