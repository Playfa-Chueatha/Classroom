<?php

include 'connect.php';

// กำหนด Header
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json; charset=utf-8");

$response = [];

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Decode JSON data instead of using $_POST
    $json_data = json_decode(file_get_contents('php://input'), true);
    
    if (json_last_error() !== JSON_ERROR_NONE) {
        $response['error'] = 'Invalid JSON format.';
        echo json_encode($response);
        exit();
    }

    $usert_prefix = $json_data['usert_prefix'] ?? '';
    $usert_thfname = $json_data['usert_thfname'] ?? '';
    $usert_thlname = $json_data['usert_thlname'] ?? '';
    $usert_enfname = $json_data['usert_enfname'] ?? '';
    $usert_enlname = $json_data['usert_enlname'] ?? '';
    $usert_username = $json_data['usert_username'] ?? '';
    $usert_password = $json_data['usert_password'] ?? '';
    $usert_email = $json_data['usert_email'] ?? '';
    $usert_classroom = $json_data['usert_classroom'] ?? '';
    $usert_numroom = $json_data['usert_numroom'] ?? '';
    $usert_phone = $json_data['usert_phone'] ?? '';
    $usert_subjects = $json_data['usert_subjects'] ?? '';

    // Validate email format
    if (!filter_var($usert_email, FILTER_VALIDATE_EMAIL)) {
        $response['error'] = 'Invalid email format.';
        echo json_encode($response);
        exit();
    }

    // Check if email already exists
    $check_sql = "SELECT * FROM user_teacher WHERE usert_email = :usert_email";
    $stmt = $conn->prepare($check_sql);
    $stmt->bindValue(':usert_email', $usert_email);
    $stmt->execute();

    if ($stmt->rowCount() > 0) {
        $response['error'] = 'Email already exists.';
    } else {
        // Encrypt password before inserting
        $hashed_password = password_hash($usert_password, PASSWORD_DEFAULT);

        // Insert the data into the database
        $insert_sql = "INSERT INTO user_teacher 
        (   usert_prefix,
            usert_thfname, 
            usert_thlname, 
            usert_enfname, 
            usert_enlname, 
            usert_username, 
            usert_password, 
            usert_email, 
            usert_classroom, 
            usert_numroom, 
            usert_phone, 
            usert_subjects) 
        VALUES 
        (   :usert_prefix,
            :usert_thfname, 
            :usert_thlname, 
            :usert_enfname, 
            :usert_enlname, 
            :usert_username, 
            :usert_password, 
            :usert_email, 
            :usert_classroom, 
            :usert_numroom, 
            :usert_phone, 
            :usert_subjects)";
        
        $stmt = $conn->prepare($insert_sql);
        $stmt->bindValue(':usert_prefix', $usert_prefix);
        $stmt->bindValue(':usert_thfname', $usert_thfname);
        $stmt->bindValue(':usert_thlname', $usert_thlname);
        $stmt->bindValue(':usert_enfname', $usert_enfname);
        $stmt->bindValue(':usert_enlname', $usert_enlname);
        $stmt->bindValue(':usert_username', $usert_username);
        $stmt->bindValue(':usert_password', $hashed_password); // Using hashed password
        $stmt->bindValue(':usert_email', $usert_email);
        $stmt->bindValue(':usert_classroom', $usert_classroom);
        $stmt->bindValue(':usert_numroom', $usert_numroom);
        $stmt->bindValue(':usert_phone', $usert_phone);
        $stmt->bindValue(':usert_subjects', $usert_subjects);

        try {
            if ($stmt->execute()) {
                $response['success'] = 'Registration successful.';
            } else {
                $response['error'] = 'Failed to register. Please try again later.';
            }
        } catch (PDOException $e) {
            error_log("Database error: " . $e->getMessage(), 0);
            $response['error'] = 'Database error. Please contact support.';
        }
    }
} else {
    $response['error'] = 'Request method is not POST.';
}

// ส่งผลลัพธ์ JSON กลับ
echo json_encode($response);
$conn = null;

?>
