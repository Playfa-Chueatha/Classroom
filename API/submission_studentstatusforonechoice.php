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
        if ($examType == 'onechoice') {
            // ค้นหานักเรียนที่ส่งงานใน `score` โดยที่ score_type เป็น 'onechoice' และดึงข้อมูล score_total ด้วย
            $query_submit = "
                SELECT DISTINCT users_username, score_total
                FROM score 
                WHERE examsets_id = :examAutoId
                AND score_type = 'onechoice'
            ";
            $stmt_submit = $conn->prepare($query_submit);
            $stmt_submit->bindParam(':examAutoId', $examAutoId);
            $stmt_submit->execute();
            $result_submit = $stmt_submit->fetchAll(PDO::FETCH_ASSOC);

            // สร้าง array สำหรับเก็บ usernames และ score_total
            $submittedUsernames = [];
            foreach ($result_submit as $row) {
                $submittedUsernames[$row['users_username']] = $row['score_total'];
            }

            $studentsSubmitted = [];
            $studentsNotSubmitted = [];

            foreach ($result_students as $student) {
                $username = $student['users_username'];
                if (isset($submittedUsernames[$username])) {
                    // ถ้านักเรียนส่งงานแล้ว ให้เก็บข้อมูลรวมถึง score_total
                    $student['score_total'] = $submittedUsernames[$username];
                    $studentsSubmitted[] = $student;
                } else {
                    // ถ้านักเรียนยังไม่ได้ส่งงาน
                    $studentsNotSubmitted[] = $student;
                }
            }

        } elseif ($examType == 'manychoice') {
            // ค้นหานักเรียนที่ส่งงานใน `score` โดยที่ score_type เป็น 'manychoice' และดึงข้อมูล score_total ด้วย
            $query_submit = "
                SELECT DISTINCT users_username, score_total
                FROM score 
                WHERE examsets_id = :examAutoId
                AND score_type = 'manychoice'
            ";
            $stmt_submit = $conn->prepare($query_submit);
            $stmt_submit->bindParam(':examAutoId', $examAutoId);
            $stmt_submit->execute();
            $result_submit = $stmt_submit->fetchAll(PDO::FETCH_ASSOC);

            // สร้าง array สำหรับเก็บ usernames และ score_total
            $submittedUsernames = [];
            foreach ($result_submit as $row) {
                $submittedUsernames[$row['users_username']] = $row['score_total'];
            }

            $studentsSubmitted = [];
            $studentsNotSubmitted = [];

            foreach ($result_students as $student) {
                $username = $student['users_username'];
                if (isset($submittedUsernames[$username])) {
                    // ถ้านักเรียนส่งงานแล้ว ให้เก็บข้อมูลรวมถึง score_total
                    $student['score_total'] = $submittedUsernames[$username];
                    $studentsSubmitted[] = $student;
                } else {
                    // ถ้านักเรียนยังไม่ได้ส่งงาน
                    $studentsNotSubmitted[] = $student;
                }
            }
        }

        // ส่งข้อมูลกลับไปยัง UI
        $response = [
            'students_submitted' => array_values($studentsSubmitted),
            'students_not_submitted' => $studentsNotSubmitted,
        ];

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
