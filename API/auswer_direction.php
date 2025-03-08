<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, PATCH, DELETE");
header("Access-Control-Allow-Headers: *");
header("Access-Control-Max-Age: 86400");
header("Content-Type: application/json; charset=UTF-8");

include 'connect.php';
date_default_timezone_set('Asia/Bangkok');

$response = ["success" => false, "message" => "", "examsets_auto" => null];

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $direction = $_POST['direction'];
    $fullMark = isset($_POST['fullMark']) ? (float) $_POST['fullMark'] : 0.0;
    $deadline = $_POST['deadline'];
    $username = $_POST['username'];
    $classroomName = $_POST['classroomName'];
    $classroomMajor = $_POST['classroomMajor'];
    $classroomYear = $_POST['classroomYear'];
    $classroomNumRoom = isset($_POST['classroomNumRoom']) ? (int) $_POST['classroomNumRoom'] : 0;
    $isClosed = isset($_POST['isClosed']) && $_POST['isClosed'] === 'Yes' ? 'Yes' : 'No';
    $currentTime = date("Y-m-d H:i:s");

    error_log("Received values: " . json_encode($_POST));

    try {
        // ตรวจสอบห้องเรียน
        $sql = "SELECT classroom_id FROM classroom 
                WHERE classroom_name = :classroomName 
                  AND classroom_major = :classroomMajor 
                  AND classroom_year = :classroomYear 
                  AND classroom_numroom = :classroomNumRoom";
        $stmt = $conn->prepare($sql);
        $stmt->bindParam(':classroomName', $classroomName);
        $stmt->bindParam(':classroomMajor', $classroomMajor);
        $stmt->bindParam(':classroomYear', $classroomYear);
        $stmt->bindParam(':classroomNumRoom', $classroomNumRoom);
        $stmt->execute();
        $row = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($row) {
            $classroomId = $row['classroom_id'];
            error_log("Found classroom_id: " . $classroomId);

            // เพิ่มข้อมูลลงในตาราง examsets
            $sqlInsertExamset = "INSERT INTO examsets (examsets_direction, examsets_fullmark, examsets_deadline, classroom_id, usert_username, examsets_time, examsets_type, examsets_closed, examsets_Inspection_status)
                                 VALUES (:direction, :fullMark, :deadline, :classroomId, :username, :currentTime, 'auswer', :isClosed, 'Incomplete')";
            $stmtInsertExamset = $conn->prepare($sqlInsertExamset);
            $stmtInsertExamset->bindParam(':direction', $direction);
            $stmtInsertExamset->bindParam(':fullMark', $fullMark, PDO::PARAM_STR);
            $stmtInsertExamset->bindParam(':deadline', $deadline);
            $stmtInsertExamset->bindParam(':classroomId', $classroomId);
            $stmtInsertExamset->bindParam(':username', $username);
            $stmtInsertExamset->bindParam(':currentTime', $currentTime);
            $stmtInsertExamset->bindParam(':isClosed', $isClosed);

            if ($stmtInsertExamset->execute()) {
                $response["success"] = true;
                $response["examsets_auto"] = $conn->lastInsertId();

                // เพิ่มข้อมูลลงในตาราง event_assignment
                $sqlInsertEventAssignment = "INSERT INTO event_assignment (event_assignment_title, event_assignment_time, event_assignment_duedate, event_assignment_classID, event_assignment_usert)
                                             VALUES (:eventAssignmentTitle, :eventAssignmentTime, :eventAssignmentDueDate, :classroomId, :username)";
                $stmtInsertEventAssignment = $conn->prepare($sqlInsertEventAssignment);
                $stmtInsertEventAssignment->bindParam(':eventAssignmentTitle', $direction);
                $stmtInsertEventAssignment->bindParam(':eventAssignmentTime', $currentTime);
                $stmtInsertEventAssignment->bindParam(':eventAssignmentDueDate', $deadline);
                $stmtInsertEventAssignment->bindParam(':classroomId', $classroomId);
                $stmtInsertEventAssignment->bindParam(':username', $username);

                if ($stmtInsertEventAssignment->execute()) {
                    // เพิ่มข้อมูล notification_assingment สำหรับนักเรียน
                    $sqlSelectStudents = "SELECT users_username 
                                          FROM students_inclass 
                                          WHERE classroom_id = :classroomId 
                                          AND inclass_type = 0";
                    $stmtSelectStudents = $conn->prepare($sqlSelectStudents);
                    $stmtSelectStudents->bindParam(':classroomId', $classroomId);
                    $stmtSelectStudents->execute();
                    $students = $stmtSelectStudents->fetchAll(PDO::FETCH_ASSOC);

                    if ($students) {
                        $sqlInsertNotificationAssignment = "INSERT INTO notification_assingment (notification_assingment_title, notification_assingment_time, notification_assingment_duedate, notification_assingment_classID, notification_assingment_usert, notification_assingment_readstatus, notification_assingment_users)
                                                            VALUES (:notificationTitle, :notificationTime, :notificationDueDate, :notificationClassID, :notificationUser, 'notread', :notificationStudentUser)";
                        $stmtInsertNotificationAssignment = $conn->prepare($sqlInsertNotificationAssignment);
                        $stmtInsertNotificationAssignment->bindParam(':notificationTitle', $direction);
                        $stmtInsertNotificationAssignment->bindParam(':notificationTime', $currentTime);
                        $stmtInsertNotificationAssignment->bindParam(':notificationDueDate', $deadline);
                        $stmtInsertNotificationAssignment->bindParam(':notificationClassID', $classroomId);
                        $stmtInsertNotificationAssignment->bindParam(':notificationUser', $username);

                        foreach ($students as $student) {
                            $stmtInsertNotificationAssignment->bindParam(':notificationStudentUser', $student['users_username']);
                            if (!$stmtInsertNotificationAssignment->execute()) {
                                error_log("Error inserting notification for student: " . $student['users_username']);
                            }
                        }
                    }
                }
            }
        } else {
            $response["message"] = "ไม่พบห้องเรียนนี้.";
        }
    } catch (PDOException $e) {
        error_log("SQL Error: " . $e->getMessage());
        $response["message"] = "เกิดข้อผิดพลาด: " . $e->getMessage();
    }
} else {
    $response["message"] = "วิธีการคำขอไม่ถูกต้อง.";
}

echo json_encode($response);
?>
