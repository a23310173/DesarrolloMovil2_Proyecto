import 'trailer_stock_data.dart';

class TrailerStockApiConfig {
  static const ApiConfiguration hostinger = ApiConfiguration(
    baseUrl: 'https://chivo.dev/hostinger_api',
    loginPath: '/login.php',
    inventoryPath: '/inventory.php',
    movementsPath: '/movements.php',
    approvalsPath: '/approvals.php',
    suppliersPath: '/suppliers.php',
  );
}
