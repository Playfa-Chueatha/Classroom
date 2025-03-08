<?php
include "connect.php";

header("Content-Type: application/json; charset=UTF-8");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // รับค่าที่ส่งมาจากแอปพลิเคชัน
    $input = json_decode(file_get_contents('php://input'), true);

    if (!isset($input['username']) || !isset($input['examsetId']) || !isset($input['scoreTotal'])) {
        echo json_encode(['error' => 'Missing required parameters.']);
        exit;
    }

    $username = $input['username'];
    $examsetId = $input['examsetId'];
    $scoreTotal = $input['scoreTotal'];

    try {
        // ตรวจสอบว่ามีข้อมูลในตารางอยู่แล้วหรือไม่
        $checkQuery = "SELECT score_auto FROM score WHERE users_username = :username AND examsets_id = :examsetId";
        $stmt = $conn->prepare($checkQuery);
        $stmt->bindParam(':username', $username);
        $stmt->bindParam(':examsetId', $examsetId);
        $stmt->execute();

        if ($stmt->rowCount() > 0) {
            // หากมีข้อมูลอยู่แล้ว ทำการอัพเดต
            $updateQuery = "UPDATE score SET score_total = :scoreTotal WHERE users_username = :username AND examsets_id = :examsetId";
            $stmt = $conn->prepare($updateQuery);
            $stmt->bindParam(':scoreTotal', $scoreTotal);
            $stmt->bindParam(':username', $username);
            $stmt->bindParam(':examsetId', $examsetId);
            $stmt->execute();

            echo json_encode(['success' => true, 'message' => 'Score updated successfully.']);
        } else {
            // หากยังไม่มีข้อมูล ทำการเพิ่มใหม่
            $insertQuery = "INSERT INTO score (examsets_id, score_total, users_username) VALUES (:examsetId, :scoreTotal, :username)";
            $stmt = $conn->prepare($insertQuery);
            $stmt->bindParam(':examsetId', $examsetId);
            $stmt->bindParam(':scoreTotal', $scoreTotal);
            $stmt->bindParam(':username', $username);
            $stmt->execute();

            echo json_encode(['success' => true, 'message' => 'Score inserted successfully.']);
        }
    } catch (PDOException $e) {
        error_log("Database error: " . $e->getMessage());
        echo json_encode(['error' => 'Database operation failed.']);
    }
} else {
    echo json_encode(['error' => 'Invalid request method.']);
}
?>
