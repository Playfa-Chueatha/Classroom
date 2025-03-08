<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    exit; // Exit early for OPTIONS requests
}

include_once 'connect.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    try {
        // รับข้อมูลจาก request body
        $data = json_decode(file_get_contents("php://input"));

        if ($data === null) {
            echo json_encode(['error' => 'Invalid JSON format']);
            exit;
        }

        // ตรวจสอบว่า examsetsId และ questions มีข้อมูลหรือไม่
        if (!isset($data->examsetsId) || !isset($data->questions) || !is_array($data->questions)) {
            echo json_encode(['error' => 'Invalid or missing examsetsId or questions data']);
            exit;
        }

        $examsetsId = $data->examsetsId;
        $questions = $data->questions;

        // เตรียมคำสั่ง SQL สำหรับการแทรกข้อมูล
        $stmt = $conn->prepare("INSERT INTO manychoice (
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
        ) VALUES (
            :examsets_id, 
            :manychoice_question, 
            :manychoice_a, 
            :manychoice_b, 
            :manychoice_c, 
            :manychoice_d, 
            :manychoice_e, 
            :manychoice_f, 
            :manychoice_g, 
            :manychoice_h, 
            :manychoice_answer,
            :manychoice_question_score
        )");

        // แทรกข้อมูลทุกคำถามใน array questions
        foreach ($questions as $question) {
            // ตรวจสอบว่ามีข้อมูลคำถามและตัวเลือกทั้งหมดหรือไม่
            if (!isset($question->question) || !isset($question->a) || !isset($question->b) || 
                !isset($question->c) || !isset($question->d) || !isset($question->answer) || 
                !isset($question->score)) {
                echo json_encode(['error' => 'Missing required question, choice, answer, or score data']);
                exit;
            }

            // ตรวจสอบค่าของ e, f, g, h ว่ามีหรือไม่ หากไม่มีให้ใช้ค่า NULL
            $manychoice_e = isset($question->e) ? $question->e : null;
            $manychoice_f = isset($question->f) ? $question->f : null;
            $manychoice_g = isset($question->g) ? $question->g : null;
            $manychoice_h = isset($question->h) ? $question->h : null;

            // ตรวจสอบว่า answer เป็นค่าที่ถูกต้อง (ต้องเป็นหนึ่งในค่าของ SET หรือเป็นหลายค่า)
            $valid_answers = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];
            $answers = explode(',', $question->answer); // แยกคำตอบที่คั่นด้วย ,
            foreach ($answers as $answer) {
                if (!in_array($answer, $valid_answers)) {
                    echo json_encode(['error' => 'Invalid answer value: ' . $answer]);
                    exit;
                }
            }

            // ตรวจสอบค่า score ให้เป็นค่าทศนิยมที่ถูกต้อง และไม่ติดลบ
            if (!is_numeric($question->score) || $question->score < 0) {
                echo json_encode(['error' => 'Score must be a non-negative decimal value']);
                exit;
            }

            // ผูกค่ากับ parameter ในคำสั่ง SQL
            $stmt->bindParam(':examsets_id', $examsetsId, PDO::PARAM_INT);
            $stmt->bindParam(':manychoice_question', $question->question, PDO::PARAM_STR);
            $stmt->bindParam(':manychoice_a', $question->a, PDO::PARAM_STR);
            $stmt->bindParam(':manychoice_b', $question->b, PDO::PARAM_STR);
            $stmt->bindParam(':manychoice_c', $question->c, PDO::PARAM_STR);
            $stmt->bindParam(':manychoice_d', $question->d, PDO::PARAM_STR);
            $stmt->bindParam(':manychoice_e', $manychoice_e, PDO::PARAM_STR);
            $stmt->bindParam(':manychoice_f', $manychoice_f, PDO::PARAM_STR);
            $stmt->bindParam(':manychoice_g', $manychoice_g, PDO::PARAM_STR);
            $stmt->bindParam(':manychoice_h', $manychoice_h, PDO::PARAM_STR);
            $stmt->bindParam(':manychoice_answer', $question->answer, PDO::PARAM_STR);
            $stmt->bindParam(':manychoice_question_score', $question->score, PDO::PARAM_STR); // ใช้ PARAM_STR สำหรับ decimal

            // ดำเนินการคำสั่ง SQL
            if (!$stmt->execute()) {
                // หากเกิดข้อผิดพลาดในการ execute ให้บันทึกข้อผิดพลาด
                $errorInfo = $stmt->errorInfo();
                error_log("SQL Error: " . print_r($errorInfo, true));
                echo json_encode(['error' => 'Failed to insert question']);
                exit;
            }
        }

        // ส่งข้อความสำเร็จกลับไป
        echo json_encode(['success' => true, 'message' => 'Questions added successfully']);
    } catch (PDOException $e) {
        // จัดการข้อผิดพลาดจากฐานข้อมูล
        error_log("Database error: " . $e->getMessage());
        echo json_encode(['error' => 'Database error occurred']);
    } catch (Exception $e) {
        // จัดการข้อผิดพลาดทั่วไป
        error_log("General error: " . $e->getMessage());
        echo json_encode(['error' => 'An error occurred']);
    }
}
?>
