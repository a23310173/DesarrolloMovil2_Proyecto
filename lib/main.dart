import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'trailer_stock_api_config.dart';
import 'trailer_stock_data.dart';
import 'trailer_stock_models.dart';
import 'trailer_stock_vps_repository.dart';

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
        scaffoldBackgroundColor: TrailerStockColors.canvas,
        colorScheme: ColorScheme.fromSeed(
          seedColor: TrailerStockColors.steelBlue,
          primary: TrailerStockColors.steelBlue,
          secondary: TrailerStockColors.industrialOrange,
          surface: TrailerStockColors.paper,
          brightness: Brightness.light,
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: TrailerStockColors.ink,
            letterSpacing: -0.8,
          ),
          titleLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: TrailerStockColors.ink,
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: TrailerStockColors.ink,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: TrailerStockColors.slate,
            height: 1.5,
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: TrailerStockColors.ink,
          ),
          iconTheme: IconThemeData(color: TrailerStockColors.ink),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.9),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: TrailerStockColors.line),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: TrailerStockColors.industrialOrange,
              width: 1.4,
            ),
          ),
          labelStyle: const TextStyle(
            color: TrailerStockColors.slate,
            fontWeight: FontWeight.w600,
          ),
        ),
        chipTheme: const ChipThemeData(
          shape: StadiumBorder(),
          side: BorderSide.none,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white.withValues(alpha: 0.96),
          height: 78,
          indicatorColor: TrailerStockColors.steelBlue.withValues(alpha: 0.12),
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ),
        navigationRailTheme: const NavigationRailThemeData(
          selectedIconTheme: IconThemeData(
            color: TrailerStockColors.industrialOrange,
          ),
          selectedLabelTextStyle: TextStyle(
            color: TrailerStockColors.industrialOrange,
            fontWeight: FontWeight.w700,
          ),
          unselectedIconTheme: IconThemeData(color: Color(0xFF96A4B5)),
          unselectedLabelTextStyle: TextStyle(
            color: Color(0xFF96A4B5),
            fontWeight: FontWeight.w600,
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: TrailerStockColors.industrialOrange,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w800,
              letterSpacing: 0.1,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: TrailerStockColors.ink,
            side: const BorderSide(color: TrailerStockColors.line),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            textStyle: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: TrailerStockColors.paper,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
            side: const BorderSide(color: TrailerStockColors.line),
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
  late final TrailerStockController _controller;

  @override
  void initState() {
    super.initState();
    final apiConfig = TrailerStockApiConfig.hostinger;
    _controller = TrailerStockController(
      repository: apiConfig.isConfigured
          ? VpsTrailerStockRepository(config: apiConfig)
          : const MockTrailerStockRepository(),
      apiConfiguration: apiConfig,
    )..load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        if (_controller.isBootstrapping) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (_controller.currentUser == null) {
          return TrailerStockLoginScreen(
            onLogin: (name, role, email, password) {
              _controller.signIn(
                name: name,
                email: email,
                password: password,
                role: role,
              );
            },
            syncStatus: _controller.apiConfiguration.isConfigured
                ? 'Backend configurado'
                : 'Modo demo listo para conectar VPS',
          );
        }

        return TrailerStockShell(
          currentUser: _controller.currentUser!,
          currentIndex: _controller.currentIndex,
          onDestinationSelected: _controller.changeSection,
          onSignOut: _controller.signOut,
          syncStatus: _controller.apiConfiguration.isConfigured
              ? 'Sincronizado con API'
              : 'Esperando API VPS',
          sections: [
            DashboardPage(
              currentUser: _controller.currentUser!,
              inventory: _controller.inventory,
              movements: _controller.movements,
              approvals: _controller.approvals,
              onOpenSection: _controller.changeSection,
            ),
            InventoryPage(
              items: _controller.filteredInventory,
              selectedCategory: _controller.inventoryCategory,
              onFiltersChanged: _controller.updateInventoryFilters,
            ),
            MovementsPage(
              inventory: _controller.inventory,
              recentMovements: _controller.movements.take(5).toList(),
              currentUser: _controller.currentUser!,
              onRegisterMovement: _controller.registerMovement,
            ),
            ApprovalsPage(
              approvals: _controller.approvals,
              onResolveApproval: _controller.resolveApproval,
            ),
            SuppliersPage(suppliers: _controller.suppliers),
          ],
        );
      },
    );
  }
}

