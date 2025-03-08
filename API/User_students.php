<?php
header("Access-Control-Allow-Origin: *");
header('Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, PATCH, DELETE');
header('Access-Control-Allow-Headers: *');
header('Access-Control-Max-Age: 86400');


include "connect.php";


$username = isset($_GET['username']) ? $_GET['username'] : '';


if ($username != '') {
    try {
    
        $stmt = $conn->prepare("SELECT * FROM user_students WHERE users_username = :username");
        $stmt->bindParam(':username', $username, PDO::PARAM_STR);
        $stmt->execute();
        
        $user = $stmt->fetch(PDO::FETCH_ASSOC);
        if ($user) {
            echo json_encode($user); 
        } else {
            echo json_encode(['error' => 'User not found.']); 
        }
    } catch (PDOException $e) {
        error_log("Query failed: " . $e->getMessage());
        echo json_encode(['error' => 'Query failed.']);
    }
} else {
    echo json_encode(['error' => 'Username is required.']); 
}
?>
