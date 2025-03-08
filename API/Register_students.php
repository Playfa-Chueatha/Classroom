<?php

include 'connect.php';

// กำหนด Header
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json; charset=utf-8");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");

$response = [];

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // รับข้อมูลจาก JSON แทนที่จะใช้ $_POST
    $json_data = json_decode(file_get_contents('php://input'), true);
    
    if (json_last_error() !== JSON_ERROR_NONE) {
        $response['error'] = 'รูปแบบ JSON ไม่ถูกต้อง';
        echo json_encode($response);
        exit();
    }

    // รับค่าแต่ละตัวแปรจาก JSON ที่ถูกส่งมา
    $users_prefix = $json_data['users_prefix'] ?? ''; 
    $users_thfname = $json_data['users_thfname'] ?? '';
    $users_thlname = $json_data['users_thlname'] ?? '';
    $users_enfname = $json_data['users_enfname'] ?? '';
    $users_enlname = $json_data['users_enlname'] ?? '';
    $users_username = $json_data['users_username'] ?? '';
    $users_password = $json_data['users_password'] ?? '';
    $users_email = $json_data['users_email'] ?? '';
    $users_classroom = $json_data['users_classroom'] ?? '';
    $users_numroom = $json_data['users_numroom'] ?? '';
    $users_phone = $json_data['users_phone'] ?? '';
    $users_major = $json_data['users_major'] ?? '';
    $users_id = $json_data['users_id'] ?? '';
    $users_number = $json_data['users_number'] ?? '';
    $users_parentphone = $json_data['users_parentphone'] ?? '';
    $usert_username = $json_data['usert_username'] ?? '';

    // ตรวจสอบรูปแบบอีเมล
    if (!filter_var($users_email, FILTER_VALIDATE_EMAIL)) {
        $response['error'] = 'รูปแบบอีเมลไม่ถูกต้อง';
        echo json_encode($response);
        exit();
    }

    // ตรวจสอบว่าอีเมลนี้มีอยู่ในระบบหรือไม่
    $check_sql = "SELECT * FROM user_students WHERE users_email = :users_email";
    $stmt = $conn->prepare($check_sql);
    $stmt->bindValue(':users_email', $users_email);
    $stmt->execute();

    if ($stmt->rowCount() > 0) {
        $response['error'] = 'อีเมลนี้มีผู้ใช้งานอยู่แล้ว';
    } else {
        // เข้ารหัสรหัสผ่านก่อนบันทึก
        $hashed_password = password_hash($users_password, PASSWORD_DEFAULT);

        // เพิ่มข้อมูลลงฐานข้อมูล
        $insert_sql = "INSERT INTO user_students
        (   users_prefix,
            users_thfname, 
            users_thlname, 
            users_enfname, 
            users_enlname, 
            users_username, 
            users_password, 
            users_email, 
            users_classroom, 
            users_numroom, 
            users_phone, 
            users_major,
            users_id,
            users_number,
            users_parentphone,
            usert_username) 
        VALUES 
        (   :users_prefix,
            :users_thfname, 
            :users_thlname, 
            :users_enfname, 
            :users_enlname, 
            :users_username, 
            :users_password, 
            :users_email, 
            :users_classroom, 
            :users_numroom, 
            :users_phone, 
            :users_major,
            :users_id,
            :users_number,
            :users_parentphone,
            :usert_username)";
        
        $stmt = $conn->prepare($insert_sql);
        $stmt->bindValue(':users_prefix', $users_prefix);
        $stmt->bindValue(':users_thfname', $users_thfname);
        $stmt->bindValue(':users_thlname', $users_thlname);
        $stmt->bindValue(':users_enfname', $users_enfname);
        $stmt->bindValue(':users_enlname', $users_enlname);
        $stmt->bindValue(':users_username', $users_username);
        $stmt->bindValue(':users_password', $hashed_password);
        $stmt->bindValue(':users_email', $users_email);
        $stmt->bindValue(':users_classroom', $users_classroom);
        $stmt->bindValue(':users_numroom', $users_numroom);
        $stmt->bindValue(':users_phone', $users_phone);
        $stmt->bindValue(':users_major', $users_major);
        $stmt->bindValue(':users_id', $users_id);
        $stmt->bindValue(':users_number', $users_number);
        $stmt->bindValue(':users_parentphone', $users_parentphone);
        $stmt->bindValue(':usert_username', $usert_username);

        try {
            if ($stmt->execute()) {
                $response['success'] = 'ลงทะเบียนสำเร็จ';
            } else {
                $response['error'] = 'การลงทะเบียนล้มเหลว กรุณาลองใหม่อีกครั้ง';
            }
        } catch (PDOException $e) {
            error_log("Database error: " . $e->getMessage(), 0);
            $response['error'] = 'เกิดข้อผิดพลาดในฐานข้อมูล กรุณาติดต่อฝ่ายสนับสนุน';
        }
    }
} else {
    $response['error'] = 'Request method is not POST.';
}

// ส่งผลลัพธ์ JSON กลับ
echo json_encode($response);
$conn = null;

?>
