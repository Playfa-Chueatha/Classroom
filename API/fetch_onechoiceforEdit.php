<?php
include 'connect.php';


header('Content-Type: application/json');


$examsets_id = $_POST['examsets_id'] ?? null;


if ($examsets_id) {
    try {
        
        $stmt = $conn->prepare("
            SELECT 
                onechoice_auto, 
                examsets_id, 
                onechoice_question, 
                onechoice_a, 
                onechoice_b, 
                onechoice_c, 
                onechoice_d, 
                onechoice_answer, 
                onechoice_question_score 
            FROM 
                onechoice 
            WHERE 
                examsets_id = :examsets_id
        ");
        
        
        $stmt->bindParam(':examsets_id', $examsets_id, PDO::PARAM_INT);
        
        
        $stmt->execute();
        
        
        $result = $stmt->fetchAll(PDO::FETCH_ASSOC);
        
        
        echo json_encode($result);
    } catch (Exception $e) {
        
        error_log("Error: " . $e->getMessage());
        echo json_encode(['error' => 'Failed to fetch data.']);
    }
} else {
    echo json_encode(['error' => 'Invalid or missing examsets_id.']);
}
?>
