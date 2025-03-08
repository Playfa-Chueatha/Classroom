<?php
header('Content-Type: application/json; charset=UTF-8');

// รวมไฟล์การเชื่อมต่อฐานข้อมูล
include 'connect.php';

// รับค่าจาก GET parameter
$examsets_id = isset($_GET['examsets_id']) ? $_GET['examsets_id'] : '';
$username = isset($_GET['username']) ? $_GET['username'] : '';

// ตรวจสอบว่ามีการส่งค่าที่จำเป็นมา
if ($examsets_id && $username) {
    try {
        // Query ข้อมูลจากตาราง submit_upfile โดยตรวจสอบทั้ง examsets_id และ username
        $sql = "SELECT `submit_upfile_auto`, `examsets_id`, `submit_upfile_name`, `submit_upfile_size`, 
                       `submit_upfile_type`, `submit_upfile_url`, `users_username`, `submit_upfile_time`
                FROM `submit_upfile`
                WHERE `examsets_id` = :examsets_id AND `users_username` = :username";
        
        // เตรียมคำสั่ง SQL
        $stmt = $conn->prepare($sql);

        // Binding ค่าพารามิเตอร์
        $stmt->bindParam(':examsets_id', $examsets_id, PDO::PARAM_INT);
        $stmt->bindParam(':username', $username, PDO::PARAM_STR);

        // Execute คำสั่ง SQL
        $stmt->execute();

        // ดึงข้อมูลที่ได้มาเป็น Array
        $submit_upfile_data = $stmt->fetchAll(PDO::FETCH_ASSOC);

        // ส่งข้อมูลเป็น JSON แบบ List
        echo json_encode($submit_upfile_data, JSON_UNESCAPED_UNICODE);

    } catch (PDOException $e) {
        // ถ้ามีข้อผิดพลาดใน SQL หรือการเชื่อมต่อฐานข้อมูล
        http_response_code(500);
        echo json_encode(['error' => 'Database query failed: ' . $e->getMessage()]);
    }
} else {
    // ถ้าค่าที่จำเป็น (examsets_id หรือ username) ไม่ครบ
    http_response_code(400);
    echo json_encode(['error' => 'Missing required parameters: examsets_id or username']);
}
?>
