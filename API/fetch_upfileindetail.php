<?php
header("Access-Control-Allow-Origin: *");
header('Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, PATCH, DELETE');
header('Access-Control-Allow-Headers: *');
header('Access-Control-Max-Age: 86400');

include "connect.php";

try {
    // ตั้งค่าการเชื่อมต่อฐานข้อมูล
    $conn = new PDO("mysql:host=$servername;dbname=$dbname;charset=utf8", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION); 

    if (isset($_POST['type']) && isset($_POST['autoId'])) {
        $type = $_POST['type'];
        $autoId = $_POST['autoId'];

        if ($type == 'auswer') {
            // ดึงข้อมูลจาก auswer_question โดยตรวจสอบ examsets_id
            $stmt = $conn->prepare("SELECT `question_auto`, `examsets_id`, `question_detail`, `auswer_question_score` 
                                    FROM `auswer_question` 
                                    WHERE `examsets_id` = :autoId");
            $stmt->bindParam(':autoId', $autoId, PDO::PARAM_INT);
            $stmt->execute();
            
            $questions = $stmt->fetchAll(PDO::FETCH_ASSOC);
            if (count($questions) > 0) {
                echo json_encode(['auswer_question' => $questions]);
            } else {
                echo json_encode(['error' => 'No questions found for the provided autoId.']);
            }

        } elseif ($type == 'upfile') {
            // ดึงข้อมูลจาก upfile โดยตรวจสอบ examsets_id
            $stmt = $conn->prepare("SELECT `upfile_auto`, `examsets_id`, `upfile_name`, `upfile_size`, `upfile_type`, `upfile_url` 
                                    FROM `upfile` 
                                    WHERE `examsets_id` = :autoId");
            $stmt->bindParam(':autoId', $autoId, PDO::PARAM_INT);
            $stmt->execute();
            
            $files = $stmt->fetchAll(PDO::FETCH_ASSOC);

            // ดึงข้อมูลลิงก์จาก upfile_link
            $stmt_link = $conn->prepare("SELECT `upfile_link_auto`, `examsets_id`, `upfile_link_url` 
                                        FROM `upfile_link` 
                                        WHERE `examsets_id` = :autoId");
            $stmt_link->bindParam(':autoId', $autoId, PDO::PARAM_INT);
            $stmt_link->execute();
            
            $links = $stmt_link->fetchAll(PDO::FETCH_ASSOC);

            // รวมข้อมูลจาก upfile และ upfile_link
            echo json_encode([
                'upfile' => $files,
                'upfile_links' => $links
            ]);

        } else {
            // หาก type ไม่ใช่ 'auswer' หรือ 'upfile'
            echo json_encode(['error' => 'Invalid type parameter. Expected "auswer" or "upfile".']);
        }

    } else {
        // หากไม่มีการส่ง type หรือ autoId มา
        echo json_encode(['error' => 'Missing required parameters (type or autoId).']);
    }

} catch (PDOException $e) {
    error_log("Connection failed: " . $e->getMessage());
    echo json_encode(['error' => 'Connection failed.']);
}

// ปิดการเชื่อมต่อ
$conn = null;
?>
