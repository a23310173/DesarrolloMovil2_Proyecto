CREATE TABLE IF NOT EXISTS app_users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    email VARCHAR(160) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(40) NOT NULL DEFAULT 'storekeeper',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS inventory_items (
    sku VARCHAR(40) PRIMARY KEY,
    name VARCHAR(160) NOT NULL,
    category VARCHAR(80) NOT NULL,
    unit VARCHAR(40) NOT NULL,
    location VARCHAR(80) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    minimum_stock INT NOT NULL DEFAULT 0,
    image_label VARCHAR(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS stock_movements (
    id VARCHAR(40) PRIMARY KEY,
    sku VARCHAR(40) NOT NULL,
    product_name VARCHAR(160) NOT NULL,
    type VARCHAR(40) NOT NULL,
    quantity INT NOT NULL,
    responsible VARCHAR(120) NOT NULL,
    movement_time DATETIME NOT NULL,
    status VARCHAR(40) NOT NULL,
    evidence_attached TINYINT(1) NOT NULL DEFAULT 0,
    notes TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS approval_requests (
    id VARCHAR(40) PRIMARY KEY,
    movement_id VARCHAR(40) NOT NULL,
    product_name VARCHAR(160) NOT NULL,
    supervisor VARCHAR(120) NOT NULL,
    comments TEXT NOT NULL,
    status VARCHAR(40) NOT NULL DEFAULT 'pending',
    requested_at DATETIME NOT NULL
);

CREATE TABLE IF NOT EXISTS suppliers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(160) NOT NULL,
    specialty VARCHAR(120) NOT NULL,
    phone VARCHAR(60) NOT NULL,
    address VARCHAR(220) NOT NULL,
    distance_km DECIMAL(5,2) NOT NULL DEFAULT 0,
    open_now TINYINT(1) NOT NULL DEFAULT 1
);

INSERT INTO app_users (name, email, password, role)
VALUES ('Santiago Ramirez', 'santiago@gmdshop.com', 'Trailer123', 'storekeeper')
ON DUPLICATE KEY UPDATE name = VALUES(name);

INSERT INTO inventory_items (sku, name, category, unit, location, stock, minimum_stock, image_label) VALUES
('BRK-1102', 'Balata premium de remolque', 'Frenos', 'Juego', 'Rack A-02', 14, 8, 'BRK'),
('SUS-2048', 'Bolsa de suspension 1T15', 'Suspension', 'Pieza', 'Rack B-04', 5, 6, 'AIR'),
('LGT-7780', 'Lampara lateral LED', 'Iluminacion', 'Pieza', 'Rack C-01', 27, 10, 'LED'),
('ELE-5099', 'Arnes electrico de 7 vias', 'Electrico', 'Pieza', 'Rack C-03', 3, 5, '7P'),
('TIR-3005', 'Llanta 295/75 R22.5', 'Rodado', 'Pieza', 'Patio D-01', 9, 4, '295')
ON DUPLICATE KEY UPDATE name = VALUES(name);

INSERT INTO stock_movements (id, sku, product_name, type, quantity, responsible, movement_time, status, evidence_attached, notes) VALUES
('MOV-9001', 'BRK-1102', 'Balata premium de remolque', 'exit', 2, 'Mario Perez', NOW(), 'approved', 1, 'Servicio preventivo unidad TX-19'),
('MOV-9002', 'ELE-5099', 'Arnes electrico de 7 vias', 'entry', 4, 'Laura Ruiz', NOW(), 'completed', 1, 'Recepcion de proveedor Industrial Parts'),
('MOV-9003', 'SUS-2048', 'Bolsa de suspension 1T15', 'adjustment', 1, 'Carlos Nunez', NOW(), 'pendingApproval', 0, 'Ajuste por inventario fisico.')
ON DUPLICATE KEY UPDATE product_name = VALUES(product_name);

INSERT INTO approval_requests (id, movement_id, product_name, supervisor, comments, status, requested_at) VALUES
('APR-5001', 'MOV-9003', 'Bolsa de suspension 1T15', 'Supervisor de turno', 'Validar costo y existencia antes de liberar.', 'pending', NOW()),
('APR-5002', 'MOV-9010', 'Modulo ABS trailer', 'Jefe de almacen', 'Pieza de alto valor para salida urgente.', 'pending', NOW())
ON DUPLICATE KEY UPDATE product_name = VALUES(product_name);

INSERT INTO suppliers (name, specialty, phone, address, distance_km, open_now) VALUES
('Industrial Parts Hub', 'Frenos y suspension', '+1 713 555 0182', '1450 East Beltway, Houston, TX', 4.2, 1),
('Trailer Electric Solutions', 'Arneses y conectores', '+1 713 555 0148', '920 Northline Dr, Houston, TX', 6.8, 1),
('Heavy Duty Wheels Center', 'Rodado y alineacion', '+1 713 555 0195', '782 Market St, Houston, TX', 12.1, 0);
