<?php
header("Access-Control-Allow-Origin: *");  // อนุญาตการเข้าถึงจากทุกโดเมน
header("Access-Control-Allow-Headers: Content-Type, Authorization");  // อนุญาต headers
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");  // อนุญาต methods
header("Content-Type: application/json");  // กำหนดประเภทข้อมูลเป็น JSON

include "connect.php";  // เชื่อมต่อฐานข้อมูล

// ตรวจสอบว่ามีการส่งค่าจาก GET มาหรือไม่
if (isset($_GET['users_username']) && isset($_GET['thaifirstname']) && isset($_GET['thailastname']) && isset($_GET['email'])) {
    // ดึงค่าจาก GET request และทำความสะอาดข้อมูล
    $username_students = htmlspecialchars(strip_tags($_GET['users_username']));
    $thai_firstname = htmlspecialchars(strip_tags($_GET['thaifirstname']));
    $thai_lastname = htmlspecialchars(strip_tags($_GET['thailastname']));
    $email = htmlspecialchars(strip_tags($_GET['email']));

    // ตรวจสอบว่า username ซ้ำหรือไม่
    $sql = "SELECT * FROM user_students WHERE users_username = :users_username";
    $stmt = $conn->prepare($sql);
    $stmt->bindParam(":users_username", $username_students);
    $stmt->execute();
    $returnValue = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // ตรวจสอบชื่อและนามสกุล
    $sql_name = "SELECT * FROM user_students WHERE users_thfname = :thaifirstname AND users_thlname = :thailastname";
    $stmt_name = $conn->prepare($sql_name);
    $stmt_name->bindParam(":thaifirstname", $thai_firstname);
    $stmt_name->bindParam(":thailastname", $thai_lastname);
    $stmt_name->execute();
    $nameExists = $stmt_name->fetch(PDO::FETCH_ASSOC);

    // ตรวจสอบอีเมล
    $sql_email = "SELECT * FROM user_students WHERE users_email = :email";
    $stmt_email = $conn->prepare($sql_email);
    $stmt_email->bindParam(":email", $email);
    $stmt_email->execute();
    $emailExists = $stmt_email->fetch(PDO::FETCH_ASSOC);

    // ตรวจสอบการซ้ำของข้อมูล
    if ($emailExists) {
        echo json_encode(["status" => "duplicate_email", "message" => "อีเมลนี้มีผู้ใช้งานแล้ว"]);
    } elseif ($nameExists) {
        echo json_encode(["status" => "duplicate_name", "message" => "ชื่อและนามสกุลซ้ำในระบบ"]);
    } elseif ($returnValue) {
        echo json_encode(["status" => "duplicate_username", "message" => "User นี้มีผู้ใช้แล้ว"]);
    } else {
        echo json_encode(["status" => "available", "message" => "สามารถใช้ User นี้ได้"]);
    }
} else {
    echo json_encode(["error" => "All parameters are required."]);
}
?>
