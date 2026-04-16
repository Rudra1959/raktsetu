import 'package:flutter/material.dart';

/// App settings screen — language, theme, notifications, account.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          _SettingsSection(
            title: 'Account',
            items: [
              _SettingsTile(icon: Icons.person, title: 'Edit Profile'),
              _SettingsTile(icon: Icons.security, title: 'Privacy & Security'),
              _SettingsTile(icon: Icons.delete_outline, title: 'Delete Account',
                  textColor: Colors.red),
            ],
          ),
          _SettingsSection(
            title: 'Preferences',
            items: [
              _SettingsTile(icon: Icons.language, title: 'Language'),
              _SettingsTile(icon: Icons.dark_mode, title: 'Dark Mode'),
              _SettingsTile(icon: Icons.notifications, title: 'Notifications'),
            ],
          ),
          _SettingsSection(
            title: 'About',
            items: [
              _SettingsTile(icon: Icons.info, title: 'About RaktSetu'),
              _SettingsTile(icon: Icons.policy, title: 'Privacy Policy'),
              _SettingsTile(icon: Icons.description, title: 'Terms of Service'),
              _SettingsTile(icon: Icons.help, title: 'Help & Support'),
            ],
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.logout),
              label: const Text('Sign Out'),
              style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
            ),
          ),
          const SizedBox(height: 32),
          Center(
            child: Text(
              'RaktSetu v1.0.0',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<_SettingsTile> items;
  const _SettingsSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
          child: Text(title, style: const TextStyle(
            fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey,
          )),
        ),
        ...items.map((item) => ListTile(
          leading: Icon(item.icon, color: item.textColor),
          title: Text(item.title, style: TextStyle(color: item.textColor)),
          trailing: const Icon(Icons.chevron_right, size: 20),
          onTap: () {},
        )),
      ],
    );
  }
}

class _SettingsTile {
  final IconData icon;
  final String title;
  final Color? textColor;
  const _SettingsTile({required this.icon, required this.title, this.textColor});
}
