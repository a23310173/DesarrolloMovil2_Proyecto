<?php

require_once __DIR__ . '/db.php';

$pdo = trailer_stock_db();
$items = $pdo->query('
    SELECT
        sku,
        name,
        category,
        unit,
        location,
        stock,
        minimum_stock AS minimumStock,
        image_label AS imageLabel
    FROM inventory_items
    ORDER BY name ASC
')->fetchAll();

json_response([
    'success' => true,
    'items' => $items,
]);
