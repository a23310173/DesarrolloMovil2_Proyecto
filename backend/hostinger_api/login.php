<?php

require_once __DIR__ . '/db.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    json_response(['success' => false, 'message' => 'Metodo no permitido.'], 405);
}

$body = json_decode(file_get_contents('php://input'), true) ?? [];
$email = trim($body['email'] ?? '');
$password = trim($body['password'] ?? '');
$role = trim($body['role'] ?? '');
$fallbackName = trim($body['name'] ?? 'Usuario');

if ($email === '' || $password === '') {
    json_response(['success' => false, 'message' => 'Correo y password son obligatorios.'], 422);
}

$pdo = trailer_stock_db();
$stmt = $pdo->prepare('SELECT id, name, email, password, role FROM app_users WHERE email = :email LIMIT 1');
$stmt->execute(['email' => $email]);
$user = $stmt->fetch();

if (!$user) {
    json_response(['success' => false, 'message' => 'Usuario no encontrado.'], 404);
}

$passwordOk = password_verify($password, $user['password']) || $password === $user['password'];
if (!$passwordOk) {
    json_response(['success' => false, 'message' => 'Credenciales incorrectas.'], 401);
}

json_response([
    'success' => true,
    'user' => [
        'name' => $user['name'] ?: $fallbackName,
        'role' => $user['role'] ?: ($role !== '' ? $role : 'storekeeper'),
    ],
]);
