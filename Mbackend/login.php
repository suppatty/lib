<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
session_start();

include 'db.php';

$input = file_get_contents("php://input");
$data = json_decode($input, true);

if (isset($data['email']) && isset($data['password'])) {
    $email = $data['email'];
    $password = $data['password'];

    try {
        $sql = "SELECT * FROM signin WHERE email = :email LIMIT 1";
        $stmt = $conn->prepare($sql);
        $stmt->bindParam(':email', $email);
        $stmt->execute();

        if ($stmt->rowCount() > 0) {
            $user = $stmt->fetch(PDO::FETCH_ASSOC);

            if ($password === $user['password']) {
                $_SESSION['user_id'] = $user['id'];
            
                echo json_encode([
                    'success' => true,
                    'id' => $user['id'],
                    'name' => $user['name'],
                    'phone' => $user['phone'],
                    'email' => $user['email'],
                    'unit' => $user['unit'],
                ]);
            } else {
                echo json_encode(['success' => false, 'message' => 'Invalid password.']);
            }
            
        } else {
            echo json_encode(['success' => false, 'message' => 'User not found.']);
        }
    } catch (PDOException $e) {
        echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
    }
} else {
    echo json_encode(['success' => false, 'message' => 'Invalid input.']);
}
?>
