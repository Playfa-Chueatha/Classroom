<?php
require "connect.php";
if (!$con) {
    echo "connection error";
}

$name = $_POST['name'];
$surname = $_POST['surname'];
$password = $_POST['password'];
$email = $_POST['email'];
$encrypted_pwd = md5($password);
$sql = "SELECT * FROM usert WHERE email = '$email'";


$result = mysqli_query($con, $sql);
$count = mysqli_num_rows($result);

if ($count == 1) {
    echo json_encode('Error');
} else {
    $insert = "INSERT INTO usert(name,surname,password,email)VALUES('$name','$surname','$encrypted_pwd','$email')";
    $query = mysqli_query($con, $insert);
    if ($query) {
        echo json_encode('Succeed');
    }
}
