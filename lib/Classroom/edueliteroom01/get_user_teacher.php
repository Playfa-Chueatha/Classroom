<?php
    header("Access-Control-Allow-Origin: *");
    header("Access-Control-Allow-Headers: Content-Type, Authorization");
    header("Content-Type: application/json");

    include "connect.php";

    $id_teacher = $_GET['id_teacher '];

    $sql = "SELECT * FROM userteacher WHERE id_teacher  = :id_teacher";
    $stmt = $conn->prepare($sql);
    $stmt->bindParam(":id_teacher", $id_teacher);
    $stmt->execute();

    $returnValue = $stmt->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode($returnValue);
?>
