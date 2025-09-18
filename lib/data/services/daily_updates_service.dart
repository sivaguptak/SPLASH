import '../models/daily_update.dart';

class DailyUpdatesService {
  static final List<DailyUpdate> _allUpdates = [
    // 1. Banks - Holiday list, important public info
    DailyUpdate(
      id: 'bank_1',
      title: 'Bank Holiday Notice',
      description: 'All banks will remain closed on 15th August for Independence Day. ATM services will be available.',
      category: 'Banks',
      subcategory: 'Holiday Notice',
      location: 'All Locations',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      source: 'State Bank of India',
      isUrgent: true,
      contactInfo: '1800-123-4567',
    ),
    DailyUpdate(
      id: 'bank_2',
      title: 'New Banking Hours',
      description: 'Banking hours changed to 9:30 AM - 3:30 PM from Monday to Friday. Saturday: 9:30 AM - 1:30 PM',
      category: 'Banks',
      subcategory: 'Service Update',
      location: 'Chintalapudi',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      source: 'Canara Bank',
      contactInfo: '9876543210',
    ),

    // 2. Bus Depots - Bus timings and route details
    DailyUpdate(
      id: 'bus_1',
      title: 'New Bus Route to Vijayawada',
      description: 'New direct bus service from Chintalapudi to Vijayawada. Departure: 6:00 AM, 12:00 PM, 6:00 PM',
      category: 'Bus Depots',
      subcategory: 'New Route',
      location: 'Chintalapudi Bus Stand',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      source: 'APSRTC',
      additionalData: {'fare': '₹120', 'duration': '2.5 hours'},
      contactInfo: '1800-200-4598',
    ),
    DailyUpdate(
      id: 'bus_2',
      title: 'Bus Timing Changes',
      description: 'Eluru route buses will depart 30 minutes earlier due to traffic conditions',
      category: 'Bus Depots',
      subcategory: 'Schedule Update',
      location: 'All Bus Stands',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      source: 'APSRTC',
      contactInfo: '1800-200-4598',
    ),

    // 3. Schools - Holiday info, notices for parents
    DailyUpdate(
      id: 'school_1',
      title: 'School Reopening Notice',
      description: 'Schools will reopen on 1st September. Parents are requested to submit health certificates.',
      category: 'Schools',
      subcategory: 'Reopening Notice',
      location: 'All Schools',
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      source: 'District Education Office',
      isUrgent: true,
      contactInfo: '9876543211',
    ),
    DailyUpdate(
      id: 'school_2',
      title: 'Parent-Teacher Meeting',
      description: 'PTM scheduled for 25th August at 10:00 AM. All parents are requested to attend.',
      category: 'Schools',
      subcategory: 'Meeting Notice',
      location: 'ZP High School, Chintalapudi',
      timestamp: DateTime.now().subtract(const Duration(hours: 6)),
      source: 'ZP High School',
      contactInfo: '9876543212',
    ),

    // 4. Auto Drivers - Daily departure schedules to nearby villages
    DailyUpdate(
      id: 'auto_1',
      title: 'Village Auto Schedule',
      description: 'Auto services to Pragadavaram: Every 30 minutes from 6 AM to 8 PM. Fare: ₹25',
      category: 'Auto Drivers',
      subcategory: 'Village Schedule',
      location: 'Chintalapudi Auto Stand',
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      source: 'Auto Drivers Association',
      additionalData: {'fare': '₹25', 'frequency': 'Every 30 minutes'},
      contactInfo: '9876543213',
    ),
    DailyUpdate(
      id: 'auto_2',
      title: 'Night Auto Service',
      description: 'Night auto service available till 11 PM to Lingapalem and Dharmajigudem',
      category: 'Auto Drivers',
      subcategory: 'Extended Hours',
      location: 'Chintalapudi',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      source: 'Auto Drivers Association',
      contactInfo: '9876543214',
    ),

    // 5. Religious Institutions - Events, religious festival updates
    DailyUpdate(
      id: 'religious_1',
      title: 'Krishna Janmashtami Celebrations',
      description: 'Special prayers and cultural programs at Sri Venkateswara Temple from 6 PM to 10 PM',
      category: 'Religious Institutions',
      subcategory: 'Festival Update',
      location: 'Sri Venkateswara Temple, Chintalapudi',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      source: 'Temple Committee',
      additionalData: {'date': 'August 18th', 'time': '6 PM - 10 PM'},
      contactInfo: '9876543215',
    ),
    DailyUpdate(
      id: 'religious_2',
      title: 'Weekly Satsang',
      description: 'Weekly spiritual gathering every Sunday at 7 PM. All devotees welcome.',
      category: 'Religious Institutions',
      subcategory: 'Regular Event',
      location: 'Ramakrishna Mission, Eluru',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      source: 'Ramakrishna Mission',
      contactInfo: '9876543216',
    ),

    // 6. Government Departments
    DailyUpdate(
      id: 'govt_1',
      title: 'Power Cut Schedule',
      description: 'Power cut scheduled for maintenance on 20th August from 9 AM to 2 PM in Chintalapudi area',
      category: 'Government Departments',
      subcategory: 'Power Department',
      location: 'Chintalapudi',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      source: 'APEPDCL',
      isUrgent: true,
      contactInfo: '1912',
    ),
    DailyUpdate(
      id: 'govt_2',
      title: 'Water Supply Update',
      description: 'Water supply will be available from 6 AM to 8 AM and 6 PM to 8 PM daily',
      category: 'Government Departments',
      subcategory: 'Water Supply',
      location: 'All Areas',
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      source: 'Municipal Water Department',
      contactInfo: '9876543217',
    ),
    DailyUpdate(
      id: 'govt_3',
      title: 'Health Camp Announcement',
      description: 'Free health camp at Government Hospital on 22nd August. Blood pressure, diabetes checkup available',
      category: 'Government Departments',
      subcategory: 'Health Department',
      location: 'Government Hospital, Chintalapudi',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      source: 'District Health Office',
      additionalData: {'date': 'August 22nd', 'time': '9 AM - 4 PM'},
      contactInfo: '9876543218',
    ),

    // 7. Local Businesses - Deals, digital coupons, local ads
    DailyUpdate(
      id: 'business_1',
      title: '50% Off on Electronics',
      description: 'Mega sale on all electronics at Tech World. Valid till 25th August. Use coupon: TECH50',
      category: 'Local Businesses',
      subcategory: 'Electronics Sale',
      location: 'Tech World, Eluru',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      source: 'Tech World',
      additionalData: {'discount': '50%', 'valid_till': 'August 25th'},
      contactInfo: '9876543219',
    ),
    DailyUpdate(
      id: 'business_2',
      title: 'New Restaurant Opening',
      description: 'Spice Garden Restaurant opening in Chintalapudi. 20% off on first week orders',
      category: 'Local Businesses',
      subcategory: 'Restaurant',
      location: 'Main Road, Chintalapudi',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      source: 'Spice Garden Restaurant',
      additionalData: {'discount': '20%', 'valid_till': 'August 30th'},
      contactInfo: '9876543220',
    ),

    // 8. Job Alerts - Daily job alerts (local/state/national)
    DailyUpdate(
      id: 'job_1',
      title: 'Government Job Openings',
      description: 'AP Police recruitment 2024. 1000+ vacancies. Last date: 30th August. Apply online at apslrb.gov.in',
      category: 'Job Alerts',
      subcategory: 'Government Jobs',
      location: 'Andhra Pradesh',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      source: 'APSLRB',
      isUrgent: true,
      additionalData: {'vacancies': '1000+', 'last_date': 'August 30th'},
      contactInfo: '1800-425-1234',
    ),
    DailyUpdate(
      id: 'job_2',
      title: 'Private Sector Jobs',
      description: 'IT companies hiring in Vijayawada. Software developers, testers needed. Walk-in interview on 25th August',
      category: 'Job Alerts',
      subcategory: 'Private Jobs',
      location: 'Vijayawada',
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      source: 'Job Portal',
      additionalData: {'interview_date': 'August 25th', 'positions': 'Software Developer, Tester'},
      contactInfo: '9876543221',
    ),

    // 9. Town Re-sale - Second-hand product listings (OLX style)
    DailyUpdate(
      id: 'resale_1',
      title: 'Second-hand Bike for Sale',
      description: 'Bajaj Pulsar 150, 2020 model, 15,000 km run. Well maintained. Price: ₹45,000. Contact for details',
      category: 'Town Re-sale',
      subcategory: 'Vehicles',
      location: 'Chintalapudi',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      source: 'Local Seller',
      additionalData: {'price': '₹45,000', 'year': '2020', 'km': '15,000'},
      contactInfo: '9876543222',
    ),
    DailyUpdate(
      id: 'resale_2',
      title: 'Furniture Sale',
      description: 'Complete home furniture for sale. Sofa set, dining table, beds available. Good condition',
      category: 'Town Re-sale',
      subcategory: 'Furniture',
      location: 'Eluru',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      source: 'Local Seller',
      contactInfo: '9876543223',
    ),

    // 10. Travel Information - Cab sharing and return ride details
    DailyUpdate(
      id: 'travel_1',
      title: 'Cab Sharing to Hyderabad',
      description: 'Cab sharing available to Hyderabad on 20th August. Departure: 6 AM. Fare: ₹800 per person',
      category: 'Travel Information',
      subcategory: 'Cab Sharing',
      location: 'Chintalapudi',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      source: 'Travel Agent',
      additionalData: {'date': 'August 20th', 'time': '6 AM', 'fare': '₹800'},
      contactInfo: '9876543224',
    ),
    DailyUpdate(
      id: 'travel_2',
      title: 'Return Ride Available',
      description: 'Return ride from Vijayawada to Chintalapudi available. Contact for pickup time and location',
      category: 'Travel Information',
      subcategory: 'Return Ride',
      location: 'Vijayawada to Chintalapudi',
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      source: 'Local Driver',
      contactInfo: '9876543225',
    ),

    // 11. Daily Labour Required Section
    DailyUpdate(
      id: 'labour_1',
      title: 'Construction Workers Needed',
      description: 'Construction site in Eluru needs 10 workers. Daily wage: ₹800. Contact immediately',
      category: 'Daily Labour Required',
      subcategory: 'Construction',
      location: 'Eluru',
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      source: 'Contractor',
      additionalData: {'workers_needed': '10', 'daily_wage': '₹800'},
      contactInfo: '9876543226',
    ),
    DailyUpdate(
      id: 'labour_2',
      title: 'Farm Workers Required',
      description: 'Farm work available in Dharmajigudem. Rice harvesting. Daily wage: ₹600',
      category: 'Daily Labour Required',
      subcategory: 'Agriculture',
      location: 'Dharmajigudem',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      source: 'Farmer',
      additionalData: {'work_type': 'Rice Harvesting', 'daily_wage': '₹600'},
      contactInfo: '9876543227',
    ),

    // 12. Daily foods - curry points, restaurants, tiffin hotels, street food
    DailyUpdate(
      id: 'food_1',
      title: 'Today\'s Special Curry',
      description: 'Chicken curry, mutton curry, and fish curry available at Spice Point. Fresh and hot',
      category: 'Daily Foods',
      subcategory: 'Curry Points',
      location: 'Spice Point, Chintalapudi',
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      source: 'Spice Point',
      additionalData: {'special_items': ['Chicken Curry', 'Mutton Curry', 'Fish Curry']},
      contactInfo: '9876543228',
    ),
    DailyUpdate(
      id: 'food_2',
      title: 'Street Food Festival',
      description: 'Street food festival at Main Road today. Pani puri, samosa, chaat available till 10 PM',
      category: 'Daily Foods',
      subcategory: 'Street Food',
      location: 'Main Road, Chintalapudi',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      source: 'Street Vendors',
      additionalData: {'time': 'Till 10 PM', 'items': ['Pani Puri', 'Samosa', 'Chaat']},
      contactInfo: '9876543229',
    ),

    // 13. Daily - fresh veg, fresh fruits, fresh meat
    DailyUpdate(
      id: 'daily_1',
      title: 'Fresh Vegetables Today',
      description: 'Fresh tomatoes, onions, potatoes, and leafy vegetables available at vegetable market',
      category: 'Daily Essentials',
      subcategory: 'Fresh Vegetables',
      location: 'Vegetable Market, Chintalapudi',
      timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
      source: 'Vegetable Vendors',
      additionalData: {'items': ['Tomatoes', 'Onions', 'Potatoes', 'Leafy Vegetables']},
      contactInfo: '9876543230',
    ),
    DailyUpdate(
      id: 'daily_2',
      title: 'Fresh Fruits Available',
      description: 'Mangoes, bananas, apples, and oranges available at fruit market. Sweet and fresh',
      category: 'Daily Essentials',
      subcategory: 'Fresh Fruits',
      location: 'Fruit Market, Chintalapudi',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      source: 'Fruit Vendors',
      additionalData: {'items': ['Mangoes', 'Bananas', 'Apples', 'Oranges']},
      contactInfo: '9876543231',
    ),
    DailyUpdate(
      id: 'daily_3',
      title: 'Fresh Meat Available',
      description: 'Fresh chicken, mutton, and fish available at meat market. Hygienically prepared',
      category: 'Daily Essentials',
      subcategory: 'Fresh Meat',
      location: 'Meat Market, Chintalapudi',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      source: 'Meat Vendors',
      additionalData: {'items': ['Chicken', 'Mutton', 'Fish']},
      contactInfo: '9876543232',
    ),

    // 14. Street vendors today
    DailyUpdate(
      id: 'vendor_1',
      title: 'Mobile Repair Service',
      description: 'Mobile repair service available near bus stand. All brands serviced. Quick repair',
      category: 'Street Vendors Today',
      subcategory: 'Mobile Repair',
      location: 'Near Bus Stand, Chintalapudi',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      source: 'Mobile Repair Vendor',
      contactInfo: '9876543233',
    ),
    DailyUpdate(
      id: 'vendor_2',
      title: 'Key Making Service',
      description: 'Key making and duplicate service available. All types of keys made. Quick service',
      category: 'Street Vendors Today',
      subcategory: 'Key Making',
      location: 'Main Road, Chintalapudi',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      source: 'Key Maker',
      contactInfo: '9876543234',
    ),

    // 15. Health camp info - special doctors in city, regular doctors timings
    DailyUpdate(
      id: 'health_1',
      title: 'Specialist Doctor Visit',
      description: 'Cardiologist Dr. Rajesh Kumar visiting Chintalapudi on 25th August. Book appointment now',
      category: 'Health Camp Info',
      subcategory: 'Special Doctors',
      location: 'Chintalapudi Medical Center',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      source: 'Medical Center',
      additionalData: {'doctor': 'Dr. Rajesh Kumar', 'specialization': 'Cardiologist', 'date': 'August 25th'},
      contactInfo: '9876543235',
    ),
    DailyUpdate(
      id: 'health_2',
      title: 'Regular Doctor Timings',
      description: 'Dr. Srinivas available from 9 AM to 6 PM. Dr. Priya available from 10 AM to 4 PM',
      category: 'Health Camp Info',
      subcategory: 'Regular Doctors',
      location: 'Chintalapudi',
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      source: 'Local Doctors',
      additionalData: {'doctors': ['Dr. Srinivas: 9 AM - 6 PM', 'Dr. Priya: 10 AM - 4 PM']},
      contactInfo: '9876543236',
    ),

    // 16. Melas In town
    DailyUpdate(
      id: 'mela_1',
      title: 'Annual Village Fair',
      description: 'Annual village fair starting from 20th August. Games, food stalls, cultural programs',
      category: 'Melas In Town',
      subcategory: 'Village Fair',
      location: 'Village Ground, Chintalapudi',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      source: 'Village Committee',
      additionalData: {'start_date': 'August 20th', 'duration': '5 days'},
      contactInfo: '9876543237',
    ),

    // 17. BIRTH DAY & OTHER EVENTS OFFERS WITH WISHES FROM ENTERPRENUERS
    DailyUpdate(
      id: 'event_1',
      title: 'Birthday Special Offers',
      description: 'Birthday special 20% off at all restaurants. Show ID proof for discount. Valid today only',
      category: 'Birthday & Events',
      subcategory: 'Birthday Offers',
      location: 'All Restaurants',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      source: 'Restaurant Association',
      additionalData: {'discount': '20%', 'validity': 'Today only'},
      contactInfo: '9876543238',
    ),

    // 18. CONDOLENSES ORGANISED BY MANAVATHA
    DailyUpdate(
      id: 'condolence_1',
      title: 'Condolence Meeting',
      description: 'Condolence meeting for late Sri Ramana Rao at community hall. All are requested to attend',
      category: 'Condolences',
      subcategory: 'Condolence Meeting',
      location: 'Community Hall, Chintalapudi',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      source: 'Manavatha Organization',
      additionalData: {'person': 'Late Sri Ramana Rao', 'time': '6 PM'},
      contactInfo: '9876543239',
    ),

    // 19. Movies in town
    DailyUpdate(
      id: 'movie_1',
      title: 'Latest Movies in Theaters',
      description: 'New releases: "Pushpa 2", "Kalki 2898 AD" showing at Eluru Multiplex. Book tickets online',
      category: 'Movies in Town',
      subcategory: 'Theater Movies',
      location: 'Eluru Multiplex',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      source: 'Eluru Multiplex',
      additionalData: {'movies': ['Pushpa 2', 'Kalki 2898 AD']},
      contactInfo: '9876543240',
    ),

    // 20. Latest movies in otts
    DailyUpdate(
      id: 'ott_1',
      title: 'New OTT Releases',
      description: 'New releases on Netflix: "The Family Man 3", "Sacred Games 3". Available for streaming',
      category: 'Latest Movies in OTTs',
      subcategory: 'OTT Releases',
      location: 'Online Streaming',
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      source: 'Netflix',
      additionalData: {'platform': 'Netflix', 'movies': ['The Family Man 3', 'Sacred Games 3']},
      contactInfo: '1800-123-4567',
    ),

    // 21. Functions in function halls
    DailyUpdate(
      id: 'function_1',
      title: 'Wedding Function',
      description: 'Wedding function of Sri Venkat and Smt. Lakshmi at Grand Function Hall. All invited',
      category: 'Functions in Function Halls',
      subcategory: 'Wedding',
      location: 'Grand Function Hall, Eluru',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      source: 'Function Hall',
      additionalData: {'event': 'Wedding', 'couple': 'Sri Venkat & Smt. Lakshmi'},
      contactInfo: '9876543241',
    ),

    // 22. Digital pamphlets section - various mock pamphlets
    DailyUpdate(
      id: 'pamphlet_1',
      title: 'New Digital Pamphlet Available',
      description: 'Check out the new digital pamphlet for local businesses. Download and share with friends',
      category: 'Digital Pamphlets',
      subcategory: 'Business Pamphlets',
      location: 'All Locations',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      source: 'LOCSY App',
      additionalData: {'type': 'Business Pamphlet', 'downloadable': true},
      contactInfo: '9876543242',
    ),
  ];

