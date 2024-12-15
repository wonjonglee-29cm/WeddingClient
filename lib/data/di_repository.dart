import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wedding/data/di_preference.dart';
import 'package:wedding/data/repository/event_repository.dart';
import 'package:wedding/data/repository/home_repository.dart';
import 'package:wedding/data/repository/member_repository.dart';
import 'package:wedding/data/repository/quiz_repository.dart';

final memberRepositoryProvider = Provider<MemberRepository>((ref) {
  final prefsValue = ref.watch(sharedPreferencesProvider);
  return prefsValue.when(
    data: (prefs) => MemberRepository(prefs),
    loading: () => throw UnimplementedError("SharedPreferences not initialized"),
    error: (err, stack) => throw Exception("Failed to initialize SharedPreferences"),
  );
});

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepository(FirebaseFirestore.instance);
});

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  return EventRepository(FirebaseFirestore.instance);
});

final quizRepositoryProvider = Provider<QuizRepository>((ref) {
  final prefsValue = ref.watch(sharedPreferencesProvider);
  return prefsValue.when(
    data: (prefs) => QuizRepository(prefs),
    loading: () => throw UnimplementedError("SharedPreferences not initialized"),
    error: (err, stack) => throw Exception("Failed to initialize SharedPreferences"),
  );
});
