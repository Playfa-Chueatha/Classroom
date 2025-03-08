<?php
header("Access-Control-Allow-Origin: *");
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

include "connect.php";

$data = json_decode(file_get_contents("php://input"), true);

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $classroomName = $data['classroomName'];
    $classroomYear = $data['classroomYear'];
    $classroomNumRoom = $data['classroomNumRoom'];
    $classroomMajor = $data['classroomMajor'];
    $username = $data['username'];

    try {
        // ค้นหา classroom_id จากตาราง classroom
        $query1 = $conn->prepare("SELECT classroom_id FROM classroom WHERE classroom_name = :classroomName AND classroom_year = :classroomYear AND classroom_numroom = :classroomNumRoom AND classroom_major = :classroomMajor");
        $query1->execute([
            ':classroomName' => $classroomName,
            ':classroomYear' => $classroomYear,
            ':classroomNumRoom' => $classroomNumRoom,
            ':classroomMajor' => $classroomMajor
        ]);

        $classroom = $query1->fetch(PDO::FETCH_ASSOC);

        if ($classroom) {
            $classroom_id = $classroom['classroom_id'];

            // ค้นหา examsets โดยใช้ classroom_id
            $query2 = $conn->prepare("SELECT * FROM examsets WHERE classroom_id = :classroom_id");
            $query2->execute([':classroom_id' => $classroom_id]);
            $examsets = $query2->fetchAll(PDO::FETCH_ASSOC);

            // ดึงข้อมูล score โดยใช้ username และ examsets_auto
            $scoreData = [];
            foreach ($examsets as $examset) {
                $examsets_id = $examset['examsets_auto'];
                $query3 = $conn->prepare("SELECT * FROM score WHERE users_username = :username AND examsets_id = :examsets_id");
                $query3->execute([
                    ':username' => $username,
                    ':examsets_id' => $examsets_id
                ]);

                $scores = $query3->fetchAll(PDO::FETCH_ASSOC);
                $scoreData = array_merge($scoreData, $scores);
            }

            // ส่งข้อมูลกลับในรูปแบบ JSON
            echo json_encode([
                'status' => 'success',
                'examsets' => $examsets,
                'scores' => $scoreData
            ]);
        } else {
            echo json_encode([
                'status' => 'error',
                'message' => 'ไม่พบข้อมูลห้องเรียน'
            ]);
        }
    } catch (Exception $e) {
        echo json_encode([
            'status' => 'error',
            'message' => 'Error: ' . $e->getMessage()
        ]);
    }
} else {
    echo json_encode([
        'status' => 'error',
        'message' => 'Invalid request method'
    ]);
}
?>
