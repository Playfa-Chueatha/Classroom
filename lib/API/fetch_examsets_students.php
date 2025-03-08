<?php
header("Access-Control-Allow-Origin: *");
header('Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, PATCH, DELETE');
header('Access-Control-Allow-Headers: *');
header('Access-Control-Max-Age: 86400');

$servername = "118.27.130.237"; 
$username = "zgmupszw_edueliteroom1"; 
$password = "edueliteroom1"; 
$dbname = "zgmupszw_edueliteroom01"; 

try {
    // ตั้งค่าการเชื่อมต่อฐานข้อมูล
    $conn = new PDO("mysql:host=$servername;dbname=$dbname;charset=utf8", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION); // เปิดการแสดงข้อผิดพลาด
} catch (PDOException $e) {
    error_log("Connection failed: " . $e->getMessage()); // บันทึกข้อผิดพลาดลงใน Log
    echo json_encode(['error' => 'Connection failed.']); // ส่งกลับ JSON หากเชื่อมต่อไม่สำเร็จ
    exit;
}

// รับค่าจาก POST
$classroomName = $_POST['classroomName'] ?? '';
$classroomMajor = $_POST['classroomMajor'] ?? '';
$classroomYear = $_POST['classroomYear'] ?? '';
$classroomNumRoom = $_POST['classroomNumRoom'] ?? '';
$username = $_POST['username'] ?? '';

// ตรวจสอบว่ามีพารามิเตอร์ครบถ้วน
if (empty($classroomName) || empty($classroomMajor) || empty($classroomYear) || empty($classroomNumRoom) || empty($username)) {
    error_log("Missing parameters: " . json_encode([
        'classroomName' => $classroomName,
        'classroomMajor' => $classroomMajor,
        'classroomYear' => $classroomYear,
        'classroomNumRoom' => $classroomNumRoom,
        'username' => $username
    ]));  // บันทึกข้อผิดพลาดที่พารามิเตอร์หายไป
    echo json_encode(['error' => 'Missing parameters.']);
    exit;
}

try {
    // ดึง classroom_id จากตาราง classroom
    $classroom_query = $conn->prepare("SELECT classroom_id FROM classroom WHERE classroom_name = :name AND classroom_major = :major AND classroom_year = :year AND classroom_numroom = :numroom");
    $classroom_query->execute([
        ':name' => $classroomName,
        ':major' => $classroomMajor,
        ':year' => $classroomYear,
        ':numroom' => $classroomNumRoom
    ]);

    $classroom_row = $classroom_query->fetch(PDO::FETCH_ASSOC);

    if ($classroom_row) {
        $classroom_id = $classroom_row['classroom_id'];
        error_log("Found classroom_id: " . $classroom_id);  // บันทึกข้อมูล classroom_id

        // ดึงข้อมูลจาก examsets ที่ตรงกับ classroom_id
        $examsets_query = $conn->prepare("SELECT examsets_auto, examsets_direction, examsets_fullmark, examsets_deadline, examsets_time, examsets_type, examsets_closed, examsets_Inspection_status, usert_username FROM examsets WHERE classroom_id = :classroom_id");
        $examsets_query->execute([ ':classroom_id' => $classroom_id ]);
        $examsets_data = $examsets_query->fetchAll(PDO::FETCH_ASSOC);

        // ตรวจสอบข้อมูลใน submit_auswer ที่ตรงกับ username
        $submit_answer_query = $conn->prepare("SELECT DISTINCT examsets_id FROM submit_auswer WHERE users_username = :username");
        $submit_answer_query->execute([ ':username' => $username ]);
        $submit_auswer_data = $submit_answer_query->fetchAll(PDO::FETCH_ASSOC);
        
        // ตรวจสอบข้อมูลใน submit_manychoice ที่ตรงกับ username
        $submit_manychoice_query = $conn->prepare("SELECT DISTINCT examsets_id FROM submit_manychoice WHERE users_username = :username");
        $submit_manychoice_query->execute([ ':username' => $username ]);
        $submit_manychoice_data = $submit_manychoice_query->fetchAll(PDO::FETCH_ASSOC);
        
        // ตรวจสอบข้อมูลใน submit_onechoice ที่ตรงกับ username
        $submit_onechoice_query = $conn->prepare("SELECT DISTINCT examsets_id FROM submit_onechoice WHERE users_username = :username");
        $submit_onechoice_query->execute([ ':username' => $username ]);
        $submit_onechoice_data = $submit_onechoice_query->fetchAll(PDO::FETCH_ASSOC);
        
        // ตรวจสอบข้อมูลใน submit_upfile ที่ตรงกับ username
        $submit_upfile_query = $conn->prepare("SELECT DISTINCT examsets_id FROM submit_upfile WHERE users_username = :username");
        $submit_upfile_query->execute([ ':username' => $username ]);
        $submit_upfile_data = $submit_upfile_query->fetchAll(PDO::FETCH_ASSOC);
        
        // ตรวจสอบให้แน่ใจว่าแต่ละตัวแปรที่ใช้ใน array_merge() เป็นอาร์เรย์
        $submit_auswer_data = $submit_auswer_data ?? []; // ถ้าเป็น null ให้ตั้งเป็นอาร์เรย์ว่าง
        $submit_manychoice_data = $submit_manychoice_data ?? [];
        $submit_onechoice_data = $submit_onechoice_data ?? [];
        $submit_upfile_data = $submit_upfile_data ?? [];
        
        // รวมข้อมูลทั้งหมดจากตารางต่างๆ
        $completed_examsets = [];
        $future_examsets = [];
        
        // รวมข้อมูลทั้งหมดที่ต้องตรวจสอบ
        $all_submitted_examsets = array_merge(
            $submit_auswer_data,
            $submit_manychoice_data,
            $submit_onechoice_data,
            $submit_upfile_data
        );


        // เปรียบเทียบ examsets_id ที่ดึงจาก submit ต่างๆ กับ examsets_auto จาก examsets
        foreach ($examsets_data as $examset) {
            $examsets_auto = $examset['examsets_auto'];
            $is_completed = false;

            // ตรวจสอบว่า examsets_id ซ้ำกับที่มีใน submit_answer, submit_manychoice, submit_onechoice หรือ submit_upfile หรือไม่
            foreach ($all_submitted_examsets as $submit_data) {
                if ($submit_data['examsets_id'] == $examsets_auto) {
                    $is_completed = true;
                    break;
                }
            }

            // ถ้ามีข้อมูลซ้ำ ให้โยนเข้า completeexamsets ถ้าไม่ให้โยนเข้า futureexamsets
            if ($is_completed) {
                $completed_examsets[] = $examset;
            } else {
                $future_examsets[] = $examset;
            }
        }

        // ส่งข้อมูลในรูปแบบที่ต้องการ
        echo json_encode([
            'completed_examsets' => $completed_examsets,
            'future_examsets' => $future_examsets
        ]);
    } else {
        error_log("No classroom found for provided parameters.");
        echo json_encode(['error' => 'Classroom not found.']);
    }
} catch (Exception $e) {
    // บันทึกข้อผิดพลาด
    error_log("Error fetching data: " . $e->getMessage());
    echo json_encode(['error' => 'Failed to fetch data.']);
}
?>
