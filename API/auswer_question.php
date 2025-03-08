<?php
include 'connect.php';  // รวมไฟล์เชื่อมต่อฐานข้อมูล

header('Content-Type: application/json');

ini_set('display_errors', 1);
error_reporting(E_ALL);

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $input = json_decode(file_get_contents('php://input'), true);

    if (isset($input['examsets_id']) && isset($input['questions']) && is_array($input['questions'])) {
        $examsets_id = $input['examsets_id'];
        $questions = $input['questions'];

        try {
            // ตรวจสอบการเชื่อมต่อฐานข้อมูล
            if (!$conn) {  
                throw new Exception('Database connection failed');
            }

            $conn->beginTransaction();

            foreach ($questions as $question) {
                $question_detail = $question['question_detail'] ?? null;
                $auswer_question_score = $question['auswer_question_score'] ?? null;

                // ตรวจสอบข้อมูล
                if (empty($question_detail) || $auswer_question_score === null) {
                    throw new Exception('Invalid question data');
                }

                // คำสั่ง SQL สำหรับการเพิ่มคำถาม
                $query = "INSERT INTO auswer_question (examsets_id, question_detail, auswer_question_score) 
                          VALUES (:examsets_id, :question_detail, :auswer_question_score)";
                
                $stmt = $conn->prepare($query);
                $stmt->bindParam(':examsets_id', $examsets_id, PDO::PARAM_INT);
                $stmt->bindParam(':question_detail', $question_detail, PDO::PARAM_STR);
                $stmt->bindParam(':auswer_question_score', $auswer_question_score, PDO::PARAM_STR);

                $stmt->execute();
            }

            // ยืนยันการทำธุรกรรม
            $conn->commit();
            echo json_encode(['status' => 'success', 'message' => 'Questions added successfully']);
        } catch (Exception $e) {
            if ($conn) {
                $conn->rollBack();  // ยกเลิกการทำธุรกรรมในกรณีเกิดข้อผิดพลาด
            }
            echo json_encode(['status' => 'error', 'message' => 'Failed to add questions: ' . $e->getMessage()]);
        }
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Missing or invalid required data']);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request method']);
}
?>
