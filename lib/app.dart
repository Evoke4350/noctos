import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router.dart';
import 'core/theme.dart';
import 'services/notifications/scheduler.dart';

class NoctosApp extends ConsumerWidget {
  const NoctosApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(notificationSyncProvider);
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'noctos',
      debugShowCheckedModeBanner: false,
      theme: NoctosTheme.dark(),
      darkTheme: NoctosTheme.dark(),
      themeMode: ThemeMode.dark,
      routerConfig: router,
    );
  }
}
