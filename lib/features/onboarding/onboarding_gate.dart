import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/repositories/schedule_repository.dart';

class OnboardingGate extends HookConsumerWidget {
  const OnboardingGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(scheduleProvider);
    useEffect(() {
      async.whenData((schedule) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted) return;
          if (schedule == null) {
            context.go('/onboarding/intake');
          } else {
            context.go('/home');
          }
        });
      });
      return null;
    }, [async]);

    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
