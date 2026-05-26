import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/time.dart';
import '../../data/repositories/schedule_repository.dart';
import '../../services/export/exporter.dart';
import '../../services/notifications/scheduler.dart';
import 'widgets/health_connect_section.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleAsync = ref.watch(scheduleProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: scheduleAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (schedule) {
            if (schedule == null) {
              return const Center(child: Text('No schedule yet'));
            }
            final bedtime = timeOfDayFromMinutes(
              schedule.currentBedtimeMinutesOfDay,
            );
            final wake = timeOfDayFromMinutes(schedule.fixedWakeMinutesOfDay);
            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  'Schedule',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text('Fixed wake time'),
                        subtitle: Text(formatTimeOfDay(wake)),
                        trailing: const Icon(Icons.access_time),
                        onTap: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: wake,
                          );
                          if (picked == null) return;
                          await ref
                              .read(scheduleRepositoryProvider)
                              .update(
                                schedule.copyWith(
                                  fixedWakeMinutesOfDay: minutesOfDay(picked),
                                  updatedAt: DateTime.now(),
                                ),
                              );
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        title: const Text('Bedtime window opens'),
                        subtitle: Text(formatTimeOfDay(bedtime)),
                        trailing: const Icon(Icons.bedtime_outlined),
                        onTap: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: bedtime,
                          );
                          if (picked == null) return;
                          await ref
                              .read(scheduleRepositoryProvider)
                              .update(
                                schedule.copyWith(
                                  currentBedtimeMinutesOfDay: minutesOfDay(
                                    picked,
                                  ),
                                  updatedAt: DateTime.now(),
                                ),
                              );
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        title: const Text('Wind-down lead time'),
                        subtitle: Text(
                          '${schedule.windDownMinutes} min before bedtime',
                        ),
                        trailing: const Icon(Icons.timer_outlined),
                        onTap: () => _editIntDialog(
                          context,
                          title: 'Wind-down minutes',
                          initial: schedule.windDownMinutes,
                          onSave: (v) => ref
                              .read(scheduleRepositoryProvider)
                              .update(
                                schedule.copyWith(
                                  windDownMinutes: v,
                                  updatedAt: DateTime.now(),
                                ),
                              ),
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        title: const Text('Caffeine cutoff after wake'),
                        subtitle: Text(
                          '${schedule.caffeineCutoffOffsetMin ~/ 60}h ${schedule.caffeineCutoffOffsetMin % 60}m',
                        ),
                        trailing: const Icon(Icons.coffee_outlined),
                        onTap: () => _editIntDialog(
                          context,
                          title: 'Caffeine cutoff (min after wake)',
                          initial: schedule.caffeineCutoffOffsetMin,
                          onSave: (v) => ref
                              .read(scheduleRepositoryProvider)
                              .update(
                                schedule.copyWith(
                                  caffeineCutoffOffsetMin: v,
                                  updatedAt: DateTime.now(),
                                ),
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Notifications',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Card(
                  child: Column(
                    children: [
                      SwitchListTile(
                        value: schedule.notificationsEnabled,
                        title: const Text('Enable reminders'),
                        subtitle: const Text(
                          'Wind-down, bedtime, wake, caffeine cutoff',
                        ),
                        onChanged: (v) async {
                          if (v) {
                            await NoctosNotifications.requestPermissions();
                          }
                          await ref
                              .read(scheduleRepositoryProvider)
                              .update(
                                schedule.copyWith(
                                  notificationsEnabled: v,
                                  updatedAt: DateTime.now(),
                                ),
                              );
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        title: const Text('Request all permissions'),
                        subtitle: const Text('Notifications + exact alarms'),
                        trailing: const Icon(
                          Icons.notifications_active_outlined,
                        ),
                        onTap: () async {
                          final ok =
                              await NoctosNotifications.requestPermissions();
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                ok ? 'Granted' : 'Some permissions denied',
                              ),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        title: const Text('Battery exemption'),
                        subtitle: const Text(
                          'Required on Xiaomi/Oppo/OnePlus to keep alarms reliable',
                        ),
                        trailing: const Icon(Icons.battery_alert_outlined),
                        onTap: () async {
                          await Permission.ignoreBatteryOptimizations.request();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Health Connect',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                const HealthConnectSection(),
                const SizedBox(height: 20),
                Text('Data', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text('Export JSON'),
                        subtitle: const Text('All tables, one file'),
                        trailing: const Icon(Icons.file_download_outlined),
                        onTap: () async {
                          final res = await ref
                              .read(exporterProvider)
                              .export(ExportFormat.json);
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Saved: ${res.path}')),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        title: const Text('Export CSV'),
                        subtitle: const Text('One section per table'),
                        trailing: const Icon(Icons.table_chart_outlined),
                        onTap: () async {
                          final res = await ref
                              .read(exporterProvider)
                              .export(ExportFormat.csv);
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Saved: ${res.path}')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text('About', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Card(
                  child: Column(
                    children: const [
                      ListTile(
                        title: Text('noctos'),
                        subtitle: Text('OSS CBT-I sleep app · AGPLv3'),
                      ),
                      Divider(height: 1),
                      ListTile(
                        title: Text('Not medical advice'),
                        subtitle: Text(
                          'Severe insomnia: see a clinician. CBT-I works alongside care, not in place of it.',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _editIntDialog(
    BuildContext context, {
    required String title,
    required int initial,
    required Future<void> Function(int) onSave,
  }) async {
    final controller = TextEditingController(text: initial.toString());
    final value = await showDialog<int>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final v = int.tryParse(controller.text);
                if (v != null) Navigator.of(ctx).pop(v);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
    if (value != null) await onSave(value);
  }
}
