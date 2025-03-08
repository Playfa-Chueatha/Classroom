<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

include "connect.php";

$data = json_decode(file_get_contents("php://input"), true);

$examsets_id = $data['examsets_id'] ?? null;
$users_username = $data['users_username'] ?? null;
$answers = $data['answers'] ?? [];

if (!$examsets_id || !$users_username || empty($answers)) {
    echo json_encode(['success' => false, 'message' => 'ข้อมูลไม่ครบถ้วน']);
    exit;
}

try {
    $conn->beginTransaction();

    foreach ($answers as $answer) {
        $question_id = $answer['question_id'] ?? null;
        $submit_auswer_reply = $answer['submit_auswer_reply'] ?? '';

        if ($question_id === null) {
            continue; 
        }

        $stmt = $conn->prepare("
            INSERT INTO submit_auswer 
            (examsets_id, question_id, submit_auswer_reply, users_username, submit_auswer_time) 
            VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP)
        ");
        $stmt->execute([$examsets_id, $question_id, $submit_auswer_reply, $users_username]);
    }
    
    //ขั้นตอนเพิ่มข้อมูลในตาราง notification_sibmit
    $stmt = $conn->prepare("SELECT classroom_id, examsets_direction, usert_username FROM examsets WHERE examsets_auto = ?");
    $stmt->execute([$examsets_id]);
    $examsets = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$examsets) {
        throw new Exception('ไม่พบข้อมูลในตาราง examsets');
    }

    $classroom_id = $examsets['classroom_id'];
    $examsets_direction = $examsets['examsets_direction'];
    $usert_username = $examsets['usert_username'];

    // ขั้นตอนที่ 3: เพิ่มข้อมูลลงในตาราง notification_sibmit
    $stmt = $conn->prepare("
        INSERT INTO notification_sibmit 
        (notification_sibmit_users, notification_sibmit_classID, notification_sibmit_title, notification_sibmit_usert, notification_sibmit_time, notification_sibmit_readstatus) 
        VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP, 'notread')
    ");
    $stmt->execute([$users_username, $classroom_id, $examsets_direction, $usert_username]);

    $conn->commit();
    echo json_encode(['success' => true, 'message' => 'บันทึกข้อมูลสำเร็จ']);
} catch (Exception $e) {
    $conn->rollBack();
    error_log($e->getMessage());
    echo json_encode(['success' => false, 'message' => 'เกิดข้อผิดพลาดในการบันทึกข้อมูล']);
}
?>
