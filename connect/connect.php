<?php
$db_name = "zgmupszw_edueliteroom";
$db_user = "edueliteroom";
$db_pass = "edueliteroom0";
$db_host = "118.27.130.237";

$con = new mysqli_connect($db_host, $db_user, $db_pass, $db_name);

if ($con->connect_error) {
    die("Connection failed: " . $conn->connect_error);
} else {
    die("Connection done");
}

