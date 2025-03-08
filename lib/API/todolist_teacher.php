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
        if (isset($data->usert_username)) {
            $usert_username = $data->usert_username;

            // สร้างคำสั่ง SQL เพื่อดึง To-Do ตาม username
            $sql = "SELECT * FROM todolist_usert WHERE usert_username = ?";
            $stmt = $conn->prepare($sql);
            $stmt->bindParam(1, $usert_username);
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
        if (isset($data->todolist_usert_title) && isset($data->todolist_usert_details) && isset($data->usert_username)) {
            $todolist_usert_title = $data->todolist_usert_title;
            $todolist_usert_details = $data->todolist_usert_details;
            $usert_username = $data->usert_username;
            $todolist_usert_status = 'Not Started'; // ตั้งค่าสถานะเริ่มต้น

            // สร้างคำสั่ง SQL เพื่อเพิ่ม To-Do ใหม่
            $sql = "INSERT INTO todolist_usert (todolist_usert_title, todolist_usert_details, usert_username, todolist_usert_status) VALUES (?, ?, ?, ?)";
            $stmt = $conn->prepare($sql);
            $stmt->bindParam(1, $todolist_usert_title);
            $stmt->bindParam(2, $todolist_usert_details);
            $stmt->bindParam(3, $usert_username);
            $stmt->bindParam(4, $todolist_usert_status);

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
        if (isset($data->todolist_usert_auto) && isset($data->todolist_usert_status)) {
        $todolist_usert_auto = $data->todolist_usert_auto; // รับ ID ของ To-Do
        $todolist_usert_status = $data->todolist_usert_status; // รับสถานะใหม่

        // สร้างคำสั่ง SQL เพื่ออัพเดตสถานะ
        $sql = "UPDATE todolist_usert SET todolist_usert_status = ? WHERE todolist_usert_auto = ?";
        $stmt = $conn->prepare($sql);
        $stmt->execute([$todolist_usert_status, $todolist_usert_auto]);
        
        
        echo json_encode(["message" => "Status updated successfully"]);
        } else {
        echo json_encode(["error" => "Invalid input for updating status"]);
        }
    } 
}

// ปิดการเชื่อมต่อ
$conn = null;
?>
