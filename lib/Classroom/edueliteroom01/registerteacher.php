<?php

include 'connect.php';

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json");
header('Content-Type: application/json; charset=utf-8');

$response = [];

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $json_data = file_get_contents('php://input');

    /*$data = json_decode($json_data, true);

    $thaifirstname_teacher = isset($data['thaifirstname_teacher']) ? $data['thaifirstname_teacher'] : '';
    $thailastname_teacher = isset($data['thailastname_teacher']) ? $data['thailastname_teacher'] : '';
    $username_teacher = isset($data['username_teacher']) ? $data['username_teacher'] : '';
    $password_teacher = isset($data['password_teacher']) ? $data['password_teacher'] : '';
    $email_teacher = isset($data['email_teacher']) ? $data['email_teacher'] : '';*/

    $thaifirstname_teacher = $_POST['thaifirstname_teacher'];
    $thailastname_teacher = $_POST['thailastname_teacher'];
    $username_teacher = $_POST['username_teacher'];
    $password_teacher = $_POST['password_teacher'];
    $email_teacher = $_POST['email_teacher'];

    $check_sql = "SELECT * FROM userteacher WHERE email_teacher = :email_teacher";
    $stmt = $conn->prepare($check_sql);
    $stmt->bindParam(':email_teacher', $email_teacher);
    $stmt->execute();

    if ($stmt->rowCount() > 0) {
        $response['error'] = 'Email already exists.';
    } else {
        $insert_sql = "INSERT INTO userteacher (thaifirstname_teacher, thailastname_teacher, username_teacher, password_teacher, email_teacher) 
        VALUES (:thaifirstname_teacher, :thailastname_teacher, :username_teacher, :password_teacher, :email_teacher)";
        $stmt = $conn->prepare($insert_sql);
        $stmt->bindParam(':thaifirstname_teacher', $thaifirstname_teacher);
        $stmt->bindParam(':thailastname_teacher', $thailastname_teacher);
        $stmt->bindParam(':username_teacher', $username_teacher);
        $stmt->bindParam(':password_teacher', $password_teacher);
        $stmt->bindParam(':email_teacher', $email_teacher);
        
        if ($stmt->execute()) {
            $response['success'] = 'Registration successful.';
        } else {
            $response['error'] = 'Failed to register. Please try again later.';
        }
    }
} else {
    $response['error'] = 'Request method is not POST.';
}

echo json_encode($response);
$conn = null;

?>
