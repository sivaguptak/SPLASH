import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../data/models/service_product.dart';
import '../../../widgets/lo_buttons.dart';
import '../../../widgets/bottom_navigation_widget.dart';
import '../../../app.dart';

class ServicesProductsScreen extends StatefulWidget {
  const ServicesProductsScreen({super.key});

  @override
  State<ServicesProductsScreen> createState() => _ServicesProductsScreenState();
}

class _ServicesProductsScreenState extends State<ServicesProductsScreen> {
  final List<ServiceProductModel> _items = [
    ServiceProductModel(
      id: '1',
      shopId: '1',
      name: 'Gulab Jamun',
      description: 'Soft and delicious gulab jamun',
      type: 'product',
      category: 'sweets',
      price: 50.0,
      unit: 'piece',
      isAvailable: true,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now(),
    ),
    ServiceProductModel(
      id: '2',
      shopId: '1',
      name: 'Rasgulla',
      description: 'Fresh and soft rasgulla',
      type: 'product',
      category: 'sweets',
      price: 40.0,
      unit: 'piece',
      isAvailable: true,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      updatedAt: DateTime.now(),
    ),
    ServiceProductModel(
      id: '3',
      shopId: '1',
      name: 'Home Delivery',
      description: 'Free home delivery within 5km',
      type: 'service',
      category: 'delivery',
      price: 0.0,
      unit: 'order',
      isAvailable: true,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      updatedAt: DateTime.now(),
    ),
  ];

  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Products', 'Services', 'Available', 'Unavailable'];

  @override
  Widget build(BuildContext context) {
    final filteredItems = _getFilteredItems();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Services & Products'),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
            tooltip: 'Add Item',
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
          
          // Items List
          Expanded(
            child: filteredItems.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return _buildItemCard(item);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationWidget(
        selectedIndex: 1, // Services tab
        onTap: _onBottomNavTap,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 80,
            color: LocsyColors.slate.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No items found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: LocsyColors.slate,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first service or product',
            style: TextStyle(
              fontSize: 14,
              color: LocsyColors.slate,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
            label: const Text('Add Item'),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(ServiceProductModel item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _editItem(item),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Item Icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: item.type == 'service' 
                      ? LocsyColors.info.withOpacity(0.2)
                      : LocsyColors.success.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(
                  item.type == 'service' ? Icons.build : Icons.shopping_bag,
                  color: item.type == 'service' ? LocsyColors.info : LocsyColors.success,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              
              // Item Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: item.isAvailable 
                                ? LocsyColors.success.withOpacity(0.2)
                                : LocsyColors.error.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            item.isAvailable ? 'Available' : 'Unavailable',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: item.isAvailable ? LocsyColors.success : LocsyColors.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: LocsyColors.slate,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: LocsyColors.orange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            item.type.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: LocsyColors.orange,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: LocsyColors.accentOrange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            item.category.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: LocsyColors.orange,
                            ),
                          ),
                        ),
                        const Spacer(),
                        if (item.price != null && item.price! > 0)
                          Text(
                            '₹${item.price!.toStringAsFixed(0)}/${item.unit ?? 'item'}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: LocsyColors.orange,
                            ),
                          )
                        else
                          const Text(
                            'FREE',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: LocsyColors.success,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Actions
              PopupMenuButton<String>(
                onSelected: (value) => _handleMenuAction(value, item),
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
                    value: 'toggle',
                    child: Row(
                      children: [
                        Icon(
                          item.isAvailable ? Icons.visibility_off : Icons.visibility,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(item.isAvailable ? 'Hide' : 'Show'),
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
        ),
      ),
    );
  }

  List<ServiceProductModel> _getFilteredItems() {
    switch (_selectedFilter) {
      case 'Products':
        return _items.where((item) => item.type == 'product').toList();
      case 'Services':
        return _items.where((item) => item.type == 'service').toList();
      case 'Available':
        return _items.where((item) => item.isAvailable).toList();
      case 'Unavailable':
        return _items.where((item) => !item.isAvailable).toList();
      default:
        return _items;
    }
  }

  void _addItem() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _AddEditItemScreen(),
      ),
    ).then((result) {
      if (result != null) {
        setState(() {
          _items.add(result);
        });
      }
    });
  }

