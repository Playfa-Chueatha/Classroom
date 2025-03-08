<?php
header("Access-Control-Allow-Origin: *");
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: *');
header('Access-Control-Max-Age: 86400');

include "connect.php"; 

// ตรวจสอบว่ามีการส่งค่ามาหรือไม่
if (!isset($_POST['username']) || !isset($_POST['comment_auto'])) {
    echo json_encode(['error' => 'Missing username or comment_auto']);
    exit;
}

$username = $_POST['username'];
$comment_auto = $_POST['comment_auto'];

// คำสั่ง SQL เพื่อตรวจสอบข้อมูลในฐานข้อมูล
$sql = "SELECT comment_username FROM comment WHERE comment_auto = :comment_auto AND comment_username = :username";
$stmt = $conn->prepare($sql);

if ($stmt === false) {
    echo json_encode(['error' => 'SQL prepare failed: ' . $conn->errorInfo()]);
    exit;
}

// การ binding parameters ใช้ bindParam หรือ bindValue
$stmt->bindParam(':comment_auto', $comment_auto, PDO::PARAM_INT);
$stmt->bindParam(':username', $username, PDO::PARAM_STR);

$stmt->execute();

// หากพบข้อมูลตรงกัน
if ($stmt->rowCount() > 0) {
    // ลบคอมเมนต์ที่ตรงกับเงื่อนไข
    $deleteSql = "DELETE FROM comment WHERE comment_auto = :comment_auto AND comment_username = :username";
    $deleteStmt = $conn->prepare($deleteSql);
    
    if ($deleteStmt === false) {
        echo json_encode(['error' => 'SQL prepare failed: ' . $conn->errorInfo()]);
        exit;
    }

    // การ binding parameters
    $deleteStmt->bindParam(':comment_auto', $comment_auto, PDO::PARAM_INT);
    $deleteStmt->bindParam(':username', $username, PDO::PARAM_STR);

    $deleteStmt->execute();
    
    // ตรวจสอบผลลัพธ์การลบ
    if ($deleteStmt->rowCount() > 0) {
        echo json_encode(['success' => true]);
    } else {
        echo json_encode(['success' => false, 'error' => 'Failed to delete comment']);
    }
} else {
    echo json_encode(['success' => false, 'error' => 'No matching comment found']);
}

$conn = null; // ปิดการเชื่อมต่อ
?>
