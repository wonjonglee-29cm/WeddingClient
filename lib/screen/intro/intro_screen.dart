import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wedding/screen/di_viewmodel.dart';
import 'package:wedding/screen/intro/intro_viewmodel.dart';
import 'package:wedding/screen/main/main_screen.dart';
import 'package:wedding/screen/signin/signin_screen.dart';
import 'package:wedding/screen/userinfo/user_info_screen.dart';

class IntroScreen extends ConsumerStatefulWidget {
  const IntroScreen({super.key});

  @override
  ConsumerState<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends ConsumerState<IntroScreen> {
  bool _isDelayComplete = false;

  @override
  void initState() {
    super.initState();
    ref.read(introViewModelProvider.notifier).checkLoginState();

    Future.delayed(const Duration(milliseconds: 3000), () {
      if (!mounted) return;
      setState(() {
        _isDelayComplete = true;
      });
      _handleNavigation();
    });
  }

  void _handleNavigation() {
    if (!mounted) return;

    final state = ref.read(introViewModelProvider);

    if (!_isDelayComplete) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
      );
      return;
    }

    switch (state) {
      case Pass():
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      case RequiredLogin():
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignInScreen()),
        );
      case RequiredUserInfo():
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UserInfoScreen()),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<IntroState>(introViewModelProvider, (previous, next) {
      if (_isDelayComplete) {
        _handleNavigation();
      }
    });

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Image.asset('../assets/images/splash.png'),
        ),
      ),
    );
  }
}