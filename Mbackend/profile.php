<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
include 'db.php';

// Check if `id` is passed as a GET parameter
if (isset($_GET['id'])) {
    $user_id = $_GET['id'];

    try {
        // Prepare SQL to fetch user details by user_id
        $sql = "SELECT name, phone, email, unit FROM signin WHERE id = :id LIMIT 1";
        $stmt = $conn->prepare($sql);
        $stmt->bindParam(':id', $user_id);
        $stmt->execute();

        if ($stmt->rowCount() > 0) {
            $user = $stmt->fetch(PDO::FETCH_ASSOC);
            echo json_encode([
                'success' => true,
                'name' => $user['name'],
                'phone' => $user['phone'],
                'email' => $user['email'],
                'unit' => $user['unit'],
            ]);
        } else {
            echo json_encode(['success' => false, 'message' => 'User not found.']);
        }
    } catch (PDOException $e) {
        echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
    }
} else {
    echo json_encode(['success' => false, 'message' => 'No user ID provided.']);
}
?>
