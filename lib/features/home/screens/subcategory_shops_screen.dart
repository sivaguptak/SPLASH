import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../widgets/bottom_navigation_widget.dart';
import '../../../app.dart';

class SubcategoryShopsScreen extends StatefulWidget {
  final String subcategoryName;
  final Color categoryColor;
  final IconData categoryIcon;

  const SubcategoryShopsScreen({
    super.key,
    required this.subcategoryName,
    required this.categoryColor,
    required this.categoryIcon,
  });

  @override
  State<SubcategoryShopsScreen> createState() => _SubcategoryShopsScreenState();
}

class _SubcategoryShopsScreenState extends State<SubcategoryShopsScreen>
    with TickerProviderStateMixin {
  late List<ShopCard> _shops;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _shops = _getShopsForSubcategory();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<ShopCard> _getShopsForSubcategory() {
    // Sample data for different subcategories
    switch (widget.subcategoryName.toLowerCase()) {
      case 'grocery':
        return [
          ShopCard(
            name: 'Lakshmi Ganapathi Kirana',
            address: 'Main Road, Near Temple',
            services: ['Fresh Vegetables', 'Daily Essentials', 'Spices', 'Rice & Dal'],
            products: ['Organic Products', 'Local Produce', 'Imported Items'],
            phone: '+91 98765 43210',
            rating: 4.5,
          ),
          ShopCard(
            name: 'V Marts',
            address: 'Near Bus Stand',
            services: ['Home Delivery', 'Bulk Orders', 'Fresh Meat'],
            products: ['Frozen Foods', 'Beverages', 'Snacks'],
            phone: '+91 98765 43211',
            rating: 4.2,
          ),
          ShopCard(
            name: 'Fresh Corner',
            address: 'Market Street',
            services: ['Vegetable Cutting', 'Fruit Juices', 'Custom Orders'],
            products: ['Fresh Fruits', 'Vegetables', 'Herbs'],
            phone: '+91 98765 43212',
            rating: 4.7,
          ),
          ShopCard(
            name: 'Daily Needs Store',
            address: 'School Road',
            services: ['Morning Delivery', 'Subscription Service'],
            products: ['Milk Products', 'Bread', 'Eggs'],
            phone: '+91 98765 43213',
            rating: 4.3,
          ),
          ShopCard(
            name: 'Super Market Plus',
            address: 'Highway Road',
            services: ['24/7 Service', 'Online Orders', 'Cashback Offers'],
            products: ['Everything Available', 'Branded Items', 'Local Brands'],
            phone: '+91 98765 43214',
            rating: 4.6,
          ),
        ];
      case 'electricians':
        return [
          ShopCard(
            name: 'Power Solutions',
            address: 'Industrial Area',
            services: ['Wiring', 'Repairs', 'Installation', 'Maintenance'],
            products: ['Wires', 'Switches', 'Fans', 'Lights'],
            phone: '+91 98765 43220',
            rating: 4.8,
          ),
          ShopCard(
            name: 'Quick Fix Electric',
            address: 'Near Hospital',
            services: ['Emergency Service', 'Home Wiring', 'Generator Setup'],
            products: ['Electrical Tools', 'Safety Equipment'],
            phone: '+91 98765 43221',
            rating: 4.4,
          ),
          ShopCard(
            name: 'Bright Lights Co.',
            address: 'Market Area',
            services: ['LED Installation', 'Solar Setup', 'Smart Home'],
            products: ['LED Lights', 'Solar Panels', 'Smart Switches'],
            phone: '+91 98765 43222',
            rating: 4.9,
          ),
          ShopCard(
            name: 'Safe Electric Works',
            address: 'Residential Area',
            services: ['Safety Checks', 'Rewiring', 'Panel Upgrades'],
            products: ['Safety Devices', 'Circuit Breakers'],
            phone: '+91 98765 43223',
            rating: 4.5,
          ),
          ShopCard(
            name: '24/7 Electric Service',
            address: 'City Center',
            services: ['Round the Clock', 'Commercial Wiring', 'Industrial'],
            products: ['Heavy Duty Equipment', 'Commercial Lights'],
            phone: '+91 98765 43224',
            rating: 4.7,
          ),
        ];
      default:
        return [
          ShopCard(
            name: '${widget.subcategoryName} Shop 1',
            address: 'Main Road',
            services: ['Service 1', 'Service 2', 'Service 3'],
            products: ['Product 1', 'Product 2', 'Product 3'],
            phone: '+91 98765 43200',
            rating: 4.0,
          ),
          ShopCard(
            name: '${widget.subcategoryName} Shop 2',
            address: 'Near Bus Stand',
            services: ['Service A', 'Service B', 'Service C'],
            products: ['Product A', 'Product B', 'Product C'],
            phone: '+91 98765 43201',
            rating: 4.2,
          ),
          ShopCard(
            name: '${widget.subcategoryName} Shop 3',
            address: 'Market Street',
            services: ['Service X', 'Service Y', 'Service Z'],
            products: ['Product X', 'Product Y', 'Product Z'],
            phone: '+91 98765 43202',
            rating: 4.5,
          ),
          ShopCard(
            name: '${widget.subcategoryName} Shop 4',
            address: 'School Road',
            services: ['Service P', 'Service Q', 'Service R'],
            products: ['Product P', 'Product Q', 'Product R'],
            phone: '+91 98765 43203',
            rating: 4.3,
          ),
          ShopCard(
            name: '${widget.subcategoryName} Shop 5',
            address: 'Highway Road',
            services: ['Service M', 'Service N', 'Service O'],
            products: ['Product M', 'Product N', 'Product O'],
            phone: '+91 98765 43204',
            rating: 4.6,
          ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _shops.length,
              itemBuilder: (context, index) {
                return _buildFlipCard(_shops[index]);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationWidget(
        selectedIndex: 1, // Explore tab
        onTap: _onBottomNavTap,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: widget.categoryColor,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
          size: 24,
        ),
      ),
      title: Text(
        widget.subcategoryName,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: widget.categoryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              widget.categoryIcon,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '${_shops.length} Shops Available',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFlipCard(ShopCard shop) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 200,
      child: GestureDetector(
        onTap: () => _showShopDetailsModal(shop),
        child: _buildCardFront(shop),
      ),
    );
  }

  void _showShopDetailsModal(ShopCard selectedShop) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ShopDetailsModal(
        shops: _shops,
        initialShop: selectedShop,
        categoryColor: widget.categoryColor,
        categoryIcon: widget.categoryIcon,
      ),
    );
  }

  Widget _buildCardFront(ShopCard shop) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Shop Holder Photo Placeholder
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.grey[400]!, width: 2),
                  ),
                  child: Icon(
                    Icons.person,
                    color: Colors.grey[600],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                // Shop Photo Placeholder
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: widget.categoryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: widget.categoryColor.withOpacity(0.3), width: 1),
                  ),
                  child: Icon(
                    widget.categoryIcon,
                    color: widget.categoryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shop.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      const SizedBox(height: 4),
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
                              shop.address,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star,
                        size: 16,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        shop.rating.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.phone,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Text(
                  shop.phone,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: widget.categoryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Tap to see Details',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: widget.categoryColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardBack(ShopCard shop) {
    return Container(
      decoration: BoxDecoration(
        color: widget.categoryColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: widget.categoryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Icon(
                    Icons.build,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    shop.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Services & Products',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Services',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...shop.services.take(3).map((service) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                size: 12,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  service,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Products',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...shop.products.take(3).map((product) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.shopping_bag,
                                size: 12,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  product,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Tap to see Details',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onBottomNavTap(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        break;
      case 1:
        // Already on Explore screen
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

class ShopCard {
  final String name;
  final String address;
  final List<String> services;
  final List<String> products;
  final String phone;
  final double rating;

  ShopCard({
    required this.name,
    required this.address,
    required this.services,
    required this.products,
    required this.phone,
    required this.rating,
  });
}

class ShopDetailsModal extends StatefulWidget {
  final List<ShopCard> shops;
  final ShopCard initialShop;
  final Color categoryColor;
  final IconData categoryIcon;

  const ShopDetailsModal({
    super.key,
    required this.shops,
    required this.initialShop,
    required this.categoryColor,
    required this.categoryIcon,
  });

  @override
  State<ShopDetailsModal> createState() => _ShopDetailsModalState();
}

class _ShopDetailsModalState extends State<ShopDetailsModal>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _flipController;
  int _currentIndex = 0;
  bool _isFlipped = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.shops.indexOf(widget.initialShop);
    _pageController = PageController(initialPage: _currentIndex);
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _flipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(),
          _buildPageIndicator(),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                  _isFlipped = false;
                  _flipController.reset();
                });
              },
              itemCount: widget.shops.length,
              itemBuilder: (context, index) {
                return _buildFlipCard(widget.shops[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: widget.categoryColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, color: Colors.white, size: 24),
          ),
          Expanded(
            child: Text(
              widget.shops[_currentIndex].name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48), // Balance the close button
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.shops.length, (index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentIndex == index 
                  ? widget.categoryColor 
                  : Colors.grey[300],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildFlipCard(ShopCard shop) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isFlipped = !_isFlipped;
          });
          if (_isFlipped) {
            _flipController.forward();
          } else {
            _flipController.reverse();
          }
        },
        child: AnimatedBuilder(
          animation: _flipController,
          builder: (context, child) {
            final isShowingFront = !_isFlipped;
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(_flipController.value * 3.14159),
              child: isShowingFront 
                  ? _buildModalCardFront(shop)
                  : Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..rotateY(3.14159),
                      child: _buildModalCardBack(shop),
                    ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildModalCardFront(ShopCard shop) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shop Holder Photo and Shop Photo
            Row(
              children: [
                // Shop Holder Photo Placeholder
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(color: Colors.grey[400]!, width: 3),
                  ),
                  child: Icon(
                    Icons.person,
                    color: Colors.grey[600],
                    size: 40,
                  ),
                ),
                const SizedBox(width: 20),
                // Shop Photo Placeholder
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: widget.categoryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: widget.categoryColor.withOpacity(0.3), width: 2),
                  ),
                  child: Icon(
                    widget.categoryIcon,
                    color: widget.categoryColor,
                    size: 40,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star,
                        size: 20,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        shop.rating.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Shop Name
            Text(
              shop.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 12),
            // Address
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 20,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    shop.address,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Phone
            Row(
              children: [
                Icon(
                  Icons.phone,
                  size: 20,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Text(
                  shop.phone,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const Spacer(),
            // Tap to flip hint
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: widget.categoryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Tap to see Services & Products',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: widget.categoryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModalCardBack(ShopCard shop) {
    return Container(
      decoration: BoxDecoration(
        color: widget.categoryColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: widget.categoryColor.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.build,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    shop.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'Services & Products',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Services',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...shop.services.map((service) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                size: 16,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  service,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Products',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...shop.products.map((product) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.shopping_bag,
                                size: 16,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  product,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Tap to see Shop Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FlipCard extends StatefulWidget {
  final Widget front;
  final Widget back;
  final AnimationController animationController;

  const FlipCard({
    super.key,
    required this.front,
    required this.back,
    required this.animationController,
  });

  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard> {
  bool _isFront = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isFront = !_isFront;
        });
        if (_isFront) {
          widget.animationController.reverse();
        } else {
          widget.animationController.forward();
        }
      },
      child: AnimatedBuilder(
        animation: widget.animationController,
        builder: (context, child) {
          final isShowingFront = _isFront;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(widget.animationController.value * 3.14159),
            child: isShowingFront ? widget.front : Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..rotateY(3.14159),
              child: widget.back,
            ),
          );
        },
      ),
    );
  }
}
