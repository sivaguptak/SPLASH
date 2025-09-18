import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../data/models/shop_daily_update.dart';
import '../../../widgets/lo_buttons.dart';

class DailyUpdatesScreen extends StatefulWidget {
  const DailyUpdatesScreen({super.key});

  @override
  State<DailyUpdatesScreen> createState() => _DailyUpdatesScreenState();
}

class _DailyUpdatesScreenState extends State<DailyUpdatesScreen> {
  final List<ShopDailyUpdate> _updates = [
    ShopDailyUpdate(
      id: '1',
      shopId: '1',
      title: 'Fresh Sweets Available',
      content: 'Today we have fresh gulab jamun, rasgulla, and kaju katli available. Order now!',
      isActive: true,
      priority: 3,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    ShopDailyUpdate(
      id: '2',
      shopId: '1',
      title: 'Special Offer',
      content: 'Buy 2 kg of any sweets and get 10% discount. Valid till this weekend!',
      isActive: true,
      priority: 4,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    ShopDailyUpdate(
      id: '3',
      shopId: '1',
      title: 'Shop Closed Tomorrow',
      content: 'We will be closed tomorrow for maintenance. Sorry for the inconvenience.',
      isActive: false,
      priority: 5,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Active', 'Inactive', 'High Priority'];

  @override
  Widget build(BuildContext context) {
    final filteredUpdates = _getFilteredUpdates();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Updates'),
        actions: [
          IconButton(
            onPressed: _addUpdate,
            icon: const Icon(Icons.add),
            tooltip: 'Add Update',
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text(
                  'Filter:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _filters.map((filter) {
                        final isSelected = _selectedFilter == filter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(filter),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _selectedFilter = filter;
                              });
                            },
                            backgroundColor: LocsyColors.white,
                            selectedColor: LocsyColors.orange,
                            checkmarkColor: LocsyColors.black,
                            labelStyle: TextStyle(
                              color: isSelected ? LocsyColors.black : LocsyColors.slate,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Updates List
          Expanded(
            child: filteredUpdates.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredUpdates.length,
                    itemBuilder: (context, index) {
                      final update = filteredUpdates[index];
                      return _buildUpdateCard(update);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addUpdate,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.campaign_outlined,
            size: 80,
            color: LocsyColors.slate.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No updates found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: LocsyColors.slate,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first daily update',
            style: TextStyle(
              fontSize: 14,
              color: LocsyColors.slate,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _addUpdate,
            icon: const Icon(Icons.add),
            label: const Text('Add Update'),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateCard(ShopDailyUpdate update) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _editUpdate(update),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  // Priority Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getPriorityColor(update.priority),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Priority ${update.priority}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: update.isActive 
                          ? LocsyColors.success.withOpacity(0.2)
                          : LocsyColors.error.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      update.isActive ? 'Active' : 'Inactive',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: update.isActive ? LocsyColors.success : LocsyColors.error,
                      ),
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Time
                  Text(
                    _formatTime(update.createdAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: LocsyColors.slate,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Title
              Text(
                update.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              
              // Content
              Text(
                update.content,
                style: TextStyle(
                  fontSize: 14,
                  color: LocsyColors.slate,
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              
              // Actions Row
              Row(
                children: [
                  // Quick Actions
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => _toggleUpdateStatus(update),
                        icon: Icon(
                          update.isActive ? Icons.visibility_off : Icons.visibility,
                          size: 16,
                          color: update.isActive ? LocsyColors.warning : LocsyColors.success,
                        ),
                        tooltip: update.isActive ? 'Hide Update' : 'Show Update',
                      ),
                      IconButton(
                        onPressed: () => _duplicateUpdate(update),
                        icon: const Icon(Icons.copy, size: 16, color: LocsyColors.info),
                        tooltip: 'Duplicate Update',
                      ),
                    ],
                  ),
                  
                  const Spacer(),
                  
                  // More Actions
                  PopupMenuButton<String>(
                    onSelected: (value) => _handleMenuAction(value, update),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 16),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'duplicate',
                        child: Row(
                          children: [
                            Icon(Icons.copy, size: 16),
                            SizedBox(width: 8),
                            Text('Duplicate'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'toggle',
                        child: Row(
                          children: [
                            Icon(
                              update.isActive ? Icons.visibility_off : Icons.visibility,
                              size: 16,
                            ),
                            SizedBox(width: 8),
                            Text(update.isActive ? 'Hide' : 'Show'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 16, color: LocsyColors.error),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: LocsyColors.error)),
                          ],
                        ),
                      ),
                    ],
                    child: const Icon(Icons.more_vert),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<ShopDailyUpdate> _getFilteredUpdates() {
    switch (_selectedFilter) {
      case 'Active':
        return _updates.where((update) => update.isActive).toList();
      case 'Inactive':
        return _updates.where((update) => !update.isActive).toList();
      case 'High Priority':
        return _updates.where((update) => update.priority >= 4).toList();
      default:
        return _updates;
    }
  }

  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 1: return LocsyColors.slate;
      case 2: return LocsyColors.info;
      case 3: return LocsyColors.warning;
      case 4: return LocsyColors.error;
      case 5: return Colors.purple;
      default: return LocsyColors.slate;
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  void _addUpdate() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _AddEditUpdateScreen(),
      ),
    ).then((result) {
      if (result != null) {
        setState(() {
          _updates.insert(0, result); // Add to top
        });
      }
    });
  }

  void _editUpdate(ShopDailyUpdate update) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _AddEditUpdateScreen(update: update),
      ),
    ).then((result) {
      if (result != null) {
        setState(() {
          final index = _updates.indexWhere((u) => u.id == update.id);
          if (index != -1) {
            _updates[index] = result;
          }
        });
      }
    });
  }

  void _toggleUpdateStatus(ShopDailyUpdate update) {
    setState(() {
      final index = _updates.indexWhere((u) => u.id == update.id);
      if (index != -1) {
        _updates[index] = update.copyWith(
          isActive: !update.isActive,
          updatedAt: DateTime.now(),
        );
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${update.isActive ? 'Hidden' : 'Shown'} "${update.title}"'),
        backgroundColor: LocsyColors.success,
      ),
    );
  }

  void _duplicateUpdate(ShopDailyUpdate update) {
    final duplicatedUpdate = update.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: '${update.title} (Copy)',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    setState(() {
      _updates.insert(0, duplicatedUpdate);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Update duplicated successfully!'),
        backgroundColor: LocsyColors.success,
      ),
    );
  }

  void _handleMenuAction(String action, ShopDailyUpdate update) {
    switch (action) {
      case 'edit':
        _editUpdate(update);
        break;
      case 'duplicate':
        _duplicateUpdate(update);
        break;
      case 'toggle':
        _toggleUpdateStatus(update);
        break;
      case 'delete':
        _deleteUpdate(update);
        break;
    }
  }

  void _deleteUpdate(ShopDailyUpdate update) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Update'),
        content: Text('Are you sure you want to delete "${update.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _updates.removeWhere((u) => u.id == update.id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('"${update.title}" deleted successfully!'),
                  backgroundColor: LocsyColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: LocsyColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _AddEditUpdateScreen extends StatefulWidget {
  final ShopDailyUpdate? update;
  
  const _AddEditUpdateScreen({this.update});

  @override
  State<_AddEditUpdateScreen> createState() => _AddEditUpdateScreenState();
}

class _AddEditUpdateScreenState extends State<_AddEditUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  int _selectedPriority = 3;
  bool _isActive = true;

  final List<int> _priorities = [1, 2, 3, 4, 5];
  final List<String> _priorityLabels = [
    'Low', 'Medium', 'High', 'Urgent', 'Critical'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.update != null) {
      _populateFields();
    }
  }

  void _populateFields() {
    final update = widget.update!;
    _titleController.text = update.title;
    _contentController.text = update.content;
    _selectedPriority = update.priority;
    _isActive = update.isActive;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.update == null ? 'Add Update' : 'Edit Update'),
        actions: [
          TextButton(
            onPressed: _saveUpdate,
            child: const Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Priority Selection
              _buildSectionTitle('Priority Level'),
              const SizedBox(height: 16),
              
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _priorities.asMap().entries.map((entry) {
                  final priority = entry.key + 1;
                  final label = _priorityLabels[entry.key];
                  final isSelected = _selectedPriority == priority;
                  
                  return FilterChip(
                    label: Text('$label ($priority)'),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedPriority = priority;
                      });
                    },
                    backgroundColor: LocsyColors.white,
                    selectedColor: _getPriorityColor(priority),
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : LocsyColors.slate,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              
              // Update Content
              _buildSectionTitle('Update Content'),
              const SizedBox(height: 16),
              
              _buildTextField(
                controller: _titleController,
                label: 'Title',
                hint: 'Enter update title',
                icon: Icons.title,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              _buildTextField(
                controller: _contentController,
                label: 'Content',
                hint: 'Enter update content...',
                icon: Icons.description,
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter content';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              
              // Settings
              _buildSectionTitle('Settings'),
              const SizedBox(height: 16),
              
              SwitchListTile(
                title: const Text('Active'),
                subtitle: const Text('Update will be visible to customers'),
                value: _isActive,
                onChanged: (value) {
                  setState(() {
                    _isActive = value;
                  });
                },
                activeColor: LocsyColors.orange,
              ),
              const SizedBox(height: 32),
              
              // Save Button
              SizedBox(
                width: double.infinity,
                child: LoPrimaryButton(
                  text: widget.update == null ? 'Create Update' : 'Update',
                  onPressed: _saveUpdate,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: LocsyColors.black,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: LocsyColors.orange),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: LocsyColors.white,
      ),
    );
  }

  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 1: return LocsyColors.slate;
      case 2: return LocsyColors.info;
      case 3: return LocsyColors.warning;
      case 4: return LocsyColors.error;
      case 5: return Colors.purple;
      default: return LocsyColors.slate;
    }
  }

  void _saveUpdate() {
    if (_formKey.currentState!.validate()) {
      final update = ShopDailyUpdate(
        id: widget.update?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        shopId: '1', // TODO: Get from auth
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        priority: _selectedPriority,
        isActive: _isActive,
        createdAt: widget.update?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      Navigator.pop(context, update);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}
