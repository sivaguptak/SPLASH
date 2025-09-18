import 'package:flutter/material.dart';
import 'dart:async';
import '../../../data/models/category.dart';
import '../../../data/services/category_service.dart';
import '../../../data/models/service_provider.dart';
import '../../../widgets/bottom_navigation_widget.dart';
import '../../../widgets/back_button_handler.dart';
import '../../../app.dart';
import 'search_results_screen.dart';
import 'service_provider_detail_screen.dart';
import 'subcategory_shops_screen.dart';

class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({super.key});

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  final CategoryService _categoryService = CategoryService();
  final TextEditingController _searchController = TextEditingController();
  late List<CategoryModel> _allCategories;
  late List<CategoryModel> _filteredCategories;
  
  // Search related variables
  Timer? _searchTimer;
  List<dynamic> _searchResults = [];
  bool _isSearching = false;
  bool _showSearchResults = false;

  @override
  void initState() {
    super.initState();
    _allCategories = _categoryService.getAllCategories();
    _filteredCategories = _allCategories;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    _searchTimer?.cancel();
    _searchTimer = Timer(const Duration(milliseconds: 500), () {
      _performSearch(_searchController.text);
    });
  }

  void _performSearch(String query) {
    final trimmedQuery = query.toLowerCase().trim();
    
    if (trimmedQuery.isEmpty) {
      setState(() {
        _showSearchResults = false;
        _searchResults.clear();
        _isSearching = false;
        _filteredCategories = _allCategories;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _showSearchResults = true;
    });

    // Perform comprehensive search
    final allResults = <dynamic>[];
    
    // Search service providers
    final providers = ServiceProviderService.searchProviders(trimmedQuery);
    allResults.addAll(providers.map((p) => {
      'type': 'provider',
      'title': p.name,
      'subtitle': p.subcategory,
      'data': p,
      'icon': Icons.business,
      'color': _getCategoryColor(p.subcategory),
    }));

    // Search categories
    final matchingCategories = _allCategories.where((category) {
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
    for (final category in _allCategories) {
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

  @override
  Widget build(BuildContext context) {
    return BackButtonHandler(
      behavior: BackButtonBehavior.navigate, // Categories screen should navigate back
      child: Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: _showSearchResults ? _buildSearchResults() : _buildCategoriesList(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationWidget(
        selectedIndex: 1, // Explore tab
        onTap: _onBottomNavTap,
        onVoiceSearchResult: _handleVoiceSearchResult,
      ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFFF7A00),
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
          size: 24,
        ),
      ),
      title: const Text(
        'All Categories',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFFFF7A00),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search categories...',
            hintStyle: const TextStyle(color: Colors.grey),
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _showSearchResults = false;
                        _searchResults.clear();
                        _filteredCategories = _allCategories;
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
    );
  }

  Widget _buildCategoriesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredCategories.length,
      itemBuilder: (context, index) {
        final category = _filteredCategories[index];
        return _buildCategoryCard(category);
      },
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceProviderDetailScreen(provider: result['data']),
          ),
        );
        break;
      case 'category':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryDetailsScreen(category: result['data']),
          ),
        );
        break;
      case 'subcategory':
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

  Widget _buildCategoryCard(CategoryModel category) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Category Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: category.color.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: category.color,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    category.icon,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${category.name} (${category.subcategories.length})',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C3E50),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: () => _showCategoryDetails(category),
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: category.color,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
          
          // Subcategories Horizontal Scrollable Carousel
          Container(
            height: 110,
            padding: const EdgeInsets.all(16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: category.subcategories.length,
              itemBuilder: (context, subIndex) {
                final subcategory = category.subcategories[subIndex];
                return _buildSubcategoryCard(subcategory);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubcategoryCard(SubcategoryModel subcategory) {
    return GestureDetector(
      onTap: () => _exploreSubcategory(subcategory),
      child: Container(
        width: 70,
        height: 90,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: subcategory.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: subcategory.color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: subcategory.color,
                shape: BoxShape.circle,
              ),
              child: Icon(
                subcategory.icon,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Text(
                subcategory.name,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCategoryDetails(CategoryModel category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryDetailsScreen(category: category),
      ),
    );
  }

  void _exploreSubcategory(SubcategoryModel subcategory) {
    // Navigate to the subcategory shops screen with flip cards
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubcategoryShopsScreen(
          subcategoryName: subcategory.name,
          categoryColor: subcategory.color,
          categoryIcon: subcategory.icon,
        ),
      ),
    );
  }

  void _handleVoiceSearchResult(String recognizedText) {
    // Clear previous search results first
    setState(() {
      _showSearchResults = false;
      _searchResults.clear();
      _isSearching = false;
      _filteredCategories = _allCategories;
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
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
        break;
      case 1:
        // Already on All Categories screen
        break;
      case 2:
        // Voice search button - handled by the widget itself
        break;
      case 3:
        // Navigate to My Activity screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('My Activity - Coming Soon!'),
            backgroundColor: Color(0xFFFF7A00),
            behavior: SnackBarBehavior.floating,
          ),
        );
        break;
      case 4:
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.profile, (route) => false);
        break;
    }
  }
}

class CategoryDetailsScreen extends StatefulWidget {
  final CategoryModel category;

  const CategoryDetailsScreen({super.key, required this.category});

  @override
  State<CategoryDetailsScreen> createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildCategoryHeader(),
          _buildSubcategoriesCarousel(),
          _buildPageIndicator(),
          _buildActionButtons(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: widget.category.color,
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
        widget.category.name,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildCategoryHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: widget.category.color,
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
              widget.category.icon,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '${widget.category.name} (${widget.category.subcategories.length})',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSubcategoriesCarousel() {
    return Expanded(
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemCount: widget.category.subcategories.length,
        itemBuilder: (context, index) {
          final subcategory = widget.category.subcategories[index];
          return _buildSubcategoryDetailCard(subcategory);
        },
      ),
    );
  }

  Widget _buildSubcategoryDetailCard(SubcategoryModel subcategory) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: subcategory.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              subcategory.icon,
              color: subcategory.color,
              size: 50,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            subcategory.name,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: subcategory.color,
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Text(
              'Available in your area',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Find the best ${subcategory.name.toLowerCase()} services near you',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.category.subcategories.length, (index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentIndex == index 
                  ? widget.category.color 
                  : Colors.grey[300],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: widget.category.color, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'Back',
                style: TextStyle(
                  color: widget.category.color,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () => _exploreCategory(),
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.category.color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Explore',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _exploreCategory() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exploring ${widget.category.name}...'),
        backgroundColor: widget.category.color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
