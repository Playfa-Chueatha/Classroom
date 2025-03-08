<?php
header('Content-Type: application/json');
include 'connect.php';

error_reporting(0);

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    echo json_encode(['error' => 'การเชื่อมต่อผิดพลาด: ' . $conn->connect_error]);
    exit;
}

// รับค่าจากพารามิเตอร์
$id = isset($_GET['id']) ? $_GET['id'] : '';
$fname = isset($_GET['fname']) ? $_GET['fname'] : '';
$lname = isset($_GET['lname']) ? $_GET['lname'] : '';
$section = isset($_GET['section']) ? $_GET['section'] : '';
$numRoom = isset($_GET['numRoom']) ? $_GET['numRoom'] : '';
$classPlan = isset($_GET['classPlan']) ? $_GET['classPlan'] : '';

$sql = "SELECT * FROM user_students WHERE 1=1";

// เพิ่มเงื่อนไขตามค่าที่มี
if ($id) {
    $sql .= " AND users_id LIKE '%" . mysqli_real_escape_string($conn, $id) . "%'";
}
if ($fname) {
    $sql .= " AND users_thfname LIKE '%" . mysqli_real_escape_string($conn, $fname) . "%'";
}
if ($lname) {
    $sql .= " AND users_thlname LIKE '%" . mysqli_real_escape_string($conn, $lname) . "%'";
}
if ($numRoom) {
    $sql .= " AND users_numroom = '" . mysqli_real_escape_string($conn, $numRoom) . "'";
}
if ($classPlan) {
    $sql .= " AND users_major LIKE '%" . mysqli_real_escape_string($conn, $classPlan) . "%'";
}
if ($section) {
    $sql .= " AND users_classroom LIKE '%" . mysqli_real_escape_string($conn, $section) . "%'";
}

$result = $conn->query($sql);

if (!$result) {
    echo json_encode(['error' => 'คำสั่ง SQL ล้มเหลว: ' . $conn->error]);
    $conn->close();
    exit;
}

$students = [];
while ($row = $result->fetch_assoc()) {
    $students[] = $row;
}

echo json_encode(['students' => $students]);

$conn->close();
?>
