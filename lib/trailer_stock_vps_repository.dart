import 'dart:convert';

import 'package:http/http.dart' as http;

import 'trailer_stock_data.dart';
import 'trailer_stock_models.dart';

class VpsTrailerStockRepository implements TrailerStockRepository {
  const VpsTrailerStockRepository({
    required this.config,
  });

  final ApiConfiguration config;

  @override
  Future<TrailerStockSnapshot> bootstrapData() async {
    final inventory = await _getList(
      config.inventoryPath,
      (item) => InventoryItem.fromMap(item),
    );
    final movements = await _getList(
      config.movementsPath,
      (item) => MovementRecord.fromMap(item),
    );
    final approvals = await _getList(
      config.approvalsPath,
      (item) => ApprovalRequest.fromMap(item),
    );
    final suppliers = await _getList(
      config.suppliersPath,
      (item) => Supplier.fromMap(item),
    );

    return TrailerStockSnapshot(
      inventory: inventory,
      movements: movements,
      approvals: approvals,
      suppliers: suppliers,
    );
  }

  @override
  Future<SessionUser> login({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    final response = await http.post(
      Uri.parse('${config.baseUrl}${config.loginPath}'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'role': role.value,
      }),
    );

    final data = _decodeResponse(response);
    if (data['success'] != true) {
      throw Exception(data['message'] ?? 'No fue posible iniciar sesion.');
    }

    return SessionUser.fromMap((data['user'] as Map).cast<String, dynamic>());
  }

  Future<List<T>> _getList<T>(
    String path,
    T Function(Map<String, dynamic>) mapper,
  ) async {
    final response = await http.get(Uri.parse('${config.baseUrl}$path'));
    final data = _decodeResponse(response);
    if (data['success'] != true) {
      throw Exception(data['message'] ?? 'No fue posible consultar $path');
    }

    final list = (data['items'] as List? ?? []).cast<Map>();
    return list.map((item) => mapper(item.cast<String, dynamic>())).toList();
  }

  Map<String, dynamic> _decodeResponse(http.Response response) {
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(data['message'] ?? 'Error HTTP ${response.statusCode}');
    }
    return data;
  }
}
