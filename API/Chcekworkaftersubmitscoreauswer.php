<?php
header("Access-Control-Allow-Origin: *");
header('Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, PATCH, DELETE');
header('Access-Control-Allow-Headers: *');
header('Access-Control-Max-Age: 86400');

// รวมไฟล์การเชื่อมต่อฐานข้อมูล
include 'connect.php';  // รวมการเชื่อมต่อฐานข้อมูลที่สร้างไว้ใน connect.php

// รับค่า query parameters จาก URL
$examsets_id = isset($_GET['examsets_id']) ? $_GET['examsets_id'] : '';
$username = isset($_GET['username']) ? $_GET['username'] : '';

// ตรวจสอบว่าได้ข้อมูลหรือไม่
if (empty($examsets_id) || empty($username)) {
    echo json_encode(['error' => 'Missing examsets_id or username']);
    exit;
}

// ดึงข้อมูลจากตาราง submit_auswer
$query = "SELECT submit_auswer_auto, examsets_id, question_id, submit_auswer_reply, users_username, submit_auswer_time 
          FROM submit_auswer
          WHERE examsets_id = :examsets_id AND users_username = :username";
$stmt = $conn->prepare($query);
$stmt->bindParam(':examsets_id', $examsets_id);
$stmt->bindParam(':username', $username);
$stmt->execute();
$submit_answers = $stmt->fetchAll(PDO::FETCH_ASSOC);

// ดึงข้อมูลจากตาราง checkwork_auswer
$query_checkwork = "SELECT checkwork_auswer_auto, examsets_id, question_id, question_detail, checkwork_auswer_score, users_username, checkwork_auswer_time
                    FROM checkwork_auswer
                    WHERE examsets_id = :examsets_id AND users_username = :username";
$stmt_checkwork = $conn->prepare($query_checkwork);
$stmt_checkwork->bindParam(':examsets_id', $examsets_id);
$stmt_checkwork->bindParam(':username', $username);
$stmt_checkwork->execute();
$checkwork_answers = $stmt_checkwork->fetchAll(PDO::FETCH_ASSOC);

// ดึงข้อมูลจากตาราง auswer_question
$query_auswer_question = "SELECT question_auto, auswer_question_score FROM auswer_question WHERE question_auto = :question_id";
$stmt_auswer_question = $conn->prepare($query_auswer_question);

// รวมข้อมูลทั้งหมดที่ตรงกับเงื่อนไข
$answers = [];
foreach ($submit_answers as $submit_answer) {
    $question_id = $submit_answer['question_id'];
    
    // ค้นหาค่าที่ตรงกันจาก checkwork_auswer
    foreach ($checkwork_answers as $checkwork_answer) {
        if ($checkwork_answer['question_id'] == $question_id) {
            // ดึงข้อมูล auswer_question_score จากตาราง auswer_question
            $stmt_auswer_question->bindParam(':question_id', $question_id);
            $stmt_auswer_question->execute();
            $auswer_question = $stmt_auswer_question->fetch(PDO::FETCH_ASSOC);
            
            // ตรวจสอบว่า auswer_question_score ไม่เป็น null
            if (!$auswer_question || $auswer_question['auswer_question_score'] === null) {
                echo json_encode(['error' => 'auswer_question_score cannot be null']);
                exit;
            }
            
            $auswer_question_score = $auswer_question['auswer_question_score'];

            // รวมข้อมูลจากตารางทั้ง 3
            $answers[] = [
                'question_id' => $checkwork_answer['question_id'],
                'question_detail' => $checkwork_answer['question_detail'],
                'checkwork_auswer_score' => $checkwork_answer['checkwork_auswer_score'],
                'submit_auswer_reply' => $submit_answer['submit_auswer_reply'],  // เพิ่มข้อมูลคำตอบที่ส่ง
                'submit_auswer_time' => $submit_answer['submit_auswer_time'],    // เพิ่มเวลาที่ส่งคำตอบ
                'auswer_question_score' => $auswer_question_score,  // เพิ่มคะแนนจาก auswer_question
            ];
        }
    }
}

// ส่งข้อมูลกลับในรูปแบบ JSON
echo json_encode($answers);
?>
