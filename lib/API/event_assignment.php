<?php
include "connect.php"; // นำเข้าไฟล์เชื่อมต่อฐานข้อมูล

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json; charset=UTF-8");

// ตรวจสอบประเภทของคำขอ
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    // รับค่าจาก query parameter
    $usert_username = isset($_GET['usert_username']) ? filter_var($_GET['usert_username'], FILTER_SANITIZE_STRING) : null;

    if (empty($usert_username)) {
        http_response_code(400);
        echo json_encode([
            "status" => "error",
            "message" => "กรุณากรอกชื่อผู้ใช้"
        ], JSON_UNESCAPED_UNICODE);
        exit;
    }

    try {
        // SQL JOIN เพื่อนำข้อมูลจาก event_assignment และ classroom มารวมกัน
        $query = "SELECT 
                    ea.event_assignment_auto, 
                    ea.event_assignment_title, 
                    ea.event_assignment_time, 
                    ea.event_assignment_duedate, 
                    ea.event_assignment_classID, 
                    ea.event_assignment_usert, 
                    c.classroom_name, 
                    c.classroom_major, 
                    c.classroom_year, 
                    c.classroom_numroom
                  FROM event_assignment ea
                  LEFT JOIN classroom c 
                  ON ea.event_assignment_classID = c.classroom_id
                  WHERE ea.event_assignment_usert = :usert_username 
                  AND c.classroom_type = 0";


        // เตรียมคำสั่ง SQL
        $stmt = $conn->prepare($query);
        $stmt->bindParam(':usert_username', $usert_username);
        $stmt->execute();

        // ดึงข้อมูล
        $events = $stmt->fetchAll(PDO::FETCH_ASSOC);

        // ตรวจสอบว่ามีข้อมูลหรือไม่
        if (empty($events)) {
            http_response_code(404);
            echo json_encode([
                "status" => "error",
                "message" => "ไม่พบข้อมูลการมอบหมาย"
            ], JSON_UNESCAPED_UNICODE);
        } else {
            // ส่งข้อมูลกลับไปยัง UI
            http_response_code(200);
            echo json_encode([
                "status" => "success",
                "data_assignment" => $events
            ], JSON_UNESCAPED_UNICODE);
        }

    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode([
            "status" => "error",
            "message" => "ข้อผิดพลาดฐานข้อมูล: " . $e->getMessage()
        ], JSON_UNESCAPED_UNICODE);
    }
}

$conn = null;
?>
