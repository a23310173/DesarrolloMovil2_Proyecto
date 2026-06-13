<?php

require_once __DIR__ . '/db.php';

$pdo = trailer_stock_db();

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $items = $pdo->query('
        SELECT
            id,
            sku,
            product_name AS productName,
            type,
            quantity,
            responsible,
            movement_time AS timestamp,
            status,
            evidence_attached AS evidenceAttached,
            notes
        FROM stock_movements
        ORDER BY movement_time DESC
    ')->fetchAll();

    json_response([
        'success' => true,
        'items' => $items,
    ]);
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    json_response(['success' => false, 'message' => 'Metodo no permitido.'], 405);
}

$body = json_decode(file_get_contents('php://input'), true) ?? [];

$stmt = $pdo->prepare('
    INSERT INTO stock_movements (
        id,
        sku,
        product_name,
        type,
        quantity,
        responsible,
        movement_time,
        status,
        evidence_attached,
        notes
    ) VALUES (
        :id,
        :sku,
        :product_name,
        :type,
        :quantity,
        :responsible,
        :movement_time,
        :status,
        :evidence_attached,
        :notes
    )
');

$stmt->execute([
    'id' => $body['id'] ?? uniqid('MOV-'),
    'sku' => $body['sku'] ?? '',
    'product_name' => $body['productName'] ?? '',
    'type' => $body['type'] ?? 'exit',
    'quantity' => (int)($body['quantity'] ?? 0),
    'responsible' => $body['responsible'] ?? '',
    'movement_time' => $body['timestamp'] ?? gmdate('c'),
    'status' => $body['status'] ?? 'completed',
    'evidence_attached' => !empty($body['evidenceAttached']) ? 1 : 0,
    'notes' => $body['notes'] ?? '',
]);

json_response([
    'success' => true,
    'message' => 'Movimiento guardado correctamente.',
]);