  static List<DailyUpdate> getAllUpdates() {
    return List.from(_allUpdates);
  }

  static List<DailyUpdate> getUpdatesByCategory(String category) {
    return _allUpdates.where((update) => update.category == category).toList();
  }

  static List<DailyUpdate> getRecentUpdates({int limit = 10}) {
    final sortedUpdates = List.from(_allUpdates);
    sortedUpdates.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return sortedUpdates.take(limit).toList().cast<DailyUpdate>();
  }

  static List<DailyUpdate> getUrgentUpdates() {
    return _allUpdates.where((update) => update.isUrgent).toList();
  }

  static List<DailyUpdate> getUpdatesByLocation(String location) {
    return _allUpdates.where((update) => 
      update.location.toLowerCase().contains(location.toLowerCase())
    ).toList();
  }

  static List<DailyUpdateCategory> getCategoriesWithUpdates() {
    final Map<String, List<DailyUpdate>> categoryMap = {};
    
    for (final update in _allUpdates) {
      if (!categoryMap.containsKey(update.category)) {
        categoryMap[update.category] = [];
      }
      categoryMap[update.category]!.add(update);
    }

    return categoryMap.entries.map((entry) {
      return DailyUpdateCategory(
        name: entry.key,
        icon: _getCategoryIcon(entry.key),
        color: _getCategoryColor(entry.key),
        updates: entry.value,
      );
    }).toList();
  }

