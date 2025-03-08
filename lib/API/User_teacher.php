<?php
header("Access-Control-Allow-Origin: *");
header('Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, PATCH, DELETE');
header('Access-Control-Allow-Headers: *');
header('Access-Control-Max-Age: 86400');

// เชื่อมต่อฐานข้อมูล
include "connect.php";

// รับค่า username จาก Flutter
$username = isset($_GET['username']) ? $_GET['username'] : '';

// ตรวจสอบว่ามีการส่งค่า username มาหรือไม่
if ($username != '') {
    try {
        // ค้นหาข้อมูลจากตาราง user_teacher โดยใช้ username
        $stmt = $conn->prepare("SELECT * FROM user_teacher WHERE usert_username = :username");
        $stmt->bindParam(':username', $username, PDO::PARAM_STR);
        $stmt->execute();
        
        // ตรวจสอบว่ามีข้อมูลหรือไม่
        $user = $stmt->fetch(PDO::FETCH_ASSOC);
        if ($user) {
            echo json_encode($user); // ส่งข้อมูลผู้ใช้กลับไปยัง Flutter
        } else {
            echo json_encode(['error' => 'User not found.']); // ถ้าไม่พบข้อมูล
        }
    } catch (PDOException $e) {
        error_log("Query failed: " . $e->getMessage());
        echo json_encode(['error' => 'Query failed.']);
    }
} else {
    echo json_encode(['error' => 'Username is required.']); // ถ้าไม่ได้ส่ง username มาด้วย
}
?>
