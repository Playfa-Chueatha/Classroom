<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json");

include "connect.php";

// รับค่า usert_usernaST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $input = json_decode(file_get_contents('php://input'), true);
    
    if (isset($input['users_username'])) {
        $users_username = $input['users_username'];
        
        $sql = "SELECT users_thfname, users_thlname FROM user_students WHERE users_username = :users_username";
        $stmt = $conn->prepare($sql);
        $stmt->bindParam(':users_username', $users_username);

        // เรียกใช้คำสั่ง
        if ($stmt->execute()) {
            if ($stmt->rowCount() > 0) {
                $data = $stmt->fetch(PDO::FETCH_ASSOC);
                // ตรวจสอบค่าที่ดึงมา
                if (isset($data['users_thfname']) && isset($data['users_thlname'])) {
                    echo json_encode($data);
                } else {
                    echo json_encode(array("message" => "Data fields are missing"));
                }
            } else {
                echo json_encode(array("message" => "No data found"));
            }
        } else {
            echo json_encode(array("message" => "SQL execution failed"));
        }
    } else {
        echo json_encode(array("message" => "usert_username not provided"));
    }
} else {
    echo json_encode(array("message" => "Invalid request method"));
}
?>