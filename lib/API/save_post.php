<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

include "connect.php"; 

try {
    // เชื่อมต่อกับฐานข้อมูล
    $conn = new PDO("mysql:host=$servername;dbname=$dbname;charset=utf8", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    echo json_encode(['error' => "Connection failed: " . $e->getMessage()]);
    exit;
}

// รับข้อมูลจากฟอร์ม
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $title = $_POST['posts_title'];
    $classroomName = $_POST['classroom_name'];
    $classroomMajor = $_POST['classroom_major'];
    $classroomYear = $_POST['classroom_year'];
    $classroomNumRoom = $_POST['classroom_numroom'];
    $usertUsername = $_POST['usert_username'];

    // สร้างคำสั่ง SQL เพื่อบันทึกข้อมูลโพสต์
    $sql_post = "INSERT INTO posts (posts_title, classroom_id, usert_username)
                VALUES (:posts_title,
                        (SELECT classroom_id FROM classroom WHERE classroom_name = :classroomName 
                        AND classroom_major = :classroomMajor 
                        AND classroom_year = :classroomYear 
                        AND classroom_numroom = :classroomNumRoom), 
                        :usertUsername)";

    $stmt = $conn->prepare($sql_post);
    $stmt->bindParam(':posts_title', $title);
    $stmt->bindParam(':classroomName', $classroomName);
    $stmt->bindParam(':classroomMajor', $classroomMajor);
    $stmt->bindParam(':classroomYear', $classroomYear);
    $stmt->bindParam(':classroomNumRoom', $classroomNumRoom);
    $stmt->bindParam(':usertUsername', $usertUsername);

    // ตรวจสอบการบันทึกโพสต์
    if ($stmt->execute()) {
        // ดึง post_id ที่เพิ่งบันทึก
        $postId = $conn->lastInsertId();
        echo json_encode(['success' => 'Post saved successfully', 'post_id' => $postId]);
    } else {
        echo json_encode(['error' => 'Error saving post']);
    }
} else {
    echo json_encode(['error' => 'Invalid request method']);
}

$conn = null;
?>
