<?php
include "connect.php";

// รับค่าจาก POST
$classroomName = $_POST['classroomName'];
$classroomMajor = $_POST['classroomMajor'];
$classroomYear = $_POST['classroomYear'];
$classroomNumRoom = $_POST['classroomNumRoom'];

try {
    // ขั้นตอนที่ 1: ดึง classroom_id จากตาราง classroom
    $stmt1 = $conn->prepare("
        SELECT classroom_id 
        FROM classroom 
        WHERE classroom_name = :classroomName 
          AND classroom_major = :classroomMajor 
          AND classroom_year = :classroomYear 
          AND classroom_numroom = :classroomNumRoom
    ");
    $stmt1->execute([
        ':classroomName' => $classroomName,
        ':classroomMajor' => $classroomMajor,
        ':classroomYear' => $classroomYear,
        ':classroomNumRoom' => $classroomNumRoom,
    ]);
    
    $classroom = $stmt1->fetch(PDO::FETCH_ASSOC);

    if (!$classroom) {
        echo json_encode(['error' => 'Classroom not found']);
        exit;
    }

    $classroomId = $classroom['classroom_id'];

    // ขั้นตอนที่ 2: ดึง users_username จากตาราง students_inclass
    $stmt2 = $conn->prepare("
        SELECT users_username 
        FROM students_inclass 
        WHERE classroom_id = :classroomId
        AND inclass_type = 0
    ");
    $stmt2->execute([':classroomId' => $classroomId]);
    $usernames = $stmt2->fetchAll(PDO::FETCH_COLUMN);

    if (empty($usernames)) {
        echo json_encode(['error' => 'No students found in this classroom']);
        exit;
    }

    // ขั้นตอนที่ 3: ดึงข้อมูลนักเรียนจากตาราง user_students
    $stmt3 = $conn->prepare("
        SELECT users_prefix, users_thfname, users_thlname, users_number, users_phone, users_id, users_username 
        FROM user_students 
        WHERE users_username IN (" . implode(',', array_map(function($key) { return ":username$key"; }, range(1, count($usernames)))) . ")
    ");
    
    // สร้างพารามิเตอร์สำหรับ usernames
    $params = [];
    foreach ($usernames as $index => $username) {
        $params[":username" . ($index + 1)] = $username;
    }
    
    $stmt3->execute($params);
    $students = $stmt3->fetchAll(PDO::FETCH_ASSOC);

    if (empty($students)) {
        echo json_encode(['error' => 'No student data found']);
        exit;
    }

    // ขั้นตอนที่ 4: ตรวจสอบข้อมูลการเช็คอินจากตาราง checkin_classroom
    $currentDate = date('Y-m-d'); // วันที่ปัจจุบันในรูปแบบ Y-m-d
    $stmt4 = $conn->prepare("
        SELECT users_username, checkin_classroom_status 
        FROM checkin_classroom 
        WHERE checkin_classroom_classID = :classroomId 
          AND checkin_classroom_date = :currentDate 
          AND users_username IN (" . implode(',', array_map(function($key) { return ":username$key"; }, range(1, count($usernames)))) . ")
    ");
    
    // ผูกพารามิเตอร์ทั้งหมดรวมถึง usernames ที่ต้องใช้
    $stmt4->execute(array_merge(
        ['classroomId' => $classroomId, 'currentDate' => $currentDate],
        $params
    ));

    $checkins = $stmt4->fetchAll(PDO::FETCH_ASSOC);

    // เพิ่มข้อมูลสถานะการเช็คอินลงในข้อมูลนักเรียน
    foreach ($students as &$student) {
        $status = '-'; // ค่าเริ่มต้นสำหรับกรณีไม่มีการเช็คอิน
        foreach ($checkins as $checkin) {
            if ($checkin['users_username'] == $student['users_username']) {
                $status = $checkin['checkin_classroom_status']; // ดึงสถานะจาก checkin_classroom
                break;
            }
        }
        $student['checkin_status'] = $status; // เพิ่มสถานะการเช็คอินให้กับข้อมูลนักเรียน
    }

    // ส่งข้อมูลนักเรียนพร้อมสถานะการเช็คอินกลับไปยัง UI
    echo json_encode($students);

} catch (PDOException $e) {
    // การจัดการข้อผิดพลาดจากฐานข้อมูล
    error_log("Query failed: " . $e->getMessage()); // เพิ่มการ log ข้อผิดพลาด
    echo json_encode(['error' => 'Query failed: ' . $e->getMessage()]); // ส่งข้อความข้อผิดพลาดกลับไป
}
?>
