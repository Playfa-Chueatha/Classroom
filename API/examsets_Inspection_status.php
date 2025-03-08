<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, PATCH, DELETE");
header("Access-Control-Allow-Headers: *");
header("Content-Type: application/json; charset=UTF-8");

// รับข้อมูลจาก POST
$input = json_decode(file_get_contents('php://input'), true);

// ตรวจสอบว่า autoId และ status ถูกส่งมาในคำขอหรือไม่
if (!isset($input['autoId']) || !isset($input['status'])) {
    echo json_encode([
        "success" => false,
        "message" => "Missing required parameters."
    ]);
    exit;
}

$autoId = $input['autoId'];
$status = $input['status'];

// เชื่อมต่อกับฐานข้อมูล
include 'connect.php';

try {
    // อัปเดตสถานะการตรวจงานในฐานข้อมูล
    $sql = "UPDATE examsets SET examsets_Inspection_status = :status WHERE examsets_auto = :autoId";
    $stmt = $conn->prepare($sql);
    $stmt->bindParam(':status', $status);
    $stmt->bindParam(':autoId', $autoId, PDO::PARAM_INT);

    if ($stmt->execute()) {
        echo json_encode([
            "success" => true,
            "message" => "Status updated successfully."
        ]);
    } else {
        echo json_encode([
            "success" => false,
            "message" => "Failed to update status."
        ]);
    }
} catch (PDOException $e) {
    echo json_encode([
        "success" => false,
        "message" => "Error: " . $e->getMessage()
    ]);
}
?>