  void _editItem(ServiceProductModel item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _AddEditItemScreen(item: item),
      ),
    ).then((result) {
      if (result != null) {
        setState(() {
          final index = _items.indexWhere((i) => i.id == item.id);
          if (index != -1) {
            _items[index] = result;
          }
        });
      }
    });
  }

  void _handleMenuAction(String action, ServiceProductModel item) {
    switch (action) {
      case 'edit':
        _editItem(item);
        break;
      case 'toggle':
        setState(() {
          final index = _items.indexWhere((i) => i.id == item.id);
          if (index != -1) {
            _items[index] = item.copyWith(
              isAvailable: !item.isAvailable,
              updatedAt: DateTime.now(),
            );
          }
        });
        break;
      case 'delete':
        _deleteItem(item);
        break;
    }
  }

  void _deleteItem(ServiceProductModel item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Are you sure you want to delete "${item.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _items.removeWhere((i) => i.id == item.id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${item.name} deleted successfully!'),
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

  void _onBottomNavTap(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        break;
      case 1:
        // Already on Services screen
        break;
      case 2:
        // Navigate to My Activity screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('My Activity - Coming Soon!'),
            backgroundColor: Color(0xFFFF7A00),
            behavior: SnackBarBehavior.floating,
          ),
        );
        break;
      case 3:
        Navigator.pushReplacementNamed(context, AppRoutes.profile);
        break;
    }
  }
}

class _AddEditItemScreen extends StatefulWidget {
  final ServiceProductModel? item;
  
  const _AddEditItemScreen({this.item});

  @override
  State<_AddEditItemScreen> createState() => _AddEditItemScreenState();
}

class _AddEditItemScreenState extends State<_AddEditItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _unitController = TextEditingController();

  String _selectedType = 'product';
  String _selectedCategory = 'sweets';
  bool _isAvailable = true;

  final List<String> _types = ['product', 'service'];
  final List<String> _categories = [
    'sweets', 'food', 'electronics', 'clothing', 'pharmacy',
    'hardware', 'beauty', 'fitness', 'delivery', 'repair', 'other'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _populateFields();
    }
  }

  void _populateFields() {
    final item = widget.item!;
    _nameController.text = item.name;
    _descriptionController.text = item.description;
    _priceController.text = item.price?.toString() ?? '';
    _unitController.text = item.unit ?? '';
    _selectedType = item.type;
    _selectedCategory = item.category;
    _isAvailable = item.isAvailable;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Add Item' : 'Edit Item'),
        actions: [
          TextButton(
            onPressed: _saveItem,
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
              // Basic Information
              _buildSectionTitle('Basic Information'),
              const SizedBox(height: 16),
              
              _buildTextField(
                controller: _nameController,
                label: 'Name',
                hint: 'Enter item name',
                icon: Icons.label,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter item name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              _buildTextField(
                controller: _descriptionController,
                label: 'Description',
                hint: 'Enter item description',
                icon: Icons.description,
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: _buildDropdownField(
                      label: 'Type',
                      value: _selectedType,
                      items: _types,
                      onChanged: (value) {
                        setState(() {
                          _selectedType = value!;
                        });
                      },
                      icon: Icons.category,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDropdownField(
                      label: 'Category',
                      value: _selectedCategory,
                      items: _categories,
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                      icon: Icons.tag,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Pricing Information
              _buildSectionTitle('Pricing Information'),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildTextField(
                      controller: _priceController,
                      label: 'Price',
                      hint: '0.00',
                      icon: Icons.attach_money,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _unitController,
                      label: 'Unit',
                      hint: 'piece, kg, hour',
                      icon: Icons.straighten,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Availability
              _buildSectionTitle('Availability'),
              const SizedBox(height: 16),
              
              SwitchListTile(
                title: const Text('Available'),
                subtitle: const Text('Item is currently available'),
                value: _isAvailable,
                onChanged: (value) {
                  setState(() {
                    _isAvailable = value;
                  });
                },
                activeColor: LocsyColors.orange,
              ),
              const SizedBox(height: 32),
              
              // Save Button
              SizedBox(
                width: double.infinity,
                child: LoPrimaryButton(
                  text: widget.item == null ? 'Add Item' : 'Update Item',
                  onPressed: _saveItem,
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
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
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

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required IconData icon,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: LocsyColors.orange),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: LocsyColors.white,
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item.toUpperCase()),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      final item = ServiceProductModel(
        id: widget.item?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        shopId: '1', // TODO: Get from auth
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        type: _selectedType,
        category: _selectedCategory,
        price: _priceController.text.trim().isEmpty 
            ? null 
            : double.tryParse(_priceController.text.trim()),
        unit: _unitController.text.trim().isEmpty 
            ? null 
            : _unitController.text.trim(),
        isAvailable: _isAvailable,
        createdAt: widget.item?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      Navigator.pop(context, item);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _unitController.dispose();
    super.dispose();
  }
}
