import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile_settings_screen.dart';

class AccountScreen extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String userPhotoUrl;
  final String userId;

  AccountScreen({
    required this.userName,
    required this.userEmail,
    required this.userPhotoUrl,
    required this.userId,
  });

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: userPhotoUrl.isNotEmpty
                      ? NetworkImage(userPhotoUrl)
                      : AssetImage('assets/default_avatar.png')
                          as ImageProvider,
                  child: userPhotoUrl.isEmpty
                      ? Icon(Icons.person, size: 40, color: Colors.white)
                      : null,
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      userEmail,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: [
                  _buildAccountOption(
                    icon: Icons.person,
                    title: "Profile Settings",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileSettingsScreen(
                          userId: userId,
                        ),
                      ),
                    ),
                  ),
                  _buildAccountOption(
                    icon: Icons.history,
                    title: "Order History",
                    onTap: () {},
                  ),
                  _buildAccountOption(
                    icon: Icons.settings,
                    title: "App Settings",
                    onTap: () {},
                  ),
                  _buildAccountOption(
                    icon: Icons.help_outline,
                    title: "Help & Support",
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
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
