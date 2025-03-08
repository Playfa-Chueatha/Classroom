<?php
include "connect.php";
header('Content-Type: application/json; charset=utf-8');

try {
    // ดึงค่า username จาก URL
    $username = isset($_GET['username']) ? $_GET['username'] : '';

    // เพิ่มเงื่อนไขกรองข้อมูลตาม username
    $stmt = $conn->prepare("SELECT classroom_id, classroom_name, classroom_major, classroom_year, classroom_numroom FROM classroom WHERE usert_username = :username");
    $stmt->bindParam(':username', $username, PDO::PARAM_STR);
    $stmt->execute();

    $classrooms = $stmt->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode([
        'success' => true,
        'classrooms' => $classrooms
    ], JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);
} catch (PDOException $e) {
    // กรณีเกิดข้อผิดพลาด
    http_response_code(500); 
    echo json_encode([
        'success' => false,
        'message' => 'เกิดข้อผิดพลาดในการดึงข้อมูล: ' . $e->getMessage()
    ]);
}
?>
