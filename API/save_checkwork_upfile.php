<?php
// รวมไฟล์เชื่อมต่อฐานข้อมูล
include "connect.php";

// รับค่าจาก POST
$examsets_id = $_POST['examsets_id'] ?? '';
$question_detail = $_POST['question_detail'] ?? '';
$checkwork_upfile_score = $_POST['checkwork_upfile_score'] ?? null;
$users_username = $_POST['users_username'] ?? ''; // รับค่า users_username ที่ส่งจาก Flutter
$checkwork_upfile_comments = $_POST['checkwork_upfile_comments'] ?? '';

// ตรวจสอบและแปลงคะแนน
if ($checkwork_upfile_score !== null && is_numeric($checkwork_upfile_score)) {
    $checkwork_upfile_score = floatval($checkwork_upfile_score); // แปลงเป็นตัวเลขทศนิยม
} else {
    $checkwork_upfile_score = 0.00; // กำหนดเป็น 0.00 หากไม่มีค่าหรือค่าผิด
}

// ตรวจสอบว่ามีข้อมูลที่จำเป็นครบถ้วน
if (empty($examsets_id) || empty($question_detail) || empty($users_username)) {
    echo json_encode(['error' => 'กรุณากรอกข้อมูลให้ครบถ้วน']);
    exit;
}

try {
    // ค้นหาข้อมูล users_username จากตาราง user_students
    $sql = "SELECT users_username FROM user_students 
            WHERE users_username = :users_username";

    $stmt = $conn->prepare($sql);
    $stmt->bindParam(':users_username', $users_username);
    $stmt->execute();

    // ตรวจสอบผลลัพธ์
    if ($stmt->rowCount() > 0) {
        // บันทึกข้อมูลลงในตาราง checkwork_upfile
        $insertSql = "INSERT INTO checkwork_upfile 
                      (examsets_id, question_detail, checkwork_upfile_score, users_username, checkwork_upfile_time, checkwork_upfile_comments)
                      VALUES 
                      (:examsets_id, :question_detail, :checkwork_upfile_score, :users_username, NOW(), :checkwork_upfile_comments)";

        $insertStmt = $conn->prepare($insertSql);
        $insertStmt->bindParam(':examsets_id', $examsets_id);
        $insertStmt->bindParam(':question_detail', $question_detail);
        $insertStmt->bindParam(':checkwork_upfile_score', $checkwork_upfile_score);
        $insertStmt->bindParam(':users_username', $users_username);
        $insertStmt->bindParam(':checkwork_upfile_comments', $checkwork_upfile_comments);

        $insertStmt->execute();

        // บันทึกข้อมูลลงในตาราง score
        $insertScoreSql = "INSERT INTO score 
                           (examsets_id, score_total, score_type, users_username)
                           VALUES 
                           (:examsets_id, :score_total, 'upfile', :users_username)";

        $insertScoreStmt = $conn->prepare($insertScoreSql);
        $insertScoreStmt->bindParam(':examsets_id', $examsets_id);
        $insertScoreStmt->bindParam(':score_total', $checkwork_upfile_score); // ใช้ตัวแปรทศนิยม
        $insertScoreStmt->bindParam(':users_username', $users_username);

        $insertScoreStmt->execute();

        // ส่งกลับผลลัพธ์สำเร็จ
        echo json_encode(['success' => 'บันทึกข้อมูลสำเร็จ']);
    } else {
        echo json_encode(['error' => 'ไม่พบผู้ใช้ที่ตรงกับข้อมูล']);
    }
} catch (PDOException $e) {
    echo json_encode(['error' => 'เกิดข้อผิดพลาด: ' . $e->getMessage()]);
}
?>
