class Product {
  final int id;
  final String name;
  final String description;
  final String sku;
  final double price;
  final double? discountPrice;
  final String category;
  final List<String> tags;
  final Map<int, ProductInventory> inventory; // shopId -> inventory
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<String> images;
  final ProductSpecs specs;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.sku,
    required this.price,
    this.discountPrice,
    required this.category,
    required this.tags,
    required this.inventory,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
    required this.images,
    required this.specs,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final inventoryMap = Map<int, ProductInventory>.from(
      json['inventory'].map(
        (key, value) => MapEntry(
          int.parse(key.toString()),
          ProductInventory.fromJson(value),
        ),
      ),
    );

    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      sku: json['sku'],
      price: json['price'].toDouble(),
      discountPrice: json['discountPrice']?.toDouble(),
      category: json['category'],
      tags: List<String>.from(json['tags']),
      inventory: inventoryMap,
      isActive: json['isActive'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null 
        ? DateTime.parse(json['updatedAt'])
        : null,
      images: List<String>.from(json['images']),
      specs: ProductSpecs.fromJson(json['specs']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'sku': sku,
      'price': price,
      'discountPrice': discountPrice,
      'category': category,
      'tags': tags,
      'inventory': inventory.map(
        (key, value) => MapEntry(key.toString(), value.toJson()),
      ),
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'images': images,
      'specs': specs.toJson(),
    };
  }

  Product copyWith({
    int? id,
    String? name,
    String? description,
    String? sku,
    double? price,
    double? discountPrice,
    String? category,
    List<String>? tags,
    Map<int, ProductInventory>? inventory,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? images,
    ProductSpecs? specs,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      sku: sku ?? this.sku,
      price: price ?? this.price,
      discountPrice: discountPrice ?? this.discountPrice,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      inventory: inventory ?? this.inventory,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      images: images ?? this.images,
      specs: specs ?? this.specs,
    );
  }
}

class ProductInventory {
  final int quantity;
  final int minQuantity;
  final int maxQuantity;
  final String location;
  final DateTime lastRestocked;

  ProductInventory({
    required this.quantity,
    required this.minQuantity,
    required this.maxQuantity,
    required this.location,
    required this.lastRestocked,
  });

  factory ProductInventory.fromJson(Map<String, dynamic> json) {
    return ProductInventory(
      quantity: json['quantity'],
      minQuantity: json['minQuantity'],
      maxQuantity: json['maxQuantity'],
      location: json['location'],
      lastRestocked: DateTime.parse(json['lastRestocked']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
      'minQuantity': minQuantity,
      'maxQuantity': maxQuantity,
      'location': location,
      'lastRestocked': lastRestocked.toIso8601String(),
    };
  }

  ProductInventory copyWith({
    int? quantity,
    int? minQuantity,
    int? maxQuantity,
    String? location,
    DateTime? lastRestocked,
  }) {
    return ProductInventory(
      quantity: quantity ?? this.quantity,
      minQuantity: minQuantity ?? this.minQuantity,
      maxQuantity: maxQuantity ?? this.maxQuantity,
      location: location ?? this.location,
      lastRestocked: lastRestocked ?? this.lastRestocked,
    );
  }
}

class ProductSpecs {
  final String brand;
  final String manufacturer;
  final String model;
  final String color;
  final Map<String, String> dimensions;
  final double weight;
  final Map<String, String> additionalSpecs;

  ProductSpecs({
    required this.brand,
    required this.manufacturer,
    required this.model,
    required this.color,
    required this.dimensions,
    required this.weight,
    required this.additionalSpecs,
  });

  factory ProductSpecs.fromJson(Map<String, dynamic> json) {
    return ProductSpecs(
      brand: json['brand'],
      manufacturer: json['manufacturer'],
      model: json['model'],
      color: json['color'],
      dimensions: Map<String, String>.from(json['dimensions']),
      weight: json['weight'].toDouble(),
      additionalSpecs: Map<String, String>.from(json['additionalSpecs']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'brand': brand,
      'manufacturer': manufacturer,
      'model': model,
      'color': color,
      'dimensions': dimensions,
      'weight': weight,
      'additionalSpecs': additionalSpecs,
    };
  }

  ProductSpecs copyWith({
    String? brand,
    String? manufacturer,
    String? model,
    String? color,
    Map<String, String>? dimensions,
    double? weight,
    Map<String, String>? additionalSpecs,
  }) {
    return ProductSpecs(
      brand: brand ?? this.brand,
      manufacturer: manufacturer ?? this.manufacturer,
      model: model ?? this.model,
      color: color ?? this.color,
      dimensions: dimensions ?? this.dimensions,
      weight: weight ?? this.weight,
      additionalSpecs: additionalSpecs ?? this.additionalSpecs,
    );
  }
}
