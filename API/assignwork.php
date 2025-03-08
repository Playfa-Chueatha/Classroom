<?php
    include 'connect.php';
    
    header("Access-Control-Allow-Origin: *");
    header("Access-Control-Allow-Headers: Content-Type, Authorization");
    header("Content-Type: application/json");
    header('Content-Type: application/json; charset=utf-8');
    
    if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $json_data = file_get_contents('php://input');
    
    $direction = $_POST['direction'];
    $fullMarks = $_POST['fullMark'];
    $dueDate = $_POST['duedate'];
    $files = implode(',', $data['files']);
    $links = implode(',', $data['links']);
    
    $check_sql = "SELECT * FROM userteacher WHERE email_teacher = :email_teacher";
    
    



>