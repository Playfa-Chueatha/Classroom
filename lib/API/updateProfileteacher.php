<?php

include 'connect.php';

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json");
header('Content-Type: application/json; charset=utf-8');

// Get the raw POST data and decode it
$json = file_get_contents('php://input');
$json = json_decode($json, true);

// Prepare the SQL statement
$update_sql = "UPDATE userteacher SET
                thaifirstname_teacher = :thainame,
                thailastname_teacher = :thailastname,
                engfirstname_teacher = :engname,
                englastname_teacher = :englastname,
                room_teacher = :room,
                numroom_teacher = :numroom,
                phone_teacher = :phone,
                subject_teacher = :subject 
                WHERE id_teacher = :idT";

$stmt = $conn->prepare($update_sql);

// Bind the parameters from the decoded JSON data
$stmt->bindParam(":idT", $json['idT']);
$stmt->bindParam(":thainame", $json['thainame']);
$stmt->bindParam(":thailastname", $json['thailastname']);
$stmt->bindParam(":engname", $json['engname']);
$stmt->bindParam(":englastname", $json['englastname']);
$stmt->bindParam(":room", $json['room']);
$stmt->bindParam(":numroom", $json['numroom']);
$stmt->bindParam(":phone", $json['phone']);
$stmt->bindParam(":subject", $json['subject']);

// Execute the query and return the result
$stmt->execute();
$returnValue = $stmt->rowCount() > 0 ? 1 : 0;

echo json_encode($returnValue);

?>
