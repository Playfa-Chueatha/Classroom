<?php
// ตรวจสอบว่าไฟล์ถูกอัปโหลดมาและไม่มีข้อผิดพลาด
if (isset($_FILES['file']) && $_FILES['file']['error'] == 0) {
    // กำหนดโฟลเดอร์ปลายทางที่ไฟล์จะถูกบันทึก
    $targetDirectory = "https://www.edueliteroom.com/uploads/"; // ระบุพาธที่ต้องการจัดเก็บไฟล์
    $fileName = basename($_FILES['file']['name']);  // รับชื่อไฟล์
    $targetFilePath = $targetDirectory . $fileName;  // รวมพาธเต็มของไฟล์

    // ย้ายไฟล์จาก temporary location ไปยังโฟลเดอร์ที่กำหนด
    if (move_uploaded_file($_FILES['file']['tmp_name'], $targetFilePath)) {
        // ถ้าอัปโหลดสำเร็จ ส่งชื่อไฟล์กลับไป
        echo $fileName;
    } else {
        // ถ้าเกิดข้อผิดพลาดในการอัปโหลด
        echo "Error uploading file.";
    }
} else {
    // ถ้าไม่มีไฟล์ถูกส่งมา หรือเกิดข้อผิดพลาด
    echo "No file uploaded.";
}
?>
