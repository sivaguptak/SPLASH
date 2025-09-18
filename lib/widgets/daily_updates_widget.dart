import 'package:flutter/material.dart';
import '../data/models/daily_update.dart';
import '../data/services/daily_updates_service.dart';
import '../core/theme.dart';
import 'daily_updates_story_viewer.dart';

class DailyUpdatesWidget extends StatefulWidget {
  const DailyUpdatesWidget({Key? key}) : super(key: key);

  @override
  State<DailyUpdatesWidget> createState() => _DailyUpdatesWidgetState();
}

class _DailyUpdatesWidgetState extends State<DailyUpdatesWidget> {
  String _selectedCategory = 'All';
  List<DailyUpdate> _filteredUpdates = [];

  @override
  void initState() {
    super.initState();
    _filteredUpdates = DailyUpdatesService.getAllUpdates();
  }

  void _filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;
      if (category == 'All') {
        _filteredUpdates = DailyUpdatesService.getAllUpdates();
      } else {
        _filteredUpdates = DailyUpdatesService.getUpdatesByCategory(category);
      }
    });
  }

  void _openStoryMode() {
    if (_filteredUpdates.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DailyUpdatesStoryViewer(
            updates: _filteredUpdates,
            initialIndex: 0,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No updates available for story mode'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _openSingleStory(DailyUpdate update) {
    final index = _filteredUpdates.indexOf(update);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DailyUpdatesStoryViewer(
          updates: _filteredUpdates,
          initialIndex: index >= 0 ? index : 0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = DailyUpdatesService.getCategoriesWithUpdates();
    final allCategories = ['All', ...categories.map((c) => c.name)];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.newspaper,
                color: LocsyColors.orange,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Daily Updates',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: LocsyColors.orange,
                ),
              ),
              const Spacer(),
              // Story Mode Button
              GestureDetector(
                onTap: _openStoryMode,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [LocsyColors.orange, LocsyColors.orange.withOpacity(0.8)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: LocsyColors.orange.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.play_circle_fill,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Story Mode',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: LocsyColors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_filteredUpdates.length} Updates',
                  style: TextStyle(
                    fontSize: 12,
                    color: LocsyColors.orange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Category Filter
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: allCategories.length,
            itemBuilder: (context, index) {
              final category = allCategories[index];
              final isSelected = _selectedCategory == category;
              
              return Container(
                margin: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(
                    category,
                    style: TextStyle(
                      color: isSelected ? Colors.white : LocsyColors.orange,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (selected) => _filterByCategory(category),
                  backgroundColor: Colors.white,
                  selectedColor: LocsyColors.orange,
                  checkmarkColor: Colors.white,
                  side: BorderSide(
                    color: LocsyColors.orange,
                    width: 1,
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 16),

        // Updates List
        Expanded(
          child: _filteredUpdates.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No updates found',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filteredUpdates.length,
                  itemBuilder: (context, index) {
                    final update = _filteredUpdates[index];
                    return _buildUpdateCard(update);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildUpdateCard(DailyUpdate update) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _getCategoryColor(update.category).withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(update.category),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getCategoryIcon(update.category),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        update.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        update.category,
                        style: TextStyle(
                          fontSize: 12,
                          color: _getCategoryColor(update.category),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (update.isUrgent)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'URGENT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  update.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF2C3E50),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                
                // Location and Time
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        update.location,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatTime(update.timestamp),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),

                // Source
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.source,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Source: ${update.source}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),

                // Contact Info
                if (update.contactInfo != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.phone,
                        size: 16,
                        color: LocsyColors.orange,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        update.contactInfo!,
                        style: TextStyle(
                          fontSize: 12,
                          color: LocsyColors.orange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],

                // Story Mode Button
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => _openSingleStory(update),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [_getCategoryColor(update.category), _getCategoryColor(update.category).withOpacity(0.8)],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.play_circle_fill,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'View in Story Mode',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Additional Data
                if (update.additionalData != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: update.additionalData!.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${entry.key}: ',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700],
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  entry.value.toString(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getCategoryIcon(String category) {
    switch (category) {
      case 'Banks':
        return '🏦';
      case 'Bus Depots':
        return '🚌';
      case 'Schools':
        return '🏫';
      case 'Auto Drivers':
        return '🛺';
      case 'Religious Institutions':
        return '🛕';
      case 'Government Departments':
        return '🏛️';
      case 'Local Businesses':
        return '🏪';
      case 'Job Alerts':
        return '💼';
      case 'Town Re-sale':
        return '🛒';
      case 'Travel Information':
        return '🚗';
      case 'Daily Labour Required':
        return '👷';
      case 'Daily Foods':
        return '🍽️';
      case 'Daily Essentials':
        return '🛍️';
      case 'Street Vendors Today':
        return '🛵';
      case 'Health Camp Info':
        return '🏥';
      case 'Melas In Town':
        return '🎪';
      case 'Birthday & Events':
        return '🎂';
      case 'Condolences':
        return '🕊️';
      case 'Movies in Town':
        return '🎬';
      case 'Latest Movies in OTTs':
        return '📺';
      case 'Functions in Function Halls':
        return '🎉';
      case 'Digital Pamphlets':
        return '📱';
      default:
        return '📢';
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Banks':
        return const Color(0xFF4CAF50);
      case 'Bus Depots':
        return const Color(0xFF2196F3);
      case 'Schools':
        return const Color(0xFFFF9800);
      case 'Auto Drivers':
        return const Color(0xFF9C27B0);
      case 'Religious Institutions':
        return const Color(0xFFFF5722);
      case 'Government Departments':
        return const Color(0xFF607D8B);
      case 'Local Businesses':
        return const Color(0xFF795548);
      case 'Job Alerts':
        return const Color(0xFF3F51B5);
      case 'Town Re-sale':
        return const Color(0xFF009688);
      case 'Travel Information':
        return const Color(0xFFE91E63);
      case 'Daily Labour Required':
        return const Color(0xFFFFC107);
      case 'Daily Foods':
        return const Color(0xFFFF5722);
      case 'Daily Essentials':
        return const Color(0xFF4CAF50);
      case 'Street Vendors Today':
        return const Color(0xFF9E9E9E);
      case 'Health Camp Info':
        return const Color(0xFFF44336);
      case 'Melas In Town':
        return const Color(0xFFE91E63);
      case 'Birthday & Events':
        return const Color(0xFFFF9800);
      case 'Condolences':
        return const Color(0xFF9E9E9E);
      case 'Movies in Town':
        return const Color(0xFF673AB7);
      case 'Latest Movies in OTTs':
        return const Color(0xFF3F51B5);
      case 'Functions in Function Halls':
        return const Color(0xFFFF5722);
      case 'Digital Pamphlets':
        return const Color(0xFF00BCD4);
      default:
        return LocsyColors.orange;
    }
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
