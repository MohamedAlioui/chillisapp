import 'package:flutter/material.dart';
import '../models/panier.dart';
import '../models/commande.dart';
import '../service/cart_service.dart';
import '../service/user_service.dart';
import '../widgets/cart_item_list.dart';
import '../widgets/delivery_options.dart';
import '../widgets/order_form.dart';
import '../widgets/place_order_button.dart';
import '../widgets/error_dialog.dart';
import '../widgets/cart_loading.dart';
import '../widgets/cart_error.dart';
import '../utils/http_exception.dart';
import '../widgets/cart_error.dart';
import '../widgets/cart_loading.dart';
import '../models/menu_item.dart'; // MenuItem model
import 'item_detail_screen.dart'; // Page pour les détails des items

class CartScreen extends StatefulWidget {
  final String userId;
  final String? panierId;

  const CartScreen({
    super.key,
    required this.userId,
    this.panierId,
  });

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService _cartService = CartService();
  final UserService _userService = UserService();
  Future<Panier>? _panierFuture;
  final _commentController = TextEditingController();
  final _addressController = TextEditingController();
  String _selectedDeliveryType = 'pickup';
  bool _isLoading = false;
  String? _currentPanierId;

  @override
  void initState() {
    super.initState();
    _initializeCart();
  }

  Future<void> _initializeCart() async {
    try {
      String panierId;
      if (widget.panierId != null && widget.panierId!.isNotEmpty) {
        panierId = widget.panierId!;
      } else {
        panierId = await _userService.fetchUserPanierId(widget.userId);
      }

      if (mounted) {
        setState(() {
          _currentPanierId = panierId;
          _panierFuture = _cartService.getPanierById(panierId);
        });
      }
    } on HttpException catch (e) {
      if (mounted) {
        _showError(e.toString());
      }
    } catch (e) {
      if (mounted) {
        _showError('Failed to initialize cart: ${e.toString()}');
      }
    }
  }

  Future<void> _loadCart() async {
    try {
      String panierId;
      if (_currentPanierId != null && _currentPanierId!.isNotEmpty) {
        panierId = _currentPanierId!;
      } else {
        panierId = await _userService.fetchUserPanierId(widget.userId);
        _currentPanierId = panierId;
      }

      final updatedPanier = await _cartService.getPanierById(panierId);

      if (mounted) {
        setState(() {
          _panierFuture = Future.value(updatedPanier);
        });
      }
    } catch (e) {
      print('Error loading cart: $e'); // Debugging
      if (mounted) {
        _showError('Failed to load cart: ${e.toString()}');
      }
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => ErrorDialog(message: message),
    );
  }

  Future<void> _placeOrder(Panier panier) async {
    if (_selectedDeliveryType == 'delivery' &&
        _addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a delivery address')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final commande = Commande(
        clientId: widget.userId,
        items: panier.items,
        total: panier.total,
        localisationResto:
            _selectedDeliveryType == 'pickup' ? "Restaurant B" : "",
        etat: "pending",
        typeCommande: _selectedDeliveryType,
        commentaire: _commentController.text,
        adresseLivraison:
            _selectedDeliveryType == 'delivery' ? _addressController.text : "",
      );

      print('Sending order: ${commande.toJson()}'); // Debugging

      final createdCommande =
          await _cartService.createCommandeFromPanier(panier.id, commande);

      print('Order created: ${createdCommande.toJson()}'); // Debugging

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order placed successfully!')),
      );

      _loadCart(); // Recharger le panier après avoir passé la commande
    } catch (e) {
      print('Error during order placement: $e'); // Debugging
      _showError('Failed to place order: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildCartContent(Panier panier) {
    const List<String> restaurantLocations = [
      'Chilis El Manar',
      'Chilis Les Berge du Lac',
    ];

    if (panier.items.isEmpty) {
      return Center(
        child: Text(
          'Your cart is empty!',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CartItemList(
            items: panier.items,
            total: panier.total,
          ),
          const SizedBox(height: 16),
          DeliveryOptions(
            selectedType: _selectedDeliveryType,
            onTypeChanged: (value) {
              setState(() {
                _selectedDeliveryType = value ?? 'pickup';
              });
            },
          ),
          const SizedBox(height: 16),
          OrderForm(
            commentController: _commentController,
            addressController: _addressController,
            selectedDeliveryType: _selectedDeliveryType,
            restaurantLocations: restaurantLocations, // Pass the list here
          ),
          const SizedBox(height: 24),
          PlaceOrderButton(
            onPressed: () => _placeOrder(panier),
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
      ),
      body: _panierFuture == null
          ? const CartLoading()
          : FutureBuilder<Panier>(
              future: _panierFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CartLoading();
                }

                if (snapshot.hasError) {
                  print('Error: ${snapshot.error}'); // Debugging
                  return CartError(
                    error: snapshot.error.toString(),
                    onRetry: _loadCart,
                  );
                }

                if (!snapshot.hasData) {
                  print('Snapshot has no data'); // Debugging
                  return CartError(
                    error: 'Cart not found',
                    onRetry: _loadCart,
                  );
                }

                print('Cart Data: ${snapshot.data}'); // Debugging
                return _buildCartContent(snapshot.data!);
              },
            ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
