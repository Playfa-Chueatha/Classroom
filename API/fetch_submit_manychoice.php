<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *"); // อนุญาตให้ทุกโดเมนสามารถร้องขอ
header("Access-Control-Allow-Methods: GET, POST, OPTIONS"); // อนุญาตให้ใช้ GET และ POST
header("Access-Control-Allow-Headers: Content-Type"); // อนุญาตให้ใช้งาน header `Content-Type`

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

// ตรวจสอบว่ามีค่าผิดปกติ ให้หยุดการประมวลผล
if (empty($username) || empty($examsetsId)) {
    echo json_encode(["message" => "Invalid input parameters"]);
    exit;
}

// คำสั่ง SQL เพื่อดึงข้อมูลจากตาราง submit_manychoice
$sql = "
    SELECT 
        s.submit_manychoice_auto, 
        s.examsets_id, 
        s.question_id, 
        s.submit_manychoice_reply, 
        s.submit_manychoice_score, 
        s.submit_manychoice_time, 
        s.users_username 
    FROM submit_manychoice s
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
    $submit_manychoice_auto,
    $examsets_id,
    $question_id,
    $submit_manychoice_reply,
    $submit_manychoice_score,
    $submit_manychoice_time,
    $users_username
);

$response = [];

// ดึงข้อมูล
while ($stmt->fetch()) {
    // แปลง submit_manychoice_reply ให้เป็น array (แยกค่าด้วย comma)
    $replyArray = explode(',', str_replace(['(', ')', "'"], '', $submit_manychoice_reply)); // ลบ () และ ' แล้วแยกด้วย comma

    // เพิ่มข้อมูลลงใน response
    $response[] = [
        "submit_manychoice_auto" => $submit_manychoice_auto,
        "examsets_id" => $examsets_id,
        "question_id" => $question_id,
        "submit_manychoice_reply" => $replyArray, // แสดงคำตอบที่เลือกในรูปแบบ array
        "submit_manychoice_score" => $submit_manychoice_score,
        "submit_manychoice_time" => $submit_manychoice_time,
        "users_username" => $users_username
    ];
}

// ตรวจสอบว่ามีข้อมูลหรือไม่
if (empty($response)) {
    $response = ["message" => "No results found"];
}

// ตรวจสอบการแปลงเป็น JSON ก่อนส่งออก
$response_json = json_encode($response);

// ตรวจสอบว่า json_encode() ส่งกลับค่าเป็นค่าผิดพลาดหรือไม่
if (json_last_error() !== JSON_ERROR_NONE) {
    // ถ้าเกิดข้อผิดพลาดในการแปลงเป็น JSON ให้ส่งข้อความแสดงข้อผิดพลาด
    echo json_encode(["message" => "Error encoding JSON: " . json_last_error_msg()]);
    exit;
}

// ส่งผลลัพธ์กลับในรูปแบบ JSON
echo $response_json;

// ปิดการเชื่อมต่อ
$stmt->close();
$conn->close();
?>
