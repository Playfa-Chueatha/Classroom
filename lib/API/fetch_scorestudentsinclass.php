<?php
// รวมการเชื่อมต่อฐานข้อมูล
include 'connect.php';

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $classroomName = $_POST['classroomName'];
    $classroomMajor = $_POST['classroomMajor'];
    $classroomYear = $_POST['classroomYear'];
    $classroomNumRoom = $_POST['classroomNumRoom'];

    try {
        // Query classroom เพื่อดึง classroom_id
        $queryClassroom = "SELECT classroom_id FROM classroom 
                           WHERE classroom_name = :classroomName 
                             AND classroom_major = :classroomMajor 
                             AND classroom_year = :classroomYear 
                             AND classroom_numroom = :classroomNumRoom";
        $stmt = $conn->prepare($queryClassroom);
        $stmt->bindParam(':classroomName', $classroomName);
        $stmt->bindParam(':classroomMajor', $classroomMajor);
        $stmt->bindParam(':classroomYear', $classroomYear);
        $stmt->bindParam(':classroomNumRoom', $classroomNumRoom);
        $stmt->execute();
        $result = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($result) {
            $classroom_id = $result['classroom_id'];

            // ชุดที่ 1: Query students_inclass เพื่อดึง users_username
            $queryStudentsInClass = "SELECT users_username FROM students_inclass WHERE classroom_id = :classroom_id AND inclass_type = 0";
            $stmt2 = $conn->prepare($queryStudentsInClass);
            $stmt2->bindParam(':classroom_id', $classroom_id);
            $stmt2->execute();
            $studentsInClass = $stmt2->fetchAll(PDO::FETCH_ASSOC);

            if ($studentsInClass) {
                $usernames = array_column($studentsInClass, 'users_username');

                // Query user_students เพื่อดึงข้อมูลนักเรียน
                $placeholders = implode(',', array_fill(0, count($usernames), '?'));
                $queryUserDetails = "SELECT users_thfname, users_thlname, users_id, users_number, users_username 
                                     FROM user_students 
                                     WHERE users_username IN ($placeholders)";
                $stmt3 = $conn->prepare($queryUserDetails);
                $stmt3->execute($usernames);
                $userDetails = $stmt3->fetchAll(PDO::FETCH_ASSOC);

                // เตรียมข้อมูลชุดที่ 1
                $response1 = [
                    'userDetails' => $userDetails
                ];

                // Query examsets โดยใช้ classroom_id
                $queryExamsets = "SELECT examsets_auto, examsets_direction, examsets_fullmark, examsets_time, examsets_type 
                                  FROM examsets 
                                  WHERE classroom_id = :classroom_id";
                $stmt4 = $conn->prepare($queryExamsets);
                $stmt4->bindParam(':classroom_id', $classroom_id);
                $stmt4->execute();
                $examsetsDetails = $stmt4->fetchAll(PDO::FETCH_ASSOC);

                // แปลงค่าของ examsets_auto เป็น int ก่อนใช้งาน
                $examsetsDetails = array_map(function($exam) {
                    $exam['examsets_auto'] = (int) $exam['examsets_auto']; // แปลงค่า examsets_auto เป็น int
                    return $exam;
                }, $examsetsDetails);

                // Query score โดยใช้ users_username และ examsets_auto
                $examsetsIds = array_column($examsetsDetails, 'examsets_auto');
                $examsetsPlaceholders = implode(',', array_fill(0, count($examsetsIds), '?'));
                $placeholders = implode(',', array_fill(0, count($usernames), '?'));

                $queryScores = "SELECT score_total, score_type, users_username, examsets_id 
                                FROM score 
                                WHERE users_username IN ($placeholders) 
                                  AND examsets_id IN ($examsetsPlaceholders)";
                $stmt5 = $conn->prepare($queryScores);
                $stmt5->execute(array_merge($usernames, $examsetsIds));
                $scores = $stmt5->fetchAll(PDO::FETCH_ASSOC);

                // แปลง score_auto เป็น int หากจำเป็น
                $scores = array_map(function($score) {
                    // ตรวจสอบและแปลงค่า score_auto เป็น int หากมี
                    if (isset($score['score_auto'])) {
                        $score['score_auto'] = (int) $score['score_auto'];
                    }
                    return $score;
                }, $scores);

                // ส่งข้อมูลทั้งหมดไปยัง UI
                echo json_encode([
                    'userDetails' => $response1['userDetails'],
                    'examsetsDetails' => $examsetsDetails,
                    'scores' => $scores
                ]);
            } else {
                echo json_encode(['error' => 'ไม่พบนักเรียนในชั้นเรียน']);
                return;
            }
        } else {
            echo json_encode(['error' => 'ไม่พบข้อมูลชั้นเรียน']);
        }
    } catch (Exception $e) {
        echo json_encode(['error' => 'เกิดข้อผิดพลาด: ' . $e->getMessage()]);
    }
}
?>
