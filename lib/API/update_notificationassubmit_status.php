<?php
header("Access-Control-Allow-Origin: *");
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: *');
header('Access-Control-Max-Age: 86400');

// ข้อมูลการเชื่อมต่อฐานข้อมูล
$servername = "118.27.130.237";
$username = "zgmupszw_edueliteroom1";
$password = "edueliteroom1";
$dbname = "zgmupszw_edueliteroom01";

// ตรวจสอบว่าได้รับค่า notification_id หรือไม่
if (isset($_POST['notification_id'])) {
    $notificationId = $_POST['notification_id'];

    try {
        // เชื่อมต่อกับฐานข้อมูล
        $conn = new PDO("mysql:host=$servername;dbname=$dbname;charset=utf8", $username, $password);
        $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

        // คำสั่ง SQL เพื่ออัปเดตสถานะการอ่าน
        $stmt = $conn->prepare("UPDATE notification_sibmit SET notification_sibmit_readstatus = 'Alreadyread' WHERE notification_sibmit_auto = :id");
        $stmt->bindParam(':id', $notificationId, PDO::PARAM_INT);

        // ทำการอัปเดต
        $stmt->execute();

        // ส่งผลลัพธ์กลับไปว่าอัปเดตสำเร็จ
        echo json_encode(['status' => 'success']);
    } catch (PDOException $e) {
        echo json_encode(['error' => 'Failed to update notification: ' . $e->getMessage()]);
    }
} else {
    echo json_encode(['error' => 'Notification ID is missing']);
}
?>
