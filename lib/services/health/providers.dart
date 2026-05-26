import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'health_connect_service.dart';

final healthConnectServiceProvider = Provider<HealthConnectService>((ref) {
  return RealHealthConnectService();
});

final healthConnectStatusProvider = FutureProvider<HealthConnectStatus>((ref) {
  return ref.watch(healthConnectServiceProvider).status();
});
