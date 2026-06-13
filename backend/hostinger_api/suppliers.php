<?php

require_once __DIR__ . '/db.php';

$pdo = trailer_stock_db();
$items = $pdo->query('
    SELECT
        name,
        specialty,
        phone,
        address,
        distance_km AS distanceKm,
        open_now AS openNow
    FROM suppliers
    ORDER BY distance_km ASC
')->fetchAll();

json_response([
    'success' => true,
    'items' => $items,
]);
