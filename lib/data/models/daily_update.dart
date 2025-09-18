class DailyUpdate {
  final String id;
  final String title;
  final String description;
  final String category;
  final String subcategory;
  final String location;
  final DateTime timestamp;
  final String source;
  final String? imageUrl;
  final Map<String, dynamic>? additionalData;
  final bool isUrgent;
  final String? contactInfo;

  DailyUpdate({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.subcategory,
    required this.location,
    required this.timestamp,
    required this.source,
    this.imageUrl,
    this.additionalData,
    this.isUrgent = false,
    this.contactInfo,
  });

  factory DailyUpdate.fromJson(Map<String, dynamic> json) {
    return DailyUpdate(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      subcategory: json['subcategory'],
      location: json['location'],
      timestamp: DateTime.parse(json['timestamp']),
      source: json['source'],
      imageUrl: json['imageUrl'],
      additionalData: json['additionalData'],
      isUrgent: json['isUrgent'] ?? false,
      contactInfo: json['contactInfo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'subcategory': subcategory,
      'location': location,
      'timestamp': timestamp.toIso8601String(),
      'source': source,
      'imageUrl': imageUrl,
      'additionalData': additionalData,
      'isUrgent': isUrgent,
      'contactInfo': contactInfo,
    };
  }
}

class DailyUpdateCategory {
  final String name;
  final String icon;
  final String color;
  final List<DailyUpdate> updates;

  DailyUpdateCategory({
    required this.name,
    required this.icon,
    required this.color,
    required this.updates,
  });
}