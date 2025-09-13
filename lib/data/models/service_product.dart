class ServiceProductModel {
  final String id;
  final String shopId;
  final String name;
  final String description;
  final String type; // 'service' or 'product'
  final String category; // 'food', 'electronics', 'clothing', etc.
  final double? price;
  final String? unit; // 'kg', 'piece', 'hour', etc.
  final bool isAvailable;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  ServiceProductModel({
    required this.id,
    required this.shopId,
    required this.name,
    required this.description,
    required this.type,
    required this.category,
    this.price,
    this.unit,
    this.isAvailable = true,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory ServiceProductModel.fromJson(Map<String, dynamic> j) => ServiceProductModel(
    id: j['id'],
    shopId: j['shopId'],
    name: j['name'],
    description: j['description'],
    type: j['type'],
    category: j['category'],
    price: j['price']?.toDouble(),
    unit: j['unit'],
    isAvailable: j['isAvailable'] ?? true,
    imageUrl: j['imageUrl'],
    createdAt: DateTime.parse(j['createdAt']),
    updatedAt: DateTime.parse(j['updatedAt']),
  );
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'shopId': shopId,
    'name': name,
    'description': description,
    'type': type,
    'category': category,
    'price': price,
    'unit': unit,
    'isAvailable': isAvailable,
    'imageUrl': imageUrl,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
  
  ServiceProductModel copyWith({
    String? id,
    String? shopId,
    String? name,
    String? description,
    String? type,
    String? category,
    double? price,
    String? unit,
    bool? isAvailable,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ServiceProductModel(
      id: id ?? this.id,
      shopId: shopId ?? this.shopId,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      category: category ?? this.category,
      price: price ?? this.price,
      unit: unit ?? this.unit,
      isAvailable: isAvailable ?? this.isAvailable,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
