import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wedding/data/di_repository.dart';
import 'package:wedding/screen/intro/intro_viewmodel.dart';
import 'package:wedding/screen/main/main_viewmodel.dart';
import 'package:wedding/screen/main/tabs/home/home_tab_viewmodel.dart';
import 'package:wedding/screen/signin/signin_viewmodel.dart';

import 'userinfo/user_info_viewmodel.dart';

final introViewModelProvider =
    StateNotifierProvider<IntroViewModel, IntroState>((ref) {
  return IntroViewModel(ref.watch(memberRepositoryProvider));
});

final signInViewModelProvider =
StateNotifierProvider<SignInViewModel, SignInState>((ref) {
  return SignInViewModel(ref.watch(memberRepositoryProvider));
});

final userInfoViewModelProvider =
    StateNotifierProvider<UserInfoViewModel, UserInfoState>((ref) {
  final memberRepository = ref.watch(memberRepositoryProvider);
  return UserInfoViewModel(memberRepository);
});

final mainViewModelProvider = StateNotifierProvider<MainViewModel, MainState>((ref) {
  return MainViewModel();
});

final homeViewModelProvider = StateNotifierProvider<HomeViewModel, HomeState>((ref) {
  final repository = ref.watch(homeRepositoryProvider);
  return HomeViewModel(repository);
});
