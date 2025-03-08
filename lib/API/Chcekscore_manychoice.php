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
    // ขั้นตอนที่ 2: ดึงข้อมูลจากตาราง manychoice
    $sql_manychoice = "
        SELECT 
            manychoice_auto, 
            examsets_id, 
            manychoice_question, 
            manychoice_a, 
            manychoice_b, 
            manychoice_c, 
            manychoice_d, 
            manychoice_e, 
            manychoice_f, 
            manychoice_g, 
            manychoice_h, 
            manychoice_answer, 
            manychoice_question_score 
        FROM manychoice 
        WHERE examsets_id = :autoId";
    $stmt_manychoice = $conn->prepare($sql_manychoice);
    $stmt_manychoice->bindParam(':autoId', $autoId, PDO::PARAM_INT);
    $stmt_manychoice->execute();
    $manychoice_data = $stmt_manychoice->fetchAll(PDO::FETCH_ASSOC);

    // ขั้นตอนที่ 3: ดึงข้อมูลจากตาราง submit_manychoice
    $sql_submit_manychoice = "
        SELECT 
            submit_manychoice_auto, 
            examsets_id, 
            question_id, 
            submit_manychoice_reply, 
            submit_manychoice_score, 
            submit_manychoice_time, 
            users_username 
        FROM submit_manychoice 
        WHERE examsets_id = :autoId 
        AND users_username = :username";
    $stmt_submit_manychoice = $conn->prepare($sql_submit_manychoice);
    $stmt_submit_manychoice->bindParam(':autoId', $autoId, PDO::PARAM_INT);
    $stmt_submit_manychoice->bindParam(':username', $username, PDO::PARAM_STR);
    $stmt_submit_manychoice->execute();
    $submit_manychoice_data = $stmt_submit_manychoice->fetchAll(PDO::FETCH_ASSOC);

    // ส่งข้อมูลกลับไปยัง UI
    $response = [
        'manychoice_data' => $manychoice_data,
        'submit_manychoice_data' => $submit_manychoice_data
    ];

    echo json_encode($response);
} catch (PDOException $e) {
    // ถ้ามีข้อผิดพลาดเกิดขึ้น
    echo json_encode(['error' => $e->getMessage()]);
} finally {
    $conn = null; // ปิดการเชื่อมต่อฐานข้อมูล
}
?>
