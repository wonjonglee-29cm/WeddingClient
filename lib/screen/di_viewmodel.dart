import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wedding/data/di_repository.dart';
import 'package:wedding/data/raw/component_raw.dart';
import 'package:wedding/screen/home/home_viewmodel.dart';
import 'package:wedding/screen/intro/intro_viewmodel.dart';
import 'package:wedding/screen/invite/invite_viewmodel.dart';
import 'package:wedding/screen/main/main_viewmodel.dart';
import 'package:wedding/screen/quiz/quiz_viewmodel.dart';
import 'package:wedding/screen/signin/signin_viewmodel.dart';

import 'greeting/greeting_viewmodel.dart';
import 'userinfo/user_info_viewmodel.dart';

final introViewModelProvider = StateNotifierProvider<IntroViewModel, IntroState>((ref) {
  return IntroViewModel(ref.watch(memberRepositoryProvider));
});

final signInViewModelProvider = StateNotifierProvider<SignInViewModel, SignInState>((ref) {
  return SignInViewModel(ref.watch(memberRepositoryProvider));
});

final userInfoViewModelProvider = StateNotifierProvider<UserInfoViewModel, UserInfoState>((ref) {
  final memberRepository = ref.watch(memberRepositoryProvider);
  return UserInfoViewModel(memberRepository);
});

final mainViewModelProvider = StateNotifierProvider<MainViewModel, MainState>((ref) {
  final repository = ref.watch(greetingRepositoryProvider);
  return MainViewModel(repository);
});

final homeViewModelProvider = StateNotifierProvider<HomeViewModel, AsyncValue<List<ComponentRaw>>>((ref) {
  final repository = ref.watch(componentRepositoryProvider);
  return HomeViewModel(repository);
});

final inviteViewModelProvider = StateNotifierProvider<InviteViewModel, AsyncValue<List<ComponentRaw>>>((ref) {
  final repository = ref.watch(componentRepositoryProvider);
  return InviteViewModel(repository);
});

final quizViewModelProvider = StateNotifierProvider<QuizViewModel, QuizState>((ref) {
  final repository = ref.watch(quizRepositoryProvider);
  return QuizViewModel(repository);
});

final greetingViewModelProvider = StateNotifierProvider.autoDispose<GreetingViewModel, AsyncValue>((ref) {
  final repository = ref.watch(greetingRepositoryProvider);
  return GreetingViewModel(repository);
});
