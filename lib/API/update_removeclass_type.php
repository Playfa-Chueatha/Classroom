<?php
header("Access-Control-Allow-Origin: *");
header('Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, PATCH, DELETE');
header('Access-Control-Allow-Headers: *');
header('Access-Control-Max-Age: 86400');

include "connect.php";

try {
    // เชื่อมต่อกับฐานข้อมูล
    $conn = new PDO("mysql:host=$servername;dbname=$dbname;charset=utf8", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    // ตรวจสอบข้อผิดพลาดการเชื่อมต่อ
    error_log("Connection failed: " . $e->getMessage());
    echo json_encode(['error' => 'Connection failed.']);
    exit;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['users_id'], $_POST['classroomName'], $_POST['classroomMajor'], $_POST['classroomYear'], $_POST['classroomNumRoom'])) {
    // รับข้อมูลจาก POST
    $users_id = $_POST['users_id'];
    $classroomName = $_POST['classroomName'];
    $classroomMajor = $_POST['classroomMajor'];
    $classroomYear = $_POST['classroomYear'];
    $classroomNumRoom = $_POST['classroomNumRoom'];

    try {
        // แสดงค่าที่รับมาจาก POST สำหรับการตรวจสอบ
        var_dump($_POST);  // สำหรับดีบัก

        // ดึงข้อมูล users_username จาก user_students โดยใช้ users_id
        $stmt = $conn->prepare("SELECT users_username FROM user_students WHERE users_id = :users_id");
        $stmt->bindParam(':users_id', $users_id, PDO::PARAM_INT);
        $stmt->execute();
        $user = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($user) {
            $users_username = $user['users_username'];

            // ดึง classroom_id จาก classroom โดยใช้เงื่อนไข classroom_name, classroom_major, classroom_year, classroom_numroom
            $stmt = $conn->prepare("SELECT classroom_id FROM classroom WHERE classroom_name = :classroomName AND classroom_major = :classroomMajor AND classroom_year = :classroomYear AND classroom_numroom = :classroomNumRoom");
            $stmt->bindParam(':classroomName', $classroomName);
            $stmt->bindParam(':classroomMajor', $classroomMajor);
            $stmt->bindParam(':classroomYear', $classroomYear);
            $stmt->bindParam(':classroomNumRoom', $classroomNumRoom);
            $stmt->execute();
            $classroom = $stmt->fetch(PDO::FETCH_ASSOC);

            if ($classroom) {
                $classroom_id = $classroom['classroom_id'];

                // ตรวจสอบว่าในตาราง students_inclass มีข้อมูลที่ตรงกับ users_username และ classroom_id หรือไม่
                $stmt = $conn->prepare("SELECT * FROM students_inclass WHERE users_username = :users_username AND classroom_id = :classroom_id");
                $stmt->bindParam(':users_username', $users_username);
                $stmt->bindParam(':classroom_id', $classroom_id);
                $stmt->execute();
                $studentInClass = $stmt->fetch(PDO::FETCH_ASSOC);

                if ($studentInClass) {
                    // หากมีข้อมูลใน students_inclass ให้ทำการอัปเดต inclass_type เป็น 1
                    $stmt = $conn->prepare("UPDATE students_inclass SET inclass_type = 1 WHERE users_username = :users_username AND classroom_id = :classroom_id");
                    $stmt->bindParam(':users_username', $users_username);
                    $stmt->bindParam(':classroom_id', $classroom_id);
                    $stmt->execute();

                    // ตรวจสอบว่ามีการอัปเดตข้อมูลหรือไม่
                    if ($stmt->rowCount() > 0) {
                        echo json_encode(['success' => 'Inclass type updated successfully.']);
                    } else {
                        echo json_encode(['error' => 'No rows updated.']);
                    }
                } else {
                    echo json_encode(['error' => 'No matching student found in class.']);
                }
            } else {
                echo json_encode(['error' => 'Classroom not found.']);
            }
        } else {
            echo json_encode(['error' => 'User not found.']);
        }
    } catch (Exception $e) {
        // จัดการกับข้อผิดพลาด
        echo json_encode(['error' => 'An error occurred: ' . $e->getMessage()]);
    }
} else {
    echo json_encode(['error' => 'Invalid request method or missing parameters.']);
}
?>
