<?php
include "connect.php";

header("Content-Type: application/json; charset=UTF-8");

// รับข้อมูลจาก POST
$data = json_decode(file_get_contents("php://input"));

// ตรวจสอบว่ามีการส่งข้อมูลหรือไม่
if (isset($data->action)) {
    $action = $data->action; // รับการกระทำที่ต้องการทำ

    if ($action === 'fetch') {
        // ฟังก์ชันสำหรับดึง To-Do
        if (isset($data->users_username)) {
            $users_username = $data->users_username;

            // สร้างคำสั่ง SQL เพื่อดึง To-Do ตาม username
            $sql = "SELECT `todolist_users_auto`, `todolist_users_title`, `todolist_users_details`, `users_username`, `todolist_users_status` FROM `todolist_users` WHERE users_username = ?";
            $stmt = $conn->prepare($sql);
            $stmt->bindParam(1, $users_username); // เปลี่ยนเป็น users_username ที่ถูกต้อง
            $stmt->execute();

            $todos = [];
            while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
                $todos[] = $row; // เก็บผลลัพธ์ในรูปแบบ array
            }
            echo json_encode($todos); // ส่งกลับ JSON ของ To-Do
        } else {
            echo json_encode(["error" => "Username is required"]);
        }
    } elseif ($action === 'add') {
        // ฟังก์ชันสำหรับการเพิ่ม To-Do
        if (isset($data->todolist_users_title) && isset($data->todolist_users_details) && isset($data->users_username)) {
            $todolist_users_title = $data->todolist_users_title;
            $todolist_users_details = $data->todolist_users_details;
            $users_username = $data->users_username;
            $todolist_users_status = 'Not Started'; // ตั้งค่าสถานะเริ่มต้น

            // สร้างคำสั่ง SQL เพื่อเพิ่ม To-Do ใหม่
            $sql = "INSERT INTO todolist_users (todolist_users_title, todolist_users_details, users_username, todolist_users_status) VALUES (?, ?, ?, ?)";
            $stmt = $conn->prepare($sql);
            $stmt->bindParam(1, $todolist_users_title);
            $stmt->bindParam(2, $todolist_users_details);
            $stmt->bindParam(3, $users_username);
            $stmt->bindParam(4, $todolist_users_status);

            if ($stmt->execute()) {
                echo json_encode(["message" => "To-Do added successfully"]);
            } else {
                echo json_encode(["error" => "Error adding To-Do: " . $stmt->errorInfo()[2]]);
            }
        } else {
            echo json_encode(["error" => "Invalid input for adding To-Do"]);
        }
    } elseif ($action === 'update') {
        // ฟังก์ชันสำหรับการอัพเดตสถานะของ To-Do
        if (isset($data->todolist_users_auto) && isset($data->todolist_users_status)) {
            $todolist_users_auto = $data->todolist_users_auto; // รับ ID ของ To-Do
            $todolist_users_status = $data->todolist_users_status; // รับสถานะใหม่

            // สร้างคำสั่ง SQL เพื่ออัพเดตสถานะ
            $sql = "UPDATE todolist_users SET todolist_users_status = ? WHERE todolist_users_auto = ?";
            $stmt = $conn->prepare($sql);
            $stmt->execute([$todolist_users_status, $todolist_users_auto]);
            
            echo json_encode(["message" => "Status updated successfully"]);
        } else {
            echo json_encode(["error" => "Invalid input for updating status"]);
        }
    } 
}

// ปิดการเชื่อมต่อ
$conn = null;
?>
