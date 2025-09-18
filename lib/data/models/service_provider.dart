import 'package:flutter/material.dart';

class ServiceProvider {
  final String id;
  final String name;
  final String category;
  final String subcategory;
  final String address;
  final String phoneNumber;
  final String whatsappNumber;
  final double latitude;
  final double longitude;
  final double rating;
  final int reviewCount;
  final String description;
  final List<String> services;
  final String imageUrl;
  final bool isVerified;
  final String workingHours;
  final String experience;
  final double distance;
  final String location;
  final String phone;

  ServiceProvider({
    required this.id,
    required this.name,
    required this.category,
    required this.subcategory,
    required this.address,
    required this.phoneNumber,
    required this.whatsappNumber,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.reviewCount,
    required this.description,
    required this.services,
    required this.imageUrl,
    required this.isVerified,
    required this.workingHours,
    required this.experience,
    required this.distance,
    required this.location,
    required this.phone,
  });
}

class ServiceProviderService {
  static List<ServiceProvider> getAllProviders() {
    return [
      // Lawyers
      ServiceProvider(
        id: 'lawyer_1',
        name: 'Lawyer Srinivasarao',
        category: 'Professionals',
        subcategory: 'Lawyers',
        address: 'Main Road, Chintalapudi, Andhra Pradesh 534460',
        phoneNumber: '+91 9876543210',
        whatsappNumber: '+91 9876543210',
        latitude: 16.8661,
        longitude: 81.1956,
        rating: 4.8,
        reviewCount: 45,
        description: 'Experienced lawyer specializing in civil and criminal cases',
        services: ['Civil Cases', 'Criminal Cases', 'Property Disputes', 'Family Law'],
        imageUrl: 'assets/images/lawyer_1.jpg',
        isVerified: true,
        workingHours: '9:00 AM - 6:00 PM',
        experience: '15 years',
        distance: 0.3,
        location: 'Chintalapudi',
        phone: '+91 9876543210',
      ),
      ServiceProvider(
        id: 'lawyer_2',
        name: 'Advocate Rajesh Kumar',
        category: 'Professionals',
        subcategory: 'Lawyers',
        address: 'Court Road, Chintalapudi, Andhra Pradesh 534460',
        phoneNumber: '+91 9876543211',
        whatsappNumber: '+91 9876543211',
        latitude: 16.8661,
        longitude: 81.1956,
        rating: 4.6,
        reviewCount: 32,
        description: 'Expert in property and business law',
        services: ['Property Law', 'Business Law', 'Contract Disputes'],
        imageUrl: 'assets/images/lawyer_2.jpg',
        isVerified: true,
        workingHours: '10:00 AM - 7:00 PM',
        experience: '12 years',
        distance: 0.5,
        location: 'Chintalapudi',
        phone: '+91 9876543211',
      ),

      // Grocery Stores
      ServiceProvider(
        id: 'grocery_1',
        name: 'Sri Lakshmi Kirana Store',
        category: 'Daily Essentials',
        subcategory: 'Grocery Stores',
        address: 'Market Street, Chintalapudi, Andhra Pradesh 534460',
        phoneNumber: '+91 9876543212',
        whatsappNumber: '+91 9876543212',
        latitude: 16.8661,
        longitude: 81.1956,
        rating: 4.5,
        reviewCount: 28,
        description: 'Fresh groceries and daily essentials',
        services: ['Rice & Pulses', 'Spices', 'Oil & Ghee', 'Snacks'],
        imageUrl: 'assets/images/grocery_1.jpg',
        isVerified: true,
        workingHours: '6:00 AM - 10:00 PM',
        experience: '8 years',
        distance: 0.6,
        location: 'Chintalapudi',
        phone: '+91 9876543212',
      ),

      // Fruits & Vegetables
      ServiceProvider(
        id: 'fruits_1',
        name: 'Fresh Fruits & Vegetables',
        category: 'Daily Essentials',
        subcategory: 'Fruits & Vegetables',
        address: 'Vegetable Market, Chintalapudi, Andhra Pradesh 534460',
        phoneNumber: '+91 9876543213',
        whatsappNumber: '+91 9876543213',
        latitude: 16.8661,
        longitude: 81.1956,
        rating: 4.7,
        reviewCount: 35,
        description: 'Fresh fruits and vegetables daily',
        services: ['Seasonal Fruits', 'Fresh Vegetables', 'Organic Products'],
        imageUrl: 'assets/images/fruits_1.jpg',
        isVerified: true,
        workingHours: '5:00 AM - 9:00 PM',
        experience: '10 years',
        distance: 0.4,
        location: 'Chintalapudi',
        phone: '+91 9876543213',
      ),

      // Electricians
      ServiceProvider(
        id: 'electrician_1',
        name: 'Ravi Electrical Services',
        category: 'Home Needs & Repair',
        subcategory: 'Electricians',
        address: 'Industrial Area, Chintalapudi, Andhra Pradesh 534460',
        phoneNumber: '+91 9876543214',
        whatsappNumber: '+91 9876543214',
        latitude: 16.8661,
        longitude: 81.1956,
        rating: 4.9,
        reviewCount: 52,
        description: 'Professional electrical services for home and office',
        services: ['Wiring', 'Repairs', 'Installation', 'Maintenance'],
        imageUrl: 'assets/images/electrician_1.jpg',
        isVerified: true,
        workingHours: '8:00 AM - 8:00 PM',
        experience: '18 years',
        distance: 1.0,
        location: 'Chintalapudi',
        phone: '+91 9876543214',
      ),

      // Plumbers
      ServiceProvider(
        id: 'plumber_1',
        name: 'Suresh Plumbing Works',
        category: 'Home Needs & Repair',
        subcategory: 'Plumbers',
        address: 'Service Road, Chintalapudi, Andhra Pradesh 534460',
        phoneNumber: '+91 9876543215',
        whatsappNumber: '+91 9876543215',
        latitude: 16.8661,
        longitude: 81.1956,
        rating: 4.6,
        reviewCount: 41,
        description: 'Complete plumbing solutions for residential and commercial',
        services: ['Pipe Repair', 'Installation', 'Blockage Removal', 'Water Tank'],
        imageUrl: 'assets/images/plumber_1.jpg',
        isVerified: true,
        workingHours: '7:00 AM - 7:00 PM',
        experience: '14 years',
        distance: 0.7,
        location: 'Chintalapudi',
        phone: '+91 9876543215',
      ),

      // Restaurants
      ServiceProvider(
        id: 'restaurant_1',
        name: 'Spice Garden Restaurant',
        category: 'Food & Restaurants',
        subcategory: 'Restaurants',
        address: 'Main Road, Chintalapudi, Andhra Pradesh 534460',
        phoneNumber: '+91 9876543216',
        whatsappNumber: '+91 9876543216',
        latitude: 16.8661,
        longitude: 81.1956,
        rating: 4.4,
        reviewCount: 67,
        description: 'Authentic Andhra cuisine with fresh ingredients',
        services: ['Andhra Meals', 'Biryani', 'Tandoor', 'South Indian'],
        imageUrl: 'assets/images/restaurant_1.jpg',
        isVerified: true,
        workingHours: '11:00 AM - 11:00 PM',
        experience: '12 years',
        distance: 0.5,
        location: 'Chintalapudi',
        phone: '+91 9876543216',
      ),

      // Schools
      ServiceProvider(
        id: 'school_1',
        name: 'Chintalapudi Public School',
        category: 'Education',
        subcategory: 'Schools',
        address: 'Education Colony, Chintalapudi, Andhra Pradesh 534460',
        phoneNumber: '+91 9876543217',
        whatsappNumber: '+91 9876543217',
        latitude: 16.8661,
        longitude: 81.1956,
        rating: 4.7,
        reviewCount: 89,
        description: 'Quality education from LKG to 10th standard',
        services: ['Primary Education', 'Secondary Education', 'Sports', 'Transport'],
        imageUrl: 'assets/images/school_1.jpg',
        isVerified: true,
        workingHours: '8:00 AM - 4:00 PM',
        experience: '25 years',
        distance: 0.8,
        location: 'Chintalapudi',
        phone: '+91 9876543217',
      ),
    ];
  }

  static List<ServiceProvider> searchProviders(String query) {
    final allProviders = getAllProviders();
    final lowercaseQuery = query.toLowerCase();
    
    return allProviders.where((provider) {
      return provider.name.toLowerCase().contains(lowercaseQuery) ||
             provider.subcategory.toLowerCase().contains(lowercaseQuery) ||
             provider.category.toLowerCase().contains(lowercaseQuery) ||
             provider.services.any((service) => service.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }

  static List<ServiceProvider> getProvidersBySubcategory(String subcategory) {
    return getAllProviders().where((provider) => 
        provider.subcategory.toLowerCase() == subcategory.toLowerCase()).toList();
  }
}
