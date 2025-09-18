import 'package:flutter/material.dart';
import '../../../data/models/service_provider.dart';
import '../../../widgets/back_button_handler.dart';
import 'service_provider_detail_screen.dart';

class SearchResultsScreen extends StatefulWidget {
  final String searchQuery;

  const SearchResultsScreen({super.key, required this.searchQuery});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  late List<ServiceProvider> _searchResults;

  @override
  void initState() {
    super.initState();
    _searchResults = ServiceProviderService.searchProviders(widget.searchQuery);
  }

  @override
  Widget build(BuildContext context) {
    return BackButtonHandler(
      behavior: BackButtonBehavior.navigate, // Search results should navigate back
      child: Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: _searchResults.isEmpty ? _buildNoResults() : _buildResultsList(),
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
      title: Text(
        'Search Results',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildNoResults() {
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

  Widget _buildResultsList() {
    return Column(
      children: [
        // Results count
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Text(
            '${_searchResults.length} results found for "${widget.searchQuery}"',
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
              final provider = _searchResults[index];
              return _buildProviderCard(provider);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProviderCard(ServiceProvider provider) {
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
      child: InkWell(
        onTap: () => _navigateToProviderDetail(provider),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with name and rating
              Row(
                children: [
                  // Icon
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: _getCategoryColor(provider.subcategory).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getCategoryIcon(provider.subcategory),
                      color: _getCategoryColor(provider.subcategory),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Name and category
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                provider.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2C3E50),
                                ),
                              ),
                            ),
                            if (provider.isVerified)
                              const Icon(
                                Icons.verified,
                                color: Colors.blue,
                                size: 16,
                              ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          provider.subcategory,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Rating
                  Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.yellow, size: 16),
                          const SizedBox(width: 2),
                          Text(
                            provider.rating.toString(),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${provider.reviewCount} reviews',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Address
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.grey[600],
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      provider.address,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Experience and working hours
              Row(
                children: [
                  Icon(
                    Icons.work,
                    color: Colors.grey[600],
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    provider.experience,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.access_time,
                    color: Colors.grey[600],
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    provider.workingHours,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Services (first 3)
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: provider.services.take(3).map((service) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(provider.subcategory).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      service,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: _getCategoryColor(provider.subcategory),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String subcategory) {
    switch (subcategory.toLowerCase()) {
      case 'lawyers':
        return Icons.gavel;
      case 'grocery stores':
        return Icons.shopping_cart;
      case 'fruits & vegetables':
        return Icons.eco;
      case 'electricians':
        return Icons.electrical_services;
      case 'plumbers':
        return Icons.plumbing;
      case 'restaurants':
        return Icons.restaurant;
      case 'schools':
        return Icons.school;
      default:
        return Icons.business;
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

  void _navigateToProviderDetail(ServiceProvider provider) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServiceProviderDetailScreen(provider: provider),
      ),
    );
  }
}
