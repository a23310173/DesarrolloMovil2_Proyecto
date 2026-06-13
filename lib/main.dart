import 'package:flutter/material.dart';

void main() {
  runApp(const TrailerStockApp());
}

class TrailerStockApp extends StatelessWidget {
  const TrailerStockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TrailerStock',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: TrailerStockColors.ivory,
        colorScheme: ColorScheme.fromSeed(
          seedColor: TrailerStockColors.steelBlue,
          primary: TrailerStockColors.steelBlue,
          secondary: TrailerStockColors.industrialOrange,
          surface: Colors.white,
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: TrailerStockColors.steelBlue,
            letterSpacing: -0.5,
          ),
          titleLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: TrailerStockColors.steelBlue,
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: TrailerStockColors.steelBlue,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: TrailerStockColors.metalGray,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: TrailerStockColors.borderSoft),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(
              color: TrailerStockColors.industrialOrange,
              width: 1.3,
            ),
          ),
        ),
        chipTheme: const ChipThemeData(
          shape: StadiumBorder(),
          side: BorderSide.none,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: TrailerStockColors.borderSoft),
          ),
        ),
      ),
      home: const TrailerStockRoot(),
    );
  }
}

class TrailerStockRoot extends StatefulWidget {
  const TrailerStockRoot({super.key});

  @override
  State<TrailerStockRoot> createState() => _TrailerStockRootState();
}

class _TrailerStockRootState extends State<TrailerStockRoot> {
  SessionUser? _currentUser;
  int _currentIndex = 0;
  String _inventoryQuery = '';
  String _inventoryCategory = 'Todos';

  final List<InventoryItem> _inventory = [
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
  ];

  final List<MovementRecord> _movements = [
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
  ];

  final List<ApprovalRequest> _approvals = [
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
  ];

  final List<Supplier> _suppliers = [
    Supplier(
      name: 'Industrial Parts Hub',
      specialty: 'Frenos y suspension',
      phone: '+1 713 555 0182',
      address: '1450 East Beltway, Houston, TX',
      distanceKm: 4.2,
      openNow: true,
    ),
    Supplier(
      name: 'Trailer Electric Solutions',
      specialty: 'Arneses y conectores',
      phone: '+1 713 555 0148',
      address: '920 Northline Dr, Houston, TX',
      distanceKm: 6.8,
      openNow: true,
    ),
    Supplier(
      name: 'Heavy Duty Wheels Center',
      specialty: 'Rodado y alineacion',
      phone: '+1 713 555 0195',
      address: '782 Market St, Houston, TX',
      distanceKm: 12.1,
      openNow: false,
    ),
  ];

  void _signIn(String name, UserRole role) {
    setState(() {
      _currentUser = SessionUser(name: name, role: role);
    });
  }

  void _signOut() {
    setState(() {
      _currentUser = null;
      _currentIndex = 0;
    });
  }

