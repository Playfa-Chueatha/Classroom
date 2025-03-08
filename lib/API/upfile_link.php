<?php
header("Access-Control-Allow-Origin: *");
header('Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, PATCH, DELETE');
header('Access-Control-Allow-Headers: Content-Type');
header('Access-Control-Max-Age: 86400');

// รวมการเชื่อมต่อฐานข้อมูล
include "connect.php"; 

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // รับค่าจาก POST
    $examsets_id = isset($_POST['examsets_id']) ? $_POST['examsets_id'] : '';
    $link = isset($_POST['link']) ? $_POST['link'] : '';

    // ตรวจสอบค่าที่ได้รับ
    if (empty($examsets_id) || empty($link)) {
        echo json_encode(['success' => false, 'message' => 'Missing examsets_id or link']);
        exit;
    }

    try {
        // สร้างคำสั่ง SQL สำหรับการบันทึกลิงค์ลงฐานข้อมูล
        $sql = "INSERT INTO `upfile_link` (`examsets_id`, `upfile_link_url`) VALUES (:examsets_id, :link)";
        
        // เตรียมคำสั่ง
        $stmt = $conn->prepare($sql);
        
        // Binding ข้อมูล
        $stmt->bindParam(':examsets_id', $examsets_id);
        $stmt->bindParam(':link', $link);

        // Execute คำสั่ง SQL
        $stmt->execute();

        // ส่งคืนผลลัพธ์เมื่อบันทึกสำเร็จ
        echo json_encode(['success' => true, 'message' => 'Link uploaded successfully']);
    } catch (PDOException $e) {
        // แสดงข้อผิดพลาดถ้าการบันทึกไม่สำเร็จ
        error_log("Error: " . $e->getMessage());
        echo json_encode(['success' => false, 'message' => 'Failed to upload link']);
    }
} else {
    echo json_encode(['success' => false, 'message' => 'Invalid request method']);
}
?>
