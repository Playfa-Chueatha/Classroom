<?php
header("Access-Control-Allow-Origin:*");
header('Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, PATCH, DELETE');
header('Access-Control-Allow-Headers:*');
header('Access-Control-Max-Age:86400');

$servername = "localhost"; // Server name (usually localhost)
$username = "root"; // MySQL username
$password = ""; // MySQL password
$dbname = "edueliteroom01"; // Name of the database


try{
    $conn = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
}catch(PDOException $e){
    echo "Connection failed: " . $e->getMessage();
}

?>


