<?php
include "connect.php"; // การเชื่อมต่อฐานข้อมูล

// อ่านข้อมูลที่ส่งมาจาก Flutter
$data = json_decode(file_get_contents("php://input"), true);
$scores = $data['scores']; // ข้อมูลที่ส่งมาจาก Flutter

// อัพเดตตาราง score และ examsets
foreach ($scores as $score) {
    $examsetId = $score['examsetId'];
    $username = $score['username'];
    $newScore = $score['newScore'];
    $adjustedScore = $score['adjustedScore'];

    // 1. อัพเดตตาราง score
    $updateScoreQuery = "UPDATE score SET score_total = :adjustedScore WHERE examsets_id = :examsetId AND users_username = :username";
    $stmt = $conn->prepare($updateScoreQuery);
    $stmt->bindParam(':adjustedScore', $adjustedScore);
    $stmt->bindParam(':examsetId', $examsetId);
    $stmt->bindParam(':username', $username);
    $scoreUpdateResult = $stmt->execute();

    // 2. อัพเดตตาราง examsets
    $updateExamsetQuery = "UPDATE examsets SET examsets_fullmark = :newScore WHERE examsets_auto = :examsetId";
    $stmt = $conn->prepare($updateExamsetQuery);
    $stmt->bindParam(':newScore', $newScore);
    $stmt->bindParam(':examsetId', $examsetId);
    $examsetUpdateResult = $stmt->execute();
}

// ส่งผลลัพธ์กลับไป
if ($scoreUpdateResult && $examsetUpdateResult) {
    echo json_encode(['status' => 'success']);
} else {
    echo json_encode(['status' => 'error', 'message' => 'Failed to update scores']);
}
?>
