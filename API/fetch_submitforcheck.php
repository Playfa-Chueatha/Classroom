<?php
header("Access-Control-Allow-Origin: *");
header('Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, PATCH, DELETE');
header('Access-Control-Allow-Headers: *');
header('Access-Control-Max-Age: 86400');

include 'connect.php';

try {
    $conn = new PDO("mysql:host=$servername;dbname=$dbname;charset=utf8", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    $prefix = $_POST['users_prefix'] ?? '';
    $thfname = $_POST['users_thfname'] ?? '';
    $thlname = $_POST['users_thlname'] ?? '';
    $number = $_POST['users_number'] ?? '';
    $autoId = $_POST['auto_id'] ?? ''; // รับค่า autoId จาก UI

    if (empty($prefix) || empty($thfname) || empty($thlname) || empty($number) || empty($autoId)) {
        echo json_encode(['error' => 'Missing required fields.']);
        exit;
    }

    $stmt1 = $conn->prepare("
        SELECT users_username 
        FROM user_students 
        WHERE users_prefix = :prefix 
        AND users_thfname = :thfname 
        AND users_thlname = :thlname 
        AND users_number = :number
    ");
    $stmt1->execute([
        ':prefix' => $prefix,
        ':thfname' => $thfname,
        ':thlname' => $thlname,
        ':number' => $number,
    ]);

    $userResult = $stmt1->fetch(PDO::FETCH_ASSOC);

    if (!$userResult) {
        echo json_encode(['error' => 'User not found.']);
        exit;
    }

    $users_username = $userResult['users_username'];

    $stmt2 = $conn->prepare("
        SELECT submit_auswer_auto, examsets_id, question_id, submit_auswer_reply 
        FROM submit_auswer 
        WHERE users_username = :users_username
        AND examsets_id = :auto_id
    "); // เพิ่มเงื่อนไขตรวจสอบ examsets_id
    $stmt2->execute([
        ':users_username' => $users_username,
        ':auto_id' => $autoId,
    ]);

    $submitResults = $stmt2->fetchAll(PDO::FETCH_ASSOC);

    if (!$submitResults) {
        echo json_encode(['user' => $userResult, 'submissions' => []]);
        exit;
    }

    // ดึงข้อมูลเพิ่มเติมจาก auswer_question รวมถึง auswer_question_score
    $enhancedSubmissions = [];
    foreach ($submitResults as $submission) {
        $stmt3 = $conn->prepare("
            SELECT question_auto, question_detail, auswer_question_score 
            FROM auswer_question 
            WHERE question_auto = :question_id
            AND examsets_id = :auto_id
        "); // เพิ่มเงื่อนไขตรวจสอบ examsets_id
        $stmt3->execute([
            ':question_id' => $submission['question_id'],
            ':auto_id' => $autoId,
        ]);
        $questionDetails = $stmt3->fetch(PDO::FETCH_ASSOC);

        if ($questionDetails) {
            // เพิ่มข้อมูล auswer_question_score ไปยัง submission
            $submission['question_details'] = $questionDetails;
        } else {
            $submission['question_details'] = null; // กรณีที่ไม่มีข้อมูลใน auswer_question
        }

        $enhancedSubmissions[] = $submission;
    }

    echo json_encode(['user' => $userResult, 'submissions' => $enhancedSubmissions]);

} catch (PDOException $e) {
    error_log("Database error: " . $e->getMessage());
    echo json_encode(['error' => 'Database error.']);
    exit;
}
?>
