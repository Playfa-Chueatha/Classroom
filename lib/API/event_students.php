<?php
include "connect.php"; // นำเข้าไฟล์เชื่อมต่อฐานข้อมูล

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json; charset=UTF-8");

// ตรวจสอบประเภทของคำขอ
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    // รับค่าจาก query parameter
    $users_username = isset($_GET['users_username']) ? filter_var($_GET['users_username'], FILTER_SANITIZE_STRING) : null;

    if (empty($users_username)) {
        http_response_code(400);
        echo json_encode([
            "status" => "error",
            "message" => "กรุณากรอกชื่อผู้ใช้"
        ], JSON_UNESCAPED_UNICODE);
        exit;
    }

    try {
        // เปลี่ยนคำสั่ง SELECT เป็นตารางและฟิลด์ใหม่
        $query = "SELECT event_users_auto, event_users_title, event_users_date, event_users_time, users_username FROM event_users WHERE users_username = :users_username";
        $stmt = $conn->prepare($query);
        $stmt->bindParam(':users_username', $users_username);
        $stmt->execute();

        $events = $stmt->fetchAll(PDO::FETCH_ASSOC);
        http_response_code(200);
        echo json_encode([
            "status" => "success",
            "data" => $events
        ], JSON_UNESCAPED_UNICODE);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode([
            "status" => "error",
            "message" => "ข้อผิดพลาดฐานข้อมูล: " . $e->getMessage()
        ]);
    }
} elseif ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // รับข้อมูลจาก POST request
    $event_users_title = isset($_POST['event_users_title']) ? filter_var($_POST['event_users_title'], FILTER_SANITIZE_STRING) : null;
    $event_users_date = isset($_POST['event_users_date']) ? $_POST['event_users_date'] : null;
    $event_users_time = isset($_POST['event_users_time']) ? $_POST['event_users_time'] : null;
    $users_username = isset($_POST['users_username']) ? filter_var($_POST['users_username'], FILTER_SANITIZE_STRING) : null;

    // ตรวจสอบว่าข้อมูลทั้งหมดถูกส่งมาครบหรือไม่
    if (empty($event_users_title) || empty($event_users_date) || empty($event_users_time) || empty($users_username)) {
        http_response_code(400); // รหัสสถานะ HTTP 400 (Bad Request)
        echo json_encode([
            "status" => "error",
            "message" => "กรุณากรอกข้อมูลให้ครบถ้วน"
        ], JSON_UNESCAPED_UNICODE);
        exit;
    }

    try {
        // คำสั่ง SQL สำหรับการเพิ่มข้อมูลในตารางใหม่
        $insert_sql = "INSERT INTO `event_users` (
                                event_users_title, 
                                event_users_date, 
                                event_users_time, 
                                users_username) 
                       VALUES (
                                :event_users_title, 
                                :event_users_date, 
                                :event_users_time, 
                                :users_username)";

        // เตรียมคำสั่ง SQL
        $stmt = $conn->prepare($insert_sql);

        // ผูกค่าพารามิเตอร์
        $stmt->bindParam(':event_users_title', $event_users_title);
        $stmt->bindParam(':event_users_date', $event_users_date);
        $stmt->bindParam(':event_users_time', $event_users_time);
        $stmt->bindParam(':users_username', $users_username);

        // ตรวจสอบผลการเพิ่มข้อมูล
        if ($stmt->execute()) {
            http_response_code(200); //  (OK)
            $response = [
                "status" => "success",
                "message" => "เพิ่มกิจกรรมสำเร็จ"
            ];
        } else {
            http_response_code(500); //Internal Server Error
            $response = [
                "status" => "error",
                "message" => "เพิ่มกิจกรรมไม่สำเร็จ"
            ];
        }
    } catch (PDOException $e) {
        // จัดการข้อผิดพลาดจากฐานข้อมูล
        error_log("Database error: " . $e->getMessage()); // บันทึกข้อผิดพลาดลงใน log
        http_response_code(500); //Internal Server Error
        $response = [
            "status" => "error",
            "message" => "ข้อผิดพลาดฐานข้อมูล: " . $e->getMessage()
        ];
    }

    // ส่งผลลัพธ์เป็น JSON โดยไม่ต้อง escape Unicode
    echo json_encode($response, JSON_UNESCAPED_UNICODE);
}

// ปิดการเชื่อมต่อฐานข้อมูล
$conn = null;
?>
