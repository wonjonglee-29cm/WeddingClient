import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wedding/data/di_repository.dart';
import 'package:wedding/screen/intro/intro_viewmodel.dart';
import 'package:wedding/screen/main/main_viewmodel.dart';
import 'package:wedding/screen/main/tabs/event/event_tab_viewmodel.dart';
import 'package:wedding/screen/main/tabs/home/home_tab_viewmodel.dart';
import 'package:wedding/screen/signin/signin_viewmodel.dart';

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
  return MainViewModel();
});

final homeTabViewModelProvider = StateNotifierProvider<HomeTabViewModel, HomeTabState>((ref) {
  final repository = ref.watch(homeRepositoryProvider);
  return HomeTabViewModel(repository);
});

final eventTabViewModelProvider = StateNotifierProvider<EventTabViewModel, EventTabState>((ref) {
  final repository = ref.watch(eventRepositoryProvider);
  return EventTabViewModel(repository);
});
