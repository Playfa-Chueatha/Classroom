<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json");

include "connect.php"; // เชื่อมต่อกับฐานข้อมูล

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // การเข้าสู่ระบบ
    $data = json_decode(file_get_contents("php://input"), true);

    $users_username = isset($data['users_username']) ? $data['users_username'] : null;
    $users_password = isset($data['users_password']) ? $data['users_password'] : null;

    if ($users_username === null || $users_password === null) {
        echo json_encode(["error" => "Missing credentials"]);
        exit;
    }

    // ตรวจสอบว่าชื่อผู้ใช้มีอยู่หรือไม่
    $sql = "SELECT * FROM user_students WHERE users_username = :users_username";
    $stmt = $conn->prepare($sql);
    $stmt->bindParam(":users_username", $users_username);
    $stmt->execute();

    $user = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($user && password_verify($users_password, $user['users_password'])) {
        // เข้าสู่ระบบสำเร็จ
        echo json_encode([
            "success" => true,
            "user" => [
                "users_username" => $user['users_username'],
                "users_email" => $user['users_email'],
                "users_classroom" => $user['users_classroom'],
                "users_thfname" => $user['users_thfname'],
                "users_thlname" => $user['users_thlname']
            ]
        ]);
    } else {
        // ข้อมูลรับรองไม่ถูกต้อง
        echo json_encode(["error" => "ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง"]);
    }
} elseif ($_SERVER["REQUEST_METHOD"] == "GET") {
    // ดึงข้อมูลผู้ใช้
    $users_username = isset($_GET['users_username']) ? $_GET['users_username'] : null;

    if ($users_username === null) {
        echo json_encode(["error" => "Missing username"]);
        exit;
    }

    // คำสั่ง SQL เพื่อดึงข้อมูล
    $sql = "SELECT `users_thfname`, `users_thlname` FROM `user_students` WHERE `users_username` = :users_username";
    $stmt = $conn->prepare($sql);
    $stmt->bindParam(":users_username", $users_username);
    $stmt->execute();

    // ดึงผลลัพธ์
    $result = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($result) {
        echo json_encode([
            "success" => true,
            "data" => $result
        ]);
    } else {
        echo json_encode(["error" => "ไม่พบข้อมูล"]);
    }
} else {
    echo json_encode(["error" => "Invalid request method"]);
}
?>
