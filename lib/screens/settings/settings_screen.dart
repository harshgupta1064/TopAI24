import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/supabase_service.dart';
import '../auth/login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primary.withOpacity(0.1),
              theme.colorScheme.secondary.withOpacity(0.1),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Danger Zone Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning_rounded,
                            color: Colors.red[700],
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Danger Zone',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: Colors.red[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading:
                          const Icon(Icons.delete_forever, color: Colors.red),
                      title: const Text('Delete Account'),
                      subtitle: const Text(
                        'Permanently delete your account and all associated data',
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Account'),
                            content: const Text(
                              'Are you sure you want to delete your account? This action cannot be undone.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  final user = context.read<AuthService>().user;
                                  if (user != null) {
                                    await context
                                        .read<SupabaseService>()
                                        .deleteUserData(user.uid);
                                    await context.read<AuthService>().signOut();
                                    if (context.mounted) {
                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen(),
                                        ),
                                        (route) => false,
                                      );
                                    }
                                  }
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.red,
                                ),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // About Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: theme.colorScheme.primary,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'About',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.code),
                      title: const Text('Version'),
                      subtitle: const Text('1.0.0'),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.description),
                      title: const Text('Terms of Service'),
                      onTap: () {
                        // TODO: Navigate to Terms of Service
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.privacy_tip),
                      title: const Text('Privacy Policy'),
                      onTap: () {
                        // TODO: Navigate to Privacy Policy
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
