import 'package:flutter/foundation.dart';

import 'trailer_stock_models.dart';

class ApiConfiguration {
  const ApiConfiguration({
    required this.baseUrl,
    this.loginPath = '/auth/login',
    this.inventoryPath = '/inventory',
    this.movementsPath = '/movements',
    this.approvalsPath = '/approvals',
    this.suppliersPath = '/suppliers',
  });

  final String baseUrl;
  final String loginPath;
  final String inventoryPath;
  final String movementsPath;
  final String approvalsPath;
  final String suppliersPath;

  bool get isConfigured => baseUrl.trim().isNotEmpty;
}

class TrailerStockSnapshot {
  const TrailerStockSnapshot({
    required this.inventory,
    required this.movements,
    required this.approvals,
    required this.suppliers,
  });

  final List<InventoryItem> inventory;
  final List<MovementRecord> movements;
  final List<ApprovalRequest> approvals;
  final List<Supplier> suppliers;
}

abstract class TrailerStockRepository {
  Future<TrailerStockSnapshot> bootstrapData();
  Future<SessionUser> login({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  });
}

class MockTrailerStockRepository implements TrailerStockRepository {
  const MockTrailerStockRepository();

  @override
  Future<TrailerStockSnapshot> bootstrapData() async {
    return TrailerStockSnapshot(
      inventory: const [
        InventoryItem(
          sku: 'BRK-1102',
          name: 'Balata premium de remolque',
          category: 'Frenos',
          unit: 'Juego',
          location: 'Rack A-02',
          stock: 14,
          minimumStock: 8,
          imageLabel: 'BRK',
        ),
        InventoryItem(
          sku: 'SUS-2048',
          name: 'Bolsa de suspension 1T15',
          category: 'Suspension',
          unit: 'Pieza',
          location: 'Rack B-04',
          stock: 5,
          minimumStock: 6,
          imageLabel: 'AIR',
        ),
        InventoryItem(
          sku: 'LGT-7780',
          name: 'Lampara lateral LED',
          category: 'Iluminacion',
          unit: 'Pieza',
          location: 'Rack C-01',
          stock: 27,
          minimumStock: 10,
          imageLabel: 'LED',
        ),
        InventoryItem(
          sku: 'ELE-5099',
          name: 'Arnes electrico de 7 vias',
          category: 'Electrico',
          unit: 'Pieza',
          location: 'Rack C-03',
          stock: 3,
          minimumStock: 5,
          imageLabel: '7P',
        ),
        InventoryItem(
          sku: 'TIR-3005',
          name: 'Llanta 295/75 R22.5',
          category: 'Rodado',
          unit: 'Pieza',
          location: 'Patio D-01',
          stock: 9,
          minimumStock: 4,
          imageLabel: '295',
        ),
      ],
      movements: [
        MovementRecord(
          id: 'MOV-9001',
          sku: 'BRK-1102',
          productName: 'Balata premium de remolque',
          type: MovementType.exit,
          quantity: 2,
          responsible: 'Mario Perez',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          status: MovementStatus.approved,
          evidenceAttached: true,
          notes: 'Servicio preventivo unidad TX-19',
        ),
        MovementRecord(
          id: 'MOV-9002',
          sku: 'ELE-5099',
          productName: 'Arnes electrico de 7 vias',
          type: MovementType.entry,
          quantity: 4,
          responsible: 'Laura Ruiz',
          timestamp: DateTime.now().subtract(const Duration(hours: 3)),
          status: MovementStatus.completed,
          evidenceAttached: true,
          notes: 'Recepcion de proveedor Industrial Parts',
        ),
        MovementRecord(
          id: 'MOV-9003',
          sku: 'SUS-2048',
          productName: 'Bolsa de suspension 1T15',
          type: MovementType.adjustment,
          quantity: 1,
          responsible: 'Carlos Nunez',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          status: MovementStatus.pendingApproval,
          evidenceAttached: false,
          notes: 'Ajuste por inventario fisico.',
        ),
      ],
      approvals: [
        ApprovalRequest(
          id: 'APR-5001',
          movementId: 'MOV-9003',
          productName: 'Bolsa de suspension 1T15',
          supervisor: 'Supervisor de turno',
          comments: 'Validar costo y existencia antes de liberar.',
          status: ApprovalStatus.pending,
          requestedAt: DateTime.now().subtract(const Duration(hours: 7)),
        ),
        ApprovalRequest(
          id: 'APR-5002',
          movementId: 'MOV-9010',
          productName: 'Modulo ABS trailer',
          supervisor: 'Jefe de almacen',
          comments: 'Pieza de alto valor para salida urgente.',
          status: ApprovalStatus.pending,
          requestedAt: DateTime.now().subtract(const Duration(hours: 10)),
        ),
      ],
      suppliers: const [
        Supplier(
          name: 'Industrial Parts Hub',
          specialty: 'Frenos y suspension',
          phone: '+1 713 555 0182',
          address: '1450 East Beltway, Houston, TX',
          distanceKm: 4.2,
          openNow: true,
          latitude: 29.7893,
          longitude: -95.2206,
        ),
        Supplier(
          name: 'Trailer Electric Solutions',
          specialty: 'Arneses y conectores',
          phone: '+1 713 555 0148',
          address: '920 Northline Dr, Houston, TX',
          distanceKm: 6.8,
          openNow: true,
          latitude: 29.8087,
          longitude: -95.3612,
        ),
        Supplier(
          name: 'Heavy Duty Wheels Center',
          specialty: 'Rodado y alineacion',
          phone: '+1 713 555 0195',
          address: '782 Market St, Houston, TX',
          distanceKm: 12.1,
          openNow: false,
          latitude: 29.7604,
          longitude: -95.3698,
        ),
      ],
    );
  }

