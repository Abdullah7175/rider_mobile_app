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
      appBar: AppBar(
        title: const Text("Profile"),
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
          const SizedBox(height: 20),
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[300],
              child: const Icon(Icons.person, size: 50),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              auth.user ?? 'Unknown User',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 4),
          const Center(child: Text("Rider ID: rider001")),
          const Center(child: Text("Vendor: Nasi Cleaning")),

          const Divider(height: 32),

          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text("Change Password"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => isPasswordDialogOpen.value = true,
          ),
          SwitchListTile(
            secondary: const Icon(Icons.notifications),
            title: const Text("Notifications"),
            value: notificationsEnabled.value,
            onChanged: (val) {
              notificationsEnabled.value = val;
              Fluttertoast.showToast(
                msg: val ? "Notifications Enabled" : "Notifications Disabled",
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text("Language"),
            trailing: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("English"),
                Icon(Icons.chevron_right),
              ],
            ),
          ),

          const Divider(height: 32),
          const Text("Support", style: TextStyle(fontWeight: FontWeight.bold)),
          ListTile(
            leading: const Icon(Icons.headset_mic),
            title: const Text("Contact Support"),
            trailing: const Icon(Icons.chevron_right),
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text("FAQ"),
            trailing: const Icon(Icons.chevron_right),
          ),

          const SizedBox(height: 20),
          const Center(child: Text("App Version 1.0.0")),
          const Center(child: Text("© 2023 Nasi Cleaning")),
        ],
      ),
      // Password Dialog
      floatingActionButton: isPasswordDialogOpen.value
          ? FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("Change Password"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(labelText: "New Password"),
                    obscureText: true,
                  ),
                  TextField(
                    controller: confirmPasswordController,
                    decoration: const InputDecoration(labelText: "Confirm Password"),
                    obscureText: true,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => isPasswordDialogOpen.value = false,
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: updatePassword,
                  child: const Text("Update"),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.lock),
      )
          : null,
    );
  }
}