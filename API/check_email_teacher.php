<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json");

include "connect.php";

// Correct the variable name and remove the extra space
$usert_email = $_GET['usert_email'];

$sql = "SELECT * FROM user_teacher WHERE usert_email = :usert_email";
$stmt = $conn->prepare($sql);

// Correct the binding parameter name
$stmt->bindParam(":usert_email", $usert_email);
$stmt->execute();

$returnValue = $stmt->fetchAll(PDO::FETCH_ASSOC);

echo json_encode($returnValue);
?>
