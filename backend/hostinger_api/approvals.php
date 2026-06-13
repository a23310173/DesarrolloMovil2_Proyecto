<?php

require_once __DIR__ . '/db.php';

$pdo = trailer_stock_db();

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $items = $pdo->query('
        SELECT
            id,
            movement_id AS movementId,
            product_name AS productName,
            supervisor,
            comments,
            status,
            requested_at AS requestedAt
        FROM approval_requests
        ORDER BY requested_at DESC
    ')->fetchAll();

    json_response([
        'success' => true,
        'items' => $items,
    ]);
}

if ($_SERVER['REQUEST_METHOD'] !== 'PATCH' && $_SERVER['REQUEST_METHOD'] !== 'POST') {
    json_response(['success' => false, 'message' => 'Metodo no permitido.'], 405);
}

$body = json_decode(file_get_contents('php://input'), true) ?? [];
$id = trim($body['id'] ?? '');
$status = trim($body['status'] ?? '');

if ($id === '' || $status === '') {
    json_response(['success' => false, 'message' => 'id y status son obligatorios.'], 422);
}

$stmt = $pdo->prepare('UPDATE approval_requests SET status = :status WHERE id = :id');
$stmt->execute([
    'id' => $id,
    'status' => $status,
]);

json_response([
    'success' => true,
    'message' => 'Aprobacion actualizada.',
]);