  @override
  Future<SessionUser> login({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    return SessionUser(name: name, role: role);
  }
}

class TrailerStockController extends ChangeNotifier {
  TrailerStockController({
    required TrailerStockRepository repository,
    required ApiConfiguration apiConfiguration,
  }) : _repository = repository,
       apiConfiguration = apiConfiguration;

  final TrailerStockRepository _repository;
  final ApiConfiguration apiConfiguration;

  SessionUser? currentUser;
  int currentIndex = 0;
  String inventoryQuery = '';
  String inventoryCategory = 'Todos';
  bool isBootstrapping = true;

  final List<InventoryItem> _inventory = [];
  final List<MovementRecord> _movements = [];
  final List<ApprovalRequest> _approvals = [];
  final List<Supplier> _suppliers = [];

  List<InventoryItem> get inventory => List.unmodifiable(_inventory);
  List<MovementRecord> get movements => List.unmodifiable(_movements);
  List<ApprovalRequest> get approvals => List.unmodifiable(_approvals);
  List<Supplier> get suppliers => List.unmodifiable(_suppliers);

  List<InventoryItem> get filteredInventory {
    return _inventory.where((item) {
      final matchesCategory =
          inventoryCategory == 'Todos' || item.category == inventoryCategory;
      final query = inventoryQuery.trim().toLowerCase();
      final matchesQuery =
          query.isEmpty ||
          item.name.toLowerCase().contains(query) ||
          item.sku.toLowerCase().contains(query) ||
          item.category.toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  Future<void> load() async {
    final snapshot = await _repository.bootstrapData();
    _inventory
      ..clear()
      ..addAll(snapshot.inventory);
    _movements
      ..clear()
      ..addAll(snapshot.movements);
    _approvals
      ..clear()
      ..addAll(snapshot.approvals);
    _suppliers
      ..clear()
      ..addAll(snapshot.suppliers);
    isBootstrapping = false;
    notifyListeners();
  }

  Future<void> signIn({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    currentUser = await _repository.login(
      name: name,
      email: email,
      password: password,
      role: role,
    );
    notifyListeners();
  }

  void signOut() {
    currentUser = null;
    currentIndex = 0;
    notifyListeners();
  }

  void changeSection(int index) {
    currentIndex = index;
    notifyListeners();
  }

  void updateInventoryFilters(String query, String category) {
    inventoryQuery = query;
    inventoryCategory = category;
    notifyListeners();
  }

  void registerMovement(MovementDraft draft) {
    final itemIndex = _inventory.indexWhere((item) => item.sku == draft.sku);
    if (itemIndex == -1) {
      return;
    }

    final item = _inventory[itemIndex];
    final newStock = switch (draft.type) {
      MovementType.entry => item.stock + draft.quantity,
      MovementType.exit => item.stock - draft.quantity,
      MovementType.adjustment =>
        draft.adjustmentSign == AdjustmentSign.plus
            ? item.stock + draft.quantity
            : item.stock - draft.quantity,
      MovementType.returning => item.stock + draft.quantity,
    };

    _inventory[itemIndex] = item.copyWith(stock: newStock.clamp(0, 9999));

    final movementId = 'MOV-${9000 + _movements.length + 1}';
    final status = draft.requiresApproval
        ? MovementStatus.pendingApproval
        : MovementStatus.completed;

    _movements.insert(
      0,
      MovementRecord(
        id: movementId,
        sku: draft.sku,
        productName: item.name,
        type: draft.type,
        quantity: draft.quantity,
        responsible: draft.responsible,
        timestamp: DateTime.now(),
        status: status,
        evidenceAttached: draft.evidenceAttached,
        notes: draft.notes,
      ),
    );

    if (draft.requiresApproval) {
      _approvals.insert(
        0,
        ApprovalRequest(
          id: 'APR-${5000 + _approvals.length + 1}',
          movementId: movementId,
          productName: item.name,
          supervisor: 'Supervisor de turno',
          comments: draft.notes.isEmpty
              ? 'Salida sensible generada desde modulo operativo.'
              : draft.notes,
          status: ApprovalStatus.pending,
          requestedAt: DateTime.now(),
        ),
      );
    }

    notifyListeners();
  }

  void resolveApproval(ApprovalRequest request, bool approved) {
    final approvalIndex = _approvals.indexWhere(
      (item) => item.id == request.id,
    );
    if (approvalIndex == -1) {
      return;
    }

    _approvals[approvalIndex] = request.copyWith(
      status: approved ? ApprovalStatus.approved : ApprovalStatus.rejected,
    );

    final movementIndex = _movements.indexWhere(
      (item) => item.id == request.movementId,
    );
    if (movementIndex != -1) {
      _movements[movementIndex] = _movements[movementIndex].copyWith(
        status: approved ? MovementStatus.approved : MovementStatus.rejected,
      );
    }

    notifyListeners();
  }
}
