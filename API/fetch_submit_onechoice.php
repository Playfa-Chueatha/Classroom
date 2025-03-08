<?php
header('Content-Type: application/json');

// เชื่อมต่อฐานข้อมูล
include 'connect.php';

$conn = new mysqli($servername, $username, $password, $dbname);

// ตรวจสอบการเชื่อมต่อ
if ($conn->connect_error) {
    die(json_encode(["message" => "Connection failed: " . $conn->connect_error]));
}

// รับค่าจากคำขอ GET
$username = $_GET['username'] ?? ''; // ตรวจสอบว่ามี username หรือไม่
$examsetsId = $_GET['examsetsId'] ?? ''; // ตรวจสอบว่ามี examsetsId หรือไม่

if (empty($username) || empty($examsetsId)) {
    echo json_encode(["message" => "Invalid input parameters"]);
    exit;
}

// คำสั่ง SQL เพื่อดึงข้อมูลจากตาราง submit_onechoice และ examsets
$sql = "
    SELECT 
        s.submit_onechoice_auto, 
        s.examsets_id, 
        s.question_id, 
        s.submit_onechoice_reply, 
        s.submit_onechoice_score, 
        s.submit_onechoice_time, 
        s.users_username, 
        e.examsets_fullmark
    FROM submit_onechoice s
    LEFT JOIN examsets e ON s.examsets_id = e.examsets_auto
    WHERE s.users_username = ? AND s.examsets_id = ?
";

// เตรียมคำสั่ง SQL
$stmt = $conn->prepare($sql);

if (!$stmt) {
    echo json_encode(["message" => "Prepare failed: " . $conn->error]);
    exit;
}

// ผูกพารามิเตอร์กับคำสั่ง SQL
$stmt->bind_param("si", $username, $examsetsId);

// รันคำสั่ง SQL
$stmt->execute();

// ผูกผลลัพธ์กับตัวแปร
$stmt->bind_result(
    $submit_onechoice_auto,
    $examsets_id,
    $question_id,
    $submit_onechoice_reply,
    $submit_onechoice_score,
    $submit_onechoice_time,
    $users_username,
    $examsets_fullmark
);

$response = [];

// ดึงข้อมูล
while ($stmt->fetch()) {
    $response[] = [
        "submit_onechoice_auto" => $submit_onechoice_auto,
        "examsets_id" => $examsets_id,
        "question_id" => $question_id,
        "submit_onechoice_reply" => $submit_onechoice_reply,
        "submit_onechoice_score" => $submit_onechoice_score,
        "submit_onechoice_time" => $submit_onechoice_time,
        "users_username" => $users_username,
        "examsets_fullmark" => $examsets_fullmark,
    ];
}

// ตรวจสอบว่ามีข้อมูลหรือไม่
if (empty($response)) {
    $response = ["message" => "No results found"];
}

// ส่งผลลัพธ์กลับในรูปแบบ JSON
echo json_encode($response);

// ปิดการเชื่อมต่อ
$stmt->close();
$conn->close();
?>
