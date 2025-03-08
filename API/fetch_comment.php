<?php
include "connect.php"; 

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

if (!isset($_POST['postId']) || !isset($_POST['classroomId'])) {
    echo json_encode(['error' => 'Missing postId or classroomId']);
    exit;
}

$postId = $_POST['postId']; // รับค่า postId
$classroomId = $_POST['classroomId']; // รับค่า classroomId

// แก้ไข SQL Query เพื่อดึงค่า comment_auto ด้วย
$sql = "SELECT c.comment_auto, c.comment_time, c.comment_title, c.comment_username
        FROM comment c
        WHERE c.posts_id = ? AND c.classroom_id = ?";
$stmt = $conn->prepare($sql);

if ($stmt === false) {
    echo json_encode(['error' => 'SQL prepare failed: ' . $conn->error]);
    exit;
}

$stmt->bind_param("ss", $postId, $classroomId);
$stmt->execute();

$stmt->store_result();
$stmt->bind_result($comment_auto, $comment_time, $comment_title, $comment_username);

$comments = [];
while ($stmt->fetch()) {
    $comment = [
        'comment_auto' => $comment_auto, // เพิ่มค่า comment_auto
        'comment_time' => $comment_time,
        'comment_title' => $comment_title,
        'comment_username' => $comment_username
    ];

    // ตรวจสอบว่าชื่อผู้ใช้ในตาราง user_students มีอยู่หรือไม่
    $sqlUserStudent = "SELECT users_thfname, users_thlname FROM user_students WHERE users_username = ?";
    $stmtUserStudent = $conn->prepare($sqlUserStudent);
    if ($stmtUserStudent === false) {
        echo json_encode(['error' => 'SQL prepare failed: ' . $conn->error]);
        exit;
    }
    $stmtUserStudent->bind_param("s", $comment_username);
    $stmtUserStudent->execute();
    $stmtUserStudent->store_result();
    $stmtUserStudent->bind_result($users_thfname, $users_thlname);
    $stmtUserStudent->fetch();

    // ตรวจสอบว่าชื่อผู้ใช้ในตาราง user_teacher มีอยู่หรือไม่
    $sqlUserTeacher = "SELECT usert_thfname, usert_thlname FROM user_teacher WHERE usert_username = ?";
    $stmtUserTeacher = $conn->prepare($sqlUserTeacher);
    if ($stmtUserTeacher === false) {
        echo json_encode(['error' => 'SQL prepare failed: ' . $conn->error]);
        exit;
    }
    $stmtUserTeacher->bind_param("s", $comment_username);
    $stmtUserTeacher->execute();
    $stmtUserTeacher->store_result();
    $stmtUserTeacher->bind_result($usert_thfname, $usert_thlname);
    $stmtUserTeacher->fetch();

    // ตรวจสอบข้อมูลที่พบในตาราง user_students หรือ user_teacher
    if ($stmtUserStudent->num_rows > 0) {
        $comment['thfname'] = $users_thfname;
        $comment['thlname'] = $users_thlname;
    } elseif ($stmtUserTeacher->num_rows > 0) {
        $comment['thfname'] = $usert_thfname;
        $comment['thlname'] = $usert_thlname;
    } else {
        $comment['thfname'] = 'ไม่พบข้อมูล';
        $comment['thlname'] = 'ไม่พบข้อมูล';
    }

    // เพิ่มคอมเมนต์ลงในอาร์เรย์
    $comments[] = $comment;
}

echo json_encode($comments);

$conn->close();
?>
