# Integracion con Hostinger

La app ya quedo separada en:

- `lib/main.dart`: UI y navegacion
- `lib/trailer_stock_models.dart`: modelos del dominio
- `lib/trailer_stock_data.dart`: controlador, configuracion API y repositorio mock
- `lib/trailer_stock_vps_repository.dart`: repositorio HTTP para Hostinger
- `backend/hostinger_api`: API PHP para subir a Hostinger

## Credenciales MySQL detectadas

- Base de datos: `u178616640_movilesfinal`
- Usuario: `u178616640_movilesfinal`
- Host asumido: `localhost`

La password real se dejo solo en `backend/hostinger_api/db_config.php`, que ahora esta ignorado por Git para no exponerla en el repo publico.

## Flujo correcto

La app no debe conectarse directo a MySQL. El flujo correcto ya preparado es:

- Flutter
- API PHP en Hostinger
- MySQL de Hostinger

## Carpeta que debes subir al hosting

Sube esta carpeta a tu `public_html`, por ejemplo:

- `backend/hostinger_api`

La URL final ideal quedaria asi:

- `https://tu-dominio.com/hostinger_api`

## Endpoints listos

- `GET /index.php`
- `POST /login.php`
- `GET /inventory.php`
- `GET /movements.php`
- `POST /movements.php`
- `GET /approvals.php`
- `PATCH /approvals.php`
- `POST /approvals.php`
- `GET /suppliers.php`

## Base de datos

Importa este archivo en phpMyAdmin de Hostinger:

- `backend/hostinger_api/schema.sql`

Eso crea:

- `app_users`
- `inventory_items`
- `stock_movements`
- `approval_requests`
- `suppliers`

Tambien inserta datos demo y un usuario inicial:

```json
{
  "email": "santiago@gmdshop.com",
  "password": "Trailer123",
  "role": "storekeeper"
}
```

## Activar Flutter contra Hostinger

Edita:

- `lib/trailer_stock_api_config.dart`

Y cambia:

```dart
baseUrl: '',
```

por algo como:

```dart
baseUrl: 'https://tu-dominio.com/hostinger_api',
```

Con eso, `main.dart` ya cambia automaticamente de:

- `MockTrailerStockRepository`

a:

- `VpsTrailerStockRepository`

## Nota de seguridad

Como el repo ya es publico, no conviene versionar:

- passwords de MySQL
- tokens
- dominios internos sensibles

Por eso `db_config.php` quedo ignorado y `db_config.example.php` se deja solo como plantilla.
