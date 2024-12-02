import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api_config.dart';
import '../utils/http_exception.dart';

class ProfileSettingsScreen extends StatefulWidget {
  final String userId;

  const ProfileSettingsScreen({Key? key, required this.userId})
      : super(key: key);

  @override
  _ProfileSettingsScreenState createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/clients/${widget.userId}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _nameController.text = data['nom'] ?? '';
          _emailController.text = data['email'] ?? '';
          _phoneController.text = data['phone'] ?? '';
        });
      } else {
        throw HttpException('Failed to load user data $widget.userId');
      }
    } catch (e) {
      _showErrorSnackBar('Failed to load user data');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/api/clients/${widget.userId}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': _nameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
        }),
      );

      if (response.statusCode == 200) {
        _showSuccessSnackBar('Profile updated successfully');
      } else {
        throw HttpException('Failed to update profile');
      }
    } catch (e) {
      _showErrorSnackBar('Failed to update profile');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Settings'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTextFormField(
                      controller: _nameController,
                      labelText: 'Name',
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter your name' : null,
                    ),
                    SizedBox(height: 16),
                    _buildTextFormField(
                      controller: _emailController,
                      labelText: 'Email',
                      validator: (value) {
                        if (value!.isEmpty) return 'Please enter your email';
                        if (!value.contains('@'))
                          return 'Please enter a valid email';
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    _buildTextFormField(
                      controller: _phoneController,
                      labelText: 'Phone',
                      validator: (value) => value!.isEmpty
                          ? 'Please enter your phone number'
                          : null,
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _updateProfile,
                      child: Text('Save Changes'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
      validator: validator,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
