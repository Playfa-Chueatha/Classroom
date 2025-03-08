<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    exit; 
}

include_once 'connect.php'; 

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    try {
       
        $data = json_decode(file_get_contents("php://input"));

        if ($data === null) {
            echo json_encode(['error' => 'Invalid JSON format']);
            exit;
        }

        if (!isset($data->examsetsId) || !isset($data->questions) || !is_array($data->questions)) {
            echo json_encode(['error' => 'Invalid or missing examsetsId or questions data']);
            exit;
        }

        $examsetsId = $data->examsetsId;
        $questions = $data->questions;

        foreach ($questions as $question) {
           
            if (!isset($question->question) || !isset($question->a) || !isset($question->b) || !isset($question->c) || !isset($question->d) || !isset($question->answer) || !isset($question->score)) {
                echo json_encode(['error' => 'Missing question, choice data, or score']);
                exit;
            }
        
            if (!in_array($question->answer, ['a', 'b', 'c', 'd'])) {
                echo json_encode(['error' => "Invalid answer value: {$question->answer}. Must be 'a', 'b', 'c', or 'd'."]);
                exit;
            }
        }

        // Prepare SQL query
        $stmt = $conn->prepare("INSERT INTO onechoice (examsets_id, onechoice_question, onechoice_a, onechoice_b, onechoice_c, onechoice_d, onechoice_answer, onechoice_question_score) 
                                VALUES (:examsets_id, :onechoice_question, :onechoice_a, :onechoice_b, :onechoice_c, :onechoice_d, :onechoice_answer, :onechoice_question_score)");

        foreach ($questions as $question) {
            
            // แปลงคะแนนเป็นทศนิยม 2 ตำแหน่ง
            $score = round($question->score, 2);
            
            // Bind parameters
            $stmt->bindParam(':examsets_id', $examsetsId, PDO::PARAM_INT);
            $stmt->bindParam(':onechoice_question', $question->question, PDO::PARAM_STR);
            $stmt->bindParam(':onechoice_a', $question->a, PDO::PARAM_STR);
            $stmt->bindParam(':onechoice_b', $question->b, PDO::PARAM_STR);
            $stmt->bindParam(':onechoice_c', $question->c, PDO::PARAM_STR);
            $stmt->bindParam(':onechoice_d', $question->d, PDO::PARAM_STR);
            $stmt->bindParam(':onechoice_answer', $question->answer, PDO::PARAM_STR);
            $stmt->bindParam(':onechoice_question_score', $score, PDO::PARAM_STR);

            // Execute the query
            $stmt->execute();
        }

        // Response if successful
        echo json_encode(['success' => true, 'message' => 'Questions and scores added successfully']);
    } catch (PDOException $e) {
        error_log("Database error: " . $e->getMessage());
        echo json_encode(['error' => 'Database error occurred: ' . $e->getMessage()]);
    } catch (Exception $e) {
        error_log("General error: " . $e->getMessage());
        echo json_encode(['error' => 'An error occurred: ' . $e->getMessage()]);
    }
}
?>
