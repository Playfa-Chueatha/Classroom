<?php
header("Access-Control-Allow-Origin: *"); // ปรับให้เป็นโดเมนของคุณหากต้องการจำกัด
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

include "connect.php";

try {
    $conn = new PDO("mysql:host=$servername;dbname=$dbname;charset=utf8", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    echo json_encode(['error' => "Connection failed: " . $e->getMessage()]);
    exit;
}

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Debug logs
    error_log(print_r($_POST, true));
    error_log(print_r($_FILES, true));

    // รับค่าจาก POST
    $examsetsId = intval($_POST['examsets_id'] ?? 0);
    $username = $_POST['username'] ?? ''; // รับ username จาก Flutter

    // ตรวจสอบค่าที่จำเป็น
    if ($examsetsId <= 0 || empty($username)) {
        echo json_encode(['error' => 'Invalid examsets_id or username']);
        exit;
    }

    // ตรวจสอบว่ามีไฟล์ถูกอัพโหลดมาหรือไม่
    if (isset($_FILES['file']) && $_FILES['file']['error'] === UPLOAD_ERR_OK) {
        $uploadDir = __DIR__ . '/uploads/'; // โฟลเดอร์สำหรับเก็บไฟล์ที่อัพโหลด
        $uploadUrl = "https://www.edueliteroom.com/connect/uploads/";

        // สร้างโฟลเดอร์ถ้ายังไม่มี
        if (!is_dir($uploadDir)) {
            mkdir($uploadDir, 0755, true);
        }

        // ข้อมูลไฟล์
        $fileTmpPath = $_FILES['file']['tmp_name'];
        $fileName = $_FILES['file']['name'];
        $fileSize = $_FILES['file']['size'];
        $fileType = $_FILES['file']['type'];

        // สร้างชื่อไฟล์ที่ไม่ซ้ำ
        $uniqueFileName = uniqid() . "_" . basename($fileName);
        $destPath = $uploadDir . $uniqueFileName;

        // ย้ายไฟล์จาก temp ไปยังตำแหน่งปลายทาง
        if (move_uploaded_file($fileTmpPath, $destPath)) {
            $fileUrl = $uploadUrl . $uniqueFileName;

            // บันทึกข้อมูลไฟล์ลงฐานข้อมูล
            $sql = "INSERT INTO submit_upfile (examsets_id, users_username, submit_upfile_name, submit_upfile_size, submit_upfile_type, submit_upfile_url, submit_upfile_time)
                    VALUES (:examsets_id, :users_username, :submit_upfile_name, :submit_upfile_size, :submit_upfile_type, :submit_upfile_url, CURRENT_TIMESTAMP)";
            
            $stmt = $conn->prepare($sql);
            $stmt->bindParam(':examsets_id', $examsetsId);
            $stmt->bindParam(':users_username', $username); // บันทึก username
            $stmt->bindParam(':submit_upfile_name', $fileName);
            $stmt->bindParam(':submit_upfile_size', $fileSize);
            $stmt->bindParam(':submit_upfile_type', $fileType);
            $stmt->bindParam(':submit_upfile_url', $fileUrl);

            if ($stmt->execute()) {
                // ขั้นตอนที่ 1: ดึงข้อมูลจากตาราง examsets
                $stmt = $conn->prepare("SELECT classroom_id, examsets_direction, usert_username FROM examsets WHERE examsets_auto = ?");
                $stmt->execute([$examsetsId]);
                $examsets = $stmt->fetch(PDO::FETCH_ASSOC);

                if (!$examsets) {
                    throw new Exception('ไม่พบข้อมูลในตาราง examsets');
                }

                $classroom_id = $examsets['classroom_id'];
                $examsets_direction = $examsets['examsets_direction'];
                $usert_username = $examsets['usert_username'];

                // ขั้นตอนที่ 2: เพิ่มข้อมูลลงในตาราง notification_sibmit
                $stmt = $conn->prepare("
                    INSERT INTO notification_sibmit 
                    (notification_sibmit_users, notification_sibmit_classID, notification_sibmit_title, notification_sibmit_usert, notification_sibmit_time, notification_sibmit_readstatus) 
                    VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP, 'notread')
                ");
                $stmt->execute([$username, $classroom_id, $examsets_direction, $usert_username]);


                echo json_encode([
                    'success' => 'File uploaded, information saved to database, and notification added.',
                    'upfile_url' => $fileUrl
                ]);
            } else {
                echo json_encode(['error' => 'Failed to save file information']);
            }
        } else {
            echo json_encode(['error' => 'Failed to move uploaded file']);
        }
    } else {
        echo json_encode(['error' => 'No file uploaded or an error occurred during upload']);
    }
}

$conn = null;
?>
