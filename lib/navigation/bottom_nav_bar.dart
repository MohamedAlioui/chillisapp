import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/menu_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/account_screen.dart';

class BottomNavBar extends StatefulWidget {
  final String userEmail;
  final String userName;
  final String userPhotoUrl;
  final String userId;

  const BottomNavBar({
    Key? key,
    required this.userEmail,
    required this.userName,
    required this.userPhotoUrl,
    required this.userId
  }) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  // List of screens for navigation
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    _screens = [
      HomeScreen(
        userEmail: widget.userEmail,
        userName: widget.userName,
        userPhotoUrl: widget.userPhotoUrl,
        userId:widget.userId, panierId: '' ,
      ),
      MenuScreen(
        userEmail: widget.userEmail,
        userName: widget.userName,
        userPhotoUrl: widget.userPhotoUrl,
        userId: widget.userId,
      ),
      CartScreen(
        userEmail: widget.userEmail,
        userName: widget.userName,
        userPhotoUrl: widget.userPhotoUrl, panierId: '', userId: widget.userId,
      ),
      AccountScreen(
        userEmail: widget.userEmail,
        userName: widget.userName,
        userPhotoUrl: widget.userPhotoUrl,
      ),
    ];
  }

  // Update selected index when user taps a navigation item
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Body with IndexedStack to switch between different screens
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      // Bottom Navigation Bar
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
