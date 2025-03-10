class Role {
  final int id;
  final String name;
  final String description;
  final List<Permission> permissions;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Role({
    required this.id,
    required this.name,
    required this.description,
    required this.permissions,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      permissions: (json['permissions'] as List)
          .map((p) => Permission.fromJson(p))
          .toList(),
      isActive: json['isActive'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null 
        ? DateTime.parse(json['updatedAt'])
        : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'permissions': permissions.map((p) => p.toJson()).toList(),
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  Role copyWith({
    int? id,
    String? name,
    String? description,
    List<Permission>? permissions,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Role(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      permissions: permissions ?? this.permissions,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class Permission {
  final int id;
  final String name;
  final String description;
  final String module;
  final List<String> actions;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Permission({
    required this.id,
    required this.name,
    required this.description,
    required this.module,
    required this.actions,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
  });

  factory Permission.fromJson(Map<String, dynamic> json) {
    return Permission(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      module: json['module'],
      actions: List<String>.from(json['actions']),
      isActive: json['isActive'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null 
        ? DateTime.parse(json['updatedAt'])
        : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'module': module,
      'actions': actions,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  Permission copyWith({
    int? id,
    String? name,
    String? description,
    String? module,
    List<String>? actions,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Permission(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      module: module ?? this.module,
      actions: actions ?? this.actions,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class Module {
  final int id;
  final String name;
  final String description;
  final List<String> features;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Module({
    required this.id,
    required this.name,
    required this.description,
    required this.features,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
  });

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      features: List<String>.from(json['features']),
      isActive: json['isActive'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null 
        ? DateTime.parse(json['updatedAt'])
        : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'features': features,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  Module copyWith({
    int? id,
    String? name,
    String? description,
    List<String>? features,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Module(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      features: features ?? this.features,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
