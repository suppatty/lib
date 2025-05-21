<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
session_start();

include 'db.php';

try {
    // Read and decode incoming JSON
    $input = file_get_contents("php://input");
    $data = json_decode($input, true);

    if (!isset($data['tenant_id']) || !isset($data['message'])) {
        echo json_encode(['success' => false, 'message' => 'Missing tenant_id or message']);
        exit;
    }

    $tenant_id = $data['tenant_id'];
    $message = $data['message'];

    // Insert message into the database
    $query = "INSERT INTO messages (tenant_id, message) VALUES (:tenant_id, :message)";
    $stmt = $conn->prepare($query);
    $stmt->bindParam(':tenant_id', $tenant_id);
    $stmt->bindParam(':message', $message);

    if ($stmt->execute()) {
        echo json_encode(['success' => true, 'message' => 'Message saved to database']);
    } else {
        echo json_encode(['success' => false, 'message' => 'Database error']);
    }

} catch (Exception $e) {
    // JSON response for all exceptions
    echo json_encode([
        'success' => false,
        'message' => 'Error: ' . $e->getMessage(),
    ]);
}
?>
