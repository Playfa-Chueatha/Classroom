<?php
    header("Access-Control-Allow-Origin: *");
    header("Access-Control-Allow-Headers: Content-Type, Authorization");
    header("Content-Type: application/json");

    include "connect.php";

    $username_teacher = $_GET['username_teacher'];
    $password_teacher = $_GET['password_teacher'];

    $sql = "SELECT * FROM userteacher WHERE username_teacher = :username_teacher AND password_teacher = :password_teacher";
    $stmt = $conn->prepare($sql);
    $stmt->bindParam(":username_teacher", $username_teacher);
    $stmt->bindParam(":password_teacher", $password_teacher);
    $stmt->execute();

    $returnValue = $stmt->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode($returnValue);
?>
