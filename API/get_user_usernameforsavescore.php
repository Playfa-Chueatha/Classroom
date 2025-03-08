<?php
// รวมไฟล์เชื่อมต่อฐานข้อมูล
include "connect.php";

// รับค่าจาก POST
$users_prefix = isset($_POST['users_prefix']) ? $_POST['users_prefix'] : '';
$users_thfname = isset($_POST['users_thfname']) ? $_POST['users_thfname'] : '';
$users_thlname = isset($_POST['users_thlname']) ? $_POST['users_thlname'] : '';
$users_number = isset($_POST['users_number']) ? $_POST['users_number'] : '';

// ตรวจสอบว่ามีข้อมูลครบถ้วน
if (empty($users_prefix) || empty($users_thfname) || empty($users_thlname) || empty($users_number)) {
    echo json_encode(['error' => 'กรุณากรอกข้อมูลให้ครบถ้วน']);
    exit;
}

try {
    // ค้นหาข้อมูล users_username จากตาราง user_students
    $sql = "SELECT users_username FROM user_students 
            WHERE users_prefix = :users_prefix
            AND users_thfname = :users_thfname
            AND users_thlname = :users_thlname
            AND users_number = :users_number";

    $stmt = $conn->prepare($sql);
    $stmt->bindParam(':users_prefix', $users_prefix);
    $stmt->bindParam(':users_thfname', $users_thfname);
    $stmt->bindParam(':users_thlname', $users_thlname);
    $stmt->bindParam(':users_number', $users_number);

    $stmt->execute();

    // ตรวจสอบผลลัพธ์
    if ($stmt->rowCount() > 0) {
        $row = $stmt->fetch(PDO::FETCH_ASSOC);
        echo json_encode(['users_username' => $row['users_username']]);
    } else {
        echo json_encode(['error' => 'ไม่พบผู้ใช้ที่ตรงกับข้อมูล']);
    }
} catch (PDOException $e) {
    echo json_encode(['error' => 'เกิดข้อผิดพลาด: ' . $e->getMessage()]);
}
?>
