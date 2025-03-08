<?php
header("Access-Control-Allow-Origin: *");
header('Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, PATCH, DELETE');
header('Access-Control-Allow-Headers:*');
header('Access-Control-Max-Age: 86400');

// เชื่อมต่อกับฐานข้อมูล
include "connect.php";

// รับข้อมูลจาก Flutter
$classroom_id = (int) $_POST['classroom_id'];  // แปลงเป็น int
$classroom_type = (int) $_POST['classroom_type'];  // แปลงเป็น int

// ตรวจสอบว่าได้รับข้อมูลครบถ้วน
if (isset($classroom_id) && isset($classroom_type)) {
    try {
        // อัปเดตค่า classroom_type ในฐานข้อมูล
        $stmt = $conn->prepare("UPDATE classroom SET classroom_type = :classroom_type WHERE classroom_id = :classroom_id");
        $stmt->bindParam(':classroom_id', $classroom_id, PDO::PARAM_INT);
        $stmt->bindParam(':classroom_type', $classroom_type, PDO::PARAM_INT);
        $stmt->execute();
        
        echo json_encode(['status' => 'success']);
    } catch (PDOException $e) {
        echo json_encode(['error' => 'Failed to update classroom type']);
    }
} else {
    echo json_encode(['error' => 'Invalid input']);
}

?>
