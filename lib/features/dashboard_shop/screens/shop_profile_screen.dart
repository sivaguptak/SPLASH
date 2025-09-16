import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme.dart';
import '../../../data/models/shop.dart';
import '../../../widgets/lo_buttons.dart';

class ShopProfileScreen extends StatefulWidget {
  final ShopModel? shop;
  
  const ShopProfileScreen({super.key, this.shop});

  @override
  State<ShopProfileScreen> createState() => _ShopProfileScreenState();
}

class _ShopProfileScreenState extends State<ShopProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _shopTypeController = TextEditingController();
  final _phoneController = TextEditingController();
  final _alternatePhoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();

  String _selectedShopType = 'Kirana Store';
  final List<String> _shopTypes = [
    'Kirana Store',
    'Fancy Store',
    'Sweet Shop',
    'Restaurant',
    'Electronics',
    'Clothing',
    'Pharmacy',
    'Hardware',
    'Electrician',
    'Carpenter',
    'Plumber',
    'Beauty Salon',
    'Gym',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.shop != null) {
      _populateFields();
    }
  }

  void _populateFields() {
    final shop = widget.shop!;
    _nameController.text = shop.name;
    _shopTypeController.text = shop.shopType ?? '';
    _phoneController.text = shop.phoneNumber ?? '';
    _alternatePhoneController.text = shop.alternatePhone ?? '';
    _addressController.text = shop.address ?? '';
    _descriptionController.text = shop.description ?? '';
    _ownerNameController.text = shop.ownerName ?? '';
    _latitudeController.text = shop.latitude?.toString() ?? '';
    _longitudeController.text = shop.longitude?.toString() ?? '';
    
    if (shop.shopType != null && _shopTypes.contains(shop.shopType)) {
      _selectedShopType = shop.shopType!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.shop == null ? 'Add Shop Profile' : 'Edit Shop Profile'),
        actions: [
          if (widget.shop != null)
            IconButton(
              onPressed: _deleteShop,
              icon: const Icon(Icons.delete),
              tooltip: 'Delete Shop',
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
              // Shop Avatar Section
              _buildAvatarSection(),
              const SizedBox(height: 24),
              
              // Basic Information
              _buildSectionTitle('Basic Information'),
              const SizedBox(height: 16),
              
              _buildTextField(
                controller: _nameController,
                label: 'Shop Name',
                hint: 'Enter shop name',
                icon: Icons.store,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter shop name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              _buildDropdownField(
                label: 'Shop Type',
                value: _selectedShopType,
                items: _shopTypes,
                onChanged: (value) {
                  setState(() {
                    _selectedShopType = value!;
                  });
                },
                icon: Icons.category,
              ),
              const SizedBox(height: 16),
              
              _buildTextField(
                controller: _ownerNameController,
                label: 'Owner Name',
                hint: 'Enter owner name',
                icon: Icons.person,
              ),
              const SizedBox(height: 16),
              
              _buildTextField(
                controller: _descriptionController,
                label: 'Description',
                hint: 'Describe your shop',
                icon: Icons.description,
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              
              // Contact Information
              _buildSectionTitle('Contact Information'),
              const SizedBox(height: 16),
              
              _buildTextField(
                controller: _phoneController,
                label: 'Primary Phone',
                hint: '+91 98765 43210',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter primary phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              _buildTextField(
                controller: _alternatePhoneController,
                label: 'Alternate Phone',
                hint: '+91 98765 43211',
                icon: Icons.phone_android,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 24),
              
              // Location Information
              _buildSectionTitle('Location Information'),
              const SizedBox(height: 16),
              
              _buildTextField(
                controller: _addressController,
                label: 'Address',
                hint: 'Enter complete address',
                icon: Icons.location_on,
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _latitudeController,
                      label: 'Latitude',
                      hint: '19.0760',
                      icon: Icons.my_location,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _longitudeController,
                      label: 'Longitude',
                      hint: '72.8777',
                      icon: Icons.my_location,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _getCurrentLocation,
                  icon: const Icon(Icons.gps_fixed),
                  label: const Text('Get Current Location'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: LocsyColors.info,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              // Save Button
              SizedBox(
                width: double.infinity,
                child: LoPrimaryButton(
                  text: widget.shop == null ? 'Create Shop Profile' : 'Update Shop Profile',
                  onPressed: _saveShopProfile,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: LocsyColors.orange,
                  child: Text(
                    _nameController.text.isNotEmpty 
                        ? _nameController.text.substring(0, 1).toUpperCase()
                        : 'S',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: LocsyColors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: _changeAvatar,
                    icon: const Icon(Icons.camera_alt, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Tap to change avatar',
            style: TextStyle(
              color: LocsyColors.slate,
              fontSize: 12,
            ),
          ),
        ],
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
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  void _changeAvatar() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Change Avatar',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAvatarOption(Icons.camera_alt, 'Camera'),
                _buildAvatarOption(Icons.photo_library, 'Gallery'),
                _buildAvatarOption(Icons.emoji_emotions, 'Emoji'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarOption(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: LocsyColors.orange,
          child: Icon(icon, color: LocsyColors.black),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  void _getCurrentLocation() {
    // TODO: Implement location service
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Getting current location...')),
    );
  }

  void _saveShopProfile() {
    if (_formKey.currentState!.validate()) {
      final shop = ShopModel(
        id: widget.shop?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        shopType: _selectedShopType,
        phoneNumber: _phoneController.text.trim(),
        alternatePhone: _alternatePhoneController.text.trim().isEmpty 
            ? null 
            : _alternatePhoneController.text.trim(),
        address: _addressController.text.trim(),
        description: _descriptionController.text.trim().isEmpty 
            ? null 
            : _descriptionController.text.trim(),
        ownerName: _ownerNameController.text.trim().isEmpty 
            ? null 
            : _ownerNameController.text.trim(),
        latitude: _latitudeController.text.trim().isEmpty 
            ? null 
            : double.tryParse(_latitudeController.text.trim()),
        longitude: _longitudeController.text.trim().isEmpty 
            ? null 
            : double.tryParse(_longitudeController.text.trim()),
        approved: widget.shop?.approved ?? false,
        city: widget.shop?.city,
        createdAt: widget.shop?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // TODO: Save to Firebase/API
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.shop == null 
              ? 'Shop profile created successfully!' 
              : 'Shop profile updated successfully!'),
          backgroundColor: LocsyColors.success,
        ),
      );
      
      Navigator.pop(context, shop);
    }
  }

  void _deleteShop() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Shop'),
        content: const Text('Are you sure you want to delete this shop profile? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Delete from Firebase/API
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Shop profile deleted successfully!'),
                  backgroundColor: LocsyColors.error,
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

  @override
  void dispose() {
    _nameController.dispose();
    _shopTypeController.dispose();
    _phoneController.dispose();
    _alternatePhoneController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    _ownerNameController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }
}
