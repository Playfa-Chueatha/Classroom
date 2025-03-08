<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

// รวมการเชื่อมต่อฐานข้อมูล
include "connect.php"; 

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // รับค่าจาก POST
    $posts_id = isset($_POST['posts_id']) ? $_POST['posts_id'] : '';
    $link = isset($_POST['link']) ? $_POST['link'] : '';

    // ตรวจสอบค่าที่ได้รับ
    if (empty($posts_id) || empty($link)) {
        echo json_encode(['success' => false, 'message' => 'Missing posts_id or link']);
        exit;
    }

    try {
        // สร้างคำสั่ง SQL สำหรับการบันทึกลิงค์ลงฐานข้อมูล
        $sql = "INSERT INTO `posts_link` (`posts_id`, `posts_link_url`) VALUES (:posts_id, :link)";
        
        // เตรียมคำสั่ง
        $stmt = $conn->prepare($sql);
        
        // Binding ข้อมูล
        $stmt->bindParam(':posts_id', $posts_id);
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
