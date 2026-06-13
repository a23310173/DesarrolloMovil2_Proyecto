# TrailerStock

Aplicacion Flutter para control de almacen en taller mecanico de trailers, basada en la propuesta visual del documento `TrailerStock - diseno.pdf`.

## Modulos incluidos

- Acceso inicial con nombre, correo, contrasena y rol operativo
- Panel operativo con metricas, alertas y movimientos recientes
- Inventario con busqueda por SKU, nombre y categoria
- Registro de movimientos de entrada, salida, ajuste y devolucion
- Flujo de aprobaciones para salidas sensibles
- Proveedores cercanos con accion para abrir ruta

## Identidad visual

La interfaz usa la paleta definida en la propuesta:

- Azul acero: `#16324F`
- Naranja industrial: `#D97706`
- Gris metalico: `#6B7280`
- Marfil tecnico: `#F3F0E8`
- Verde validacion: `#0F766E`
- Rojo alerta: `#B42318`

## Estructura actual

- `lib/main.dart`: aplicacion principal y modulos UI
- `lib/trailer_stock_api_config.dart`: URL base del API de Hostinger
- `lib/trailer_stock_models.dart`: modelos del dominio
- `lib/trailer_stock_data.dart`: controlador, repositorio mock y configuracion API
- `lib/trailer_stock_vps_repository.dart`: stub del repositorio real para la VPS
- `backend/hostinger_api`: API PHP lista para Hostinger
- `test/widget_test.dart`: prueba basica de la pantalla de acceso
- `BACKEND_VPS_SETUP.md`: contrato inicial para conectar tu VPS despues

## Probar manualmente

```bash
cd /Volumes/SE880/Development/movilesdos/proyectofinal
/Volumes/SE880/dependencias/flutter/bin/flutter run
```

## Repositorio

[DesarrolloMovil2_Proyecto](https://github.com/a23310173/DesarrolloMovil2_Proyecto)
