import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

import '../providers/attendance_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_button.dart';
import 'attendance_history_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isScanning = false;

  Future<void> _scanQr(BuildContext context) async {
    if (_isScanning) return;

    setState(() => _isScanning = true);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      builder: (_) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: MobileScanner(
            allowDuplicates: false,
            controller: MobileScannerController(facing: CameraFacing.back),
            onDetect: (capture) async {
              final codes = capture.barcodes;
              if (codes.isEmpty) return;
              final code = codes.first.rawValue;
              if (code == null) return;

              Navigator.of(context).pop();
              await _submitAttendance(code);
            },
          ),
        );
      },
    );

    setState(() => _isScanning = false);
  }

  Future<void> _submitAttendance(String code) async {
    final attendanceProvider = context.read<AttendanceProvider>();
    await attendanceProvider.submitAttendance(code);

    if (attendanceProvider.error != null && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(attendanceProvider.error!)));
      return;
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Attendance recorded successfully.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final attendanceProvider = context.watch<AttendanceProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Attendance'),
        actions: [
          IconButton(
            onPressed: () async {
              await context.read<AuthProvider>().logout();
              if (!mounted) return;
              Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Welcome, ${authProvider.currentUser?.fullName ?? 'Student'}',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              if (authProvider.currentUser?.id == AuthProvider.demoUserId) ...[
                Card(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'You are exploring the demo mode with sample data. Connect a backend and log in with your real account when you are ready.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
              Text('Use the quick actions below to check in or review your records.'),
              const SizedBox(height: 32),
              CustomButton(
                label: _isScanning ? 'Initializing camera...' : 'Open Camera to scan QR',
                icon: Icons.camera_alt_outlined,
                isPrimary: true,
                onPressed: _isScanning ? null : () => _scanQr(context),
              ),
              const SizedBox(height: 16),
              CustomButton(
                label: 'Attendance history',
                icon: Icons.school_outlined,
                onPressed: () async {
                  await attendanceProvider.fetchHistory();
                  if (!mounted) return;
                  Navigator.of(context).pushNamed(AttendanceHistoryScreen.routeName);
                },
              ),
            ],
          ),
        ),
    );
  }
}
