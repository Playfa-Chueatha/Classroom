<?php
include 'connect.php';

$input = json_decode(file_get_contents('php://input'), true);

if (isset($input['answers']) && is_array($input['answers'])) {
    
    $conn->beginTransaction(); 

    try {
        // ตัวเลือกคำตอบที่อนุญาต
        $valid_choices = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];
        
        foreach ($input['answers'] as $answer) {
            // ตรวจสอบข้อมูลที่จำเป็น
            if (!isset($answer['examsets_id'], $answer['question_id'], $answer['submit_manychoice_reply'], 
                      $answer['submit_manychoice_score'], $answer['submit_manychoice_time'], $answer['users_username'])) {
                throw new Exception('ข้อมูลไม่ครบถ้วน');
            }

            $examsets_id = $answer['examsets_id'];
            $question_id = $answer['question_id'];
            $submit_manychoice_reply = $answer['submit_manychoice_reply'];
            $submit_manychoice_score = $answer['submit_manychoice_score'];
            $submit_manychoice_time = $answer['submit_manychoice_time'];
            $users_username = $answer['users_username'];

            // ตรวจสอบคำตอบที่เลือก
            if (empty($submit_manychoice_reply)) {
                throw new Exception("คำตอบว่างเปล่าสำหรับคำถาม ID: $question_id");
            }

            // ตรวจสอบตัวเลือกคำตอบที่ถูกต้อง
            $selected_answers = explode(',', $submit_manychoice_reply);
            foreach ($selected_answers as $selected_answer) {
                $selected_answer = strtolower($selected_answer); // แปลงเป็นตัวพิมพ์เล็ก
                if (!in_array($selected_answer, $valid_choices)) {
                    throw new Exception("คำตอบไม่ถูกต้อง: $selected_answer สำหรับคำถาม ID: $question_id");
                }
            }

            // ตรวจสอบคะแนน
            if (!is_numeric($submit_manychoice_score)) {
                throw new Exception("คะแนนไม่ถูกต้องสำหรับคำถาม ID: $question_id");
            }

            // บันทึกคำตอบลงในฐานข้อมูล
            $stmt = $conn->prepare("INSERT INTO submit_manychoice (examsets_id, question_id, submit_manychoice_reply, submit_manychoice_score, submit_manychoice_time, users_username) 
                                    VALUES (?, ?, ?, ?, ?, ?)");
            $stmt->execute([$examsets_id, $question_id, $submit_manychoice_reply, $submit_manychoice_score, $submit_manychoice_time, $users_username]);
        }

        // ดึงข้อมูลที่เกี่ยวข้องจากตาราง examsets
        $stmt = $conn->prepare("SELECT classroom_id, examsets_direction, usert_username FROM examsets WHERE examsets_auto = ?");
        $stmt->execute([$examsets_id]);
        $examsets = $stmt->fetch(PDO::FETCH_ASSOC);
    
        if (!$examsets) {
            throw new Exception('ไม่พบข้อมูลในตาราง examsets');
        }
    
        $classroom_id = $examsets['classroom_id'];
        $examsets_direction = $examsets['examsets_direction'];
        $usert_username = $examsets['usert_username'];
    
        // เพิ่มข้อมูลลงในตาราง notification_sibmit
        $stmt = $conn->prepare("
            INSERT INTO notification_sibmit 
            (notification_sibmit_users, notification_sibmit_classID, notification_sibmit_title, notification_sibmit_usert, notification_sibmit_time, notification_sibmit_readstatus) 
            VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP, 'notread')
        ");
        $stmt->execute([$users_username, $classroom_id, $examsets_direction, $usert_username]);

        // ยืนยันการทำงาน
        $conn->commit();
        echo json_encode(['message' => 'บันทึกคำตอบสำเร็จ']);
        
    } catch (Exception $e) {
        $conn->rollBack(); 
        echo json_encode(['error' => $e->getMessage()]);
    }
} else {
    echo json_encode(['error' => 'ข้อมูลไม่ถูกต้อง']);
}
?>
