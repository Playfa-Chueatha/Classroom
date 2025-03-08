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

    // ตัวอย่างการใช้คำสั่ง SQL
    $stmt = $conn->prepare("SELECT * FROM manychoice WHERE examsets_id = :examId");
    $stmt->bindParam(':examId', $_POST['examsets_id'], PDO::PARAM_STR);
    $stmt->execute();

    // ดึงข้อมูล
    $data = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // ส่งกลับข้อมูลในรูปแบบ JSON
    echo json_encode($data);

} catch (PDOException $e) {
    error_log("Connection failed: " . $e->getMessage()); // บันทึกข้อผิดพลาดลงใน Log
    echo json_encode(['error' => 'Connection failed.']); // ส่งกลับ JSON หากเชื่อมต่อไม่สำเร็จ
    exit;
}
?>
