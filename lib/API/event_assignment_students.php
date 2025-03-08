<?php
include "connect.php"; // นำเข้าไฟล์เชื่อมต่อฐานข้อมูล

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json; charset=UTF-8");

// รับค่า `usert_username` จาก URL
$usert_username = $_GET['usert_username'];

// ตรวจสอบว่ามีค่า `usert_username` หรือไม่
if (empty($usert_username)) {
    echo json_encode(['status' => 'error', 'message' => 'กรุณาระบุค่า usert_username']);
    exit;
}

try {
    // เชื่อมต่อฐานข้อมูล
    $pdo = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    echo json_encode(['status' => 'error', 'message' => 'Connection failed: ' . $e->getMessage()]);
    exit;
}

// ค้นหาค่า `classroom_id` ทั้งหมดจากตาราง `students_inclass` ที่ตรงกับ `usert_username`
$stmt = $pdo->prepare("
    SELECT classroom.classroom_id 
    FROM students_inclass 
    INNER JOIN classroom ON students_inclass.classroom_id = classroom.classroom_id
    WHERE students_inclass.users_username = :usert_username 
      AND students_inclass.inclass_type = 0 
      AND classroom.classroom_type = 0
");
$stmt->bindParam(':usert_username', $usert_username);
$stmt->execute();
$classroom_ids = $stmt->fetchAll(PDO::FETCH_COLUMN);

if (empty($classroom_ids)) {
    echo json_encode(['status' => 'error', 'message' => 'ไม่พบข้อมูล classroom_id']);
    exit;
}

// แปลง `classroom_ids` เป็น string สำหรับใช้ในคำสั่ง SQL
$classroom_ids_str = implode(',', $classroom_ids);

// ค้นหาข้อมูลใน `event_assignment` ที่ตรงกับ `classroom_id` ทั้งหมด
$stmt = $pdo->prepare("SELECT * FROM event_assignment WHERE event_assignment_classID IN ($classroom_ids_str)");
$stmt->execute();
$events = $stmt->fetchAll(PDO::FETCH_ASSOC);

if (empty($events)) {
    echo json_encode(['status' => 'error', 'message' => 'ไม่พบข้อมูลกิจกรรม']);
    exit;
}

// ดึงข้อมูลห้องเรียนและรวมข้อมูลเข้าไปในกิจกรรม
foreach ($events as &$event) {
    $classID = $event['event_assignment_classID'];
    
    // ค้นหาข้อมูลห้องเรียนจาก `classroom`
    $stmt = $pdo->prepare("
        SELECT classroom_name, classroom_major, classroom_year, classroom_numroom 
        FROM classroom 
        WHERE classroom_id = :classroom_id
    ");
    $stmt->bindParam(':classroom_id', $classID);
    $stmt->execute();
    $classroom = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($classroom) {
        $event['classroom_name'] = $classroom['classroom_name'];
        $event['classroom_major'] = $classroom['classroom_major'];
        $event['classroom_year'] = $classroom['classroom_year'];
        $event['classroom_numroom'] = $classroom['classroom_numroom'];
    } else {
        $event['classroom_name'] = '';
        $event['classroom_major'] = '';
        $event['classroom_year'] = '';
        $event['classroom_numroom'] = '';
    }
}

// ส่งข้อมูลทั้งหมดในรูปแบบ JSON
echo json_encode([
    'status' => 'success',
    'data_assignment' => $events
]);
?>
