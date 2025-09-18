class ShopDailyUpdate {
  final String id;
  final String shopId;
  final String title;
  final String content;
  final bool isActive;
  final int priority;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ShopDailyUpdate({
    required this.id,
    required this.shopId,
    required this.title,
    required this.content,
    required this.isActive,
    required this.priority,
    required this.createdAt,
    this.updatedAt,
  });

  factory ShopDailyUpdate.fromJson(Map<String, dynamic> json) {
    return ShopDailyUpdate(
      id: json['id'],
      shopId: json['shopId'],
      title: json['title'],
      content: json['content'],
      isActive: json['isActive'] ?? true,
      priority: json['priority'] ?? 1,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shopId': shopId,
      'title': title,
      'content': content,
      'isActive': isActive,
      'priority': priority,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  ShopDailyUpdate copyWith({
    String? id,
    String? shopId,
    String? title,
    String? content,
    bool? isActive,
    int? priority,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ShopDailyUpdate(
      id: id ?? this.id,
      shopId: shopId ?? this.shopId,
      title: title ?? this.title,
      content: content ?? this.content,
      isActive: isActive ?? this.isActive,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
