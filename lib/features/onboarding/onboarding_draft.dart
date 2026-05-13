import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingDraft {
  final Set<String> insomniaTypes;
  final int severity;
  final int? chronotypeScore;
  final String? chronotypeCategory;
  final TimeOfDay? fixedWake;
  final TimeOfDay? initialBedtime;

  const OnboardingDraft({
    this.insomniaTypes = const {},
    this.severity = 5,
    this.chronotypeScore,
    this.chronotypeCategory,
    this.fixedWake,
    this.initialBedtime,
  });

  OnboardingDraft copyWith({
    Set<String>? insomniaTypes,
    int? severity,
    int? chronotypeScore,
    String? chronotypeCategory,
    TimeOfDay? fixedWake,
    TimeOfDay? initialBedtime,
  }) {
    return OnboardingDraft(
      insomniaTypes: insomniaTypes ?? this.insomniaTypes,
      severity: severity ?? this.severity,
      chronotypeScore: chronotypeScore ?? this.chronotypeScore,
      chronotypeCategory: chronotypeCategory ?? this.chronotypeCategory,
      fixedWake: fixedWake ?? this.fixedWake,
      initialBedtime: initialBedtime ?? this.initialBedtime,
    );
  }
}

class OnboardingDraftNotifier extends Notifier<OnboardingDraft> {
  @override
  OnboardingDraft build() => const OnboardingDraft();

  void setInsomniaTypes(Set<String> v) => state = state.copyWith(insomniaTypes: v);
  void setSeverity(int v) => state = state.copyWith(severity: v);
  void setChronotype(int score, String category) =>
      state = state.copyWith(chronotypeScore: score, chronotypeCategory: category);
  void setSchedule(TimeOfDay wake, TimeOfDay bedtime) =>
      state = state.copyWith(fixedWake: wake, initialBedtime: bedtime);
}

final onboardingDraftProvider =
    NotifierProvider<OnboardingDraftNotifier, OnboardingDraft>(
  OnboardingDraftNotifier.new,
);
