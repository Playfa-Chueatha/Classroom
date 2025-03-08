<?php
header("Access-Control-Allow-Origin: *");
header('Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, PATCH, DELETE');
header('Access-Control-Allow-Headers: *');
header('Access-Control-Max-Age: 86400');
header('Content-Type: application/json');  // เพิ่ม header Content-Type เป็น application/json

$servername = "118.27.130.237"; 
$username = "zgmupszw_edueliteroom1"; 
$password = "edueliteroom1"; 
$dbname = "zgmupszw_edueliteroom01"; 

// รับค่าจาก Flutter
$classroomName = $_POST['classroomName'];
$classroomMajor = $_POST['classroomMajor'];
$classroomYear = $_POST['classroomYear'];
$classroomNumRoom = $_POST['classroomNumRoom'];

try {
    // ตั้งค่าการเชื่อมต่อฐานข้อมูล
    $conn = new PDO("mysql:host=$servername;dbname=$dbname;charset=utf8", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // ตรวจสอบข้อมูล classroom
    $stmt = $conn->prepare("
        SELECT `classroom_id` 
        FROM `classroom` 
        WHERE `classroom_name` = :classroomName 
          AND `classroom_major` = :classroomMajor 
          AND `classroom_year` = :classroomYear 
          AND `classroom_numroom` = :classroomNumRoom
    ");
    $stmt->bindParam(':classroomName', $classroomName);
    $stmt->bindParam(':classroomMajor', $classroomMajor);
    $stmt->bindParam(':classroomYear', $classroomYear);
    $stmt->bindParam(':classroomNumRoom', $classroomNumRoom);
    $stmt->execute();
    
    $classroomData = $stmt->fetch(PDO::FETCH_ASSOC);
    
    if ($classroomData) {
        $classroom_id = $classroomData['classroom_id'];

        // ตรวจสอบข้อมูลจาก checkin_classroom
        $checkinStmt = $conn->prepare("
            SELECT `checkin_classroom_auto`, `checkin_classroom_date`, `users_username`, `checkin_classroom_classID`, `checkin_classroom_status` 
            FROM `checkin_classroom` 
            WHERE `checkin_classroom_classID` = :classroom_id
        ");
        $checkinStmt->bindParam(':classroom_id', $classroom_id);
        $checkinStmt->execute();

        $checkinData = $checkinStmt->fetchAll(PDO::FETCH_ASSOC);

        // เตรียมข้อมูลทั้งหมด
        $result = [];
        foreach ($checkinData as $checkin) {
            $users_username = $checkin['users_username'];

            // ตรวจสอบข้อมูลจาก user_students
            $userStmt = $conn->prepare("
                SELECT `users_prefix`, `users_thfname`, `users_thlname`, `users_number`, `users_id`, `users_phone` 
                FROM `user_students` 
                WHERE `users_username` = :users_username
            ");
            $userStmt->bindParam(':users_username', $users_username);
            $userStmt->execute();

            $userData = $userStmt->fetch(PDO::FETCH_ASSOC);

            if ($userData) {
                // ดึงข้อมูลคะแนนจาก affective_domain
                $affectiveStmt = $conn->prepare("
                    SELECT `affective_domain_score` 
                    FROM `affective_domain` 
                    WHERE `users_username` = :users_username AND `affective_domain_classID` = :classroom_id
                ");
                $affectiveStmt->bindParam(':users_username', $users_username);
                $affectiveStmt->bindParam(':classroom_id', $classroom_id);
                $affectiveStmt->execute();

                $affectiveData = $affectiveStmt->fetch(PDO::FETCH_ASSOC);

                $affective_score = $affectiveData ? $affectiveData['affective_domain_score'] : null;

                // เพิ่มข้อมูลทั้งหมดใน result
                $result[] = [
                    'checkin_classroom_auto' => $checkin['checkin_classroom_auto'],
                    'checkin_classroom_date' => $checkin['checkin_classroom_date'],
                    'users_username' => $checkin['users_username'],
                    'checkin_classroom_classID' => $checkin['checkin_classroom_classID'],
                    'checkin_classroom_status' => $checkin['checkin_classroom_status'],
                    'users_prefix' => $userData['users_prefix'],
                    'users_thfname' => $userData['users_thfname'],
                    'users_thlname' => $userData['users_thlname'],
                    'users_number' => $userData['users_number'],
                    'users_id' => $userData['users_id'],
                    'users_phone' => $userData['users_phone'],
                    'affective_domain_score' => $affective_score, 
                ];
            }
        }

        // ส่งข้อมูลกลับเป็น JSON
        echo json_encode($result);
    } else {
        echo json_encode(['error' => 'Classroom not found.']);
    }

} catch (PDOException $e) {
    error_log("Connection failed: " . $e->getMessage());
    echo json_encode(['error' => 'Connection failed.']);
}
?>
