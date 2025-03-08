<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json");

include "connect.php"; // เชื่อมต่อกับฐานข้อมูล

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // การเข้าสู่ระบบ
    $data = json_decode(file_get_contents("php://input"), true);

    $usert_username = isset($data['usert_username']) ? $data['usert_username'] : null;
    $usert_password = isset($data['usert_password']) ? $data['usert_password'] : null;

    if ($usert_username === null || $usert_password === null) {
        echo json_encode(["error" => "Missing credentials"]);
        exit;
    }

    // ตรวจสอบว่าชื่อผู้ใช้มีอยู่หรือไม่
    $sql = "SELECT * FROM user_teacher WHERE usert_username = :usert_username";
    $stmt = $conn->prepare($sql);
    $stmt->bindParam(":usert_username", $usert_username);
    $stmt->execute();

    $user = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($user && password_verify($usert_password, $user['usert_password'])) {
        // เข้าสู่ระบบสำเร็จ
        echo json_encode([
            "success" => true,
            "user" => [
                "usert_username" => $user['usert_username'],
                "usert_email" => $user['usert_email'],
                "usert_classroom" => $user['usert_classroom'],
                "usert_thfname" => $user['usert_thfname'], // เพิ่มข้อมูลชื่อ
                "usert_thlname" => $user['usert_thlname']  // เพิ่มข้อมูลนามสกุล
            ]
        ]);
    } else {
        // ข้อมูลรับรองไม่ถูกต้อง
        echo json_encode(["error" => "ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง"]);
    }
} elseif ($_SERVER["REQUEST_METHOD"] == "GET") {
    // ดึงข้อมูลผู้ใช้
    $usert_username = isset($_GET['usert_username']) ? $_GET['usert_username'] : null;

    if ($usert_username === null) {
        echo json_encode(["error" => "Missing username"]);
        exit;
    }

    // คำสั่ง SQL เพื่อดึงข้อมูล
    $sql = "SELECT `usert_thfname`, `usert_thlname` FROM `user_teacher` WHERE `usert_username` = :usert_username";
    $stmt = $conn->prepare($sql);
    $stmt->bindParam(":usert_username", $usert_username);
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
