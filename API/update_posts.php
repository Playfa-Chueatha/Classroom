<?php
header("Access-Control-Allow-Origin: *");
header('Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, PATCH, DELETE');
header('Access-Control-Allow-Headers: *');
header('Content-Type: application/json; charset=UTF-8');
include "connect.php"; // เรียกใช้การเชื่อมต่อฐานข้อมูล

// ตรวจสอบว่าเป็นคำร้องแบบ POST
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(['error' => 'Invalid request method.']);
    exit;
}

// รับข้อมูลจากคำร้อง
$data = json_decode(file_get_contents("php://input"), true);

// ตรวจสอบว่ามีข้อมูลที่จำเป็นครบถ้วน
if (!isset($data['postId'], $data['newTitle'], $data['username'])) {
    echo json_encode(['error' => 'Missing required fields.']);
    exit;
}

$postId = $data['postId'];
$newTitle = $data['newTitle'];
$username = $data['username'];

try {
    // ตรวจสอบว่ามีโพสต์ที่ตรงกับ postId และ username
    $stmt = $conn->prepare("SELECT * FROM posts WHERE posts_auto = :postId AND usert_username = :username");
    $stmt->bindParam(':postId', $postId, PDO::PARAM_INT);
    $stmt->bindParam(':username', $username, PDO::PARAM_STR);
    $stmt->execute();

    if ($stmt->rowCount() === 0) {
        // ไม่พบโพสต์ที่ตรงกัน
        echo json_encode(['error' => 'No matching post found.']);
        exit;
    }

    // อัปเดต posts_title ด้วยค่าใหม่
    $updateStmt = $conn->prepare("UPDATE posts SET posts_title = :newTitle WHERE posts_auto = :postId AND usert_username = :username");
    $updateStmt->bindParam(':newTitle', $newTitle, PDO::PARAM_STR);
    $updateStmt->bindParam(':postId', $postId, PDO::PARAM_INT);
    $updateStmt->bindParam(':username', $username, PDO::PARAM_STR);
    $updateStmt->execute();

    if ($updateStmt->rowCount() > 0) {
        echo json_encode(['success' => 'Post updated successfully.']);
    } else {
        echo json_encode(['error' => 'Update failed or no changes made.']);
    }
} catch (PDOException $e) {
    error_log("Database error: " . $e->getMessage());
    echo json_encode(['error' => 'Database error occurred.']);
}
?>
