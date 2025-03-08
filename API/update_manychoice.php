<?php
include "connect.php"; // เชื่อมต่อฐานข้อมูล

// ตรวจสอบว่ามีข้อมูลที่จำเป็นทั้งหมดหรือไม่
if (
    isset($_POST['manychoice_auto']) &&
    isset($_POST['manychoice_question']) &&
    isset($_POST['manychoice_question_score']) &&
    isset($_POST['manychoice_a']) &&
    isset($_POST['manychoice_b']) &&
    isset($_POST['manychoice_c']) &&
    isset($_POST['manychoice_d']) &&
    isset($_POST['manychoice_e']) &&
    isset($_POST['manychoice_f']) &&
    isset($_POST['manychoice_g']) &&
    isset($_POST['manychoice_h'])
) {
    $manychoice_auto = $_POST['manychoice_auto'];
    $manychoice_question = $_POST['manychoice_question'];
    $manychoice_question_score = $_POST['manychoice_question_score'];
    $manychoice_a = $_POST['manychoice_a'];
    $manychoice_b = $_POST['manychoice_b'];
    $manychoice_c = $_POST['manychoice_c'];
    $manychoice_d = $_POST['manychoice_d'];
    $manychoice_e = $_POST['manychoice_e'];
    $manychoice_f = $_POST['manychoice_f'];
    $manychoice_g = $_POST['manychoice_g'];
    $manychoice_h = $_POST['manychoice_h'];

    try {
        // เตรียมคำสั่ง SQL สำหรับการอัปเดตข้อมูล
        $sql = "UPDATE manychoice SET
                    manychoice_question = :manychoice_question,
                    manychoice_question_score = :manychoice_question_score,
                    manychoice_a = :manychoice_a,
                    manychoice_b = :manychoice_b,
                    manychoice_c = :manychoice_c,
                    manychoice_d = :manychoice_d,
                    manychoice_e = :manychoice_e,
                    manychoice_f = :manychoice_f,
                    manychoice_g = :manychoice_g,
                    manychoice_h = :manychoice_h
                WHERE manychoice_auto = :manychoice_auto";

        // เตรียมคำสั่ง SQL
        $stmt = $conn->prepare($sql);

        // ผูกค่าที่จะส่งไปยังคำสั่ง SQL
        $stmt->bindParam(':manychoice_question', $manychoice_question);
        $stmt->bindParam(':manychoice_question_score', $manychoice_question_score);
        $stmt->bindParam(':manychoice_a', $manychoice_a);
        $stmt->bindParam(':manychoice_b', $manychoice_b);
        $stmt->bindParam(':manychoice_c', $manychoice_c);
        $stmt->bindParam(':manychoice_d', $manychoice_d);
        $stmt->bindParam(':manychoice_e', $manychoice_e);
        $stmt->bindParam(':manychoice_f', $manychoice_f);
        $stmt->bindParam(':manychoice_g', $manychoice_g);
        $stmt->bindParam(':manychoice_h', $manychoice_h);
        $stmt->bindParam(':manychoice_auto', $manychoice_auto);

        // ประมวลผลคำสั่ง SQL
        $stmt->execute();

        // ส่งข้อความตอบกลับไปยัง Flutter
        echo json_encode(['success' => 'Data updated successfully']);
    } catch (PDOException $e) {
        // ส่งข้อผิดพลาดหากเกิดข้อผิดพลาดในการอัปเดต
        echo json_encode(['error' => 'Failed to update data: ' . $e->getMessage()]);
    }
} else {
    echo json_encode(['error' => 'Missing required parameters']);
}
?>
