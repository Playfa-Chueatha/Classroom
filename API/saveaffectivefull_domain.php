<?php
// เชื่อมต่อฐานข้อมูล
header("Access-Control-Allow-Origin: *");
header('Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, PATCH, DELETE');
header('Access-Control-Allow-Headers: *');
header('Access-Control-Max-Age: 86400');

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

// ตรวจสอบว่า request ใช้ method POST และข้อมูลที่ต้องการได้รับมา
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // รับข้อมูลจาก request body
    $data = json_decode(file_get_contents("php://input"), true);

    // ตรวจสอบว่าข้อมูลที่ต้องการมาครบหรือไม่
    if (isset($data['classroomName'], $data['classroomMajor'], $data['classroomYear'], $data['classroomNumRoom'], $data['usert_username'], $data['affectivefull_domain_score'])) {
        $classroomName = $data['classroomName'];
        $classroomMajor = $data['classroomMajor'];
        $classroomYear = $data['classroomYear'];
        $classroomNumRoom = $data['classroomNumRoom'];
        $usertUsername = $data['usert_username'];
        $fullScore = $data['affectivefull_domain_score'];

        try {
            // 1. ดึง classroom_id จากตาราง classroom
            $stmt = $conn->prepare("SELECT classroom_id FROM classroom WHERE classroom_name = :classroomName AND classroom_major = :classroomMajor AND classroom_year = :classroomYear AND classroom_numroom = :classroomNumRoom");
            $stmt->bindParam(':classroomName', $classroomName);
            $stmt->bindParam(':classroomMajor', $classroomMajor);
            $stmt->bindParam(':classroomYear', $classroomYear);
            $stmt->bindParam(':classroomNumRoom', $classroomNumRoom);
            $stmt->execute();
            $classroom = $stmt->fetch(PDO::FETCH_ASSOC);

            if ($classroom) {
                $classroomId = $classroom['classroom_id'];

                // ตรวจสอบว่ามีข้อมูลที่ตรงกันใน affectivefull_domain หรือไม่
                $checkStmt = $conn->prepare("SELECT * FROM affectivefull_domain WHERE affectivefull_domain_classID = :classroom_id AND usert_username = :usert_username");
                $checkStmt->bindParam(':classroom_id', $classroomId);
                $checkStmt->bindParam(':usert_username', $usertUsername);
                $checkStmt->execute();
                $existingRecord = $checkStmt->fetch(PDO::FETCH_ASSOC);

                if ($existingRecord) {
                    // ถ้ามีข้อมูล ให้ทำการอัปเดต
                    $updateStmt = $conn->prepare("UPDATE affectivefull_domain SET affectivefull_domain_score = :affectivefull_domain_score WHERE affectivefull_domain_classID = :classroom_id AND usert_username = :usert_username");
                    $updateStmt->bindParam(':classroom_id', $classroomId);
                    $updateStmt->bindParam(':usert_username', $usertUsername);
                    $updateStmt->bindParam(':affectivefull_domain_score', $fullScore);
                    $updateStmt->execute();

                    echo json_encode(['status' => 'success', 'message' => 'อัปเดตคะแนนเต็มสำเร็จ']);
                } else {
                    // ถ้าไม่มีข้อมูล ให้เพิ่มข้อมูลใหม่
                    $insertStmt = $conn->prepare("INSERT INTO affectivefull_domain (affectivefull_domain_classID, affectivefull_domain_score, usert_username) 
                                                  VALUES (:classroom_id, :affectivefull_domain_score, :usert_username)");
                    $insertStmt->bindParam(':classroom_id', $classroomId);
                    $insertStmt->bindParam(':usert_username', $usertUsername);
                    $insertStmt->bindParam(':affectivefull_domain_score', $fullScore);
                    $insertStmt->execute();

                    echo json_encode(['status' => 'success', 'message' => 'บันทึกคะแนนเต็มสำเร็จ']);
                }
            } else {
                echo json_encode(['status' => 'error', 'message' => 'ไม่พบข้อมูล classroom ที่ตรงกับที่ระบุ']);
            }
        } catch (PDOException $e) {
            // ถ้ามีข้อผิดพลาดในการดึงข้อมูลหรือลงข้อมูล
            echo json_encode(['status' => 'error', 'message' => 'ไม่สามารถดำเนินการได้: ' . $e->getMessage()]);
        }
    } else {
        // ถ้าข้อมูลไม่ครบ
        echo json_encode(['status' => 'error', 'message' => 'ข้อมูลไม่ครบ']);
    }
} else {
    // ถ้าไม่ใช่ POST method
    echo json_encode(['status' => 'error', 'message' => 'Method Not Allowed']);
}
?>
