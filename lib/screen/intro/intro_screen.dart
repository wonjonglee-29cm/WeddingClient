import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wedding/screen/di_viewmodel.dart';
import 'package:wedding/screen/intro/intro_viewmodel.dart';
import 'package:wedding/screen/main/main_screen.dart';
import 'package:wedding/screen/signin/signin_screen.dart';
import 'package:live_background/live_background.dart';
import 'package:live_background/fx/base_fx.dart';
import 'package:live_background/object/particle_shape_type.dart';
import 'package:live_background/widget/live_background_widget.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:wedding/screen/userinfo/user_info_screen.dart';

class IntroScreen extends ConsumerStatefulWidget {
  const IntroScreen({super.key});

  @override
  ConsumerState<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends ConsumerState<IntroScreen> {
  bool showBackButton = false;
  final liveBackgroundController = LiveBackgroundController();
  final Palette _palette = const Palette(colors: [Colors.white, Colors.yellow]);
  double particleCount = 300;
  double vx = BaseFx.baseVelocity;
  double vy = BaseFx.baseVelocity;
  double particleMinSize = 10;
  double particleMaxSize = 50;
  bool hideSetting = false;
  ShowCase? showCase;
  ParticleShapeType shapeType = ParticleShapeType.circle;


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

    // API 호출이 길어진 경우
    if (!_isDelayComplete) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
      );
      return;
    }

    // 상태에 따른 화면 이동
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
      body: Builder(
        builder: (context) => Stack(
          children: [
            Container(
              color: Colors.black,
            ),
            LiveBackgroundWidget(
              controller: liveBackgroundController,
              palette: _palette,
              shape: shapeType,
            ),
            SafeArea(
              child: SingleChildScrollView(
                child: hideSetting
                    ? showCase?.getWidget(context) ?? Container()
                    : Container(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum ShowCase {
  Christmas,
  HappyNewYear,
  Matrix;

  Widget getWidget(BuildContext context) {
    final size = MediaQuery.of(context).size;
    switch (this) {
      case ShowCase.Christmas:
        return Container(
          height: size.height,
          width: size.width,
          child: Center(
            child: Image.asset("assets/images/merry.png"),
          ),
        );
      case ShowCase.Matrix:
        return Container(
          height: size.height,
          width: size.width,
          child: Center(
            child: Image.asset("assets/images/matrix.png").pSymmetric(h: 40),
          ),
        );
      case ShowCase.HappyNewYear:
        return Container(
          width: size.width,
          child: Column(
            children: [
              const Height(100),
              Center(
                child: Image.asset(
                  "assets/images/happy.png",
                  width: 300,
                ),
              ),
              Container(
                  constraints: const BoxConstraints(maxWidth: 340),
                  child:
                      "Wishing you and your family a happy new year filled with hope, health, and happiness - with a generous sprinkle of fun!"
                          .text
                          .size(30)
                          .white
                          .center
                          .make()),
              Height(100),
            ],
          ),
        );
    }
  }

  String get showCaseName {
    switch (this) {
      case ShowCase.Matrix:
        return "Matrix";
      case ShowCase.Christmas:
        return "Christmas";
      case ShowCase.HappyNewYear:
        return "Happy New year!";
    }
  }

  Palette get palette {
    switch (this) {
      case ShowCase.Matrix:
        return const Palette(colors: [
          Color(0xff165B33),
          Color(0xff83ec00),
        ]);
      case ShowCase.Christmas:
        return const Palette(colors: [
          Color(0xff165B33),
          Color(0xffF8B229),
          Color(0xffEA4630),
          Color(0xffBB2528),
        ]);
      case ShowCase.HappyNewYear:
        return const Palette(colors: [
          Color(0xffFFDF00),
          Color(0xffFFCC00),
          Color(0xffECBD00),
          Color(0xffCC9900),
          Color(0xffB8860B),
          Color(0xffffffff),
          Color(0xffffffff),
          Color(0xffffffff),
        ]);
    }
  }
}

class Height extends StatelessWidget {
  final double height;

  const Height(this.height, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}

class Width extends StatelessWidget {
  final double width;

  const Width(this.width, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
    );
  }
}
