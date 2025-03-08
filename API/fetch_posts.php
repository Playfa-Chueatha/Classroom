<?php
include 'connect.php';

header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// รับค่าจาก Flutter
$classroomName = isset($_POST['classroomName']) ? $_POST['classroomName'] : '';
$classroomMajor = isset($_POST['classroomMajor']) ? $_POST['classroomMajor'] : '';
$classroomYear = isset($_POST['classroomYear']) ? $_POST['classroomYear'] : '';
$classroomNumRoom = isset($_POST['classroomNumRoom']) ? $_POST['classroomNumRoom'] : '';

// ตรวจสอบค่าที่ได้รับจาก Flutter
if (empty($classroomName) || empty($classroomMajor) || empty($classroomYear) || empty($classroomNumRoom)) {
    echo json_encode(['error' => 'Missing required parameters']);
    exit();
}

// SQL เพื่อตรวจหาข้อมูล classroom_id จากตาราง classroom
$sqlClassroom = "SELECT classroom_id FROM classroom WHERE classroom_name = ? AND classroom_major = ? AND classroom_year = ? AND classroom_numroom = ?";
$stmtClassroom = $conn->prepare($sqlClassroom);
if ($stmtClassroom === false) {
    echo json_encode(['error' => 'SQL prepare failed: ' . $conn->error]);
    exit();
}

$stmtClassroom->bind_param("ssss", $classroomName, $classroomMajor, $classroomYear, $classroomNumRoom);
$stmtClassroom->execute();
$stmtClassroom->store_result();

// ตรวจสอบว่าเจอ classroom_id หรือไม่
if ($stmtClassroom->num_rows > 0) {
    $stmtClassroom->bind_result($classroomId);
    $stmtClassroom->fetch();

    // SQL เพื่อนำข้อมูลโพสต์ พร้อมลิงค์จากตาราง posts_link
    $sqlPosts = "
    SELECT p.posts_auto, p.posts_title, p.classroom_id, p.usert_username, p.post_time
    FROM posts p
    WHERE p.classroom_id = ?";

    $stmtPosts = $conn->prepare($sqlPosts);
    if ($stmtPosts === false) {
        echo json_encode(['error' => 'SQL prepare failed: ' . $conn->error]);
        exit();
    }

    $stmtPosts->bind_param("i", $classroomId);
    $stmtPosts->execute();
    $stmtPosts->store_result();
    $stmtPosts->bind_result($postsAuto, $postsTitle, $classroomId, $usertUsername, $postTime);

    $posts = array();
    while ($stmtPosts->fetch()) {
        // ดึงลิงค์จากตาราง posts_link ที่อาจมีหลายชุดข้อมูล
        $sqlLinks = "SELECT posts_link_url, posts_link_auto FROM posts_link WHERE posts_id = ?";
        $stmtLinks = $conn->prepare($sqlLinks);
        if ($stmtLinks === false) {
            echo json_encode(['error' => 'SQL prepare failed: ' . $conn->error]);
            exit();
        }

        $stmtLinks->bind_param("i", $postsAuto);
        $stmtLinks->execute();
        $stmtLinks->store_result();
        $stmtLinks->bind_result($postLinkUrl, $postsLinkAuto);

        $links = array();
        while ($stmtLinks->fetch()) {
            $links[] = array(
                'posts_link_url' => $postLinkUrl,
                'posts_link_auto' => $postsLinkAuto
            );
        }

        // SQL ค้นหาข้อมูลจากตาราง post_files เพื่อดึง file_name, file_size, file_url
        $sqlFiles = "SELECT file_name, file_size, file_url FROM post_files WHERE post_id = ?";
        $stmtFiles = $conn->prepare($sqlFiles);
        if ($stmtFiles === false) {
            echo json_encode(['error' => 'SQL prepare failed: ' . $conn->error]);
            exit();
        }

        $stmtFiles->bind_param("i", $postsAuto);  
        $stmtFiles->execute();
        $stmtFiles->store_result();
        $stmtFiles->bind_result($fileName, $fileSize, $fileUrl);

        $files = array();
        while ($stmtFiles->fetch()) {
            // คำนวณขนาดไฟล์เป็น MB หรือ KB
            $fileSizeFormatted = $fileSize >= 1048576 ? number_format($fileSize / 1048576, 2) . ' MB' : 
                                 ($fileSize >= 1024 ? number_format($fileSize / 1024, 2) . ' KB' : $fileSize . ' B');
            $files[] = array(
                'file_name' => $fileName,
                'file_size' => $fileSizeFormatted,
                'file_url' => $fileUrl
            );
        }

        // SQL ค้นหาข้อมูลจากตาราง user_teacher
        $sqlUserTeacher = "SELECT usert_thfname, usert_thlname FROM user_teacher WHERE usert_username = ?";
        $stmtUserTeacher = $conn->prepare($sqlUserTeacher);
        if ($stmtUserTeacher === false) {
            echo json_encode(['error' => 'SQL prepare failed: ' . $conn->error]);
            exit();
        }

        $stmtUserTeacher->bind_param("s", $usertUsername);
        $stmtUserTeacher->execute();
        $stmtUserTeacher->store_result();
        $stmtUserTeacher->bind_result($usertThfname, $usertThlname);

        if ($stmtUserTeacher->num_rows > 0) {
            $stmtUserTeacher->fetch();
            $posts[] = array(
                'classroom_id' => strval($classroomId),
                'posts_auto' => strval($postsAuto),
                'posts_title' => $postsTitle,
                'post_time' => $postTime,
                'links' => $links, // ส่งลิงค์ทั้งหมดที่ดึงมาจาก posts_link
                'files' => $files,
                'usert_thfname' => $usertThfname,
                'usert_thlname' => $usertThlname
            );
        } else {
            $posts[] = array(
                'classroom_id' => strval($classroomId),
                'posts_auto' => strval($postsAuto),
                'posts_title' => $postsTitle,
                'post_time' => $postTime,
                'links' => $links, // ส่งลิงค์ทั้งหมดที่ดึงมาจาก posts_link
                'files' => $files,
                'usert_thfname' => null,
                'usert_thlname' => null
            );
        }

        $stmtUserTeacher->close();
        $stmtFiles->close();
        $stmtLinks->close();
    }

    // ส่งข้อมูลกลับไปยัง Flutter
    if (empty($posts)) {
        echo json_encode(['error' => 'No posts found']);
    } else {
        echo json_encode($posts);
    }
} else {
    echo json_encode(['error' => 'No matching classroom found']);
}

$conn->close();
?>
