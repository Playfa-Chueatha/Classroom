<?php
include 'connect.php';

header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');

$conn = new mysqli($servername, $username, $password, $dbname);

// ตรวจสอบการเชื่อมต่อ
if ($conn->connect_error) {
    die(json_encode(["error" => "Connection failed: " . $conn->connect_error]));
}

// รับข้อมูลจาก Flutter
$commentTitle = isset($_POST['commentTitle']) ? $_POST['commentTitle'] : null;
$postId = isset($_POST['postId']) ? $_POST['postId'] : null;
$classroomId = isset($_POST['classroomId']) ? $_POST['classroomId'] : null;
$commentUsername = isset($_POST['Username']) ? $_POST['Username'] : null;

// ตรวจสอบค่าที่รับมาว่าครบถ้วนหรือไม่
if (!$commentTitle) {
    echo json_encode(["error" => "Missing commentTitle"]);
    exit();
}
if (!$postId) {
    echo json_encode(["error" => "Missing postId"]);
    exit();
}
if (!$classroomId) {
    echo json_encode(["error" => "Missing classroomId"]);
    exit();
}
if (!$commentUsername) {
    echo json_encode(["error" => "Missing commentUsername"]);
    exit();
}

$commentTime = date('Y-m-d H:i:s'); // ใช้เวลาปัจจุบัน

// เตรียมคำสั่ง SQL
$sql = "INSERT INTO comment (comment_time, comment_title, posts_id, classroom_id, comment_username) 
        VALUES (?, ?, ?, ?, ?)";

// เตรียมคำสั่ง SQL
$stmt = $conn->prepare($sql);

// ตรวจสอบว่าเตรียมคำสั่งได้สำเร็จหรือไม่
if ($stmt === false) {
    die(json_encode(["error" => 'Error preparing SQL query: ' . $conn->error]));
}

// ผูกพารามิเตอร์กับคำสั่ง SQL
$stmt->bind_param("sssss", $commentTime, $commentTitle, $postId, $classroomId, $commentUsername);

// ตรวจสอบว่าแทรกข้อมูลสำเร็จหรือไม่
if ($stmt->execute()) {
    echo json_encode(["success" => "Comment added successfully"]);
} else {
    echo json_encode(["error" => "Failed to add comment: " . $stmt->error]);
}

// ปิดการเชื่อมต่อ
$stmt->close();
$conn->close();
?>
