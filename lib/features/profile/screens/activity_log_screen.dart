import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../providers/profile_provider.dart';

class ActivityLogScreen extends ConsumerStatefulWidget {
  const ActivityLogScreen({super.key});

  @override
  ConsumerState<ActivityLogScreen> createState() => _ActivityLogScreenState();
}

class _ActivityLogScreenState extends ConsumerState<ActivityLogScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(profileProvider.notifier).fetchActivityLog());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profileState = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Activity Log'), backgroundColor: theme.scaffoldBackgroundColor, elevation: 0),
      body: profileState.isLoading && profileState.activityLog.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => ref.read(profileProvider.notifier).fetchActivityLog(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: profileState.activityLog.length,
                itemBuilder: (context, index) {
                  final log = profileState.activityLog[index];
                  final isSuccess = log['status'] == 'success';
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: theme.dividerColor),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: (isSuccess ? Colors.green : Colors.red).withOpacity(0.1), shape: BoxShape.circle),
                          child: Icon(isSuccess ? LucideIcons.checkCircle : LucideIcons.xCircle, color: isSuccess ? Colors.green : Colors.red),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(log['action'] ?? 'Unknown Action', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(height: 4),
                              Text('${log['device'] ?? 'Unknown Device'} • ${log['ip_address'] ?? 'Unknown'}', style: TextStyle(color: theme.textTheme.bodySmall?.color, fontSize: 12)),
                              Text(log['time']?.split('T')[0] ?? 'Unknown', style: TextStyle(color: theme.textTheme.bodySmall?.color, fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}
