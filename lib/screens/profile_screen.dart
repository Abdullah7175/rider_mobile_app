import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);

    final isPasswordDialogOpen = useState(false);
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    final notificationsEnabled = useState(true);

    void updatePassword() {
      final password = passwordController.text;
      final confirmPassword = confirmPasswordController.text;

      if (password.length < 6) {
        Fluttertoast.showToast(msg: "Password must be at least 6 characters");
        return;
      }

      if (password != confirmPassword) {
        Fluttertoast.showToast(msg: "Passwords do not match");
        return;
      }

      Fluttertoast.showToast(msg: "Password updated successfully");
      passwordController.clear();
      confirmPasswordController.clear();
      isPasswordDialogOpen.value = false;
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Profile"),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authNotifier.logout();
              context.go('/login');
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.green[50],
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.green[500],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    auth.user ?? 'Unknown User',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Rider ID: ${auth.user?.toLowerCase().replaceAll(' ', '') ?? '01'}",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.lock_outline, color: Colors.grey[600]),
                  title: const Text("Change Password"),
                  trailing: Icon(Icons.chevron_right, color: Colors.grey[600]),
                  onTap: () => isPasswordDialogOpen.value = true,
                ),
                Divider(height: 1, color: Colors.grey[200]),
                SwitchListTile(
                  secondary: Icon(Icons.notifications_none, color: Colors.grey[600]),
                  title: const Text("Notifications"),
                  value: notificationsEnabled.value,
                  onChanged: (val) {
                    notificationsEnabled.value = val;
                    Fluttertoast.showToast(
                      msg: val ? "Notifications Enabled" : "Notifications Disabled",
                    );
                  },
                ),
                Divider(height: 1, color: Colors.grey[200]),
                ListTile(
                  leading: Icon(Icons.language, color: Colors.grey[600]),
                  title: const Text("Language"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("English", style: TextStyle(color: Colors.grey[600])),
                      Icon(Icons.chevron_right, color: Colors.grey[600]),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Text(
            "Support",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),

          const SizedBox(height: 8),

          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.headset_mic, color: Colors.grey[600]),
                  title: const Text("Contact Support"),
                  trailing: Icon(Icons.chevron_right, color: Colors.grey[600]),
                ),
                Divider(height: 1, color: Colors.grey[200]),
                ListTile(
                  leading: Icon(Icons.help_outline, color: Colors.grey[600]),
                  title: const Text("Help Center"),
                  trailing: Icon(Icons.chevron_right, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Center(
            child: Text(
              "App Version 1.0.0",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ),

          Center(
            child: Text(
              "© ${DateTime.now().year} Nasi Cleaning",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }
}