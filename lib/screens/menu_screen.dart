import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/category.dart';
import '../models/menu_item.dart';

class MenuScreen extends StatefulWidget {
  final String userEmail;
  final String userName;
  final String userPhotoUrl;
  final String userId;

  const MenuScreen({
    Key? key,
    required this.userEmail,
    required this.userName,
    required this.userPhotoUrl,
    required this.userId,
  }) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final String categoryApiUrl = 'http://10.0.2.2:9092/api/categories';
  final String menuItemsApiUrl = 'http://10.0.2.2:9092/api/menuItems';
  final String panierApiUrl = 'http://10.0.2.2:9092/api/paniers';
  final String clientApiUrl = 'http://10.0.2.2:9092/api/clients'; // New API for client data

  List<Category> categories = [];
  Map<String, List<MenuItem>> categoryItemsMap = {};
  String selectedCategoryId = '';
  String userPanierId = ''; // Store the user's active Panier ID.

  @override
  void initState() {
    super.initState();
    initializeScreen();
  }


  Future<void> fetchCategoriesAndItems() async {
    try {
      // Fetch categories
      final categoryResponse = await http.get(Uri.parse(categoryApiUrl));
      if (categoryResponse.statusCode == 200) {
        List<dynamic> categoryJsonData = json.decode(categoryResponse.body);
        categories = categoryJsonData
            .map((item) => Category.fromJson(item))
            .where((category) => category.etat == "active")
            .toList();

        selectedCategoryId = categories.isNotEmpty ? categories[0].idCategorie : '';
      } else {
        throw Exception('Failed to load categories');
      }

      // Fetch menu items
      final itemsResponse = await http.get(Uri.parse(menuItemsApiUrl));
      if (itemsResponse.statusCode == 200) {
        List<dynamic> itemsJsonData = json.decode(itemsResponse.body);
        List<MenuItem> allItems =
        itemsJsonData.map((item) => MenuItem.fromJson(item)).toList();

        // Map menu items to their categories
        for (var category in categories) {
          categoryItemsMap[category.idCategorie] = allItems
              .where((item) => item.categoryId == category.idCategorie)
              .toList();
        }

        setState(() {});
      } else {
        throw Exception('Failed to load menu items');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }
  Future<void> fetchUserData() async {
    try {
      final userResponse = await http.get(Uri.parse('$clientApiUrl/${widget.userId}'));
      if (userResponse.statusCode == 200) {
        final userData = json.decode(userResponse.body); // Parse JSON response
        userPanierId = userData['panierId']; // Extract Panier ID
        print('$clientApiUrl/${widget.userId}');
        if (userPanierId == null || userPanierId.isEmpty) {
          throw Exception('User does not have an active  ${widget.userId}');
        }
      } else {
        throw Exception('Failed to fetch user data: ${userResponse.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching user data: $e');

      // Show an error dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Failed to fetch user data. Please    $clientApiUrl/${widget.userId}  ${widget.userId} try again."),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );

      // Optionally, throw an exception or navigate
      throw Exception('Error fetching user data');
    }
  }
  Future<void> fetchUserPanier() async {
    try {
      // Fetch the user's active Panier.
      final panierResponse = await http.get(Uri.parse('$panierApiUrl/user/${widget.userId}'));
      if (panierResponse.statusCode == 200) {
        final panierData = json.decode(panierResponse.body);
        userPanierId = panierData['id']; // Extract the Panier ID.
      } else {
        throw Exception('Failed to fetch user panier');
      }
    } catch (e) {
      print('Error fetching user panier: $e');
    }
  }

  Future<void> addToPanier(MenuItem menuItem) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:9092/api/paniers/$userPanierId/items'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "menuItemId": menuItem.idItem,
          "quantity": 1, // Fixed quantity for now.
        }),
      );

      if (response.statusCode == 200) {
        // Notify success with SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${menuItem.nom} added to $userPanierId successfully!"),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green, // Success color
          ),
        );
        // Optionally, you can update your cart state here
        // e.g., Provider.of<CartProvider>(context, listen: false).addItem(...);
      } else {
        // Log the response body for debugging
        print('Response body: ${response.body}');

        // Notify failure if something goes wrong
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to add ${menuItem.nom} to ${userPanierId}."),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red, // Error color
          ),
        );
        throw Exception('Failed to add item to panier');
      }
    } catch (e) {
      print('Error adding item to panier: $e');
      // Notify failure if there is an exception
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An error occurred. Please try again."),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red, // Error color
        ),
      );
    }
  }
  Future<void> initializeScreen() async {
    await fetchUserData(); // Fetch user-specific data first
    await fetchUserPanier();
    await fetchCategoriesAndItems();// Fetch the user's active Panier.
  }

  void selectCategory(String categoryId) {
    setState(() {
      selectedCategoryId = categoryId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chili's America's Grill"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category navigation bar
          Container(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return GestureDetector(
                  onTap: () => selectCategory(category.idCategorie),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 2,
                          color: selectedCategoryId == category.idCategorie
                              ? Colors.red
                              : Colors.transparent,
                        ),
                      ),
                    ),
                    child: Text(
                      category.categorie,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: selectedCategoryId == category.idCategorie
                            ? Colors.red
                            : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(),
          // List of categories and items
          Expanded(
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final items = categoryItemsMap[category.idCategorie] ?? [];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category title
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        category.categorie,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    // List of items
                    items.isEmpty
                        ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text("No items available in this category."),
                    )
                        : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: items.length,
                      itemBuilder: (context, itemIndex) {
                        final menuItem = items[itemIndex];
                        return Card(
                          margin: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: ListTile(
                            leading: menuItem.image != null
                                ? Image.network(
                              menuItem.image!,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            )
                                : Icon(Icons.image_not_supported, size: 60),
                            title: Text(menuItem.nom),
                            subtitle: Text("${menuItem.prix} DT"),
                            trailing: IconButton(
                              icon: Icon(Icons.shopping_cart),
                              color: Colors.green,
                              onPressed: () => addToPanier(menuItem),
                            ),
                          ),
                        );
                      },
                    ),
                  ],

                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
