<?php
header("Access-Control-Allow-Origin: *");
header('Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, PATCH, DELETE');
header('Access-Control-Allow-Headers: *');
header('Access-Control-Max-Age: 86400');

include "connect.php";

try {
    // ตั้งค่าการเชื่อมต่อฐานข้อมูล
    $conn = new PDO("mysql:host=$servername;dbname=$dbname;charset=utf8", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    error_log("Connection failed: " . $e->getMessage());
    echo json_encode(['error' => 'Connection failed.']);
    exit;
}

// รับค่าจาก POST
$classroomName = $_POST['classroomName'];
$classroomMajor = $_POST['classroomMajor'];
$classroomYear = $_POST['classroomYear'];
$classroomNumRoom = $_POST['classroomNumRoom'];
$username = $_POST['username'];

try {
    // ดึง classroom_id จากตาราง classroom
    $classroom_query = $conn->prepare("SELECT classroom_id FROM classroom WHERE classroom_name = :name AND classroom_major = :major AND classroom_year = :year AND classroom_numroom = :numroom");
    $classroom_query->execute([
        ':name' => $classroomName,
        ':major' => $classroomMajor,
        ':year' => $classroomYear,
        ':numroom' => $classroomNumRoom
    ]);

    $classroom_row = $classroom_query->fetch(PDO::FETCH_ASSOC);

    if ($classroom_row) {
        $classroom_id = $classroom_row['classroom_id'];

        // ดึงข้อมูลทั้งหมดจากตาราง examsets
        $examsets_query = $conn->prepare("SELECT `examsets_auto`, `examsets_direction`, `examsets_fullmark`, `examsets_deadline`, `classroom_id`, `usert_username`, `examsets_time`, `examsets_type`, `examsets_closed`, `examsets_Inspection_status` FROM `examsets` WHERE classroom_id = :classroom_id AND usert_username = :username");
        $examsets_query->execute([
            ':classroom_id' => $classroom_id,
            ':username' => $username
        ]);

        $examsets_data = $examsets_query->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode($examsets_data);
    } else {
        // หากไม่มีข้อมูล classroom
        echo json_encode([]);
    }
} catch (Exception $e) {
    error_log("Error fetching data: " . $e->getMessage());
    echo json_encode(['error' => 'Failed to fetch data.']);
}
?>
