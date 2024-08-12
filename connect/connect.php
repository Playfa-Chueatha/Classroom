<?php
$db_name = "zgmupszw_edueliteroom01";
$db_user = "zgmupszw_edueliteroom1";
$db_pass = "edueliteroom1";
$db_host = "118.27.130.237";

$conn = mysqli_connect($db_host, $db_user, $db_pass, $db_name);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
} else {
    echo "Connection done<br>";
    echo "Server IP Address: " . $_SERVER['SERVER_ADDR'] . "<br>";
    echo "Client IP Address: " . $_SERVER['REMOTE_ADDR'];
}
?>