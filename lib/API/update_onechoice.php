<?php
header("Access-Control-Allow-Origin: *");
header('Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, PATCH, DELETE');
header('Access-Control-Allow-Headers: Content-Type');
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
    echo json_encode(['error' => 'Connection failed.']);
    exit;
}

// รับค่าจาก POST request
$autoId = $_POST['autoId'];
$question = $_POST['question'];
$a = $_POST['a'];
$b = $_POST['b'];
$c = $_POST['c'];
$d = $_POST['d'];
$answer = $_POST['answer'];
$score = $_POST['score'];

// ตรวจสอบว่าเรามีค่าครบหรือไม่
if (isset($autoId, $question, $a, $b, $c, $d, $answer, $score)) {
    // สร้างคำสั่ง SQL สำหรับอัปเดตข้อมูล
    $sql = "UPDATE onechoice SET 
            onechoice_question = :question,
            onechoice_a = :a,
            onechoice_b = :b,
            onechoice_c = :c,
            onechoice_d = :d,
            onechoice_answer = :answer,
            onechoice_question_score = :score
            WHERE onechoice_auto = :autoId";

    // เตรียมคำสั่ง SQL
    $stmt = $conn->prepare($sql);
    
    // ผูกค่าต่าง ๆ กับคำสั่ง SQL
    $stmt->bindParam(':autoId', $autoId);
    $stmt->bindParam(':question', $question);
    $stmt->bindParam(':a', $a);
    $stmt->bindParam(':b', $b);
    $stmt->bindParam(':c', $c);
    $stmt->bindParam(':d', $d);
    $stmt->bindParam(':answer', $answer);
    $stmt->bindParam(':score', $score);

    // ประมวลผลคำสั่ง SQL
    if ($stmt->execute()) {
        echo json_encode(['success' => 'Data updated successfully']);
    } else {
        echo json_encode(['error' => 'Failed to update data']);
    }
} else {
    echo json_encode(['error' => 'Missing required parameters']);
}
?>
