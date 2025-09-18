import 'package:flutter/material.dart';
import '../data/models/service_provider.dart';

class SearchResultsWidget extends StatelessWidget {
  final List<ServiceProvider> results;
  final int totalCount;
  final String searchQuery;
  final String selectedLocation;
  final double selectedRadius;
  final Function(ServiceProvider) onProviderTap;

  const SearchResultsWidget({
    super.key,
    required this.results,
    required this.totalCount,
    required this.searchQuery,
    required this.selectedLocation,
    required this.selectedRadius,
    required this.onProviderTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Results Header
        _buildResultsHeader(),
        const SizedBox(height: 16),
        
        // Results List
        Expanded(
          child: results.isEmpty ? _buildNoResults() : _buildResultsList(),
        ),
      ],
    );
  }

  Widget _buildResultsHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.search,
                color: const Color(0xFFFF7A00),
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _getResultsTitle(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildSearchCriteria(),
          const SizedBox(height: 8),
          _buildResultsCount(),
        ],
      ),
    );
  }

  String _getResultsTitle() {
    if (searchQuery.isEmpty) {
      return 'All Services & Shops';
    } else {
      return 'Search Results for "$searchQuery"';
    }
  }

  Widget _buildSearchCriteria() {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        _buildCriteriaChip(
          icon: Icons.location_on,
          label: selectedLocation,
          color: Colors.blue,
        ),
        _buildCriteriaChip(
          icon: Icons.radio_button_checked,
          label: '${selectedRadius.toStringAsFixed(1)} km radius',
          color: Colors.green,
        ),
      ],
    );
  }

  Widget _buildCriteriaChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsCount() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFF7A00),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        '$totalCount ${totalCount == 1 ? 'result' : 'results'} found',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Results Found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search criteria',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 16),
          _buildSuggestions(),
        ],
      ),
    );
  }

  Widget _buildSuggestions() {
    final suggestions = [
      'Try a different location',
      'Increase the search radius',
      'Use different keywords',
      'Check spelling',
    ];

    return Column(
      children: suggestions.map((suggestion) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.lightbulb_outline,
              size: 16,
              color: Colors.grey[400],
            ),
            const SizedBox(width: 8),
            Text(
              suggestion,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildResultsList() {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final provider = results[index];
        return _buildProviderCard(provider);
      },
    );
  }

  Widget _buildProviderCard(ServiceProvider provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => onProviderTap(provider),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    // Category Icon
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _getCategoryColor(provider.category).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getCategoryIcon(provider.category),
                        color: _getCategoryColor(provider.category),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    
                    // Name and Category
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            provider.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                          Text(
                            '${provider.category} • ${provider.subcategory}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Distance
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${provider.distance.toStringAsFixed(1)} km',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Description
                Text(
                  provider.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 12),
                
                // Footer Row
                Row(
                  children: [
                    // Rating
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.amber[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          provider.rating.toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(width: 16),
                    
                    // Location
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              provider.location,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Arrow
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey[400],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'restaurants':
        return Colors.red;
      case 'electricians':
        return Colors.blue;
      case 'lawyers':
        return Colors.purple;
      case 'plumbers':
        return Colors.orange;
      case 'doctors':
        return Colors.green;
      case 'grocery':
        return Colors.brown;
      case 'auto repair':
        return Colors.indigo;
      default:
        return const Color(0xFFFF7A00);
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'restaurants':
        return Icons.restaurant;
      case 'electricians':
        return Icons.electrical_services;
      case 'lawyers':
        return Icons.gavel;
      case 'plumbers':
        return Icons.plumbing;
      case 'doctors':
        return Icons.medical_services;
      case 'grocery':
        return Icons.shopping_cart;
      case 'auto repair':
        return Icons.car_repair;
      default:
        return Icons.business;
    }
  }
}
