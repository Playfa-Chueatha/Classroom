<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json");

include "connect.php";

// ตรวจสอบว่ามีการส่งค่าที่จำเป็นมาหรือไม่
if (isset($_GET['usert_username']) && isset($_GET['thaifirstname']) && isset($_GET['thailastname']) && isset($_GET['email'])) {
    $username_teacher = htmlspecialchars(strip_tags($_GET['usert_username']));
    $thai_firstname = htmlspecialchars(strip_tags($_GET['thaifirstname']));
    $thai_lastname = htmlspecialchars(strip_tags($_GET['thailastname']));
    $email = htmlspecialchars(strip_tags($_GET['email']));

    // ตรวจสอบว่ามี user นี้อยู่หรือไม่
    $sql_username = "SELECT * FROM user_teacher WHERE usert_username = :usert_username";
    $stmt_username = $conn->prepare($sql_username);
    $stmt_username->bindParam(":usert_username", $username_teacher);
    $stmt_username->execute();
    $userExists = $stmt_username->fetch(PDO::FETCH_ASSOC);

    // ตรวจสอบว่าชื่อและนามสกุลซ้ำหรือไม่
    $sql_name = "SELECT * FROM user_teacher WHERE usert_thfname = :thaifirstname AND usert_thlname = :thailastname";
    $stmt_name = $conn->prepare($sql_name);
    $stmt_name->bindParam(":thaifirstname", $thai_firstname);
    $stmt_name->bindParam(":thailastname", $thai_lastname);
    $stmt_name->execute();
    $nameExists = $stmt_name->fetch(PDO::FETCH_ASSOC);

    // ตรวจสอบว่าอีเมลซ้ำหรือไม่
    $sql_email = "SELECT * FROM user_teacher WHERE usert_email = :email";
    $stmt_email = $conn->prepare($sql_email);
    $stmt_email->bindParam(":email", $email);
    $stmt_email->execute();
    $emailExists = $stmt_email->fetch(PDO::FETCH_ASSOC);

    // ตรวจสอบผลลัพธ์
    if ($emailExists) {
        echo json_encode(["status" => "duplicate_email", "message" => "อีเมลนี้มีผู้ใช้งานแล้ว"]);
    } elseif ($nameExists) {
        echo json_encode(["status" => "duplicate_name", "message" => "ชื่อและนามสกุลซ้ำในระบบ"]);
    } elseif ($userExists) {
        echo json_encode(["status" => "duplicate_username", "message" => "User นี้มีผู้ใช้แล้ว"]);
    } else {
        echo json_encode(["status" => "available", "message" => "สามารถใช้ User นี้ได้"]);
    }
} else {
    echo json_encode(["error" => "All parameters are required."]);
}
?>
