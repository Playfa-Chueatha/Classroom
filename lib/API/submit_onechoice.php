<?php
include 'connect.php'; 

$input = json_decode(file_get_contents('php://input'), true);

if (isset($input['answers']) && is_array($input['answers'])) {
    $conn->beginTransaction(); 

    try {
        foreach ($input['answers'] as $answer) {
            // รับค่าจาก Flutter
            $examsets_id = $answer['examsets_id'];
            $question_id = $answer['question_id'];
            $submit_onechoice_reply = $answer['submit_onechoice_reply'];
            $submit_onechoice_score = isset($answer['submit_onechoice_score']) 
                ? round((float)$answer['submit_onechoice_score'], 2) 
                : 0.00;
            $submit_onechoice_time = $answer['submit_onechoice_time'];
            $users_username = $answer['users_username'];

            // เตรียมคำสั่ง SQL สำหรับบันทึกข้อมูล
            $sql = "INSERT INTO submit_onechoice (examsets_id, question_id, submit_onechoice_reply, submit_onechoice_score, submit_onechoice_time, users_username) 
                    VALUES (:examsets_id, :question_id, :submit_onechoice_reply, :submit_onechoice_score, :submit_onechoice_time, :users_username)";

            $stmt = $conn->prepare($sql);

            // กำหนดค่าพารามิเตอร์สำหรับ SQL
            $stmt->bindParam(':examsets_id', $examsets_id, PDO::PARAM_STR);
            $stmt->bindParam(':question_id', $question_id, PDO::PARAM_STR);
            $stmt->bindParam(':submit_onechoice_reply', $submit_onechoice_reply, PDO::PARAM_STR);
            $stmt->bindParam(':submit_onechoice_score', $submit_onechoice_score, PDO::PARAM_STR);
            $stmt->bindParam(':submit_onechoice_time', $submit_onechoice_time, PDO::PARAM_STR);
            $stmt->bindParam(':users_username', $users_username, PDO::PARAM_STR);

            // Execute query
            $stmt->execute();
        }

        // ดึงข้อมูลเพิ่มเติมจาก examsets
        $stmt = $conn->prepare("SELECT classroom_id, examsets_direction, usert_username FROM examsets WHERE examsets_auto = ?");
        $stmt->execute([$examsets_id]);
        $examsets = $stmt->fetch(PDO::FETCH_ASSOC);
    
        if (!$examsets) {
            throw new Exception('ไม่พบข้อมูลในตาราง examsets');
        }
    
        $classroom_id = $examsets['classroom_id'];
        $examsets_direction = $examsets['examsets_direction'];
        $usert_username = $examsets['usert_username'];
    
        // เพิ่มข้อมูลใน notification_sibmit
        $stmt = $conn->prepare("
            INSERT INTO notification_sibmit 
            (notification_sibmit_users, notification_sibmit_classID, notification_sibmit_title, notification_sibmit_usert, notification_sibmit_time, notification_sibmit_readstatus) 
            VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP, 'notread')
        ");
        $stmt->execute([$users_username, $classroom_id, $examsets_direction, $usert_username]);

        // Commit การเปลี่ยนแปลง
        $conn->commit();
        
        // ส่งข้อมูลตอบกลับ
        echo json_encode(['status' => 'success', 'message' => 'คำตอบของคุณถูกบันทึกเรียบร้อยแล้ว!']);
    } catch (Exception $e) {
        // Rollback หากเกิดข้อผิดพลาด
        $conn->rollBack();
        echo json_encode(['error' => 'เกิดข้อผิดพลาดในการบันทึกคำตอบ: ' . $e->getMessage()]);
    }
} else {
    echo json_encode(['error' => 'ข้อมูลไม่ครบถ้วนหรือไม่ถูกต้อง']);
}
?>
