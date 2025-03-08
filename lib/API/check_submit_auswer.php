<?php
header("Access-Control-Allow-Origin: *");
header('Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, PATCH, DELETE');
header('Access-Control-Allow-Headers: *');
header('Access-Control-Max-Age: 86400');

include "connect.php";

$username = $_POST['username'];
$examType = $_POST['examType'];
$examId = $_POST['examId'];

try {
    $exists = false;  // ค่าเริ่มต้น
    $submitTime = null; // ค่าเริ่มต้นของเวลาส่ง

    if ($examType == 'auswer') {
        $query = "SELECT COUNT(*) as count, submit_auswer_time as submitTime 
                  FROM submit_auswer 
                  WHERE users_username = :username AND examsets_id = :examId";
    } elseif ($examType == 'onechoice') {
        $query = "SELECT COUNT(*) as count, submit_onechoice_time as submitTime 
                  FROM submit_onechoice 
                  WHERE users_username = :username AND examsets_id = :examId";
    } elseif ($examType == 'manychoice') {
        $query = "SELECT COUNT(*) as count, submit_manychoice_time as submitTime 
                  FROM submit_manychoice 
                  WHERE users_username = :username AND examsets_id = :examId";
    } elseif ($examType == 'upfile') {
        $query = "SELECT COUNT(*) as count, submit_upfile_time as submitTime 
                  FROM submit_upfile 
                  WHERE users_username = :username AND examsets_id = :examId";
    }

    if (isset($query)) {
        $stmt = $conn->prepare($query);
        $stmt->bindParam(':username', $username, PDO::PARAM_STR);
        $stmt->bindParam(':examId', $examId, PDO::PARAM_INT);
        $stmt->execute();
        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        $exists = $result['count'] > 0;
        $submitTime = $result['submitTime']; // เก็บค่าของเวลาส่ง
    }

    // ตรวจสอบสถานะหลังจากการตรวจสอบ exists
    if ($exists) {
        $status = false; // ค่าเริ่มต้น

        if ($examType == 'onechoice' || $examType == 'manychoice') {
            $status = true;
        } elseif ($examType == 'auswer') {
            $checkQuery = "SELECT COUNT(*) as count FROM checkwork_auswer WHERE users_username = :username AND examsets_id = :examId";
            $checkStmt = $conn->prepare($checkQuery);
            $checkStmt->bindParam(':username', $username, PDO::PARAM_STR);
            $checkStmt->bindParam(':examId', $examId, PDO::PARAM_INT);
            $checkStmt->execute();
            $checkResult = $checkStmt->fetch(PDO::FETCH_ASSOC);
            $status = $checkResult['count'] > 0;
        } elseif ($examType == 'upfile') {
            $checkQuery = "SELECT COUNT(*) as count FROM checkwork_upfile WHERE users_username = :username AND examsets_id = :examId";
            $checkStmt = $conn->prepare($checkQuery);
            $checkStmt->bindParam(':username', $username, PDO::PARAM_STR);
            $checkStmt->bindParam(':examId', $examId, PDO::PARAM_INT);
            $checkStmt->execute();
            $checkResult = $checkStmt->fetch(PDO::FETCH_ASSOC);
            $status = $checkResult['count'] > 0;
        }

        // ส่งผลลัพธ์พร้อมข้อมูลเวลา
        echo json_encode(['exists' => true, 'status' => $status, 'submitTime' => $submitTime]);
    } else {
        // ถ้าไม่พบการส่งงานในฐานข้อมูล
        echo json_encode(['exists' => false, 'submitTime' => null]);
    }

} catch (PDOException $e) {
    error_log("Query failed: " . $e->getMessage());
    echo json_encode(['error' => 'Failed to check submission.']);
}
?>
