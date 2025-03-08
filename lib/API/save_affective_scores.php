<?php
include "connect.php";

// รับข้อมูลจาก Flutter ที่ส่งมาทาง HTTP POST (ในรูปแบบ JSON)
$data = json_decode(file_get_contents("php://input"), true);

// ตรวจสอบว่ามีข้อมูลใน JSON หรือไม่
if (isset($data['scores'])) {
    $scores = $data['scores'];
    $receivedData = []; // สร้างอาเรย์เพื่อเก็บข้อมูลที่ได้รับ

    foreach ($scores as $score) {
        if (isset($score['usersUsername'], $score['affectiveDomainClassID'], $score['affectiveDomainScore'])) {
            // รับค่าจาก JSON
            $usersUsername = $score['usersUsername'];
            $affectiveDomainClassID = $score['affectiveDomainClassID'];
            $affectiveDomainScore = $score['affectiveDomainScore'];

            // ตรวจสอบข้อมูลในฐานข้อมูล
            $query = "SELECT * FROM affective_domain WHERE users_username = :usersUsername AND affective_domain_classID = :affectiveDomainClassID";
            $stmt = $conn->prepare($query);
            $stmt->execute([
                ':usersUsername' => $usersUsername,
                ':affectiveDomainClassID' => $affectiveDomainClassID
            ]);

            // หากมีข้อมูลแล้ว ทำการอัปเดตคะแนน
            if ($stmt->rowCount() > 0) {
                $updateQuery = "UPDATE affective_domain SET affective_domain_score = :affectiveDomainScore WHERE users_username = :usersUsername AND affective_domain_classID = :affectiveDomainClassID";
                $updateStmt = $conn->prepare($updateQuery);
                $updateStmt->execute([
                    ':affectiveDomainScore' => $affectiveDomainScore,
                    ':usersUsername' => $usersUsername,
                    ':affectiveDomainClassID' => $affectiveDomainClassID
                ]);

                if ($updateStmt->rowCount() > 0) {
                    $receivedData[] = ['status' => 'success', 'message' => 'อัปเดตคะแนนสำเร็จ', 'data' => $score];
                } else {
                    $receivedData[] = ['status' => 'error', 'message' => 'ไม่สามารถอัปเดตคะแนนได้', 'data' => $score];
                }

            } else {
                // หากไม่มีข้อมูลในฐานข้อมูล ให้เพิ่มข้อมูลใหม่
                $insertQuery = "INSERT INTO affective_domain (users_username, affective_domain_classID, affective_domain_score) VALUES (:usersUsername, :affectiveDomainClassID, :affectiveDomainScore)";
                $insertStmt = $conn->prepare($insertQuery);
                $insertStmt->execute([
                    ':usersUsername' => $usersUsername,
                    ':affectiveDomainClassID' => $affectiveDomainClassID,
                    ':affectiveDomainScore' => $affectiveDomainScore
                ]);

                if ($insertStmt->rowCount() > 0) {
                    $receivedData[] = ['status' => 'success', 'message' => 'เพิ่มคะแนนสำเร็จ', 'data' => $score];
                } else {
                    $receivedData[] = ['status' => 'error', 'message' => 'ไม่สามารถเพิ่มคะแนนได้', 'data' => $score];
                }
            }
        } else {
            $receivedData[] = ['status' => 'error', 'message' => 'ข้อมูลไม่ครบถ้วน', 'data' => $score];
        }
    }

    // ส่งข้อมูลกลับไปในรูปแบบ JSON
    echo json_encode(['status' => 'success', 'message' => 'ข้อมูลถูกประมวลผลแล้ว', 'data' => $receivedData]);
} else {
    // หากไม่มีข้อมูลใน POST
    echo json_encode(['status' => 'error', 'message' => 'ไม่พบข้อมูล']);
}
?>
