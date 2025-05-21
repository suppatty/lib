<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
session_start();

include 'db.php';

if (isset($_GET['tenant_id'])) {
    $tenant_id = $_GET['tenant_id'];

    try {
        $sql = "SELECT status, duedate, name, amount FROM pay WHERE tenant_id = :tenant_id LIMIT 1";
        $stmt = $conn->prepare($sql);
        $stmt->bindParam(':tenant_id', $tenant_id, PDO::PARAM_INT);
        $stmt->execute();

        if ($stmt->rowCount() > 0) {
            $row = $stmt->fetch(PDO::FETCH_ASSOC);
            echo json_encode([
                'status' => $row['status'],
                'duedate' => $row['duedate'],
                'amount' => $row['amount'],
                'name' => $row['name'],
            ]);
        } else {
            echo json_encode(['error' => '']);
        }
    } catch (PDOException $e) {
        echo json_encode(['error' => ': ' . $e->getMessage()]);
    }
} else {
    echo json_encode(['error' => '']);
}
?>
