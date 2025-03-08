<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

include "connect.php";

try {
    // เชื่อมต่อฐานข้อมูล
    $conn = new PDO("mysql:host=$servername;dbname=$dbname;charset=utf8", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    echo json_encode(['error' => "Connection failed: " . $e->getMessage()]);
    exit;
}

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Debug: ดูข้อมูลที่รับมา
    file_put_contents('debug.log', print_r($_POST, true), FILE_APPEND);
    file_put_contents('debug.log', print_r($_FILES, true), FILE_APPEND);

    // ตรวจสอบว่า `examsets_id` ถูกส่งมาหรือไม่
    $examsetsId = $_POST['examsets_id'] ?? null;
    if (!$examsetsId) {
        echo json_encode(['error' => 'examsets_id not provided']);
        exit;
    }

    // ตรวจสอบว่าไฟล์ถูกอัปโหลดมาหรือไม่
    if (isset($_FILES['file']) && $_FILES['file']['error'] === UPLOAD_ERR_OK) {
        $uploadDir = __DIR__ . '/uploads/';
        $uploadUrl = "https://www.edueliteroom.com/connect/uploads/";

        // สร้างโฟลเดอร์ uploads หากยังไม่มี
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

        // ย้ายไฟล์ไปยังโฟลเดอร์ uploads
        if (move_uploaded_file($fileTmpPath, $destPath)) {
            // บันทึก URL ของไฟล์ในฐานข้อมูล
            $fileUrl = $uploadUrl . $uniqueFileName;

            $sql = "INSERT INTO upfile (examsets_id, upfile_name, upfile_size, upfile_type, upfile_url)
                    VALUES (:examsets_id, :upfile_name, :upfile_size, :upfile_type, :upfile_url)";
            
            $stmt = $conn->prepare($sql);
            $stmt->bindParam(':examsets_id', $examsetsId);
            $stmt->bindParam(':upfile_name', $fileName);
            $stmt->bindParam(':upfile_size', $fileSize);
            $stmt->bindParam(':upfile_type', $fileType);
            $stmt->bindParam(':upfile_url', $fileUrl);

            if ($stmt->execute()) {
                echo json_encode(['success' => 'File uploaded and information saved to database', 'upfile_url' => $fileUrl]);
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
