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

    if (isset($_POST['users_prefix']) && isset($_POST['users_thfname']) && isset($_POST['users_thlname']) && isset($_POST['users_number']) && isset($_POST['autoId'])) {
        $users_prefix = $_POST['users_prefix'];
        $users_thfname = $_POST['users_thfname'];
        $users_thlname = $_POST['users_thlname'];
        $users_number = $_POST['users_number'];
        $autoId = $_POST['autoId'];

        error_log("Parameters: users_prefix={$users_prefix}, users_thfname={$users_thfname}, users_thlname={$users_thlname}, users_number={$users_number}, autoId={$autoId}");

        // ขั้นตอนที่ 1: ค้นหา users_username จากตาราง user_students
        $stmt = $conn->prepare("
            SELECT `users_username` 
            FROM `user_students` 
            WHERE `users_prefix` = :users_prefix 
                AND `users_thfname` = :users_thfname 
                AND `users_thlname` = :users_thlname 
                AND `users_number` = :users_number
        ");
        $stmt->bindParam(':users_prefix', $users_prefix, PDO::PARAM_STR);
        $stmt->bindParam(':users_thfname', $users_thfname, PDO::PARAM_STR);
        $stmt->bindParam(':users_thlname', $users_thlname, PDO::PARAM_STR);
        $stmt->bindParam(':users_number', $users_number, PDO::PARAM_STR);
        $stmt->execute();

        // ตรวจสอบผลลัพธ์ที่ได้จากการค้นหาผู้ใช้
        $user = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($user) {
            $users_username = $user['users_username']; // ถ้าพบ users_username
            
            // ขั้นตอนที่ 2: ค้นหาข้อมูลจาก submit_upfile โดยใช้ examsets_id และ users_username
            $stmt = $conn->prepare("
                SELECT 
                    `submit_upfile_auto`, 
                    `examsets_id`, 
                    `submit_upfile_name`, 
                    `submit_upfile_size`, 
                    `submit_upfile_type`, 
                    `submit_upfile_url` 
                FROM 
                    `submit_upfile` 
                WHERE 
                    `examsets_id` = :autoId 
                    AND `users_username` = :users_username
            ");
            $stmt->bindParam(':autoId', $autoId, PDO::PARAM_INT);
            $stmt->bindParam(':users_username', $users_username, PDO::PARAM_STR);
            $stmt->execute();

            $files = $stmt->fetchAll(PDO::FETCH_ASSOC);
            error_log("Fetched files: " . json_encode($files));

            if (count($files) > 0) {
                echo json_encode(['upfile' => $files]);
            } else {
                echo json_encode(['upfile' => []]); // คืนค่าอาร์เรย์ว่าง
            }
        } else {
            echo json_encode(['error' => 'No user found with the provided details']);
        }
    } else {
        error_log("Error: Missing parameters users_prefix, users_thfname, users_thlname, users_number, or autoId");
        echo json_encode(['error' => 'Missing required parameters.']);
    }
} catch (PDOException $e) {
    error_log("Connection failed: " . $e->getMessage());
    echo json_encode(['error' => 'Connection failed.']);
}

$conn = null;
?>