  static String _getCategoryIcon(String category) {
    switch (category) {
      case 'Banks':
        return '🏦';
      case 'Bus Depots':
        return '🚌';
      case 'Schools':
        return '🏫';
      case 'Auto Drivers':
        return '🛺';
      case 'Religious Institutions':
        return '🛕';
      case 'Government Departments':
        return '🏛️';
      case 'Local Businesses':
        return '🏪';
      case 'Job Alerts':
        return '💼';
      case 'Town Re-sale':
        return '🛒';
      case 'Travel Information':
        return '🚗';
      case 'Daily Labour Required':
        return '👷';
      case 'Daily Foods':
        return '🍽️';
      case 'Daily Essentials':
        return '🛍️';
      case 'Street Vendors Today':
        return '🛵';
      case 'Health Camp Info':
        return '🏥';
      case 'Melas In Town':
        return '🎪';
      case 'Birthday & Events':
        return '🎂';
      case 'Condolences':
        return '🕊️';
      case 'Movies in Town':
        return '🎬';
      case 'Latest Movies in OTTs':
        return '📺';
      case 'Functions in Function Halls':
        return '🎉';
      case 'Digital Pamphlets':
        return '📱';
      default:
        return '📢';
    }
  }

  static String _getCategoryColor(String category) {
    switch (category) {
      case 'Banks':
        return '#4CAF50';
      case 'Bus Depots':
        return '#2196F3';
      case 'Schools':
        return '#FF9800';
      case 'Auto Drivers':
        return '#9C27B0';
      case 'Religious Institutions':
        return '#FF5722';
      case 'Government Departments':
        return '#607D8B';
      case 'Local Businesses':
        return '#795548';
      case 'Job Alerts':
        return '#3F51B5';
      case 'Town Re-sale':
        return '#009688';
      case 'Travel Information':
        return '#E91E63';
      case 'Daily Labour Required':
        return '#FFC107';
      case 'Daily Foods':
        return '#FF5722';
      case 'Daily Essentials':
        return '#4CAF50';
      case 'Street Vendors Today':
        return '#9E9E9E';
      case 'Health Camp Info':
        return '#F44336';
      case 'Melas In Town':
        return '#E91E63';
      case 'Birthday & Events':
        return '#FF9800';
      case 'Condolences':
        return '#9E9E9E';
      case 'Movies in Town':
        return '#673AB7';
      case 'Latest Movies in OTTs':
        return '#3F51B5';
      case 'Functions in Function Halls':
        return '#FF5722';
      case 'Digital Pamphlets':
        return '#00BCD4';
      default:
        return '#FF7A00';
    }
  }
}
