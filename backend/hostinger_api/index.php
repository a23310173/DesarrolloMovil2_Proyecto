<?php

require_once __DIR__ . '/db.php';

json_response([
    'success' => true,
    'message' => 'TrailerStock Hostinger API activa.',
    'endpoints' => [
        'login.php',
        'inventory.php',
        'movements.php',
        'approvals.php',
        'suppliers.php',
    ],
]);
