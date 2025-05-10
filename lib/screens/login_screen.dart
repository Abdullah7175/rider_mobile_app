import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_input.dart';
import '../widgets/custom_button.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final usernameController = useTextEditingController();
    final passwordController = useTextEditingController();
    final isLoading = ref.watch(authProvider).isLoading;
    final authNotifier = ref.read(authProvider.notifier);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      ),
                      child: const Icon(Icons.house_rounded, size: 48, color: Colors.green),
                    ),
                    const SizedBox(height: 12),
                    const Text('Nasi Cleaning', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const Text('Delivery Rider Portal', style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 24),

                    // Rider ID
                    CustomInput(
                      label: 'Rider ID',
                      controller: usernameController,
                      validator: (value) => value == null || value.isEmpty ? 'Rider ID is required' : null,
                      placeholder: 'Enter your Rider ID',
                    ),
                    const SizedBox(height: 16),

                    // Password
                    CustomInput(
                      label: 'Password',
                      controller: passwordController,
                      validator: (value) => value == null || value.isEmpty ? 'Password is required' : null,
                      placeholder: 'Enter your password',
                      obscureText: true,
                    ),
                    const SizedBox(height: 24),

                    CustomButton(
                      text: 'Sign In',
                      isLoading: isLoading,
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          await authNotifier.login(
                            usernameController.text.trim(),
                            passwordController.text.trim(),
                            onSuccess: () => context.go('/orders'),
                          );
                        }
                      },
                    ),

                    const SizedBox(height: 12),
                    const Text(
                      'Forgot password? Contact your vendor admin.',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}