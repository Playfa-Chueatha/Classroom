<?php
include "connect.php";

header("Content-Type: application/json");
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $action = $_POST['action'] ?? null;

    if ($action === 'save_checkwork') {
        // รับค่าจาก POST
        $questionId = $_POST['question_id'] ?? null;
        $questionDetail = $_POST['question_detail'] ?? '';
        $checkworkScore = $_POST['checkwork_auswer_score'] ?? null;
        $usersUsername = $_POST['users_username'] ?? '';
        $examautoID = $_POST['examsets_id'] ?? '';
        $totalScore = $_POST['total_score'] ?? null;

        // ตรวจสอบว่าคะแนนเป็นตัวเลขหรือไม่
        if ($checkworkScore !== null && is_numeric($checkworkScore)) {
            $checkworkScore = round((float)$checkworkScore, 2);
        } else {
            $checkworkScore = 0; // ค่าเริ่มต้นถ้าคะแนนไม่ถูกต้อง
        }

        // ตรวจสอบว่าคะแนนรวมเป็นตัวเลขหรือไม่
        if ($totalScore !== null && is_numeric($totalScore)) {
            $totalScore = round((float)$totalScore, 2);
        } else {
            $totalScore = 0; // ค่าเริ่มต้นถ้าคะแนนรวมไม่ถูกต้อง
        }

        // ตรวจสอบว่า input มีค่าหรือไม่
        if (!empty($questionId) && !empty($questionDetail) && $checkworkScore >= 0 && !empty($usersUsername)) {
            // ตรวจสอบการเชื่อมต่อฐานข้อมูล
            if (!$conn) {
                die(json_encode(['error' => 'Database connection failed.']));
            }

            // บันทึกข้อมูลลงใน checkwork_auswer
            $query = "INSERT INTO checkwork_auswer (question_id, examsets_id, question_detail, checkwork_auswer_score, users_username, checkwork_auswer_time) 
                      VALUES (:question_id, :examsets_id, :question_detail, :checkwork_auswer_score, :users_username, NOW())";
            $stmt = $conn->prepare($query);
            $stmt->bindParam(':question_id', $questionId);
            $stmt->bindParam(':examsets_id', $examautoID);
            $stmt->bindParam(':question_detail', $questionDetail);
            $stmt->bindParam(':checkwork_auswer_score', $checkworkScore);
            $stmt->bindParam(':users_username', $usersUsername);

            if ($stmt->execute()) {
                // ตรวจสอบว่ามีการบันทึกข้อมูลใน score แล้วหรือไม่
                $checkQuery = "SELECT COUNT(*) FROM score WHERE examsets_id = :examsets_id AND users_username = :users_username";
                $checkStmt = $conn->prepare($checkQuery);
                $checkStmt->bindParam(':examsets_id', $examautoID);
                $checkStmt->bindParam(':users_username', $usersUsername);
                $checkStmt->execute();
                $existingCount = $checkStmt->fetchColumn();

                if ($existingCount == 0) {
                    // หากยังไม่มีข้อมูลใน score ให้บันทึกข้อมูลใหม่
                    $scoreQuery = "INSERT INTO score (examsets_id, score_total, score_type, users_username) 
                                   VALUES (:examsets_id, :score_total, 'auswer', :users_username)";
                    $scoreStmt = $conn->prepare($scoreQuery);
                    $scoreStmt->bindParam(':examsets_id', $examautoID);
                    $scoreStmt->bindParam(':score_total', $totalScore);
                    $scoreStmt->bindParam(':users_username', $usersUsername);

                    if ($scoreStmt->execute()) {
                        echo json_encode(['success' => true]);
                    } else {
                        $errorInfo = $scoreStmt->errorInfo();
                        echo json_encode(['error' => 'Failed to save total score.', 'details' => $errorInfo]);
                    }
                } else {
                    // หากมีข้อมูลใน score แล้ว
                    echo json_encode(['success' => true, 'message' => 'Score already exists.']);
                }
            } else {
                // ตรวจสอบข้อผิดพลาดจากฐานข้อมูล
                $errorInfo = $stmt->errorInfo();
                echo json_encode(['error' => 'Failed to save data.', 'details' => $errorInfo]);
            }
        } else {
            echo json_encode(['error' => 'Invalid input data.']);
        }
    } else {
        echo json_encode(['error' => 'Invalid action.']);
    }
} else {
    echo json_encode(['error' => 'Invalid request method.']);
}
?>
