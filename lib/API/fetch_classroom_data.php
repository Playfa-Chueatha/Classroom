<?php
header("Access-Control-Allow-Origin: *");
header('Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, PATCH, DELETE');
header('Access-Control-Allow-Headers: *');
header('Access-Control-Max-Age: 86400');

// ข้อมูลการเชื่อมต่อฐานข้อมูล
$servername = "118.27.130.237"; 
$username = "zgmupszw_edueliteroom1"; 
$password = "edueliteroom1"; 
$dbname = "zgmupszw_edueliteroom01"; 

try {
    // ตั้งค่าการเชื่อมต่อฐานข้อมูล
    $conn = new PDO("mysql:host=$servername;dbname=$dbname;charset=utf8", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION); // เปิดการแสดงข้อผิดพลาด
} catch (PDOException $e) {
    error_log("Connection failed: " . $e->getMessage()); // บันทึกข้อผิดพลาดลงใน Log
    echo json_encode(['error' => 'Connection failed.']); // ส่งกลับ JSON หากเชื่อมต่อไม่สำเร็จ
    exit;
}

// ฟังก์ชันเพื่อดึง classroom_id ตามข้อมูลห้องเรียน
function fetchClassroomId($classroomName, $classroomMajor, $classroomYear, $classroomNumRoom) {
    global $conn;
    $stmt = $conn->prepare("
        SELECT `classroom_id` FROM `classroom`
        WHERE `classroom_name` = :classroomName
        AND `classroom_major` = :classroomMajor
        AND `classroom_year` = :classroomYear
        AND `classroom_numroom` = :classroomNumRoom
    ");
    $stmt->execute([
        ':classroomName' => $classroomName,
        ':classroomMajor' => $classroomMajor,
        ':classroomYear' => $classroomYear,
        ':classroomNumRoom' => $classroomNumRoom,
    ]);
    
    $result = $stmt->fetch(PDO::FETCH_ASSOC);
    return $result ? $result['classroom_id'] : null;
}

// ฟังก์ชันเพื่อดึงข้อมูล users_username จาก students_inclass โดยใช้ classroom_id
function fetchStudentsInClass($classroomId) {
    global $conn;
    $stmt = $conn->prepare("
        SELECT `users_username` FROM `students_inclass`
        WHERE `classroom_id` = :classroomId
    ");
    $stmt->execute([':classroomId' => $classroomId]);
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
}

// ฟังก์ชันเพื่อดึงข้อมูล users_auto จาก user_students โดยใช้ users_username
function fetchUserAutoId($usersUsername) {
    global $conn;
    $stmt = $conn->prepare("
        SELECT `users_auto` FROM `user_students`
        WHERE `users_username` = :usersUsername
    ");
    $stmt->execute([':usersUsername' => $usersUsername]);
    return $stmt->fetch(PDO::FETCH_ASSOC);
}

// การรับค่า POST จากการเรียก API
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    // ดึงข้อมูลจาก URL query parameters
    $classroomName = isset($_GET['classroomName']) ? $_GET['classroomName'] : '';
    $classroomMajor = isset($_GET['classroomMajor']) ? $_GET['classroomMajor'] : '';
    $classroomYear = isset($_GET['classroomYear']) ? $_GET['classroomYear'] : '';
    $classroomNumRoom = isset($_GET['classroomNumRoom']) ? $_GET['classroomNumRoom'] : '';

    // ขั้นตอนการดึงข้อมูล classroom_id
    $classroomId = fetchClassroomId($classroomName, $classroomMajor, $classroomYear, $classroomNumRoom);
    
    if ($classroomId) {
        // หากพบ classroom_id ดึงข้อมูล students_inclass
        $studentsInClass = fetchStudentsInClass($classroomId);
        $userAutoData = [];
        
        // ดึงข้อมูล users_auto จาก user_students ตาม users_username
        foreach ($studentsInClass as $student) {
            $userAuto = fetchUserAutoId($student['users_username']);
            if ($userAuto) {
                $userAutoData[] = $userAuto['users_auto'];
            }
        }

        // ส่งข้อมูลกลับเป็น JSON
        echo json_encode([
            'status' => 'success',
            'classroom_id' => $classroomId,
            'users_auto' => $userAutoData,
        ]);
    } else {
        // หากไม่พบ classroom_id
        echo json_encode(['status' => 'error', 'message' => 'Classroom not found']);
    }
} else {
    // หากไม่ได้รับการร้องขอด้วย GET
    echo json_encode(['status' => 'error', 'message' => 'Invalid request method']);
}
?>
