import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String userPhotoUrl;

  // Constructor to accept user data
  AccountScreen({
    required this.userName,
    required this.userEmail,
    required this.userPhotoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account header section with avatar and user name/email
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: userPhotoUrl.isNotEmpty
                      ? NetworkImage(userPhotoUrl)
                      : AssetImage('assets/default_avatar.png') as ImageProvider, // Fallback image if no photo URL is available
                  child: userPhotoUrl.isEmpty
                      ? Icon(Icons.person, size: 40, color: Colors.white) // Default icon if no photo URL
                      : null,
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName, // Display the user's name
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      userEmail, // Display the user's email
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 24),

            // Account options list
            Expanded(
              child: ListView(
                children: [
                  _buildAccountOption(
                    icon: Icons.person,
                    title: "Profile Settings",
                    onTap: () {
                      // Action to navigate to profile settings
                    },
                  ),
                  _buildAccountOption(
                    icon: Icons.history,
                    title: "Order History",
                    onTap: () {
                      // Action to navigate to order history
                    },
                  ),
                  _buildAccountOption(
                    icon: Icons.settings,
                    title: "App Settings",
                    onTap: () {
                      // Action to navigate to app settings
                    },
                  ),
                  _buildAccountOption(
                    icon: Icons.help_outline,
                    title: "Help & Support",
                    onTap: () {
                      // Action to access help and support
                    },
                  ),
                  _buildAccountOption(
                    icon: Icons.logout,
                    title: "Log Out",
                    onTap: () {
                      // Action to log out
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for account options
  Widget _buildAccountOption({required IconData icon, required String title, required VoidCallback onTap}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.red),
        title: Text(title, style: TextStyle(fontSize: 18)),
        trailing: Icon(Icons.arrow_forward),
        onTap: onTap,
      ),
    );
  }
}
