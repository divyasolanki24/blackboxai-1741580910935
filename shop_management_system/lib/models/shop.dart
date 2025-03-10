class Shop {
  final int id;
  final String name;
  final String address;
  final String? phone;
  final String? email;
  final int managerId;
  final List<int> staffIds;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final ShopStats stats;

  Shop({
    required this.id,
    required this.name,
    required this.address,
    this.phone,
    this.email,
    required this.managerId,
    required this.staffIds,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
    required this.stats,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
      email: json['email'],
      managerId: json['managerId'],
      staffIds: List<int>.from(json['staffIds']),
      isActive: json['isActive'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null 
        ? DateTime.parse(json['updatedAt'])
        : null,
      stats: ShopStats.fromJson(json['stats']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'email': email,
      'managerId': managerId,
      'staffIds': staffIds,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'stats': stats.toJson(),
    };
  }

  Shop copyWith({
    int? id,
    String? name,
    String? address,
    String? phone,
    String? email,
    int? managerId,
    List<int>? staffIds,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    ShopStats? stats,
  }) {
    return Shop(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      managerId: managerId ?? this.managerId,
      staffIds: staffIds ?? this.staffIds,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      stats: stats ?? this.stats,
    );
  }
}

class ShopStats {
  final double totalRevenue;
  final int totalProducts;
  final int totalOrders;
  final int activeProducts;
  final int lowStockProducts;
  final int outOfStockProducts;

  ShopStats({
    required this.totalRevenue,
    required this.totalProducts,
    required this.totalOrders,
    required this.activeProducts,
    required this.lowStockProducts,
    required this.outOfStockProducts,
  });

  factory ShopStats.fromJson(Map<String, dynamic> json) {
    return ShopStats(
      totalRevenue: json['totalRevenue'].toDouble(),
      totalProducts: json['totalProducts'],
      totalOrders: json['totalOrders'],
      activeProducts: json['activeProducts'],
      lowStockProducts: json['lowStockProducts'],
      outOfStockProducts: json['outOfStockProducts'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalRevenue': totalRevenue,
      'totalProducts': totalProducts,
      'totalOrders': totalOrders,
      'activeProducts': activeProducts,
      'lowStockProducts': lowStockProducts,
      'outOfStockProducts': outOfStockProducts,
    };
  }

  ShopStats copyWith({
    double? totalRevenue,
    int? totalProducts,
    int? totalOrders,
    int? activeProducts,
    int? lowStockProducts,
    int? outOfStockProducts,
  }) {
    return ShopStats(
      totalRevenue: totalRevenue ?? this.totalRevenue,
      totalProducts: totalProducts ?? this.totalProducts,
      totalOrders: totalOrders ?? this.totalOrders,
      activeProducts: activeProducts ?? this.activeProducts,
      lowStockProducts: lowStockProducts ?? this.lowStockProducts,
      outOfStockProducts: outOfStockProducts ?? this.outOfStockProducts,
    );
  }
}
