import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../providers/profile_provider.dart';
import '../../../widgets/premium_widgets.dart';

class SessionsScreen extends ConsumerStatefulWidget {
  const SessionsScreen({super.key});

  @override
  ConsumerState<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends ConsumerState<SessionsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(profileProvider.notifier).fetchSessions());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profileState = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Active Sessions'), backgroundColor: theme.scaffoldBackgroundColor, elevation: 0),
      body: profileState.isLoading && profileState.sessions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => ref.read(profileProvider.notifier).fetchSessions(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: profileState.sessions.length,
                itemBuilder: (context, index) {
                  final session = profileState.sessions[index];
                  final isCurrent = session['is_current'] == true;
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
                          decoration: BoxDecoration(color: theme.colorScheme.primary.withOpacity(0.1), shape: BoxShape.circle),
                          child: Icon(isCurrent ? LucideIcons.smartphone : LucideIcons.monitor, color: theme.colorScheme.primary),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(session['device_info'] ?? 'Unknown Device', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(height: 4),
                              Text('IP: ${session['ip_address'] ?? 'Unknown'}', style: TextStyle(color: theme.textTheme.bodySmall?.color, fontSize: 12)),
                              Text('Started: ${session['created_at']?.split('T')[0] ?? 'Unknown'}', style: TextStyle(color: theme.textTheme.bodySmall?.color, fontSize: 12)),
                            ],
                          ),
                        ),
                        if (!isCurrent)
                          IconButton(
                            icon: const Icon(LucideIcons.logOut, color: Colors.red),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (c) => AlertDialog(
                                  title: const Text('Revoke Session'),
                                  content: const Text('Are you sure you want to sign out from this device?'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
                                    TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('Revoke', style: TextStyle(color: Colors.red))),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                ref.read(profileProvider.notifier).revokeSession(session['id']);
                              }
                            },
                          )
                        else
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Current', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                          )
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}