class TrailerStockLoginScreen extends StatefulWidget {
  const TrailerStockLoginScreen({
    super.key,
    required this.onLogin,
    required this.syncStatus,
  });

  final void Function(String name, UserRole role, String email, String password)
  onLogin;
  final String syncStatus;

  @override
  State<TrailerStockLoginScreen> createState() =>
      _TrailerStockLoginScreenState();
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

    widget.onLogin(name, _selectedRole, email, password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TrailerStockBackdrop(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 980;
              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1180),
                    child: isWide
                        ? Row(
                            children: [
                              Expanded(
                                child: _LoginBrandPanel(
                                  selectedRole: _selectedRole,
                                ),
                              ),
                              const SizedBox(width: 22),
                              SizedBox(
                                width: 430,
                                child: _LoginFormCard(
                                  nameController: _nameController,
                                  emailController: _emailController,
                                  passwordController: _passwordController,
                                  selectedRole: _selectedRole,
                                  syncStatus: widget.syncStatus,
                                  onRoleChanged: (role) {
                                    setState(() {
                                      _selectedRole = role;
                                    });
                                  },
                                  onSubmit: _submit,
                                ),
                              ),
                            ],
                          )
                        : _LoginFormCard(
                            nameController: _nameController,
                            emailController: _emailController,
                            passwordController: _passwordController,
                            selectedRole: _selectedRole,
                            syncStatus: widget.syncStatus,
                            onRoleChanged: (role) {
                              setState(() {
                                _selectedRole = role;
                              });
                            },
                            onSubmit: _submit,
                            includeMobileHero: true,
                          ),
                  ),
                ),
              );
            },
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
    required this.syncStatus,
    required this.sections,
  });

  final SessionUser currentUser;
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;
  final VoidCallback onSignOut;
  final String syncStatus;
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
        titleSpacing: 20,
        title: Row(
          children: [
            const TrailerStockMiniLogo(),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('TrailerStock'),
                Text(
                  '${currentUser.role.label} activo',
                  style: const TextStyle(
                    fontSize: 12,
                    color: TrailerStockColors.slate,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: TrailerStockColors.line),
            ),
            child: Row(
              children: [
                const Icon(Icons.shield_moon_outlined, size: 16),
                const SizedBox(width: 8),
                Text(
                  currentUser.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: TrailerStockColors.ink,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: TrailerStockColors.line),
            ),
            child: Row(
              children: [
                Icon(
                  syncStatus.contains('Sincronizado')
                      ? Icons.cloud_done_outlined
                      : Icons.cloud_off_outlined,
                  size: 16,
                  color: syncStatus.contains('Sincronizado')
                      ? TrailerStockColors.validationGreen
                      : TrailerStockColors.industrialOrange,
                ),
                const SizedBox(width: 8),
                Text(
                  syncStatus,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: TrailerStockColors.ink,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: onSignOut,
            tooltip: 'Cerrar sesion',
            icon: const Icon(Icons.logout),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: TrailerStockBackdrop(
        child: Row(
          children: [
            if (isWide)
              Container(
                width: 108,
                margin: const EdgeInsets.fromLTRB(16, 12, 0, 18),
                decoration: BoxDecoration(
                  color: TrailerStockColors.ink,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: const Color(0xFF26394F)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x16000000),
                      blurRadius: 28,
                      offset: Offset(0, 14),
                    ),
                  ],
                ),
                child: NavigationRail(
                  backgroundColor: Colors.transparent,
                  indicatorColor: Colors.white.withValues(alpha: 0.12),
                  minWidth: 96,
                  labelType: NavigationRailLabelType.all,
                  selectedIndex: currentIndex,
                  onDestinationSelected: onDestinationSelected,
                  leading: const Padding(
                    padding: EdgeInsets.only(top: 18),
                    child: Icon(
                      Icons.precision_manufacturing_outlined,
                      color: TrailerStockColors.industrialOrange,
                      size: 36,
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
              ),
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(
                  isWide ? 18 : 0,
                  12,
                  16,
                  isWide ? 18 : 0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.58),
                  borderRadius: BorderRadius.circular(34),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.64),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(34),
                  child: sections[currentIndex],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: isWide
          ? null
          : SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(26),
                  child: NavigationBar(
                    selectedIndex: currentIndex,
                    onDestinationSelected: onDestinationSelected,
                    destinations: destinations,
                  ),
                ),
              ),
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
    final criticalStock = inventory
        .where((item) => item.stock <= item.minimumStock)
        .length;
    final totalStock = inventory.fold<int>(0, (sum, item) => sum + item.stock);
    final pendingApprovals = approvals
        .where((item) => item.status == ApprovalStatus.pending)
        .length;
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
                    width: compact
                        ? constraints.maxWidth
                        : (constraints.maxWidth - 14) / 2,
                    label: 'Existencias totales',
                    value: '$totalStock piezas',
                    detail: 'Stock disponible en almacen',
                    accent: TrailerStockColors.steelBlue,
                    icon: Icons.inventory_2_outlined,
                  ),
                  MetricCard(
                    width: compact
                        ? constraints.maxWidth
                        : (constraints.maxWidth - 14) / 2,
                    label: 'Movimientos de hoy',
                    value: '$todaysMovements',
                    detail: 'Entradas, salidas y ajustes registrados',
                    accent: TrailerStockColors.industrialOrange,
                    icon: Icons.compare_arrows_outlined,
                  ),
                  MetricCard(
                    width: compact
                        ? constraints.maxWidth
                        : (constraints.maxWidth - 14) / 2,
                    label: 'Alertas de stock minimo',
                    value: '$criticalStock productos',
                    detail: 'Requieren reposicion inmediata',
                    accent: TrailerStockColors.alertRed,
                    icon: Icons.warning_amber_rounded,
                  ),
                  MetricCard(
                    width: compact
                        ? constraints.maxWidth
                        : (constraints.maxWidth - 14) / 2,
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
                      selectedColor: TrailerStockColors.steelBlue.withValues(
                        alpha: 0.12,
                      ),
                      onSelected: (_) {
                        widget.onFiltersChanged(
                          _searchController.text,
                          category,
                        );
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
    _selectedSku = widget.inventory.isNotEmpty
        ? widget.inventory.first.sku
        : null;
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
    if (_selectedSku == null ||
        quantity <= 0 ||
        _responsibleController.text.trim().isEmpty) {
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
                        _evidenceAttached
                            ? 'Evidencia adjunta'
                            : 'Adjuntar evidencia',
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
    final pending = approvals
        .where((item) => item.status == ApprovalStatus.pending)
        .toList();
    final resolved = approvals
        .where((item) => item.status != ApprovalStatus.pending)
        .toList();

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
  const SuppliersPage({super.key, required this.suppliers});

  final List<Supplier> suppliers;

  @override
  State<SuppliersPage> createState() => _SuppliersPageState();
}

class _SuppliersPageState extends State<SuppliersPage> {
  final _searchController = TextEditingController();
  String? _selectedSupplierName;
  GoogleMapController? _mapController;

  @override
  void dispose() {
    _mapController?.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _focusSupplier(Supplier supplier) async {
    setState(() {
      _selectedSupplierName = supplier.name;
    });

    await _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(supplier.latitude, supplier.longitude),
          zoom: 13.4,
          tilt: 20,
        ),
      ),
    );
  }

  Future<void> _openSupplierNavigation(Supplier supplier) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${supplier.latitude},${supplier.longitude}&travelmode=driving',
    );

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo abrir la ruta para ${supplier.name}.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();
    final suppliers = widget.suppliers.where((supplier) {
      return query.isEmpty ||
          supplier.name.toLowerCase().contains(query) ||
          supplier.specialty.toLowerCase().contains(query);
    }).toList();
    final activeSupplier = suppliers.isNotEmpty
        ? suppliers.firstWhere(
            (supplier) => supplier.name == _selectedSupplierName,
            orElse: () => suppliers.first,
          )
        : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionIntro(
            title: 'Proveedores y mapa',
            subtitle:
                'Encuentra refacciones cercanas y visualiza su ubicacion real dentro del tablero.',
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
          if (activeSupplier != null) ...[
            SectionCard(
              title: 'Mapa operativo',
              subtitle:
                  'Selecciona un proveedor para enfocar su ubicacion y validar distancia al taller.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFEFF4FA), Color(0xFFF8F4EA)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(color: TrailerStockColors.line),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: SizedBox(
                        height: 320,
                        child: Stack(
                          children: [
                            GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: LatLng(
                                  activeSupplier.latitude,
                                  activeSupplier.longitude,
                                ),
                                zoom: 11.8,
                              ),
                              myLocationButtonEnabled: false,
                              zoomControlsEnabled: false,
                              mapToolbarEnabled: false,
                              compassEnabled: false,
                              onMapCreated: (controller) {
                                _mapController = controller;
                              },
                              markers: suppliers
                                  .map(
                                    (supplier) => Marker(
                                      markerId: MarkerId(supplier.name),
                                      position: LatLng(
                                        supplier.latitude,
                                        supplier.longitude,
                                      ),
                                      onTap: () => _focusSupplier(supplier),
                                      infoWindow: InfoWindow(
                                        title: supplier.name,
                                        snippet: supplier.address,
                                      ),
                                      icon:
                                          BitmapDescriptor.defaultMarkerWithHue(
                                            supplier.name == activeSupplier.name
                                                ? BitmapDescriptor.hueOrange
                                                : BitmapDescriptor.hueAzure,
                                          ),
                                    ),
                                  )
                                  .toSet(),
                            ),
                            Positioned(
                              left: 14,
                              top: 14,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: TrailerStockColors.ink.withValues(
                                    alpha: 0.86,
                                  ),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(color: Colors.white24),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Proveedor activo',
                                      style: TextStyle(
                                        color: Color(0xFFB9C7D6),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        maxWidth: 180,
                                      ),
                                      child: Text(
                                        activeSupplier.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800,
                                          height: 1.15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              right: 14,
                              top: 14,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.route_outlined,
                                      size: 16,
                                      color: TrailerStockColors.steelBlue,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${activeSupplier.distanceKm.toStringAsFixed(1)} km',
                                      style: const TextStyle(
                                        color: TrailerStockColors.ink,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 52,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: suppliers.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final supplier = suppliers[index];
                        final isSelected = supplier.name == activeSupplier.name;

                        return InkWell(
                          onTap: () => _focusSupplier(supplier),
                          borderRadius: BorderRadius.circular(18),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? TrailerStockColors.steelBlue
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: isSelected
                                    ? TrailerStockColors.steelBlue
                                    : TrailerStockColors.line,
                              ),
                              boxShadow: isSelected
                                  ? const [
                                      BoxShadow(
                                        color: Color(0x1F16324F),
                                        blurRadius: 18,
                                        offset: Offset(0, 10),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isSelected
                                      ? Icons.radio_button_checked
                                      : Icons.location_on_outlined,
                                  size: 16,
                                  color: isSelected
                                      ? Colors.white
                                      : TrailerStockColors.steelBlue,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  supplier.name,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : TrailerStockColors.ink,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      StatusChip(
                        label: activeSupplier.name,
                        color: TrailerStockColors.steelBlue,
                      ),
                      StatusChip(
                        label:
                            '${activeSupplier.distanceKm.toStringAsFixed(1)} km',
                        color: TrailerStockColors.industrialOrange,
                      ),
                      StatusChip(
                        label: activeSupplier.openNow
                            ? 'Abierto ahora'
                            : 'Cerrado',
                        color: activeSupplier.openNow
                            ? TrailerStockColors.validationGreen
                            : TrailerStockColors.metalGray,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    activeSupplier.address,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      FilledButton.icon(
                        onPressed: () =>
                            _openSupplierNavigation(activeSupplier),
                        style: FilledButton.styleFrom(
                          backgroundColor: TrailerStockColors.steelBlue,
                        ),
                        icon: const Icon(Icons.navigation_outlined),
                        label: const Text('Navegar ahora'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => _focusSupplier(activeSupplier),
                        icon: const Icon(Icons.center_focus_strong),
                        label: const Text('Reenfocar mapa'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
          ],
          ...suppliers.map((supplier) {
            return SupplierCard(
              supplier: supplier,
              isSelected: supplier.name == activeSupplier?.name,
              onRoute: () => _focusSupplier(supplier),
              onNavigate: () => _openSupplierNavigation(supplier),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 640;

        return Container(
          padding: EdgeInsets.all(isCompact ? 20 : 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            gradient: const LinearGradient(
              colors: [Color(0xFF0E2237), Color(0xFF19344F), Color(0xFF1C4B55)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1E102033),
                blurRadius: 30,
                offset: Offset(0, 20),
              ),
            ],
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
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isCompact ? 26 : 30,
                            fontWeight: FontWeight.w800,
                            height: 1.04,
                            letterSpacing: -0.8,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Un centro operativo para piezas, movimientos, alertas criticas y decisiones de supervisor.',
                          style: TextStyle(
                            color: Color(0xFFE7EDF4),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: const [
                            StatusChip(
                              label: 'Taller TEAM GMD',
                              color: Color(0xFFE4ECF5),
                              filledTextDark: true,
                            ),
                            StatusChip(
                              label: 'Modo taller',
                              color: TrailerStockColors.industrialOrange,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Container(
                    width: isCompact ? 70 : 78,
                    height: isCompact ? 70 : 78,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.local_shipping_outlined,
                          color: Colors.white,
                          size: 34,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'GMD',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                      ],
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
              if (isCompact) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Alertas criticas',
                          style: TextStyle(
                            color: Color(0xFFAEC0D3),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Text(
                        '$criticalStock',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ] else
                Row(
                  children: [
                    Expanded(
                      child: Container(
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
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 124,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Alertas',
                            style: TextStyle(
                              color: Color(0xFFAEC0D3),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$criticalStock',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
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
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: accent.withValues(alpha: 0.12),
                    child: Icon(icon, color: accent),
                  ),
                  const Spacer(),
                  Container(
                    width: 42,
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      gradient: LinearGradient(
                        colors: [accent, accent.withValues(alpha: 0.18)],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: TrailerStockColors.slate,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: TrailerStockColors.ink,
                  letterSpacing: -0.5,
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final stackHeader = constraints.maxWidth < 520;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (stackHeader) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'OPERACION',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                          color: TrailerStockColors.industrialOrange,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 6),
                      Text(subtitle),
                      if (actionLabel != null && onAction != null) ...[
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: onAction,
                            child: Text(actionLabel!),
                          ),
                        ),
                      ],
                    ],
                  ),
                ] else
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'OPERACION',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.2,
                                color: TrailerStockColors.industrialOrange,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              title,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
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
      },
    );
  }
}

class SectionIntro extends StatelessWidget {
  const SectionIntro({super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'CONTROL INDUSTRIAL',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.3,
            color: TrailerStockColors.industrialOrange,
          ),
        ),
        const SizedBox(height: 10),
        Text(title, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text(subtitle),
      ],
    );
  }
}

class MovementTile extends StatelessWidget {
  const MovementTile({super.key, required this.movement});

  final MovementRecord movement;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: TrailerStockColors.surfaceGray,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: TrailerStockColors.line),
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
                  Text(movement.notes, style: const TextStyle(fontSize: 12)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _MetaPill(icon: Icons.qr_code_2, label: movement.sku),
                      _MetaPill(
                        icon: movement.evidenceAttached
                            ? Icons.photo_camera
                            : Icons.photo_camera_back_outlined,
                        label: movement.evidenceAttached
                            ? 'Con evidencia'
                            : 'Sin evidencia',
                      ),
                    ],
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
  const InventoryCard({super.key, required this.item});

  final InventoryItem item;

  @override
  Widget build(BuildContext context) {
    final lowStock = item.stock <= item.minimumStock;

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(20),
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
                          color: TrailerStockColors.ink,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          _MetaPill(icon: Icons.qr_code_2, label: item.sku),
                          _MetaPill(
                            icon: Icons.layers_outlined,
                            label: item.category,
                          ),
                          _MetaPill(
                            icon: Icons.place_outlined,
                            label: item.location,
                          ),
                        ],
                      ),
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
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    lowStock
                        ? 'Accion sugerida: reabastecer o revisar proveedor.'
                        : 'Disponibilidad saludable para operacion actual.',
                    style: const TextStyle(
                      fontSize: 12,
                      color: TrailerStockColors.slate,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Icon(
                    lowStock ? Icons.priority_high : Icons.check_circle_outline,
                    color: lowStock
                        ? TrailerStockColors.alertRed
                        : TrailerStockColors.validationGreen,
                  ),
                ),
              ],
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
    required this.isSelected,
    required this.onRoute,
    required this.onNavigate,
  });

  final Supplier supplier;
  final bool isSelected;
  final VoidCallback onRoute;
  final VoidCallback onNavigate;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: 14,
              runSpacing: 14,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? TrailerStockColors.industrialOrange.withValues(
                            alpha: 0.14,
                          )
                        : TrailerStockColors.steelBlue.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    isSelected
                        ? Icons.radar_outlined
                        : Icons.storefront_outlined,
                    color: isSelected
                        ? TrailerStockColors.industrialOrange
                        : TrailerStockColors.steelBlue,
                  ),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 160,
                    maxWidth: 320,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        supplier.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: TrailerStockColors.ink,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(supplier.specialty),
                    ],
                  ),
                ),
                StatusChip(
                  label: isSelected
                      ? 'En mapa'
                      : (supplier.openNow ? 'Abierto' : 'Cerrado'),
                  color: isSelected
                      ? TrailerStockColors.industrialOrange
                      : supplier.openNow
                      ? TrailerStockColors.validationGreen
                      : TrailerStockColors.metalGray,
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              height: 118,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: const LinearGradient(
                  colors: [Color(0xFF10253C), Color(0xFF1E395A)],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -12,
                    top: -8,
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.06),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Vista de ruta',
                            style: TextStyle(
                              color: Color(0xFFBAC8D9),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              const Icon(Icons.route, color: Colors.white),
                              Text(
                                '${supplier.distanceKm.toStringAsFixed(1)} km desde taller',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Text(supplier.address),
            const SizedBox(height: 6),
            Text(
              '${supplier.phone} • ${supplier.distanceKm.toStringAsFixed(1)} km',
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                FilledButton.tonalIcon(
                  onPressed: onRoute,
                  style: FilledButton.styleFrom(
                    backgroundColor: isSelected
                        ? TrailerStockColors.industrialOrange
                        : null,
                  ),
                  icon: const Icon(Icons.map_outlined),
                  label: Text(isSelected ? 'Proveedor activo' : 'Ver en mapa'),
                ),
                OutlinedButton.icon(
                  onPressed: onNavigate,
                  icon: const Icon(Icons.navigation_outlined),
                  label: const Text('Navegar'),
                ),
              ],
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
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: request.status == ApprovalStatus.pending
                ? TrailerStockColors.industrialOrange.withValues(alpha: 0.22)
                : TrailerStockColors.line,
          ),
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
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _MetaPill(
                  icon: Icons.receipt_long_outlined,
                  label: request.movementId,
                ),
                _MetaPill(
                  icon: Icons.schedule_outlined,
                  label: request.status == ApprovalStatus.pending
                      ? 'Requiere decision'
                      : 'Bitacora cerrada',
                ),
              ],
            ),
            if (!compactActions &&
                request.status == ApprovalStatus.pending) ...[
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
            backgroundColor: TrailerStockColors.steelBlue.withValues(
              alpha: 0.10,
            ),
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
          Text(subtitle, textAlign: TextAlign.center),
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
    this.filledTextDark = false,
  });

  final String label;
  final Color color;
  final bool filledTextDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 34, maxWidth: 220),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: filledTextDark ? TrailerStockColors.ink : color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class InventoryAvatar extends StatelessWidget {
  const InventoryAvatar({super.key, required this.label});

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

class _MetaPill extends StatelessWidget {
  const _MetaPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 240),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: TrailerStockColors.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: TrailerStockColors.slate),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: TrailerStockColors.ink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginBrandPanel extends StatelessWidget {
  const _LoginBrandPanel({required this.selectedRole});

  final UserRole selectedRole;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 680),
      padding: const EdgeInsets.all(34),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        gradient: const LinearGradient(
          colors: [Color(0xFF0D2136), Color(0xFF132F46), Color(0xFF1E4D57)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x220A1624),
            blurRadius: 40,
            offset: Offset(0, 24),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TrailerStockHeroLogo(),
          const SizedBox(height: 30),
          const Text(
            'ALMACEN DE TRAILERS',
            style: TextStyle(
              color: Color(0xFFB2C6D8),
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.6,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Un tablero tactico para inventario, salidas sensibles y trazabilidad del taller.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              height: 1.08,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.1,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'La propuesta ahora se siente como software operativo real: clara, densa cuando debe serlo y con una presencia visual mucho mas premium.',
            style: TextStyle(
              color: Color(0xFFD8E2EE),
              fontSize: 15,
              height: 1.65,
            ),
          ),
          const SizedBox(height: 28),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              const StatusChip(
                label: 'Trazabilidad',
                color: TrailerStockColors.industrialOrange,
              ),
              const StatusChip(
                label: 'Stock critico',
                color: TrailerStockColors.alertRed,
              ),
              StatusChip(
                label: selectedRole.label,
                color: const Color(0xFFDDE7F1),
                filledTextDark: true,
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.09),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white12),
            ),
            child: const Wrap(
              spacing: 14,
              runSpacing: 14,
              children: [
                SizedBox(
                  width: 120,
                  child: _BrandMetric(label: 'Refacciones', value: '148'),
                ),
                SizedBox(
                  width: 120,
                  child: _BrandMetric(label: 'Aprobaciones', value: '07'),
                ),
                SizedBox(
                  width: 120,
                  child: _BrandMetric(label: 'Proveedores', value: '19'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandMetric extends StatelessWidget {
  const _BrandMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFB2C6D8),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _LoginFormCard extends StatelessWidget {
  const _LoginFormCard({
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.selectedRole,
    required this.syncStatus,
    required this.onRoleChanged,
    required this.onSubmit,
    this.includeMobileHero = false,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final UserRole selectedRole;
  final String syncStatus;
  final ValueChanged<UserRole> onRoleChanged;
  final VoidCallback onSubmit;
  final bool includeMobileHero;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (includeMobileHero) ...[
              const TrailerStockHeroLogo(),
              const SizedBox(height: 20),
            ],
            const Text(
              'Acceso operativo',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.3,
                color: TrailerStockColors.industrialOrange,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Entra al sistema',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Gestiona inventario, movimientos y aprobaciones desde una sola interfaz.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: TrailerStockColors.surfaceGray,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: TrailerStockColors.line),
              ),
              child: Row(
                children: [
                  Icon(
                    syncStatus.contains('Backend')
                        ? Icons.cloud_done_outlined
                        : Icons.cloud_sync_outlined,
                    size: 18,
                    color: syncStatus.contains('Backend')
                        ? TrailerStockColors.validationGreen
                        : TrailerStockColors.industrialOrange,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      syncStatus,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: TrailerStockColors.ink,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre del usuario',
                prefixIcon: Icon(Icons.badge_outlined),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Correo',
                prefixIcon: Icon(Icons.alternate_email),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contrasena',
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<UserRole>(
              initialValue: selectedRole,
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
                if (value != null) {
                  onRoleChanged(value);
                }
              },
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onSubmit,
              icon: const Icon(Icons.login),
              label: const Text('Entrar al panel operativo'),
            ),
            const SizedBox(height: 18),
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
    );
  }
}

class TrailerStockBackdrop extends StatelessWidget {
  const TrailerStockBackdrop({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF7F3EA), Color(0xFFEAEFF4), Color(0xFFE6EBEE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -120,
            left: -80,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: TrailerStockColors.industrialOrange.withValues(
                  alpha: 0.05,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            right: -60,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: TrailerStockColors.steelBlue.withValues(alpha: 0.05),
              ),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(child: CustomPaint(painter: _GridPainter())),
          ),
          child,
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = TrailerStockColors.line.withValues(alpha: 0.35)
      ..strokeWidth = 1;

    const gap = 36.0;
    for (double x = 0; x < size.width; x += gap) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += gap) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
            colors: [TrailerStockColors.steelBlue, Color(0xFF2A4C73)],
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
            Icon(Icons.settings, size: 58, color: Color(0x22FFFFFF)),
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
  static const canvas = Color(0xFFF4F1E8);
  static const paper = Color(0xFFFFFCF7);
  static const ink = Color(0xFF132236);
  static const slate = Color(0xFF5D6978);
  static const line = Color(0xFFD7DDE4);
}
