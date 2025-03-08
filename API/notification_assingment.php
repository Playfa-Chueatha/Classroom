<?php
// เปิดการแสดงข้อผิดพลาดเพื่อช่วยในการดีบัก
ini_set('display_errors', 1);
error_reporting(E_ALL);

// ตั้งค่าหัวข้อ Content-Type ให้เป็น JSON
header('Content-Type: application/json');

include 'connect.php';

try {
    $username = $_POST['username']; // รับ username จาก Flutter
    if (!$username) {
        throw new Exception('Username is required');
    }

    // ดึงข้อมูลการแจ้งเตือนทั้งหมดที่ตรงกับ notification_assingment_users
    $stmt1 = $conn->prepare("
        SELECT 
            notification_assingment_auto, 
            notification_assingment_title, 
            notification_assingment_classID, 
            notification_assingment_time, 
            notification_assingment_duedate, 
            notification_assingment_usert, 
            notification_assingment_readstatus,
            notification_assingment_users
        FROM notification_assingment
        WHERE notification_assingment_users = :username
    ");
    $stmt1->bindParam(':username', $username);
    $stmt1->execute();
    $notifications = $stmt1->fetchAll(PDO::FETCH_ASSOC);

    if (empty($notifications)) {
        // ถ้าไม่พบข้อมูลที่ตรงกับ username
        echo json_encode([
            'message' => 'No notifications found for username: ' . $username,
            'notifications' => []
        ]);
        exit;
    }

    // ดึงข้อมูล classroom ที่เกี่ยวข้องจาก classroom_id
    $classroomIds = array_column($notifications, 'notification_assingment_classID');
    $placeholders = implode(',', array_fill(0, count($classroomIds), '?'));

    // ดึงข้อมูลจากตาราง classroom
    $stmt2 = $conn->prepare("
        SELECT 
            c.classroom_id,
            c.classroom_name,
            c.classroom_major,
            c.classroom_year,
            c.classroom_numroom
        FROM classroom AS c
        WHERE c.classroom_id IN ($placeholders)
    ");
    $stmt2->execute($classroomIds);
    $classroomData = $stmt2->fetchAll(PDO::FETCH_ASSOC);

    // รวมข้อมูลการแจ้งเตือนกับข้อมูลห้องเรียน
    foreach ($notifications as $key => $notification) {
        foreach ($classroomData as $classroom) {
            if ($notification['notification_assingment_classID'] == $classroom['classroom_id']) {
                $notifications[$key]['classroom_name'] = $classroom['classroom_name'];
                $notifications[$key]['classroom_major'] = $classroom['classroom_major'];
                $notifications[$key]['classroom_year'] = $classroom['classroom_year'];
                $notifications[$key]['classroom_numroom'] = $classroom['classroom_numroom'];
            }
        }
    }

    // ส่งข้อมูลที่รวมแล้วในรูปแบบ JSON
    echo json_encode([
        'message' => 'Received username: ' . $username,
        'notifications' => $notifications
    ]);
} catch (Exception $e) {
    // ส่งข้อผิดพลาดในรูปแบบ JSON หากเกิดข้อผิดพลาด
    echo json_encode(['error' => $e->getMessage()]);
}
?>
