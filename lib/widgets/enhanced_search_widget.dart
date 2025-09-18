import 'package:flutter/material.dart';
import '../data/services/comprehensive_search_service.dart';
import '../data/models/service_provider.dart';

class EnhancedSearchWidget extends StatefulWidget {
  final Function(List<ServiceProvider>, int) onSearchResults;
  final Function(String) onLocationChanged;
  final Function(double) onRadiusChanged;

  const EnhancedSearchWidget({
    super.key,
    required this.onSearchResults,
    required this.onLocationChanged,
    required this.onRadiusChanged,
  });

  @override
  State<EnhancedSearchWidget> createState() => _EnhancedSearchWidgetState();
}

class _EnhancedSearchWidgetState extends State<EnhancedSearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _radiusController = TextEditingController();
  String _selectedLocation = 'Chintalapudi';
  double _selectedRadius = 5.0;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _radiusController.text = _selectedRadius.toStringAsFixed(1);
    _performSearch(); // Initial search to show all results
  }

  @override
  void dispose() {
    _searchController.dispose();
    _radiusController.dispose();
    super.dispose();
  }

  void _performSearch() {
    setState(() {
      _isSearching = true;
    });

    final results = ComprehensiveSearchService.searchProviders(
      query: _searchController.text.trim().isEmpty ? null : _searchController.text.trim(),
      location: _selectedLocation,
      radius: _selectedRadius,
    );

    widget.onSearchResults(results, results.length);
    widget.onLocationChanged(_selectedLocation);
    widget.onRadiusChanged(_selectedRadius);

    setState(() {
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          _buildSearchBar(),
          const SizedBox(height: 12),
          
          // Popular Searches
          _buildPopularSearches(),
          const SizedBox(height: 16),
          
          // Location Dropdown
          _buildLocationDropdown(),
          const SizedBox(height: 16),
          
          // Radius Slider
          _buildRadiusSlider(),
          const SizedBox(height: 16),
          
          // Search Button
          _buildSearchButton(),
        ],
      ),
    );
  }

  Widget _buildPopularSearches() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Popular Searches',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ComprehensiveSearchService.popularSearches.map((search) {
            return GestureDetector(
              onTap: () {
                _searchController.text = search;
                _performSearch();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF7A00).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFF7A00).withOpacity(0.3)),
                ),
                child: Text(
                  search,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFFF7A00),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search for services, shops, restaurants...',
          hintStyle: TextStyle(color: Colors.grey[600]),
          prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey[600]),
                  onPressed: () {
                    _searchController.clear();
                    _performSearch();
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        onChanged: (value) {
          setState(() {});
          _performSearch();
        },
      ),
    );
  }

  Widget _buildLocationDropdown() {
    final locations = ComprehensiveSearchService.availableLocations;
    print('DEBUG: Available locations: $locations'); // Debug print
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
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
              isExpanded: true,
              isDense: false,
              icon: Icon(Icons.arrow_drop_down, color: const Color(0xFFFF7A00)),
              iconSize: 24,
              elevation: 8,
              style: const TextStyle(
                color: Color(0xFF2C3E50),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              underline: Container(), // Remove default underline
              items: locations.map((String location) {
                print('DEBUG: Creating dropdown item for: $location'); // Debug print
                return DropdownMenuItem<String>(
                  value: location,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Icon(Icons.location_on, size: 18, color: const Color(0xFFFF7A00)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            location,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        // Show count of providers in this location
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF7A00).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${ComprehensiveSearchService.getProvidersCountByLocation(location)}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFFFF7A00),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                print('DEBUG: Dropdown changed to: $newValue'); // Debug print
                if (newValue != null && newValue != _selectedLocation) {
                  setState(() {
                    _selectedLocation = newValue;
                  });
                  _performSearch();
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${locations.length} locations available',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
        // Debug info
        Text(
          'DEBUG: Current selection: $_selectedLocation',
          style: TextStyle(
            fontSize: 10,
            color: Colors.red[600],
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildRadiusSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Search Radius',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFF7A00),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_selectedRadius.toStringAsFixed(1)} km',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        
        // Radius Input with Spinner Buttons
        Row(
          children: [
            // Decrease Button
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFFF7A00),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                onPressed: _selectedRadius > 1.0 ? () {
                  setState(() {
                    _selectedRadius = (_selectedRadius - 1.0).clamp(1.0, 50.0);
                    _radiusController.text = _selectedRadius.toStringAsFixed(1);
                  });
                  _performSearch();
                } : null,
                icon: const Icon(Icons.remove, color: Colors.white, size: 20),
                padding: EdgeInsets.zero,
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Radius Input Field
            Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                  decoration: InputDecoration(
                    hintText: '5.0',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    suffix: Text(
                      'km',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  controller: _radiusController,
                  onChanged: (value) {
                    final newRadius = double.tryParse(value);
                    if (newRadius != null && newRadius >= 1.0 && newRadius <= 50.0) {
                      setState(() {
                        _selectedRadius = newRadius;
                      });
                      _performSearch();
                    }
                  },
                ),
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Increase Button
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFFF7A00),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                onPressed: _selectedRadius < 50.0 ? () {
                  setState(() {
                    _selectedRadius = (_selectedRadius + 1.0).clamp(1.0, 50.0);
                    _radiusController.text = _selectedRadius.toStringAsFixed(1);
                  });
                  _performSearch();
                } : null,
                icon: const Icon(Icons.add, color: Colors.white, size: 20),
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 8),
        
        // Slider for Fine Control
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: const Color(0xFFFF7A00),
            inactiveTrackColor: Colors.grey[300],
            thumbColor: const Color(0xFFFF7A00),
            overlayColor: const Color(0xFFFF7A00).withOpacity(0.2),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            trackHeight: 4,
          ),
          child: Slider(
            value: _selectedRadius,
            min: 1.0,
            max: 50.0,
            divisions: 49,
            onChanged: (double value) {
              setState(() {
                _selectedRadius = value;
                _radiusController.text = _selectedRadius.toStringAsFixed(1);
              });
              _performSearch();
            },
          ),
        ),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '1 km',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            Text(
              '50 km',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isSearching ? null : _performSearch,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF7A00),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2,
        ),
        child: _isSearching
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'Search',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