  void _changeSection(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _updateInventoryFilters(String query, String category) {
    setState(() {
      _inventoryQuery = query;
      _inventoryCategory = category;
    });
  }

  void _registerMovement(MovementDraft draft) {
    final itemIndex = _inventory.indexWhere((item) => item.sku == draft.sku);
    if (itemIndex == -1) {
      return;
    }

    final item = _inventory[itemIndex];
    final newStock = switch (draft.type) {
      MovementType.entry => item.stock + draft.quantity,
      MovementType.exit => item.stock - draft.quantity,
      MovementType.adjustment => draft.adjustmentSign == AdjustmentSign.plus
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

    setState(() {});
  }

  void _resolveApproval(ApprovalRequest request, bool approved) {
    final approvalIndex = _approvals.indexWhere((item) => item.id == request.id);
    if (approvalIndex == -1) {
      return;
    }

    _approvals[approvalIndex] = request.copyWith(
      status: approved ? ApprovalStatus.approved : ApprovalStatus.rejected,
    );

    final movementIndex = _movements.indexWhere((item) => item.id == request.movementId);
    if (movementIndex != -1) {
      _movements[movementIndex] = _movements[movementIndex].copyWith(
        status: approved ? MovementStatus.approved : MovementStatus.rejected,
      );
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return TrailerStockLoginScreen(
        onLogin: _signIn,
      );
    }

    final filteredInventory = _inventory.where((item) {
      final matchesCategory =
          _inventoryCategory == 'Todos' || item.category == _inventoryCategory;
      final query = _inventoryQuery.trim().toLowerCase();
      final matchesQuery = query.isEmpty ||
          item.name.toLowerCase().contains(query) ||
          item.sku.toLowerCase().contains(query) ||
          item.category.toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();

    return TrailerStockShell(
      currentUser: _currentUser!,
      currentIndex: _currentIndex,
      onDestinationSelected: _changeSection,
      onSignOut: _signOut,
      sections: [
        DashboardPage(
          currentUser: _currentUser!,
          inventory: _inventory,
          movements: _movements,
          approvals: _approvals,
          onOpenSection: _changeSection,
        ),
        InventoryPage(
          items: filteredInventory,
          selectedCategory: _inventoryCategory,
          onFiltersChanged: _updateInventoryFilters,
        ),
        MovementsPage(
          inventory: _inventory,
          recentMovements: _movements.take(5).toList(),
          currentUser: _currentUser!,
          onRegisterMovement: _registerMovement,
        ),
        ApprovalsPage(
          approvals: _approvals,
          onResolveApproval: _resolveApproval,
        ),
        SuppliersPage(
          suppliers: _suppliers,
        ),
      ],
    );
  }
}

class TrailerStockLoginScreen extends StatefulWidget {
  const TrailerStockLoginScreen({
    super.key,
    required this.onLogin,
  });

  final void Function(String name, UserRole role) onLogin;

  @override
  State<TrailerStockLoginScreen> createState() => _TrailerStockLoginScreenState();
}

class _TrailerStockLoginScreenState extends State<TrailerStockLoginScreen> {
  final _nameController = TextEditingController(text: 'Santiago Ramirez');
  final _emailController = TextEditingController(text: 'santiago@gmdshop.com');
  final _passwordController = TextEditingController(text: 'Trailer123');
  UserRole _selectedRole = UserRole.storekeeper;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completa nombre, correo y contrasena para continuar.'),
        ),
      );
      return;
    }

    widget.onLogin(name, _selectedRole);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF3F0E8),
              Color(0xFFE5E7EB),
              Color(0xFFDDE4EA),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const TrailerStockHeroLogo(),
                        const SizedBox(height: 24),
                        Text(
                          'TrailerStock',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Control de almacen para taller mecanico de trailers.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 24),
                        TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Nombre del usuario',
                            prefixIcon: Icon(Icons.badge_outlined),
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Correo',
                            prefixIcon: Icon(Icons.alternate_email),
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Contrasena',
                            prefixIcon: Icon(Icons.lock_outline),
                          ),
                        ),
                        const SizedBox(height: 14),
                        DropdownButtonFormField<UserRole>(
                          initialValue: _selectedRole,
                          decoration: const InputDecoration(
                            labelText: 'Rol operativo',
                            prefixIcon: Icon(Icons.admin_panel_settings_outlined),
                          ),
                          items: UserRole.values
                              .map(
                                (role) => DropdownMenuItem<UserRole>(
                                  value: role,
                                  child: Text(role.label),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              _selectedRole = value;
                            });
                          },
                        ),
                        const SizedBox(height: 22),
                        FilledButton.icon(
                          onPressed: _submit,
                          style: FilledButton.styleFrom(
                            backgroundColor: TrailerStockColors.industrialOrange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                          ),
                          icon: const Icon(Icons.login),
                          label: const Text('Entrar al panel operativo'),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: const [
                            StatusChip(
                              label: 'Inventario en tiempo real',
                              color: TrailerStockColors.validationGreen,
                            ),
                            StatusChip(
                              label: 'Aprobaciones sensibles',
                              color: TrailerStockColors.alertRed,
                            ),
                            StatusChip(
                              label: 'Mapa de proveedores',
                              color: TrailerStockColors.steelBlue,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TrailerStockShell extends StatelessWidget {
  const TrailerStockShell({
    super.key,
    required this.currentUser,
    required this.currentIndex,
    required this.onDestinationSelected,
    required this.onSignOut,
    required this.sections,
  });

  final SessionUser currentUser;
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;
  final VoidCallback onSignOut;
  final List<Widget> sections;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 920;

    final destinations = const [
      NavigationDestination(
        icon: Icon(Icons.space_dashboard_outlined),
        selectedIcon: Icon(Icons.space_dashboard),
        label: 'Panel',
      ),
      NavigationDestination(
        icon: Icon(Icons.inventory_2_outlined),
        selectedIcon: Icon(Icons.inventory_2),
        label: 'Inventario',
      ),
      NavigationDestination(
        icon: Icon(Icons.compare_arrows_outlined),
        selectedIcon: Icon(Icons.compare_arrows),
        label: 'Movimientos',
      ),
      NavigationDestination(
        icon: Icon(Icons.fact_check_outlined),
        selectedIcon: Icon(Icons.fact_check),
        label: 'Aprobaciones',
      ),
      NavigationDestination(
        icon: Icon(Icons.place_outlined),
        selectedIcon: Icon(Icons.place),
        label: 'Proveedores',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TrailerStockColors.ivory,
        surfaceTintColor: TrailerStockColors.ivory,
        titleSpacing: 20,
        title: Row(
          children: [
            const TrailerStockMiniLogo(),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'TrailerStock',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: TrailerStockColors.steelBlue,
                  ),
                ),
                Text(
                  '${currentUser.role.label} activo',
                  style: const TextStyle(
                    fontSize: 12,
                    color: TrailerStockColors.metalGray,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: TrailerStockColors.borderSoft),
                ),
                child: Text(
                  currentUser.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: TrailerStockColors.steelBlue,
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: onSignOut,
            tooltip: 'Cerrar sesion',
            icon: const Icon(Icons.logout),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Row(
        children: [
          if (isWide)
            NavigationRail(
              minWidth: 88,
              labelType: NavigationRailLabelType.all,
              selectedIndex: currentIndex,
              onDestinationSelected: onDestinationSelected,
              leading: const Padding(
                padding: EdgeInsets.only(top: 12),
                child: Icon(
                  Icons.precision_manufacturing_outlined,
                  color: TrailerStockColors.industrialOrange,
                  size: 34,
                ),
              ),
              destinations: destinations
                  .map(
                    (destination) => NavigationRailDestination(
                      icon: destination.icon,
                      selectedIcon: destination.selectedIcon,
                      label: Text(destination.label),
                    ),
                  )
                  .toList(),
            ),
          Expanded(child: sections[currentIndex]),
        ],
      ),
      bottomNavigationBar: isWide
          ? null
          : NavigationBar(
              selectedIndex: currentIndex,
              onDestinationSelected: onDestinationSelected,
              destinations: destinations,
            ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({
    super.key,
    required this.currentUser,
    required this.inventory,
    required this.movements,
    required this.approvals,
    required this.onOpenSection,
  });

  final SessionUser currentUser;
  final List<InventoryItem> inventory;
  final List<MovementRecord> movements;
  final List<ApprovalRequest> approvals;
  final ValueChanged<int> onOpenSection;

  @override
  Widget build(BuildContext context) {
    final criticalStock = inventory.where((item) => item.stock <= item.minimumStock).length;
    final totalStock = inventory.fold<int>(0, (sum, item) => sum + item.stock);
    final pendingApprovals =
        approvals.where((item) => item.status == ApprovalStatus.pending).length;
    final todaysMovements = movements.where((item) {
      final now = DateTime.now();
      return item.timestamp.year == now.year &&
          item.timestamp.month == now.month &&
          item.timestamp.day == now.day;
    }).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DashboardHeroCard(
            currentUser: currentUser,
            criticalStock: criticalStock,
            onOpenSection: onOpenSection,
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 780;
              return Wrap(
                spacing: 14,
                runSpacing: 14,
                children: [
                  MetricCard(
                    width: compact ? constraints.maxWidth : (constraints.maxWidth - 14) / 2,
                    label: 'Existencias totales',
                    value: '$totalStock piezas',
                    detail: 'Stock disponible en almacen',
                    accent: TrailerStockColors.steelBlue,
                    icon: Icons.inventory_2_outlined,
                  ),
                  MetricCard(
                    width: compact ? constraints.maxWidth : (constraints.maxWidth - 14) / 2,
                    label: 'Movimientos de hoy',
                    value: '$todaysMovements',
                    detail: 'Entradas, salidas y ajustes registrados',
                    accent: TrailerStockColors.industrialOrange,
                    icon: Icons.compare_arrows_outlined,
                  ),
                  MetricCard(
                    width: compact ? constraints.maxWidth : (constraints.maxWidth - 14) / 2,
                    label: 'Alertas de stock minimo',
                    value: '$criticalStock productos',
                    detail: 'Requieren reposicion inmediata',
                    accent: TrailerStockColors.alertRed,
                    icon: Icons.warning_amber_rounded,
                  ),
                  MetricCard(
                    width: compact ? constraints.maxWidth : (constraints.maxWidth - 14) / 2,
                    label: 'Solicitudes por aprobar',
                    value: '$pendingApprovals',
                    detail: 'Salidas sensibles pendientes',
                    accent: TrailerStockColors.validationGreen,
                    icon: Icons.fact_check_outlined,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 18),
          SectionCard(
            title: 'Ultimos movimientos',
            subtitle: 'Bitacora resumida de la operacion diaria.',
            actionLabel: 'Ir a movimientos',
            onAction: () => onOpenSection(2),
            child: Column(
              children: movements.take(4).map((movement) {
                return MovementTile(movement: movement);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class InventoryPage extends StatefulWidget {
  const InventoryPage({
    super.key,
    required this.items,
    required this.selectedCategory,
    required this.onFiltersChanged,
  });

  final List<InventoryItem> items;
  final String selectedCategory;
  final void Function(String query, String category) onFiltersChanged;

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final _searchController = TextEditingController();
  static const categories = [
    'Todos',
    'Frenos',
    'Suspension',
    'Iluminacion',
    'Electrico',
    'Rodado',
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_emitFilters);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_emitFilters)
      ..dispose();
    super.dispose();
  }

  void _emitFilters() {
    widget.onFiltersChanged(_searchController.text, widget.selectedCategory);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionIntro(
            title: 'Inventario y busqueda',
            subtitle:
                'Localiza piezas por SKU, nombre o categoria y revisa su disponibilidad.',
          ),
          const SizedBox(height: 18),
          SectionCard(
            title: 'Buscador operativo',
            subtitle: 'Consulta rapida para piso de taller.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'Buscar por SKU, nombre o categoria',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: categories.map((category) {
                    final selected = category == widget.selectedCategory;
                    return ChoiceChip(
                      label: Text(category),
                      selected: selected,
                      selectedColor: TrailerStockColors.steelBlue.withValues(alpha: 0.12),
                      onSelected: (_) {
                        widget.onFiltersChanged(_searchController.text, category);
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          ...widget.items.map((item) => InventoryCard(item: item)),
          if (widget.items.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(22),
                child: Text(
                  'No se encontraron piezas con ese filtro.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class MovementsPage extends StatefulWidget {
  const MovementsPage({
    super.key,
    required this.inventory,
    required this.recentMovements,
    required this.currentUser,
    required this.onRegisterMovement,
  });

  final List<InventoryItem> inventory;
  final List<MovementRecord> recentMovements;
  final SessionUser currentUser;
  final ValueChanged<MovementDraft> onRegisterMovement;

  @override
  State<MovementsPage> createState() => _MovementsPageState();
}

class _MovementsPageState extends State<MovementsPage> {
  String? _selectedSku;
  MovementType _movementType = MovementType.exit;
  AdjustmentSign _adjustmentSign = AdjustmentSign.plus;
  final _quantityController = TextEditingController(text: '1');
  final _responsibleController = TextEditingController();
  final _notesController = TextEditingController();
  bool _requiresApproval = true;
  bool _evidenceAttached = false;

  @override
  void initState() {
    super.initState();
    _selectedSku = widget.inventory.isNotEmpty ? widget.inventory.first.sku : null;
    _responsibleController.text = widget.currentUser.name;
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _responsibleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    final quantity = int.tryParse(_quantityController.text.trim()) ?? 0;
    if (_selectedSku == null || quantity <= 0 || _responsibleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona producto, cantidad valida y responsable.'),
        ),
      );
      return;
    }

    widget.onRegisterMovement(
      MovementDraft(
        sku: _selectedSku!,
        type: _movementType,
        quantity: quantity,
        responsible: _responsibleController.text.trim(),
        notes: _notesController.text.trim(),
        requiresApproval: _requiresApproval,
        evidenceAttached: _evidenceAttached,
        adjustmentSign: _adjustmentSign,
      ),
    );

    setState(() {
      _quantityController.text = '1';
      _notesController.clear();
      _requiresApproval = _movementType == MovementType.exit;
      _evidenceAttached = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Movimiento registrado en la bitacora.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionIntro(
            title: 'Registro de entrada y salida',
            subtitle:
                'Documenta cantidad, evidencia, responsable y necesidad de autorizacion.',
          ),
          const SizedBox(height: 18),
          SectionCard(
            title: 'Nuevo movimiento',
            subtitle: 'Captura operativa con enfoque en trazabilidad.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _selectedSku,
                  decoration: const InputDecoration(
                    labelText: 'Producto',
                    prefixIcon: Icon(Icons.inventory_2_outlined),
                  ),
                  items: widget.inventory
                      .map(
                        (item) => DropdownMenuItem<String>(
                          value: item.sku,
                          child: Text('${item.sku} - ${item.name}'),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSku = value;
                    });
                  },
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<MovementType>(
                  initialValue: _movementType,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de movimiento',
                    prefixIcon: Icon(Icons.swap_horiz),
                  ),
                  items: MovementType.values
                      .map(
                        (type) => DropdownMenuItem<MovementType>(
                          value: type,
                          child: Text(type.label),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      _movementType = value;
                      _requiresApproval = value == MovementType.exit;
                    });
                  },
                ),
                if (_movementType == MovementType.adjustment) ...[
                  const SizedBox(height: 14),
                  SegmentedButton<AdjustmentSign>(
                    segments: const [
                      ButtonSegment(
                        value: AdjustmentSign.plus,
                        label: Text('Ajuste +'),
                        icon: Icon(Icons.add),
                      ),
                      ButtonSegment(
                        value: AdjustmentSign.minus,
                        label: Text('Ajuste -'),
                        icon: Icon(Icons.remove),
                      ),
                    ],
                    selected: {_adjustmentSign},
                    onSelectionChanged: (selection) {
                      setState(() {
                        _adjustmentSign = selection.first;
                      });
                    },
                  ),
                ],
                const SizedBox(height: 14),
                TextField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Cantidad',
                    prefixIcon: Icon(Icons.tag),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _responsibleController,
                  decoration: const InputDecoration(
                    labelText: 'Responsable',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Notas operativas',
                    prefixIcon: Icon(Icons.notes_outlined),
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    FilterChip(
                      label: Text(
                        _evidenceAttached ? 'Evidencia adjunta' : 'Adjuntar evidencia',
                      ),
                      avatar: Icon(
                        _evidenceAttached
                            ? Icons.photo_camera_front
                            : Icons.photo_camera_outlined,
                        size: 18,
                      ),
                      selected: _evidenceAttached,
                      onSelected: (value) {
                        setState(() {
                          _evidenceAttached = value;
                        });
                      },
                    ),
                    FilterChip(
                      label: Text(
                        _requiresApproval
                            ? 'Requiere aprobacion'
                            : 'Sin aprobacion',
                      ),
                      selected: _requiresApproval,
                      onSelected: (value) {
                        setState(() {
                          _requiresApproval = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: _submit,
                  style: FilledButton.styleFrom(
                    backgroundColor: TrailerStockColors.industrialOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  icon: const Icon(Icons.add_task),
                  label: const Text('Registrar movimiento'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SectionCard(
            title: 'Bitacora reciente',
            subtitle: 'Ultimos registros del modulo.',
            child: Column(
              children: widget.recentMovements
                  .map((movement) => MovementTile(movement: movement))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class ApprovalsPage extends StatelessWidget {
  const ApprovalsPage({
    super.key,
    required this.approvals,
    required this.onResolveApproval,
  });

  final List<ApprovalRequest> approvals;
  final void Function(ApprovalRequest request, bool approved) onResolveApproval;

  @override
  Widget build(BuildContext context) {
    final pending = approvals.where((item) => item.status == ApprovalStatus.pending).toList();
    final resolved = approvals.where((item) => item.status != ApprovalStatus.pending).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionIntro(
            title: 'Aprobaciones',
            subtitle:
                'Controla salidas sensibles o piezas de alto valor con decision del supervisor.',
          ),
          const SizedBox(height: 18),
          SectionCard(
            title: 'Pendientes del supervisor',
            subtitle: 'Solicitudes activas por revisar.',
            child: pending.isEmpty
                ? const EmptyStateCard(
                    icon: Icons.verified_outlined,
                    title: 'No hay solicitudes pendientes',
                    subtitle: 'El flujo de aprobaciones esta al corriente.',
                  )
                : Column(
                    children: pending.map((request) {
                      return ApprovalTile(
                        request: request,
                        onApprove: () => onResolveApproval(request, true),
                        onReject: () => onResolveApproval(request, false),
                      );
                    }).toList(),
                  ),
          ),
          const SizedBox(height: 18),
          SectionCard(
            title: 'Historial resuelto',
            subtitle: 'Aprobadas o rechazadas recientemente.',
            child: resolved.isEmpty
                ? const EmptyStateCard(
                    icon: Icons.schedule_outlined,
                    title: 'Aun no hay historial resuelto',
                    subtitle: 'Cuando se atiendan solicitudes apareceran aqui.',
                  )
                : Column(
                    children: resolved.map((request) {
                      return ApprovalTile(
                        request: request,
                        compactActions: true,
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}

class SuppliersPage extends StatefulWidget {
  const SuppliersPage({
    super.key,
    required this.suppliers,
  });

  final List<Supplier> suppliers;

  @override
  State<SuppliersPage> createState() => _SuppliersPageState();
}

class _SuppliersPageState extends State<SuppliersPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();
    final suppliers = widget.suppliers.where((supplier) {
      return query.isEmpty ||
          supplier.name.toLowerCase().contains(query) ||
          supplier.specialty.toLowerCase().contains(query);
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionIntro(
            title: 'Proveedores y mapa',
            subtitle:
                'Encuentra refacciones cercanas y prepara la salida a ruta desde el taller.',
          ),
          const SizedBox(height: 18),
          SectionCard(
            title: 'Busqueda geografica',
            subtitle: 'Consulta por especialidad o nombre del proveedor.',
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: 'Buscar proveedor',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          const SizedBox(height: 18),
          ...suppliers.map((supplier) {
            return SupplierCard(
              supplier: supplier,
              onRoute: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Abrir ruta hacia ${supplier.name} en Google Maps.'),
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}

class DashboardHeroCard extends StatelessWidget {
  const DashboardHeroCard({
    super.key,
    required this.currentUser,
    required this.criticalStock,
    required this.onOpenSection,
  });

  final SessionUser currentUser;
  final int criticalStock;
  final ValueChanged<int> onOpenSection;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [
            TrailerStockColors.steelBlue,
            Color(0xFF244A72),
            Color(0xFF2F6A74),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bienvenido, ${currentUser.name.split(' ').first}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Supervisa inventario, trazabilidad de movimientos y proveedores desde un solo panel.',
                      style: TextStyle(
                        color: Color(0xFFE7EDF4),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Container(
                width: 78,
                height: 78,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: Colors.white24),
                ),
                child: const Icon(
                  Icons.local_shipping_outlined,
                  color: Colors.white,
                  size: 38,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              FilledButton.tonalIcon(
                onPressed: () => onOpenSection(1),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: TrailerStockColors.steelBlue,
                ),
                icon: const Icon(Icons.search),
                label: const Text('Consultar inventario'),
              ),
              OutlinedButton.icon(
                onPressed: () => onOpenSection(2),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white54),
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.add_a_photo_outlined),
                label: const Text('Registrar movimiento'),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xFFF7D56C),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    criticalStock == 0
                        ? 'No hay piezas en stock critico. Operacion estable.'
                        : '$criticalStock productos ya llegaron a stock minimo.',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MetricCard extends StatelessWidget {
  const MetricCard({
    super.key,
    required this.width,
    required this.label,
    required this.value,
    required this.detail,
    required this.accent,
    required this.icon,
  });

  final double width;
  final String label;
  final String value;
  final String detail;
  final Color accent;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: accent.withValues(alpha: 0.12),
                child: Icon(icon, color: accent),
              ),
              const SizedBox(height: 14),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: TrailerStockColors.steelBlue,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: TrailerStockColors.steelBlue,
                ),
              ),
              const SizedBox(height: 6),
              Text(detail),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 6),
                      Text(subtitle),
                    ],
                  ),
                ),
                if (actionLabel != null && onAction != null)
                  TextButton(
                    onPressed: onAction,
                    child: Text(actionLabel!),
                  ),
              ],
            ),
            const SizedBox(height: 18),
            child,
          ],
        ),
      ),
    );
  }
}

class SectionIntro extends StatelessWidget {
  const SectionIntro({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text(subtitle),
      ],
    );
  }
}

class MovementTile extends StatelessWidget {
  const MovementTile({
    super.key,
    required this.movement,
  });

  final MovementRecord movement;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: TrailerStockColors.surfaceGray,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: movement.type.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(movement.type.icon, color: movement.type.color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          movement.productName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: TrailerStockColors.steelBlue,
                          ),
                        ),
                      ),
                      StatusChip(
                        label: movement.status.label,
                        color: movement.status.color,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${movement.type.label} • ${movement.quantity} pzs • ${movement.responsible}',
                  ),
                  const SizedBox(height: 4),
                  Text(
                    movement.notes,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InventoryCard extends StatelessWidget {
  const InventoryCard({
    super.key,
    required this.item,
  });

  final InventoryItem item;

  @override
  Widget build(BuildContext context) {
    final lowStock = item.stock <= item.minimumStock;

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InventoryAvatar(label: item.imageLabel),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: TrailerStockColors.steelBlue,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text('${item.sku} • ${item.category} • ${item.location}'),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          StatusChip(
                            label: '${item.stock} ${item.unit}',
                            color: lowStock
                                ? TrailerStockColors.alertRed
                                : TrailerStockColors.validationGreen,
                          ),
                          StatusChip(
                            label: 'Minimo ${item.minimumStock}',
                            color: TrailerStockColors.metalGray,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: (item.stock / (item.minimumStock * 2)).clamp(0.0, 1.0),
              minHeight: 10,
              backgroundColor: TrailerStockColors.borderSoft,
              color: lowStock
                  ? TrailerStockColors.alertRed
                  : TrailerStockColors.validationGreen,
              borderRadius: BorderRadius.circular(999),
            ),
          ],
        ),
      ),
    );
  }
}

class SupplierCard extends StatelessWidget {
  const SupplierCard({
    super.key,
    required this.supplier,
    required this.onRoute,
  });

  final Supplier supplier;
  final VoidCallback onRoute;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: TrailerStockColors.steelBlue.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.storefront_outlined,
                    color: TrailerStockColors.steelBlue,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        supplier.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: TrailerStockColors.steelBlue,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(supplier.specialty),
                    ],
                  ),
                ),
                StatusChip(
                  label: supplier.openNow ? 'Abierto' : 'Cerrado',
                  color: supplier.openNow
                      ? TrailerStockColors.validationGreen
                      : TrailerStockColors.metalGray,
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(supplier.address),
            const SizedBox(height: 6),
            Text('${supplier.phone} • ${supplier.distanceKm.toStringAsFixed(1)} km'),
            const SizedBox(height: 16),
            FilledButton.tonalIcon(
              onPressed: onRoute,
              icon: const Icon(Icons.map_outlined),
              label: const Text('Abrir ruta'),
            ),
          ],
        ),
      ),
    );
  }
}

class ApprovalTile extends StatelessWidget {
  const ApprovalTile({
    super.key,
    required this.request,
    this.onApprove,
    this.onReject,
    this.compactActions = false,
  });

  final ApprovalRequest request;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;
  final bool compactActions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: request.status == ApprovalStatus.pending
              ? TrailerStockColors.industrialOrange.withValues(alpha: 0.08)
              : TrailerStockColors.surfaceGray,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    request.productName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: TrailerStockColors.steelBlue,
                    ),
                  ),
                ),
                StatusChip(
                  label: request.status.label,
                  color: request.status.color,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Supervisor: ${request.supervisor}'),
            const SizedBox(height: 4),
            Text(request.comments),
            if (!compactActions && request.status == ApprovalStatus.pending) ...[
              const SizedBox(height: 14),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  FilledButton.icon(
                    onPressed: onApprove,
                    style: FilledButton.styleFrom(
                      backgroundColor: TrailerStockColors.validationGreen,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Aprobar'),
                  ),
                  OutlinedButton.icon(
                    onPressed: onReject,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: TrailerStockColors.alertRed,
                    ),
                    icon: const Icon(Icons.cancel_outlined),
                    label: const Text('Rechazar'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class EmptyStateCard extends StatelessWidget {
  const EmptyStateCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: TrailerStockColors.steelBlue.withValues(alpha: 0.10),
            child: Icon(icon, color: TrailerStockColors.steelBlue),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: TrailerStockColors.steelBlue,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class InventoryAvatar extends StatelessWidget {
  const InventoryAvatar({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            TrailerStockColors.steelBlue,
            TrailerStockColors.industrialOrange,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

class TrailerStockHeroLogo extends StatelessWidget {
  const TrailerStockHeroLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 116,
        height: 116,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: const LinearGradient(
            colors: [
              TrailerStockColors.steelBlue,
              Color(0xFF2A4C73),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x2216324F),
              blurRadius: 26,
              offset: Offset(0, 14),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: const [
            Icon(
              Icons.settings,
              size: 58,
              color: Color(0x22FFFFFF),
            ),
            Positioned(
              bottom: 26,
              child: Icon(
                Icons.local_shipping_outlined,
                size: 44,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TrailerStockMiniLogo extends StatelessWidget {
  const TrailerStockMiniLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: TrailerStockColors.steelBlue,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Icon(
        Icons.precision_manufacturing_outlined,
        size: 22,
        color: Colors.white,
      ),
    );
  }
}

class TrailerStockColors {
  static const steelBlue = Color(0xFF16324F);
  static const industrialOrange = Color(0xFFD97706);
  static const metalGray = Color(0xFF6B7280);
  static const ivory = Color(0xFFF3F0E8);
  static const validationGreen = Color(0xFF0F766E);
  static const alertRed = Color(0xFFB42318);
  static const borderSoft = Color(0xFFE3E5E8);
  static const surfaceGray = Color(0xFFF7F6F2);
}

class SessionUser {
  const SessionUser({
    required this.name,
    required this.role,
  });

  final String name;
  final UserRole role;
}

enum UserRole {
  admin('Administrador'),
  storekeeper('Almacenista'),
  supervisor('Supervisor');

  const UserRole(this.label);
  final String label;
}

class InventoryItem {
  const InventoryItem({
    required this.sku,
    required this.name,
    required this.category,
    required this.unit,
    required this.location,
    required this.stock,
    required this.minimumStock,
    required this.imageLabel,
  });

  final String sku;
  final String name;
  final String category;
  final String unit;
  final String location;
  final int stock;
  final int minimumStock;
  final String imageLabel;

  InventoryItem copyWith({
    String? sku,
    String? name,
    String? category,
    String? unit,
    String? location,
    int? stock,
    int? minimumStock,
    String? imageLabel,
  }) {
    return InventoryItem(
      sku: sku ?? this.sku,
      name: name ?? this.name,
      category: category ?? this.category,
      unit: unit ?? this.unit,
      location: location ?? this.location,
      stock: stock ?? this.stock,
      minimumStock: minimumStock ?? this.minimumStock,
      imageLabel: imageLabel ?? this.imageLabel,
    );
  }
}

enum MovementType {
  entry('Entrada', TrailerStockColors.validationGreen, Icons.south_west),
  exit('Salida', TrailerStockColors.alertRed, Icons.north_east),
  adjustment('Ajuste', TrailerStockColors.industrialOrange, Icons.tune),
  returning('Devolucion', TrailerStockColors.steelBlue, Icons.assignment_return);

  const MovementType(this.label, this.color, this.icon);
  final String label;
  final Color color;
  final IconData icon;
}

enum AdjustmentSign {
  plus,
  minus,
}

enum MovementStatus {
  completed('Registrado', TrailerStockColors.validationGreen),
  pendingApproval('Pendiente', TrailerStockColors.industrialOrange),
  approved('Aprobado', TrailerStockColors.steelBlue),
  rejected('Rechazado', TrailerStockColors.alertRed);

  const MovementStatus(this.label, this.color);
  final String label;
  final Color color;
}

class MovementRecord {
  const MovementRecord({
    required this.id,
    required this.sku,
    required this.productName,
    required this.type,
    required this.quantity,
    required this.responsible,
    required this.timestamp,
    required this.status,
    required this.evidenceAttached,
    required this.notes,
  });

  final String id;
  final String sku;
  final String productName;
  final MovementType type;
  final int quantity;
  final String responsible;
  final DateTime timestamp;
  final MovementStatus status;
  final bool evidenceAttached;
  final String notes;

  MovementRecord copyWith({
    String? id,
    String? sku,
    String? productName,
    MovementType? type,
    int? quantity,
    String? responsible,
    DateTime? timestamp,
    MovementStatus? status,
    bool? evidenceAttached,
    String? notes,
  }) {
    return MovementRecord(
      id: id ?? this.id,
      sku: sku ?? this.sku,
      productName: productName ?? this.productName,
      type: type ?? this.type,
      quantity: quantity ?? this.quantity,
      responsible: responsible ?? this.responsible,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      evidenceAttached: evidenceAttached ?? this.evidenceAttached,
      notes: notes ?? this.notes,
    );
  }
}

class MovementDraft {
  const MovementDraft({
    required this.sku,
    required this.type,
    required this.quantity,
    required this.responsible,
    required this.notes,
    required this.requiresApproval,
    required this.evidenceAttached,
    required this.adjustmentSign,
  });

  final String sku;
  final MovementType type;
  final int quantity;
  final String responsible;
  final String notes;
  final bool requiresApproval;
  final bool evidenceAttached;
  final AdjustmentSign adjustmentSign;
}

enum ApprovalStatus {
  pending('Pendiente', TrailerStockColors.industrialOrange),
  approved('Aprobado', TrailerStockColors.validationGreen),
  rejected('Rechazado', TrailerStockColors.alertRed);

  const ApprovalStatus(this.label, this.color);
  final String label;
  final Color color;
}

class ApprovalRequest {
  const ApprovalRequest({
    required this.id,
    required this.movementId,
    required this.productName,
    required this.supervisor,
    required this.comments,
    required this.status,
    required this.requestedAt,
  });

  final String id;
  final String movementId;
  final String productName;
  final String supervisor;
  final String comments;
  final ApprovalStatus status;
  final DateTime requestedAt;

  ApprovalRequest copyWith({
    String? id,
    String? movementId,
    String? productName,
    String? supervisor,
    String? comments,
    ApprovalStatus? status,
    DateTime? requestedAt,
  }) {
    return ApprovalRequest(
      id: id ?? this.id,
      movementId: movementId ?? this.movementId,
      productName: productName ?? this.productName,
      supervisor: supervisor ?? this.supervisor,
      comments: comments ?? this.comments,
      status: status ?? this.status,
      requestedAt: requestedAt ?? this.requestedAt,
    );
  }
}

class Supplier {
  const Supplier({
    required this.name,
    required this.specialty,
    required this.phone,
    required this.address,
    required this.distanceKm,
    required this.openNow,
  });

  final String name;
  final String specialty;
  final String phone;
  final String address;
  final double distanceKm;
  final bool openNow;
}
