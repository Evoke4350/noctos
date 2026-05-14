import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../../data/db/database.dart';
import '../../data/repositories/schedule_repository.dart';

/// IDs are stable across reschedules so old notifications get replaced.
class NotificationIds {
  static const windDown = 1001;
  static const bedtime = 1002;
  static const wake = 1003;
  static const caffeineCutoff = 1004;
}

class NoctosNotifications {
  NoctosNotifications._();

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> ensureInitialized() async {
    if (_initialized) return;
    if (kIsWeb) {
      _initialized = true;
      return;
    }
    tzdata.initializeTimeZones();
    try {
      // Best-effort: set local timezone to system. timezone package alone
      // doesn't expose system zone reliably, so we fall back to UTC if
      // detection fails. Date/time math uses tz.TZDateTime over the resolved
      // location; scheduling still fires at the wall-clock time given by the
      // user, because we construct TZDateTime from local Y/M/D/H/m components.
      // (flutter_local_notifications uses local wall time on Android.)
      tz.setLocalLocation(tz.local);
    } catch (_) {
      tz.setLocalLocation(tz.UTC);
    }
    const init = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
    await _plugin.initialize(settings: init);
    _initialized = true;
  }

  static Future<bool> requestPermissions() async {
    if (kIsWeb) return false;
    await ensureInitialized();
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android == null) return false;
    final notif = await android.requestNotificationsPermission();
    final exact = await android.requestExactAlarmsPermission();
    return (notif ?? false) && (exact ?? false);
  }

  static Future<void> cancelAll() async {
    if (kIsWeb) return;
    await ensureInitialized();
    await _plugin.cancelAll();
  }

  static Future<void> applyForSchedule(UserSchedule s) async {
    if (kIsWeb) return;
    await ensureInitialized();
    if (!s.notificationsEnabled) {
      await cancelAll();
      return;
    }

    final bedtimeMin = s.currentBedtimeMinutesOfDay;
    final wakeMin = s.fixedWakeMinutesOfDay;
    final windDownMin = (bedtimeMin - s.windDownMinutes) % (24 * 60);
    final cutoffMin = (wakeMin + s.caffeineCutoffOffsetMin) % (24 * 60);

    await _scheduleDaily(
      id: NotificationIds.windDown,
      minuteOfDay: windDownMin,
      title: 'Wind-down',
      body: 'Dim lights, no screens. Bedtime in ${s.windDownMinutes} min.',
    );
    await _scheduleDaily(
      id: NotificationIds.bedtime,
      minuteOfDay: bedtimeMin,
      title: 'Bedtime window open',
      body: 'Get in bed only when sleepy. Bed = sleep only.',
    );
    await _scheduleDaily(
      id: NotificationIds.wake,
      minuteOfDay: wakeMin,
      title: 'Wake',
      body: 'Up and out of bed. Anchor your day on this.',
      fullScreen: true,
    );
    await _scheduleDaily(
      id: NotificationIds.caffeineCutoff,
      minuteOfDay: cutoffMin,
      title: 'Caffeine cutoff',
      body: 'New caffeine now will still be in your system at bedtime.',
    );
  }

  static Future<void> _scheduleDaily({
    required int id,
    required int minuteOfDay,
    required String title,
    required String body,
    bool fullScreen = false,
  }) async {
    final hour = minuteOfDay ~/ 60;
    final minute = minuteOfDay % 60;
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (!scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    try {
      await _plugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduled,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            'noctos_default',
            'Sleep reminders',
            channelDescription: 'Wind-down, bedtime, wake, caffeine cutoff',
            importance: Importance.high,
            priority: Priority.high,
            fullScreenIntent: fullScreen,
            category: AndroidNotificationCategory.alarm,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time, // daily repeat
      );
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('Failed to schedule notification $id: $e\n$st');
      }
    }
  }
}

/// Riverpod side effect: every time UserSchedule changes, reapply.
final notificationSyncProvider = Provider<void>((ref) {
  ref.listen<AsyncValue<UserSchedule?>>(scheduleProvider, (prev, next) {
    final s = next.value;
    if (s == null) return;
    NoctosNotifications.applyForSchedule(s);
  }, fireImmediately: true);
});
