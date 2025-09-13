class DailyUpdateModel {
  final String id;
  final String shopId;
  final String title;
  final String content;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final int priority; // 1-5, higher number = higher priority
  
  DailyUpdateModel({
    required this.id,
    required this.shopId,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
    this.priority = 1,
  });
  
  factory DailyUpdateModel.fromJson(Map<String, dynamic> j) => DailyUpdateModel(
    id: j['id'],
    shopId: j['shopId'],
    title: j['title'],
    content: j['content'],
    imageUrl: j['imageUrl'],
    createdAt: DateTime.parse(j['createdAt']),
    updatedAt: DateTime.parse(j['updatedAt']),
    isActive: j['isActive'] ?? true,
    priority: j['priority'] ?? 1,
  );
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'shopId': shopId,
    'title': title,
    'content': content,
    'imageUrl': imageUrl,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'isActive': isActive,
    'priority': priority,
  };
  
  DailyUpdateModel copyWith({
    String? id,
    String? shopId,
    String? title,
    String? content,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    int? priority,
  }) {
    return DailyUpdateModel(
      id: id ?? this.id,
      shopId: shopId ?? this.shopId,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      priority: priority ?? this.priority,
    );
  }
}
