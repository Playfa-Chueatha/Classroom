<?php
header("Access-Control-Allow-Origin: *");
header('Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, PATCH, DELETE');
header('Access-Control-Allow-Headers: *');
header('Access-Control-Max-Age: 86400');

// เชื่อมต่อกับฐานข้อมูล
include 'connect.php';

// รับข้อมูลจาก POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $users_auto = isset($_POST['users_auto']) ? $_POST['users_auto'] : '';
    $users_username = isset($_POST['users_username']) ? $_POST['users_username'] : '';
    $users_thfname = isset($_POST['users_thfname']) ? $_POST['users_thfname'] : '';
    $users_thlname = isset($_POST['users_thlname']) ? $_POST['users_thlname'] : '';
    $users_enfname = isset($_POST['users_enfname']) ? $_POST['users_enfname'] : '';
    $users_enlname = isset($_POST['users_enlname']) ? $_POST['users_enlname'] : '';
    $users_email = isset($_POST['users_email']) ? $_POST['users_email'] : ''; 
    $users_phone = isset($_POST['users_phone']) ? $_POST['users_phone'] : '';
    $users_classroom = isset($_POST['users_classroom']) ? $_POST['users_classroom'] : '';
    $users_numroom = isset($_POST['users_numroom']) ? $_POST['users_numroom'] : '';
    $users_parentphone = isset($_POST['users_parentphone']) ? $_POST['users_parentphone'] : '';
    $users_major = isset($_POST['users_major']) ? $_POST['users_major'] : '';
    $users_number = isset($_POST['users_number']) ? $_POST['users_number'] : '';

    // ตรวจสอบว่ามีการส่งค่าที่จำเป็นมาหรือไม่
    if (empty($users_auto) || empty($users_username) || empty($users_thfname) || empty($users_thlname)) {
        echo json_encode(['error' => 'กรุณากรอกข้อมูลให้ครบถ้วน']);
        exit;
    }

    try {
        // อัปเดตข้อมูลในฐานข้อมูล
        $sql = "UPDATE user_students 
                SET users_thfname = :users_thfname,
                    users_thlname = :users_thlname,
                    users_enfname = :users_enfname,
                    users_enlname = :users_enlname,
                    users_email = :users_email,
                    users_phone = :users_phone,
                    users_classroom = :users_classroom,
                    users_numroom = :users_numroom,
                    users_major = :users_major,
                    users_number = :users_number,
                    users_parentphone = :users_parentphone
                WHERE users_auto = :users_auto AND users_username = :users_username";

        $stmt = $conn->prepare($sql);
        $stmt->bindParam(':users_auto', $users_auto);
        $stmt->bindParam(':users_username', $users_username);
        $stmt->bindParam(':users_thfname', $users_thfname);
        $stmt->bindParam(':users_thlname', $users_thlname);
        $stmt->bindParam(':users_enfname', $users_enfname);
        $stmt->bindParam(':users_enlname', $users_enlname);
        $stmt->bindParam(':users_email', $users_email);
        $stmt->bindParam(':users_phone', $users_phone);
        $stmt->bindParam(':users_classroom', $users_classroom);
        $stmt->bindParam(':users_numroom', $users_numroom);
        $stmt->bindParam(':users_major', $users_major);
        $stmt->bindParam(':users_number', $users_number);
        $stmt->bindParam(':users_parentphone', $users_parentphone);

        $stmt->execute();

        // ตรวจสอบจำนวนแถวที่ได้รับผลกระทบ
        if ($stmt->rowCount() > 0) {
            // ถ้าอัปเดตสำเร็จ
            echo json_encode(['success' => 'อัปเดตข้อมูลสำเร็จ']);
        } else {
            // ถ้าไม่มีการอัปเดตข้อมูล (อาจเป็นเพราะข้อมูลเหมือนเดิม)
            echo json_encode(['error' => 'ไม่พบข้อมูลที่ต้องการอัปเดต']);
        }

    } catch (PDOException $e) {
        // ถ้าเกิดข้อผิดพลาดในการอัปเดต
        echo json_encode(['error' => 'เกิดข้อผิดพลาดในการอัปเดตข้อมูล: ' . $e->getMessage()]);
    }
}
?>
