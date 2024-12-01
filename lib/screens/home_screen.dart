import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/category.dart';
import '../widgets/category_item.dart';
import 'account_screen.dart';
import 'cart_screen.dart';
import 'menu_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userEmail;
  final String userName;
  final String userPhotoUrl;
  final String userId;
  final String panierId;

  const HomeScreen({
    required this.userEmail,
    required this.userName,
    required this.userPhotoUrl,
    required this.userId,
    required this.panierId,

    Key? key,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String apiUrl = 'http://localhost:9092/api/categories';
  int _selectedIndex = 0;

  late final Widget homeScreenWidget; // Declare the home screen widget
  late final List<Widget> _screens; // Declare the list of screens

  @override
  void initState() {
    super.initState();

    // Initialize the static home screen widget
    homeScreenWidget = buildHomeScreen();

    // Initialize the screens with the properly initialized homeScreenWidget
    _screens = [
      homeScreenWidget,
      MenuScreen(
        userEmail: widget.userEmail,
        userName: widget.userName,
        userPhotoUrl: widget.userPhotoUrl,
        userId: widget.userId,
      ),
      CartScreen(
        userId: widget.userId,
        panierId: widget.panierId,

      ),
      AccountScreen(
        userEmail: widget.userEmail,
        userName: widget.userName,
        userPhotoUrl: widget.userPhotoUrl,

      ),
    ];
  }

  // Fetch categories from the API
  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => Category.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Widget buildHomeScreen() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Logged in as: ${widget.userEmail}", style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              hintText: "Search",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Categories",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(onPressed: () {}, child: const Text("See all")),
            ],
          ),
          const SizedBox(height: 8),
          FutureBuilder<List<Category>>(
            future: fetchCategories(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Failed to load categories."),
                      ElevatedButton(
                        onPressed: () => setState(() {}),
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("No categories available."));
              } else {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: snapshot.data!
                        .map((category) => CategoryItem(category: category))
                        .toList(),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome, ${widget.userName}"),
        actions: [
          CircleAvatar(
            backgroundImage: widget.userPhotoUrl.isNotEmpty
                ? NetworkImage(widget.userPhotoUrl)
                : AssetImage('assets/default_avatar.png') as ImageProvider,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: _screens[_selectedIndex], // Dynamically switch screens
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: 28),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu, size: 28),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined, size: 28),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, size: 28),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
