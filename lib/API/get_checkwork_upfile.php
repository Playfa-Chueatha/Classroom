<?php
header("Access-Control-Allow-Origin: *");
header('Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, PATCH, DELETE');
header('Access-Control-Allow-Headers: *');
header('Access-Control-Max-Age: 86400');

// รวมไฟล์การเชื่อมต่อฐานข้อมูล
include 'connect.php';

$examsets_id = isset($_GET['examsets_id']) ? $_GET['examsets_id'] : '';
$username = isset($_GET['username']) ? $_GET['username'] : '';

if ($examsets_id) {
    try {
        // Query ข้อมูลจากตาราง checkwork_upfile
        $sql = "SELECT `checkwork_upfile_auto`, `examsets_id`, `question_detail`, 
                `checkwork_upfile_score`, `users_username`, `checkwork_upfile_time`, `checkwork_upfile_comments`
                FROM `checkwork_upfile`
                WHERE `examsets_id` = :examsets_id AND `users_username` = :username";
        
        // เตรียมคำสั่ง SQL
        $stmt = $conn->prepare($sql);

        // Binding ค่าพารามิเตอร์
        $stmt->bindParam(':examsets_id', $examsets_id, PDO::PARAM_INT);
        $stmt->bindParam(':username', $username, PDO::PARAM_STR);

        // Execute คำสั่ง SQL
        $stmt->execute();

        // ดึงข้อมูลที่ได้มาเป็น Array
        $checkwork_upfile_data = $stmt->fetchAll(PDO::FETCH_ASSOC);

        // ส่งข้อมูลเป็น JSON
        echo json_encode($checkwork_upfile_data);

    } catch (PDOException $e) {
        // ถ้ามีข้อผิดพลาดใน SQL หรือการเชื่อมต่อ
        echo json_encode(['error' => 'Database query failed: ' . $e->getMessage()]);
    }
} else {
    // ถ้าไม่มี examsets_id
    echo json_encode(['error' => 'Missing examsets_id']);
}
?>
