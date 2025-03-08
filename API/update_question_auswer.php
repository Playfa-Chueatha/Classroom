<?php
header("Access-Control-Allow-Origin: *");
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

$servername = "118.27.130.237";
$username = "zgmupszw_edueliteroom1";
$password = "edueliteroom1";
$dbname = "zgmupszw_edueliteroom01";

try {
    // ตั้งค่าการเชื่อมต่อฐานข้อมูล
    $conn = new PDO("mysql:host=$servername;dbname=$dbname;charset=utf8", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // รับข้อมูลจากคำขอ POST
    $data = json_decode(file_get_contents('php://input'), true);

    $questionAuto = $data['question_auto'];
    $questionDetail = $data['question_detail'];
    $examsetsId = $data['examsets_id'];

    // ตรวจสอบว่ามีข้อมูลที่ตรงกันในตาราง auswer_question หรือไม่
    $stmt = $conn->prepare("SELECT * FROM auswer_question WHERE question_auto = :question_auto AND examsets_id = :examsets_id");
    $stmt->bindParam(':question_auto', $questionAuto);
    $stmt->bindParam(':examsets_id', $examsetsId);
    $stmt->execute();

    if ($stmt->rowCount() > 0) {
        // มีข้อมูลที่ตรงกัน ให้ทำการอัปเดต
        $updateStmt = $conn->prepare("UPDATE auswer_question SET question_detail = :question_detail WHERE question_auto = :question_auto AND examsets_id = :examsets_id");
        $updateStmt->bindParam(':question_detail', $questionDetail);
        $updateStmt->bindParam(':question_auto', $questionAuto);
        $updateStmt->bindParam(':examsets_id', $examsetsId);
        $updateStmt->execute();

        echo json_encode(['success' => true, 'message' => 'Question updated successfully']);
    } else {
        // ไม่มีข้อมูลที่ตรงกัน
        echo json_encode(['success' => false, 'message' => 'No matching question found']);
    }
} catch (PDOException $e) {
    echo json_encode(['success' => false, 'message' => 'Connection failed: ' . $e->getMessage()]);
}
?>
