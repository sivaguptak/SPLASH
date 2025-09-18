import 'package:flutter/material.dart';
import '../../../data/models/service_provider.dart';
import '../../../widgets/enhanced_search_widget.dart';
import '../../../widgets/search_results_widget.dart';
import '../../../widgets/back_button_handler.dart';
import '../../../app.dart';
import 'service_provider_detail_screen.dart';

class EnhancedSearchScreen extends StatefulWidget {
  const EnhancedSearchScreen({super.key});

  @override
  State<EnhancedSearchScreen> createState() => _EnhancedSearchScreenState();
}

class _EnhancedSearchScreenState extends State<EnhancedSearchScreen> {
  List<ServiceProvider> _searchResults = [];
  int _totalCount = 0;
  String _currentLocation = 'Chintalapudi';
  double _currentRadius = 5.0;

  @override
  void initState() {
    super.initState();
    // Initialize with all results
    _updateSearchResults([], 0);
  }

  void _updateSearchResults(List<ServiceProvider> results, int count) {
    setState(() {
      _searchResults = results;
      _totalCount = count;
    });
  }

  void _onLocationChanged(String location) {
    setState(() {
      _currentLocation = location;
    });
  }

  void _onRadiusChanged(double radius) {
    setState(() {
      _currentRadius = radius;
    });
  }

  void _onProviderTap(ServiceProvider provider) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServiceProviderDetailScreen(provider: provider),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackButtonHandler(
      behavior: BackButtonBehavior.navigate,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: _buildAppBar(),
        body: SafeArea(
          child: Column(
            children: [
              // Enhanced Search Widget
              EnhancedSearchWidget(
                onSearchResults: _updateSearchResults,
                onLocationChanged: _onLocationChanged,
                onRadiusChanged: _onRadiusChanged,
              ),
              
              // Search Results
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SearchResultsWidget(
                    results: _searchResults,
                    totalCount: _totalCount,
                    searchQuery: '', // Will be updated by the search widget
                    selectedLocation: _currentLocation,
                    selectedRadius: _currentRadius,
                    onProviderTap: _onProviderTap,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFFF7A00),
      elevation: 0,
      title: const Text(
        'Enhanced Search',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: IconButton(
        onPressed: () {
          // Navigate back to home screen properly
          Navigator.pushNamedAndRemoveUntil(
            context, 
            AppRoutes.home, 
            (route) => false
          );
        },
        icon: const Icon(Icons.arrow_back, color: Colors.white),
      ),
      actions: [
        IconButton(
          onPressed: () {
            // Show search tips or help
            _showSearchTips();
          },
          icon: const Icon(Icons.help_outline, color: Colors.white),
        ),
      ],
    );
  }

  void _showSearchTips() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Search Tips'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('• Use keywords like "restaurants", "electricians", "lawyers"'),
              SizedBox(height: 8),
              Text('• Select your preferred location from the dropdown'),
              SizedBox(height: 8),
              Text('• Adjust the radius slider to find nearby services'),
              SizedBox(height: 8),
              Text('• Leave search empty to see all services in the area'),
              SizedBox(height: 8),
              Text('• Results are sorted by distance from your location'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Got it'),
            ),
          ],
        );
      },
    );
  }
}
