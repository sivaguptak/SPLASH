import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import '../../../widgets/lo_cards.dart';
import '../../../widgets/lo_buttons.dart';
import '../../../widgets/bottom_navigation_widget.dart';
import '../../../widgets/back_button_handler.dart';
import '../../../app.dart';
import '../../../core/theme.dart';
import '../../../data/services/category_service.dart';
import '../../../data/services/comprehensive_search_service.dart';
import '../../../data/models/category.dart';
import '../../../data/models/service_provider.dart';
import 'all_categories_screen.dart';
import 'search_results_screen.dart';
import 'service_provider_detail_screen.dart';
import 'subcategory_shops_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final CategoryService _categoryService = CategoryService();
  String _selectedLocation = 'Chintalapudi';
  String _selectedDistance = '5 km';
  double _searchRadius = 5.0;
  int _currentPamphletIndex = 0;
  
  // Search related variables
  Timer? _searchTimer;
  List<dynamic> _searchResults = [];
  bool _isSearching = false;
  bool _showSearchResults = false;
  
  // Tab controller removed - no longer using tabs

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackButtonHandler(
      behavior: BackButtonBehavior.exit, // Home screen should show exit confirmation
      child: Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header with LOCSY logo
            _buildHeader(),
            
            // Search Bar and Location
            _buildSearchSection(),
            
            // Main Content
            Expanded(
              child: _showSearchResults 
                ? _buildSearchResults() 
                : _buildMainContent(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationWidget(
        selectedIndex: 0,
        onTap: _onBottomNavTap,
        onVoiceSearchResult: _handleVoiceSearchResult,
      ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: const BoxDecoration(
        color: Color(0xFFFF7A00), // Orange background
      ),
      child: Row(
        children: [
          const Text(
            'LOCSY',
            style: TextStyle(
              color: Color(0xFF2C3E50), // Blue text as in image
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const Spacer(),
          // Location Dropdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFFF7A00)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedLocation,
                isDense: true,
                icon: Icon(Icons.keyboard_arrow_down, color: const Color(0xFFFF7A00), size: 20),
                style: const TextStyle(
                  color: Color(0xFF2C3E50),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                items: [
                  'Chintalapudi',
                  'Pragadavaram',
                  'Lingapalem', 
                  'Dharmajigudem',
                  'Eluru',
                  'Vijayawada',
                ].map((String location) {
                  return DropdownMenuItem<String>(
                    value: location,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.location_on, size: 16, color: const Color(0xFFFF7A00)),
                        const SizedBox(width: 6),
                        Text(
                          location,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null && newValue != _selectedLocation) {
                    setState(() {
                      _selectedLocation = newValue;
                    });
                    _performSearch(); // Update search results when location changes
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFFFF7A00), // Orange background
      ),
      child: Column(
        children: [
          // Location and Distance Filter
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.white, size: 16),
              const SizedBox(width: 4),
              const Text(
                'Search Radius: ',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              // Radius Input with Spinner Buttons
              Container(
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Decrease Button
                    Container(
                      width: 28,
                      height: 28,
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: IconButton(
                        onPressed: _searchRadius > 1.0 ? () {
                          setState(() {
                            _searchRadius = (_searchRadius - 1.0).clamp(1.0, 50.0);
                            _selectedDistance = '${_searchRadius.toInt()} km';
                          });
                          _performSearch(); // Update search results when radius changes
                        } : null,
                        icon: const Icon(Icons.remove, color: Colors.white, size: 16),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    
                    // Radius Display
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '${_searchRadius.toInt()} km',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    
                    // Increase Button
                    Container(
                      width: 28,
                      height: 28,
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: IconButton(
                        onPressed: _searchRadius < 50.0 ? () {
                          setState(() {
                            _searchRadius = (_searchRadius + 1.0).clamp(1.0, 50.0);
                            _selectedDistance = '${_searchRadius.toInt()} km';
                          });
                          _performSearch(); // Update search results when radius changes
                        } : null,
                        icon: const Icon(Icons.add, color: Colors.white, size: 16),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
            // Search Bar
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by place or area or need...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _showSearchResults = false;
                              _searchResults.clear();
                            });
                          },
                          icon: const Icon(Icons.clear, color: Color(0xFFFF7A00)),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDigitalPamphlets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Digital Pamphlets',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'View All',
                  style: TextStyle(
                    color: Color(0xFFFF7A00),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        
        // Carousel
        SizedBox(
          height: 200,
          child: PageView.builder(
            onPageChanged: (index) {
              setState(() {
                _currentPamphletIndex = index;
              });
            },
            itemCount: 3,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[200],
                ),
                child: Stack(
                  children: [
                    // Background image placeholder
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [Colors.blue[300]!, Colors.purple[300]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                    
                    // Content
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Larana inc',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'SEASONAL STYLE SALE!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Refresh Your Wardrobe with Amazing Discounts',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              '25% OFF',
                              style: TextStyle(
                                color: Color(0xFFFF7A00),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        
        // Page indicators
        const SizedBox(height: 12),
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPamphletIndex == index 
                      ? const Color(0xFFFF7A00) 
                      : Colors.grey[300],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildShopsServices() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Shops/Services',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
              TextButton(
                onPressed: () => _showAllCategories(),
                child: const Text(
                  'View All',
                  style: TextStyle(
                    color: Color(0xFFFF7A00),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        // Most Frequent Categories with Character Icons
        SizedBox(
          height: 80,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildCategoryIcon('KIRANA', Icons.store, Colors.purple),
              _buildCategoryIcon('Clothes', Icons.checkroom, Colors.blue),
              _buildCategoryIcon('Education', Icons.school, Colors.green),
              _buildCategoryIcon('OLX', Icons.sell, const Color(0xFFFF7A00)),
              _buildCategoryIcon('Real Estate', Icons.home_work, const Color(0xFFFF7A00)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryIcon(String label, IconData icon, Color color) {
    return Container(
      width: 60,
      margin: const EdgeInsets.only(right: 10),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: color.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3E50),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildNewInTown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'New in Town',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFFFF7A00),
                size: 16,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        // Business Cards
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildBusinessCard('Fresh Mart', Icons.local_grocery_store, Colors.green),
              _buildBusinessCard('Quick Cuts', Icons.content_cut, Colors.blue),
              _buildBusinessCard('Clean Pro', Icons.cleaning_services, Colors.orange),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTodaysOffers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Today\'s Offers',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFFFF7A00),
                size: 16,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        // Offer Cards
        SizedBox(
          height: 90,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildOfferCard('PRODUCT COUPON', Icons.local_drink, const Color(0xFFFF7A00)),
              _buildOfferCard('PRODUCT COUPON', Icons.sports_soccer, Colors.blue),
            ],
          ),
        ),
      ],
    );
  }


  void _showAllCategories() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AllCategoriesScreen(),
      ),
    );
  }

  void _onSearchChanged() {
    _searchTimer?.cancel();
    _searchTimer = Timer(const Duration(milliseconds: 500), () {
      _performSearch(_searchController.text);
    });
  }

  void _performSearch([String? query]) {
    final trimmedQuery = query?.toLowerCase().trim() ?? '';
    
    if (trimmedQuery.isEmpty) {
      setState(() {
        _showSearchResults = false;
        _searchResults.clear();
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _showSearchResults = true;
    });

    // Perform comprehensive search across all app content with location and radius filtering
    final allResults = <dynamic>[];
    
    // Search service providers with location and radius filtering using ComprehensiveSearchService
    final providers = ComprehensiveSearchService.searchProviders(
      query: trimmedQuery,
      location: _selectedLocation,
      radius: _searchRadius,
    );
    
    allResults.addAll(providers.map((p) => {
      'type': 'provider',
      'title': p.name,
      'subtitle': p.subcategory,
      'data': p,
      'icon': Icons.business,
      'color': _getCategoryColor(p.subcategory),
    }));

    // Search categories
    final categories = _categoryService.getAllCategories();
    final matchingCategories = categories.where((category) {
      return category.name.toLowerCase().contains(trimmedQuery) ||
             category.subcategories.any((sub) => 
                 sub.name.toLowerCase().contains(trimmedQuery));
    }).toList();
    
    allResults.addAll(matchingCategories.map((c) => {
      'type': 'category',
      'title': c.name,
      'subtitle': '${c.subcategories.length} subcategories',
      'data': c,
      'icon': c.icon,
      'color': c.color,
    }));

    // Search subcategories
    for (final category in categories) {
      final matchingSubs = category.subcategories.where((sub) => 
          sub.name.toLowerCase().contains(trimmedQuery)).toList();
      
      allResults.addAll(matchingSubs.map((sub) => {
        'type': 'subcategory',
        'title': sub.name,
        'subtitle': 'Under ${category.name}',
        'data': sub,
        'icon': sub.icon,
        'color': sub.color,
      }));
    }

    setState(() {
      _searchResults = allResults;
      _isSearching = false;
    });
  }


  Widget _buildMainContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Digital Pamphlets
          _buildDigitalPamphlets(),
          const SizedBox(height: 20),
          
          // Shops/Services Categories
          _buildShopsServices(),
          const SizedBox(height: 20),
          
          // New in Town
          _buildNewInTown(),
          const SizedBox(height: 20),
          
          // Today's Offers
          _buildTodaysOffers(),
          const SizedBox(height: 20),
          
          // Scratch Demo Section
          _buildScratchDemo(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_isSearching) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF7A00)),
            ),
            SizedBox(height: 16),
            Text(
              'Searching...',
              style: TextStyle(
                color: Color(0xFF2C3E50),
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No results found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try searching with different keywords',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Results count
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Text(
            '${_searchResults.length} results found for "${_searchController.text}"',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3E50),
            ),
          ),
        ),
        
        // Results list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              final result = _searchResults[index];
              return _buildSearchResultCard(result);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResultCard(Map<String, dynamic> result) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: result['color'].withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            result['icon'],
            color: result['color'],
            size: 20,
          ),
        ),
        title: Text(
          result['title'],
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
        subtitle: Text(
          result['subtitle'],
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey[400],
          size: 16,
        ),
        onTap: () => _handleSearchResultTap(result),
      ),
    );
  }

  void _handleSearchResultTap(Map<String, dynamic> result) {
    switch (result['type']) {
      case 'provider':
        // Navigate to provider detail
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ServiceProviderDetailScreen(provider: result['data']),
          ),
        );
        break;
      case 'category':
        // Navigate to category details
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryDetailsScreen(category: result['data']),
          ),
        );
        break;
      case 'subcategory':
        // Navigate to subcategory shops
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubcategoryShopsScreen(
              subcategoryName: result['data'].name,
              categoryColor: result['data'].color,
              categoryIcon: result['data'].icon,
          ),
        ),
      );
        break;
    }
  }

  Color _getCategoryColor(String subcategory) {
    switch (subcategory.toLowerCase()) {
      case 'lawyers':
        return Colors.indigo;
      case 'grocery stores':
        return Colors.green;
      case 'fruits & vegetables':
        return Colors.green;
      case 'electricians':
        return Colors.orange;
      case 'plumbers':
        return Colors.blue;
      case 'restaurants':
        return Colors.red;
      case 'schools':
        return Colors.purple;
      default:
        return const Color(0xFFFF7A00);
    }
  }

  void _handleVoiceSearchResult(String recognizedText) {
    // Clear previous search results first
    setState(() {
      _showSearchResults = false;
      _searchResults.clear();
      _isSearching = false;
    });
    
    // Set the new recognized text in the search controller
    _searchController.text = recognizedText;
    
    // Trigger search with the voice input
    _performSearch(recognizedText);
    
    // Show feedback to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
        content: Text('Voice search: "$recognizedText"'),
          backgroundColor: const Color(0xFFFF7A00),
          behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        ),
      );
  }

  void _onBottomNavTap(int index) {
    switch (index) {
      case 0:
        // Already on Home screen
        break;
      case 1:
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.allCategories, (route) => false);
        break;
      case 2:
        // Voice search button - handled by the widget itself
        break;
      case 3:
        // Navigate to Daily Updates screen
        Navigator.pushNamed(context, AppRoutes.dailyUpdates);
        break;
      case 4:
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.profile, (route) => false);
        break;
    }
  }

  Widget _buildBusinessCard(String name, IconData icon, Color color) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 10),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              icon,
              color: color,
              size: 18,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3E50),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildOfferCard(String title, IconData icon, Color color) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildScratchDemo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '🎁 Scratch & Win',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.scratchDemo),
                child: const Text(
                  'Try Demo',
                  style: TextStyle(
                    color: Color(0xFFFF7A00),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        // Scratch Demo Card
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color(0xFFFF7A00), const Color(0xFFFF7A00).withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF7A00).withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  Icons.card_giftcard,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Scratch Coupons',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Touch and scratch to reveal amazing offers!',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, AppRoutes.scratchDemo),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Try Scratch Demo',
                          style: TextStyle(
                            color: Color(0xFFFF7A00),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

}
