<?php
header("Access-Control-Allow-Origin: *");
header('Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, PATCH, DELETE');
header('Access-Control-Allow-Headers: *');
header('Access-Control-Max-Age: 86400');

// เชื่อมต่อกับฐานข้อมูล
include 'connect.php';

// รับข้อมูลจาก POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $usert_auto = isset($_POST['usert_auto']) ? $_POST['usert_auto'] : '';
    $usert_username = isset($_POST['usert_username']) ? $_POST['usert_username'] : '';
    $usert_thfname = isset($_POST['usert_thfname']) ? $_POST['usert_thfname'] : '';
    $usert_thlname = isset($_POST['usert_thlname']) ? $_POST['usert_thlname'] : '';
    $usert_enfname = isset($_POST['usert_enfname']) ? $_POST['usert_enfname'] : '';
    $usert_enlname = isset($_POST['usert_enlname']) ? $_POST['usert_enlname'] : '';
    $usert_email = isset($_POST['usert_email']) ? $_POST['usert_email'] : '';
    $usert_phone = isset($_POST['usert_phone']) ? $_POST['usert_phone'] : '';
    $usert_classroom = isset($_POST['usert_classroom']) ? $_POST['usert_classroom'] : '';
    $usert_numroom = isset($_POST['usert_numroom']) ? $_POST['usert_numroom'] : '';
    $usert_subjects = isset($_POST['usert_subjects']) ? $_POST['usert_subjects'] : '';

    // ตรวจสอบว่ามีการส่งค่าที่จำเป็นมาหรือไม่
    if (empty($usert_auto) || empty($usert_username) || empty($usert_thfname) || empty($usert_thlname)) {
        echo json_encode(['error' => 'กรุณากรอกข้อมูลให้ครบถ้วน']);
        exit;
    }

    try {
        // อัปเดตข้อมูลในฐานข้อมูล
        $sql = "UPDATE user_teacher 
                SET usert_thfname = :usert_thfname,
                    usert_thlname = :usert_thlname,
                    usert_enfname = :usert_enfname,
                    usert_enlname = :usert_enlname,
                    usert_email = :usert_email,
                    usert_phone = :usert_phone,
                    usert_classroom = :usert_classroom,
                    usert_numroom = :usert_numroom,
                    usert_subjects = :usert_subjects
                WHERE usert_auto = :usert_auto AND usert_username = :usert_username";

        $stmt = $conn->prepare($sql);
        $stmt->bindParam(':usert_auto', $usert_auto);
        $stmt->bindParam(':usert_username', $usert_username);
        $stmt->bindParam(':usert_thfname', $usert_thfname);
        $stmt->bindParam(':usert_thlname', $usert_thlname);
        $stmt->bindParam(':usert_enfname', $usert_enfname);
        $stmt->bindParam(':usert_enlname', $usert_enlname);
        $stmt->bindParam(':usert_email', $usert_email);
        $stmt->bindParam(':usert_phone', $usert_phone);
        $stmt->bindParam(':usert_classroom', $usert_classroom);
        $stmt->bindParam(':usert_numroom', $usert_numroom);
        $stmt->bindParam(':usert_subjects', $usert_subjects);

        $stmt->execute();

        // ถ้าอัปเดตสำเร็จ
        echo json_encode(['success' => 'อัปเดตข้อมูลสำเร็จ']);
    } catch (PDOException $e) {
        // ถ้าเกิดข้อผิดพลาดในการอัปเดต
        echo json_encode(['error' => 'เกิดข้อผิดพลาดในการอัปเดตข้อมูล: ' . $e->getMessage()]);
    }
}
?>
