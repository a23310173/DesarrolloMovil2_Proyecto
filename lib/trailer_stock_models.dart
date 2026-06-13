import 'package:flutter/material.dart';

class SessionUser {
  const SessionUser({
    required this.name,
    required this.role,
  });

  final String name;
  final UserRole role;

  factory SessionUser.fromMap(Map<String, dynamic> map) {
    return SessionUser(
      name: map['name']?.toString() ?? '',
      role: UserRoleX.fromValue(map['role']?.toString() ?? 'storekeeper'),
    );
  }
}

enum UserRole {
  admin('Administrador'),
  storekeeper('Almacenista'),
  supervisor('Supervisor');

  const UserRole(this.label);
  final String label;
}

extension UserRoleX on UserRole {
  String get value => switch (this) {
        UserRole.admin => 'admin',
        UserRole.storekeeper => 'storekeeper',
        UserRole.supervisor => 'supervisor',
      };

  static UserRole fromValue(String value) {
    switch (value) {
      case 'admin':
        return UserRole.admin;
      case 'supervisor':
        return UserRole.supervisor;
      case 'storekeeper':
      default:
        return UserRole.storekeeper;
    }
  }
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

  factory InventoryItem.fromMap(Map<String, dynamic> map) {
    return InventoryItem(
      sku: map['sku']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      category: map['category']?.toString() ?? '',
      unit: map['unit']?.toString() ?? '',
      location: map['location']?.toString() ?? '',
      stock: int.tryParse(map['stock']?.toString() ?? '0') ?? 0,
      minimumStock: int.tryParse(map['minimumStock']?.toString() ?? '0') ?? 0,
      imageLabel: map['imageLabel']?.toString() ?? '',
    );
  }
}

enum MovementType {
  entry('Entrada', Color(0xFF0F766E), Icons.south_west),
  exit('Salida', Color(0xFFB42318), Icons.north_east),
  adjustment('Ajuste', Color(0xFFD97706), Icons.tune),
  returning('Devolucion', Color(0xFF16324F), Icons.assignment_return);

  const MovementType(this.label, this.color, this.icon);
  final String label;
  final Color color;
  final IconData icon;
}

extension MovementTypeX on MovementType {
  String get value => switch (this) {
        MovementType.entry => 'entry',
        MovementType.exit => 'exit',
        MovementType.adjustment => 'adjustment',
        MovementType.returning => 'returning',
      };

  static MovementType fromValue(String value) {
    switch (value) {
      case 'entry':
        return MovementType.entry;
      case 'adjustment':
        return MovementType.adjustment;
      case 'returning':
        return MovementType.returning;
      case 'exit':
      default:
        return MovementType.exit;
    }
  }
}

enum AdjustmentSign {
  plus,
  minus,
}

enum MovementStatus {
  completed('Registrado', Color(0xFF0F766E)),
  pendingApproval('Pendiente', Color(0xFFD97706)),
  approved('Aprobado', Color(0xFF16324F)),
  rejected('Rechazado', Color(0xFFB42318));

  const MovementStatus(this.label, this.color);
  final String label;
  final Color color;
}

extension MovementStatusX on MovementStatus {
  String get value => switch (this) {
        MovementStatus.completed => 'completed',
        MovementStatus.pendingApproval => 'pendingApproval',
        MovementStatus.approved => 'approved',
        MovementStatus.rejected => 'rejected',
      };

  static MovementStatus fromValue(String value) {
    switch (value) {
      case 'completed':
        return MovementStatus.completed;
      case 'approved':
        return MovementStatus.approved;
      case 'rejected':
        return MovementStatus.rejected;
      case 'pendingApproval':
      default:
        return MovementStatus.pendingApproval;
    }
  }
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

  factory MovementRecord.fromMap(Map<String, dynamic> map) {
    return MovementRecord(
      id: map['id']?.toString() ?? '',
      sku: map['sku']?.toString() ?? '',
      productName: map['productName']?.toString() ?? '',
      type: MovementTypeX.fromValue(map['type']?.toString() ?? 'exit'),
      quantity: int.tryParse(map['quantity']?.toString() ?? '0') ?? 0,
      responsible: map['responsible']?.toString() ?? '',
      timestamp: DateTime.tryParse(map['timestamp']?.toString() ?? '') ?? DateTime.now(),
      status: MovementStatusX.fromValue(map['status']?.toString() ?? 'completed'),
      evidenceAttached: map['evidenceAttached'] == true ||
          map['evidenceAttached']?.toString() == '1',
      notes: map['notes']?.toString() ?? '',
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
  pending('Pendiente', Color(0xFFD97706)),
  approved('Aprobado', Color(0xFF0F766E)),
  rejected('Rechazado', Color(0xFFB42318));

  const ApprovalStatus(this.label, this.color);
  final String label;
  final Color color;
}

extension ApprovalStatusX on ApprovalStatus {
  String get value => switch (this) {
        ApprovalStatus.pending => 'pending',
        ApprovalStatus.approved => 'approved',
        ApprovalStatus.rejected => 'rejected',
      };

  static ApprovalStatus fromValue(String value) {
    switch (value) {
      case 'approved':
        return ApprovalStatus.approved;
      case 'rejected':
        return ApprovalStatus.rejected;
      case 'pending':
      default:
        return ApprovalStatus.pending;
    }
  }
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

  factory ApprovalRequest.fromMap(Map<String, dynamic> map) {
    return ApprovalRequest(
      id: map['id']?.toString() ?? '',
      movementId: map['movementId']?.toString() ?? '',
      productName: map['productName']?.toString() ?? '',
      supervisor: map['supervisor']?.toString() ?? '',
      comments: map['comments']?.toString() ?? '',
      status: ApprovalStatusX.fromValue(map['status']?.toString() ?? 'pending'),
      requestedAt: DateTime.tryParse(map['requestedAt']?.toString() ?? '') ?? DateTime.now(),
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

  factory Supplier.fromMap(Map<String, dynamic> map) {
    return Supplier(
      name: map['name']?.toString() ?? '',
      specialty: map['specialty']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      address: map['address']?.toString() ?? '',
      distanceKm: double.tryParse(map['distanceKm']?.toString() ?? '0') ?? 0,
      openNow: map['openNow'] == true || map['openNow']?.toString() == '1',
    );
  }
}
