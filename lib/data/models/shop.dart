class ShopModel {
  final String id;
  final String name;
  final String? city;
  final bool approved;
  final String? shopType; // kirana, fancy, electrician, carpenter, etc.
  final String? phoneNumber;
  final String? alternatePhone;
  final double? latitude;
  final double? longitude;
  final String? address;
  final String? description;
  final String? ownerName;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  
  ShopModel({
    required this.id, 
    required this.name, 
    this.city, 
    this.approved = false,
    this.shopType,
    this.phoneNumber,
    this.alternatePhone,
    this.latitude,
    this.longitude,
    this.address,
    this.description,
    this.ownerName,
    this.createdAt,
    this.updatedAt,
  });
  
  factory ShopModel.fromJson(Map<String, dynamic> j) => ShopModel(
    id: j['id'], 
    name: j['name'], 
    city: j['city'], 
    approved: j['approved'] ?? false,
    shopType: j['shopType'],
    phoneNumber: j['phoneNumber'],
    alternatePhone: j['alternatePhone'],
    latitude: j['latitude']?.toDouble(),
    longitude: j['longitude']?.toDouble(),
    address: j['address'],
    description: j['description'],
    ownerName: j['ownerName'],
    createdAt: j['createdAt'] != null ? DateTime.parse(j['createdAt']) : null,
    updatedAt: j['updatedAt'] != null ? DateTime.parse(j['updatedAt']) : null,
  );
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'city': city,
    'approved': approved,
    'shopType': shopType,
    'phoneNumber': phoneNumber,
    'alternatePhone': alternatePhone,
    'latitude': latitude,
    'longitude': longitude,
    'address': address,
    'description': description,
    'ownerName': ownerName,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };
  
  ShopModel copyWith({
    String? id,
    String? name,
    String? city,
    bool? approved,
    String? shopType,
    String? phoneNumber,
    String? alternatePhone,
    double? latitude,
    double? longitude,
    String? address,
    String? description,
    String? ownerName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ShopModel(
      id: id ?? this.id,
      name: name ?? this.name,
      city: city ?? this.city,
      approved: approved ?? this.approved,
      shopType: shopType ?? this.shopType,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      alternatePhone: alternatePhone ?? this.alternatePhone,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      description: description ?? this.description,
      ownerName: ownerName ?? this.ownerName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
