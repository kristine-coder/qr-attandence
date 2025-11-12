import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/attendance_provider.dart';
import '../widgets/attendance_card.dart';

class AttendanceHistoryScreen extends StatelessWidget {
  const AttendanceHistoryScreen({super.key});

  static const String routeName = '/attendance-history';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AttendanceProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Attendance history')),
      body: RefreshIndicator(
        onRefresh: () => context.read<AttendanceProvider>().fetchHistory(),
        child: provider.isLoading && provider.records.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: provider.records.length + 1,
                itemBuilder: (context, index) {
                  if (index == provider.records.length) {
                    return TextButton(
                      onPressed: provider.records.isEmpty
                          ? null
                          : () async {
                              await provider.fetchHistory();
                            },
                      child: const Text('See more'),
                    );
                  }
                  final record = provider.records[index];
                  return AttendanceCard(record: record);
                },
              ),
      ),
    );
  }
}
