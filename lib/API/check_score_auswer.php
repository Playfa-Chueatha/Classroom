<?php
header("Access-Control-Allow-Origin: *");
header('Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, PATCH, DELETE');
header('Access-Control-Allow-Headers: *');
header('Access-Control-Max-Age: 86400');

$servername = "118.27.130.237"; 
$username = "zgmupszw_edueliteroom1"; 
$password = "edueliteroom1"; 
$dbname = "zgmupszw_edueliteroom01"; 

try {
    // ตั้งค่าการเชื่อมต่อฐานข้อมูล
    $conn = new PDO("mysql:host=$servername;dbname=$dbname;charset=utf8", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION); // เปิดการแสดงข้อผิดพลาด
} catch (PDOException $e) {
    error_log("Connection failed: " . $e->getMessage()); // บันทึกข้อผิดพลาดลงใน Log
    echo json_encode(['error' => 'Connection failed.']); // ส่งกลับ JSON หากเชื่อมต่อไม่สำเร็จ
    exit;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // ตรวจสอบว่าได้รับค่า exam_autoId จาก POST หรือไม่
    if (isset($_POST['exam_autoId'])) {
        $examAutoId = $_POST['exam_autoId'];
        error_log("Received exam_autoId: $examAutoId"); // เพิ่มข้อความ debug

        // 1. ดึงข้อมูล question_auto จากตาราง auswer_question
        try {
            $stmt = $conn->prepare("SELECT DISTINCT question_auto FROM auswer_question WHERE examsets_id = :examAutoId");
            $stmt->bindParam(':examAutoId', $examAutoId, PDO::PARAM_INT);
            $stmt->execute();
            $questions = $stmt->fetchAll(PDO::FETCH_ASSOC);

            error_log("Questions found: " . count($questions)); // เพิ่มข้อความ debug

            if (count($questions) > 0) {
                $students = [];

                // 2. ดึงข้อมูล users_username จากตาราง checkwork_auswer
                foreach ($questions as $question) {
                    $questionAuto = $question['question_auto'];

                    $stmt = $conn->prepare("SELECT DISTINCT users_username FROM checkwork_auswer WHERE question_id = :questionAuto");
                    $stmt->bindParam(':questionAuto', $questionAuto, PDO::PARAM_INT);
                    $stmt->execute();
                    $usernames = $stmt->fetchAll(PDO::FETCH_ASSOC);

                    error_log("Usernames found for question $questionAuto: " . count($usernames)); // เพิ่มข้อความ debug

                    // 3. ดึงข้อมูลจากตาราง user_students
                    foreach ($usernames as $username) {
                        $usersUsername = $username['users_username'];

                        // ตรวจสอบข้อมูลนักเรียนจากตาราง user_students
                        $stmt = $conn->prepare("SELECT users_id, users_prefix, users_thfname, users_thlname, users_number 
                                                FROM user_students WHERE users_username = :usersUsername");
                        $stmt->bindParam(':usersUsername', $usersUsername, PDO::PARAM_STR);
                        $stmt->execute();
                        $userInfo = $stmt->fetch(PDO::FETCH_ASSOC);

                        error_log("User info found for username $usersUsername: " . json_encode($userInfo)); // เพิ่มข้อความ debug

                        // เพิ่มข้อมูลของนักเรียนที่พบ
                        if ($userInfo) {
                            $userInfo['checkwork_auswer_score'] = $username['checkwork_auswer_score']; // เพิ่มคะแนน
                            $students[] = $userInfo;
                        } else {
                            error_log("No student info found for username: " . $usersUsername); // บันทึก log หากไม่พบข้อมูลนักเรียน
                        }
                    }
                }

                // ส่งกลับข้อมูลนักเรียนในรูปแบบ JSON
                echo json_encode(['students' => $students]);
            } else {
                error_log("No questions found for exam_autoId: " . $examAutoId); // บันทึก log หากไม่พบคำถาม
                echo json_encode(['error' => 'ไม่พบข้อมูลคำถาม']);
            }

        } catch (PDOException $e) {
            error_log("Database query failed: " . $e->getMessage()); // บันทึกข้อผิดพลาดใน log
            echo json_encode(['error' => 'ไม่สามารถดึงข้อมูลได้']);
        }

    } else {
        echo json_encode(['error' => 'ไม่พบ exam_autoId']);
    }
} else {
    echo json_encode(['error' => 'Method not allowed']);
}
?>
