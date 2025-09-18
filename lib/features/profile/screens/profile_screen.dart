import 'package:flutter/material.dart';
import '../../../widgets/bottom_navigation_widget.dart';
import '../../../widgets/back_button_handler.dart';
import '../../../app.dart';
import 'user_dashboard_screen.dart';
import 'shop_admin_dashboard_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackButtonHandler(
      behavior: BackButtonBehavior.navigate, // Profile screen should navigate back
      child: Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Light beige background
      appBar: _buildAppBar(),
      body: TabBarView(
        controller: _tabController,
        children: const [
          UserDashboardScreen(),
          ShopAdminDashboardScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationWidget(
        selectedIndex: 3, // Profile tab
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
      toolbarHeight: 200, // Fixed height to prevent overflow
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFF7A00),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // LOCSY Brand
              const Text(
                'LOCSY',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              // Profile Title
              const Text(
                'Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              // Tabs
              TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                indicatorWeight: 3,
                indicatorSize: TabBarIndicatorSize.label,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
                tabs: const [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person, size: 18),
                        SizedBox(width: 6),
                        Text('Citizen'),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.store, size: 18),
                        SizedBox(width: 6),
                        Text('Shop Admin'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleVoiceSearchResult(String recognizedText) {
    // Navigate to home screen and perform voice search
    Navigator.pushReplacementNamed(context, AppRoutes.home);
    
    // Show feedback to user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Voice search: "$recognizedText" - Redirecting to search...'),
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
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.allCategories, (route) => false);
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
        // Already on Profile screen
        break;
    }
  }
}
