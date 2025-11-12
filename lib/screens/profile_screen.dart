import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../utils/constants.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const String routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 48,
              backgroundImage: (user?.avatarUrl.isNotEmpty ?? false)
                  ? NetworkImage(user!.avatarUrl)
                  : null,
              child: (user?.avatarUrl.isEmpty ?? true)
                  ? Text(
                      _initials(user?.fullName ?? ''),
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                    )
                  : null,
            ),
            const SizedBox(height: 24),
            _ProfileField(label: 'Full name', value: user?.fullName ?? '—'),
            _ProfileField(label: 'Email', value: user?.email ?? '—'),
            _ProfileField(label: 'Faculty', value: user?.faculty ?? '—'),
            const Spacer(),
            FilledButton.icon(
              onPressed: () async {
                final navigator = Navigator.of(context);
                await context.read<AuthProvider>().logout();
                navigator.pushNamedAndRemoveUntil(LoginScreen.routeName, (route) => false);
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }

  String _initials(String input) {
    final parts = input.trim().split(' ');
    if (parts.isEmpty) return 'S';
    final first = parts.first.isNotEmpty ? parts.first[0] : '';
    final last = parts.length > 1 && parts.last.isNotEmpty ? parts.last[0] : '';
    return '$first$last'.toUpperCase();
  }
}

class _ProfileField extends StatelessWidget {
  const _ProfileField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.grey[600])),
          const SizedBox(height: 4),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
