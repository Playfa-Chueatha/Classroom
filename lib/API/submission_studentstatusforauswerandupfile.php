<?php
include "connect.php";

header("Access-Control-Allow-Origin: *");
header('Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, PATCH, DELETE');
header('Access-Control-Allow-Headers: *');
header('Access-Control-Max-Age: 86400');
header('Content-Type: application/json');

try {
    // เชื่อมต่อฐานข้อมูล
    $conn = new PDO("mysql:host=$servername;dbname=$dbname;charset=utf8", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    error_log("Connection failed: " . $e->getMessage());
    echo json_encode(['error' => 'Connection failed.']);
    exit;
}

// รับค่า exam_autoId และ exam_type จาก UI
$examAutoId = $_POST['exam_autoId'];
$examType = $_POST['exam_type'];

// ค้นหาข้อมูลจาก `examsets` เพื่อดึง `classroom_id`
$query_examsets = "SELECT classroom_id FROM examsets WHERE examsets_auto = :examAutoId AND examsets_type = :examType";
$stmt_examsets = $conn->prepare($query_examsets);
$stmt_examsets->bindParam(':examAutoId', $examAutoId);
$stmt_examsets->bindParam(':examType', $examType);
$stmt_examsets->execute();
$result_examsets = $stmt_examsets->fetch(PDO::FETCH_ASSOC);

if ($result_examsets) {
    $classroomId = $result_examsets['classroom_id'];

    // ค้นหาผู้ใช้งานจาก `students_inclass` โดยการเปรียบเทียบ `classroom_id` และเงื่อนไข `inclass_type = 0`
    $query_students_inclass = "
        SELECT users_username
        FROM students_inclass
        WHERE classroom_id = :classroomId AND inclass_type = 0
    ";
    $stmt_students_inclass = $conn->prepare($query_students_inclass);
    $stmt_students_inclass->bindParam(':classroomId', $classroomId);
    $stmt_students_inclass->execute();
    $result_students_inclass = $stmt_students_inclass->fetchAll(PDO::FETCH_ASSOC);

    if ($result_students_inclass) {
        // ดึงข้อมูลผู้ใช้งานทั้งหมดจาก `students_inclass`
        $usernamesInClass = array_map(function($student) { return $student['users_username']; }, $result_students_inclass);

        // ค้นหาข้อมูลจาก `user_students` โดยใช้ username ที่ได้จาก `students_inclass`
        $query_students = "
            SELECT users_id, users_username, users_prefix, users_thfname, users_thlname, users_number 
            FROM user_students
            WHERE users_username IN (" . implode(",", array_fill(0, count($usernamesInClass), "?")) . ")
        ";
        $stmt_students = $conn->prepare($query_students);
        $stmt_students->execute($usernamesInClass);
        $result_students = $stmt_students->fetchAll(PDO::FETCH_ASSOC);

        // เปรียบเทียบข้อมูล submit
        if ($examType == 'auswer') {
            // ค้นหานักเรียนที่ส่งงานใน `submit_auswer` และดึงเวลาส่งงาน
            $query_submit = "
                SELECT DISTINCT users_username, submit_auswer_time 
                FROM submit_auswer 
                WHERE examsets_id = :examAutoId
            ";
            $stmt_submit = $conn->prepare($query_submit);
            $stmt_submit->bindParam(':examAutoId', $examAutoId);
            $stmt_submit->execute();
            $result_submit = $stmt_submit->fetchAll(PDO::FETCH_ASSOC);

            $submittedUsernames = array_map(function($student) { return $student['users_username']; }, $result_submit);
            $submittedTimes = array_map(function($student) { return $student['submit_auswer_time']; }, $result_submit);
            $studentsSubmitted = [];
            $studentsNotSubmitted = [];

            foreach ($result_students as $student) {
                if (in_array($student['users_username'], $submittedUsernames)) {
                    // ถ้าผ่านการส่งงานแล้ว
                    $index = array_search($student['users_username'], $submittedUsernames);
                    $student['submit_time'] = $submittedTimes[$index];
                    $studentsSubmitted[] = $student;
                } else {
                    // ถ้ายังไม่ได้ส่งงาน
                    $studentsNotSubmitted[] = $student;
                }
            }

            // ค้นหานักเรียนที่ตรวจงานแล้วใน `checkwork_auswer`
            $query_checkwork = "
                SELECT DISTINCT users_username 
                FROM checkwork_auswer 
                WHERE examsets_id = :examAutoId
            ";
            $stmt_checkwork = $conn->prepare($query_checkwork);
            $stmt_checkwork->bindParam(':examAutoId', $examAutoId);
            $stmt_checkwork->execute();
            $result_checkwork = $stmt_checkwork->fetchAll(PDO::FETCH_ASSOC);

            $checkworkUsernames = array_map(function($student) { return $student['users_username']; }, $result_checkwork);
            $studentsCheckSuccess = [];

            // เปรียบเทียบการตรวจงาน
            foreach ($studentsSubmitted as $key => $submittedStudent) {
                if (in_array($submittedStudent['users_username'], $checkworkUsernames)) {
                    // ถ้าผ่านการตรวจงานแล้ว
                    $studentsCheckSuccess[] = $submittedStudent;
                    unset($studentsSubmitted[$key]); // ลบออกจาก studentsSubmitted
                }
            }

            // ส่งข้อมูลกลับไปยัง UI
            $response = [
                'students_submitted' => array_values($studentsSubmitted),
                'students_not_submitted' => $studentsNotSubmitted,
                'students_check_success' => $studentsCheckSuccess
            ];

        } elseif ($examType == 'upfile') {
            // ค้นหานักเรียนที่ส่งงานใน `submit_upfile` และดึงเวลาส่งงาน
            $query_submit = "
                SELECT DISTINCT users_username, submit_upfile_time 
                FROM submit_upfile 
                WHERE examsets_id = :examAutoId
            ";
            $stmt_submit = $conn->prepare($query_submit);
            $stmt_submit->bindParam(':examAutoId', $examAutoId);
            $stmt_submit->execute();
            $result_submit = $stmt_submit->fetchAll(PDO::FETCH_ASSOC);

            $submittedUsernames = array_map(function($student) { return $student['users_username']; }, $result_submit);
            $submittedTimes = array_map(function($student) { return $student['submit_upfile_time']; }, $result_submit);
            $studentsSubmitted = [];
            $studentsNotSubmitted = [];

            foreach ($result_students as $student) {
                if (in_array($student['users_username'], $submittedUsernames)) {
                    // ถ้าผ่านการส่งงานแล้ว
                    $index = array_search($student['users_username'], $submittedUsernames);
                    $student['submit_time'] = $submittedTimes[$index];
                    $studentsSubmitted[] = $student;
                } else {
                    // ถ้ายังไม่ได้ส่งงาน
                    $studentsNotSubmitted[] = $student;
                }
            }

            // ค้นหานักเรียนที่ตรวจงานแล้วใน `checkwork_upfile`
            $query_checkwork = "
                SELECT DISTINCT users_username 
                FROM checkwork_upfile 
                WHERE examsets_id = :examAutoId
            ";
            $stmt_checkwork = $conn->prepare($query_checkwork);
            $stmt_checkwork->bindParam(':examAutoId', $examAutoId);
            $stmt_checkwork->execute();
            $result_checkwork = $stmt_checkwork->fetchAll(PDO::FETCH_ASSOC);

            $checkworkUsernames = array_map(function($student) { return $student['users_username']; }, $result_checkwork);
            $studentsCheckSuccess = [];

            // เปรียบเทียบการตรวจงาน
            foreach ($studentsSubmitted as $key => $submittedStudent) {
                if (in_array($submittedStudent['users_username'], $checkworkUsernames)) {
                    // ถ้าผ่านการตรวจงานแล้ว
                    $studentsCheckSuccess[] = $submittedStudent;
                    unset($studentsSubmitted[$key]); // ลบออกจาก studentsSubmitted
                }
            }

            // ส่งข้อมูลกลับไปยัง UI
            $response = [
                'students_submitted' => array_values($studentsSubmitted),
                'students_not_submitted' => $studentsNotSubmitted,
                'students_check_success' => $studentsCheckSuccess
            ];
        }

        echo json_encode($response);

    } else {
        echo json_encode(['error' => 'No students found in this classroom or inclass_type not 0']);
    }
} else {
    echo json_encode(['error' => 'Exam not found']);
}

// ปิดการเชื่อมต่อฐานข้อมูล
$conn = null;
?>
