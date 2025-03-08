<?php
// รวมไฟล์เชื่อมต่อฐานข้อมูล
include 'connect.php';

// รับค่าจาก POST
$autoId = isset($_POST['autoId']) ? $_POST['autoId'] : '';
$username = isset($_POST['username']) ? $_POST['username'] : '';

// ตรวจสอบค่า autoId และ username
if (empty($autoId) || empty($username)) {
    echo json_encode(['error' => 'autoId or username is missing']);
    exit;
}

try {
    // ขั้นตอนที่ 2: ดึงข้อมูลจากตาราง onechoice
    $sql_onechoice = "SELECT onechoice_auto, examsets_id, onechoice_question, onechoice_a, onechoice_b, onechoice_c, onechoice_d, onechoice_answer, onechoice_question_score FROM onechoice WHERE examsets_id = :autoId";
    $stmt_onechoice = $conn->prepare($sql_onechoice);
    $stmt_onechoice->bindParam(':autoId', $autoId, PDO::PARAM_INT);
    $stmt_onechoice->execute();
    $onechoice_data = $stmt_onechoice->fetchAll(PDO::FETCH_ASSOC);

    // ขั้นตอนที่ 3: ดึงข้อมูลจากตาราง submit_onechoice
    $sql_submit_onechoice = "SELECT submit_onechoice_auto, examsets_id, question_id, submit_onechoice_reply, submit_onechoice_score, submit_onechoice_time, users_username FROM submit_onechoice WHERE examsets_id = :autoId AND users_username = :username";
    $stmt_submit_onechoice = $conn->prepare($sql_submit_onechoice);
    $stmt_submit_onechoice->bindParam(':autoId', $autoId, PDO::PARAM_INT);
    $stmt_submit_onechoice->bindParam(':username', $username, PDO::PARAM_STR);
    $stmt_submit_onechoice->execute();
    $submit_onechoice_data = $stmt_submit_onechoice->fetchAll(PDO::FETCH_ASSOC);

    // ส่งข้อมูลกลับไปยัง UI
    $response = [
        'onechoice_data' => $onechoice_data,
        'submit_onechoice_data' => $submit_onechoice_data
    ];

    echo json_encode($response);
} catch (PDOException $e) {
    // ถ้ามีข้อผิดพลาดเกิดขึ้น
    echo json_encode(['error' => $e->getMessage()]);
} finally {
    $conn = null; // ปิดการเชื่อมต่อฐานข้อมูล
}
?>
