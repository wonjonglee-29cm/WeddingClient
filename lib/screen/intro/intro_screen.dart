import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wedding/design/component/ds_appbar.dart';
import 'package:wedding/design/ds_foundation.dart';
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
  late Future<void> _initialization;

  @override
  void initState() {
    super.initState();
    _initialization = _initialize();
  }

  Future<void> _initialize() async {
    await Future.wait([
      ref.read(introViewModelProvider.notifier).checkLoginState(),
      Future.delayed(const Duration(milliseconds: 2000)),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Future.microtask(() {
              if (!mounted) return;

              final state = ref.read(introViewModelProvider);
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
                    MaterialPageRoute(builder: (context) => const UserInfoScreen(screenType: UserInfoScreenType.init)),
                  );
                case NetworkError():
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('네트워크 연결을 확인해주세요.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  Future.delayed(const Duration(seconds: 2), () {
                    SystemNavigator.pop();
                  });
              }
            });
          }

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              toolbarHeight: 0,
              systemOverlayStyle: systemStyle,
            ),
            body: Container(
              color: bgColor,
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: Image.asset(
                    'assets/images/splash.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
