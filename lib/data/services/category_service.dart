import 'package:flutter/material.dart';
import '../models/category.dart';

class CategoryService {
  static final CategoryService _instance = CategoryService._internal();
  factory CategoryService() => _instance;
  CategoryService._internal();

  List<CategoryModel> getAllCategories() {
    return [
      CategoryModel(
        id: 'daily_essentials',
        name: 'Daily Essentials',
        icon: Icons.shopping_cart,
        color: Colors.green,
        subcategories: [
          SubcategoryModel(id: 'grocery', name: 'Grocery Stores', icon: Icons.store, color: Colors.green),
          SubcategoryModel(id: 'fruits', name: 'Fruits & Vegetables', icon: Icons.apple, color: Colors.green),
          SubcategoryModel(id: 'dairy', name: 'Dairy & Sweets', icon: Icons.cake, color: Colors.green),
          SubcategoryModel(id: 'meat', name: 'Meat, Fish & Eggs', icon: Icons.restaurant, color: Colors.green),
          SubcategoryModel(id: 'general', name: 'General Stores', icon: Icons.storefront, color: Colors.green),
        ],
      ),
      CategoryModel(
        id: 'home_repair',
        name: 'Home Needs & Repair',
        icon: Icons.home_repair_service,
        color: Colors.orange,
        subcategories: [
          SubcategoryModel(id: 'electrician', name: 'Electricians', icon: Icons.electrical_services, color: Colors.orange),
          SubcategoryModel(id: 'plumber', name: 'Plumbers', icon: Icons.plumbing, color: Colors.orange),
          SubcategoryModel(id: 'carpenter', name: 'Carpenters', icon: Icons.build, color: Colors.orange),
          SubcategoryModel(id: 'painter', name: 'Painters', icon: Icons.format_paint, color: Colors.orange),
          SubcategoryModel(id: 'cleaning', name: 'House Cleaning', icon: Icons.cleaning_services, color: Colors.orange),
        ],
      ),
      CategoryModel(
        id: 'construction',
        name: 'Construction & Materials',
        icon: Icons.construction,
        color: Colors.brown,
        subcategories: [
          SubcategoryModel(id: 'hardware', name: 'Hardware & Cement', icon: Icons.hardware, color: Colors.brown),
          SubcategoryModel(id: 'tiles', name: 'Tiles & Sanitary', icon: Icons.square_foot, color: Colors.brown),
          SubcategoryModel(id: 'paint', name: 'Paint & Polish Shops', icon: Icons.palette, color: Colors.brown),
          SubcategoryModel(id: 'glass', name: 'Glass & Fabrication', icon: Icons.window, color: Colors.brown),
          SubcategoryModel(id: 'contractors', name: 'Construction Contractors', icon: Icons.engineering, color: Colors.brown),
        ],
      ),
      CategoryModel(
        id: 'health',
        name: 'Health & Medical',
        icon: Icons.medical_services,
        color: Colors.red,
        subcategories: [
          SubcategoryModel(id: 'hospitals', name: 'Hospitals', icon: Icons.local_hospital, color: Colors.red),
          SubcategoryModel(id: 'clinics', name: 'Clinics', icon: Icons.medical_information, color: Colors.red),
          SubcategoryModel(id: 'labs', name: 'Diagnostic Labs', icon: Icons.science, color: Colors.red),
          SubcategoryModel(id: 'pharmacy', name: 'Pharmacies', icon: Icons.local_pharmacy, color: Colors.red),
          SubcategoryModel(id: 'doctors', name: 'Specialist Doctors', icon: Icons.person, color: Colors.red),
        ],
      ),
      CategoryModel(
        id: 'food',
        name: 'Food & Restaurants',
        icon: Icons.restaurant,
        color: Colors.deepOrange,
        subcategories: [
          SubcategoryModel(id: 'tiffins', name: 'Tiffins & Street Food', icon: Icons.lunch_dining, color: Colors.deepOrange),
          SubcategoryModel(id: 'restaurants', name: 'Restaurants', icon: Icons.restaurant_menu, color: Colors.deepOrange),
          SubcategoryModel(id: 'bakery', name: 'Bakeries & Snacks', icon: Icons.bakery_dining, color: Colors.deepOrange),
          SubcategoryModel(id: 'mess', name: 'Curry Points / Mess', icon: Icons.food_bank, color: Colors.deepOrange),
          SubcategoryModel(id: 'catering', name: 'Catering Services', icon: Icons.event_seat, color: Colors.deepOrange),
        ],
      ),
      CategoryModel(
        id: 'education',
        name: 'Education',
        icon: Icons.school,
        color: Colors.blue,
        subcategories: [
          SubcategoryModel(id: 'schools', name: 'Schools', icon: Icons.school, color: Colors.blue),
          SubcategoryModel(id: 'colleges', name: 'Colleges', icon: Icons.account_balance, color: Colors.blue),
          SubcategoryModel(id: 'tuition', name: 'Tuition Centers', icon: Icons.menu_book, color: Colors.blue),
          SubcategoryModel(id: 'computer', name: 'Computer Training', icon: Icons.computer, color: Colors.blue),
          SubcategoryModel(id: 'coaching', name: 'Coaching Centers', icon: Icons.sports_esports, color: Colors.blue),
        ],
      ),
      CategoryModel(
        id: 'professionals',
        name: 'Professionals',
        icon: Icons.business_center,
        color: Colors.indigo,
        subcategories: [
          SubcategoryModel(id: 'lawyers', name: 'Lawyers', icon: Icons.gavel, color: Colors.indigo),
          SubcategoryModel(id: 'engineers', name: 'Engineers', icon: Icons.engineering, color: Colors.indigo),
          SubcategoryModel(id: 'writers', name: 'Document Writers', icon: Icons.edit_document, color: Colors.indigo),
          SubcategoryModel(id: 'astrologers', name: 'Astrologers', icon: Icons.star, color: Colors.indigo),
          SubcategoryModel(id: 'consultants', name: 'Consultants', icon: Icons.psychology, color: Colors.indigo),
        ],
      ),
      CategoryModel(
        id: 'events',
        name: 'Events & Lifestyle',
        icon: Icons.event,
        color: Colors.purple,
        subcategories: [
          SubcategoryModel(id: 'halls', name: 'Function Halls', icon: Icons.event_seat, color: Colors.purple),
          SubcategoryModel(id: 'management', name: 'Event Management', icon: Icons.event_available, color: Colors.purple),
          SubcategoryModel(id: 'decorators', name: 'Decorators', icon: Icons.celebration, color: Colors.purple),
          SubcategoryModel(id: 'photographers', name: 'Photographers', icon: Icons.camera_alt, color: Colors.purple),
          SubcategoryModel(id: 'beauty', name: 'Beauty Parlors & Salons', icon: Icons.face, color: Colors.purple),
        ],
      ),
      CategoryModel(
        id: 'travel',
        name: 'Travel & Transport',
        icon: Icons.directions_car,
        color: Colors.teal,
        subcategories: [
          SubcategoryModel(id: 'auto', name: 'Auto Drivers', icon: Icons.motorcycle, color: Colors.teal),
          SubcategoryModel(id: 'cabs', name: 'Cabs & Taxi Services', icon: Icons.local_taxi, color: Colors.teal),
          SubcategoryModel(id: 'bus', name: 'Bus Depots & Timings', icon: Icons.directions_bus, color: Colors.teal),
          SubcategoryModel(id: 'tours', name: 'Travels & Tours', icon: Icons.tour, color: Colors.teal),
          SubcategoryModel(id: 'transport', name: 'Goods Transport', icon: Icons.local_shipping, color: Colors.teal),
        ],
      ),
      CategoryModel(
        id: 'local_services',
        name: 'Local Services',
        icon: Icons.local_laundry_service,
        color: Colors.cyan,
        subcategories: [
          SubcategoryModel(id: 'laundry', name: 'Laundry', icon: Icons.local_laundry_service, color: Colors.cyan),
          SubcategoryModel(id: 'tailors', name: 'Tailors', icon: Icons.content_cut, color: Colors.cyan),
          SubcategoryModel(id: 'barbers', name: 'Barbers', icon: Icons.content_cut, color: Colors.cyan),
          SubcategoryModel(id: 'watch_repair', name: 'Watch/Clock Repair', icon: Icons.watch, color: Colors.cyan),
          SubcategoryModel(id: 'mobile_repair', name: 'Mobile/Computer Repair', icon: Icons.phone_android, color: Colors.cyan),
        ],
      ),
      CategoryModel(
        id: 'religious',
        name: 'Religious & Community',
        icon: Icons.temple_hindu,
        color: Colors.amber,
        subcategories: [
          SubcategoryModel(id: 'temples', name: 'Temples', icon: Icons.temple_hindu, color: Colors.amber),
          SubcategoryModel(id: 'churches', name: 'Churches', icon: Icons.church, color: Colors.amber),
          SubcategoryModel(id: 'mosques', name: 'Mosques', icon: Icons.mosque, color: Colors.amber),
          SubcategoryModel(id: 'community', name: 'Community Halls', icon: Icons.groups, color: Colors.amber),
          SubcategoryModel(id: 'events', name: 'Religious Events', icon: Icons.event, color: Colors.amber),
        ],
      ),
      CategoryModel(
        id: 'government',
        name: 'Government & Notices',
        icon: Icons.account_balance,
        color: Colors.grey,
        subcategories: [
          SubcategoryModel(id: 'power', name: 'Power Cuts', icon: Icons.power, color: Colors.grey),
          SubcategoryModel(id: 'water', name: 'Water Supply Updates', icon: Icons.water_drop, color: Colors.grey),
          SubcategoryModel(id: 'municipal', name: 'Municipal Notices', icon: Icons.notifications, color: Colors.grey),
          SubcategoryModel(id: 'banks', name: 'Banks (Holidays & Notices)', icon: Icons.account_balance, color: Colors.grey),
          SubcategoryModel(id: 'post', name: 'Post Office Services', icon: Icons.local_post_office, color: Colors.grey),
        ],
      ),
      CategoryModel(
        id: 'jobs',
        name: 'Jobs & Labour',
        icon: Icons.work,
        color: Colors.deepPurple,
        subcategories: [
          SubcategoryModel(id: 'alerts', name: 'Job Alerts', icon: Icons.notifications_active, color: Colors.deepPurple),
          SubcategoryModel(id: 'labour', name: 'Daily Labour Required', icon: Icons.construction, color: Colors.deepPurple),
          SubcategoryModel(id: 'agricultural', name: 'Agricultural Labour', icon: Icons.agriculture, color: Colors.deepPurple),
          SubcategoryModel(id: 'skilled', name: 'Skilled Worker Listings', icon: Icons.engineering, color: Colors.deepPurple),
          SubcategoryModel(id: 'internship', name: 'Internship & Training', icon: Icons.school, color: Colors.deepPurple),
        ],
      ),
      CategoryModel(
        id: 'resale',
        name: 'Resale & Rentals',
        icon: Icons.sell,
        color: Colors.pink,
        subcategories: [
          SubcategoryModel(id: 'second_hand', name: 'Second-hand Goods', icon: Icons.shopping_bag, color: Colors.pink),
          SubcategoryModel(id: 'rentals', name: 'House/Shop Rentals', icon: Icons.home, color: Colors.pink),
          SubcategoryModel(id: 'real_estate', name: 'Real Estate', icon: Icons.home_work, color: Colors.pink),
          SubcategoryModel(id: 'vehicle_rental', name: 'Vehicle Rentals', icon: Icons.directions_car, color: Colors.pink),
          SubcategoryModel(id: 'machinery', name: 'Machinery Rentals', icon: Icons.build, color: Colors.pink),
        ],
      ),
      CategoryModel(
        id: 'special',
        name: 'Special Sections',
        icon: Icons.star,
        color: Colors.orange,
        subcategories: [
          SubcategoryModel(id: 'melas', name: 'Melas & Fairs', icon: Icons.festival, color: Colors.orange),
          SubcategoryModel(id: 'health_camps', name: 'Health Camps', icon: Icons.medical_services, color: Colors.orange),
          SubcategoryModel(id: 'diet', name: 'Diet Food / Healthy Options', icon: Icons.restaurant_menu, color: Colors.orange),
          SubcategoryModel(id: 'cab_sharing', name: 'Cab Sharing', icon: Icons.car_rental, color: Colors.orange),
          SubcategoryModel(id: 'vendors', name: 'Street Vendors Daily Updates', icon: Icons.streetview, color: Colors.orange),
        ],
      ),
    ];
  }

  List<CategoryModel> getMainCategories() {
    return getAllCategories().take(5).toList(); // Show first 5 categories initially
  }
}
