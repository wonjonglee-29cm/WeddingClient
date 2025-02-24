import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wedding/design/anim/ds_slide_route.dart';
import 'package:wedding/design/ds_foundation.dart';
import 'package:wedding/screen/di_viewmodel.dart';
import 'package:wedding/screen/greeting/greeting_screen.dart';
import 'package:wedding/screen/home/home_screen.dart';
import 'package:wedding/screen/invite/invite_screen.dart';
import 'package:wedding/screen/my/my_screen.dart';
import 'package:wedding/screen/quiz/quiz_screen.dart';
import 'package:wedding/utils/web/device_utils.dart';

class MainScreen extends HookConsumerWidget {
  final int? initialTab;
  static DateTime? _lastPressed;

  const MainScreen({this.initialTab, super.key});

  static final List<Widget> _screens = [
    const HomeScreen(),
    const InviteScreen(),
    const QuizScreen(),
    const MyScreen(),
  ];
  static const List<BottomNavigationBarItem> _navigationItems = [
    BottomNavigationBarItem(icon: Icon(Icons.mail_outline, size: 20), label: '초대장'),
    BottomNavigationBarItem(icon: Icon(Icons.event_note_outlined, size: 20), label: '예식 안내'),
    BottomNavigationBarItem(icon: Icon(Icons.emoji_events_outlined, size: 20), label: 'Quiz'),
    BottomNavigationBarItem(icon: Icon(Icons.mode_edit_outlined, size: 20), label: '내 정보'),
  ];

  // 스토어 배포용
  static final List<Widget> _deployScreens = [
    const HomeScreen(),
    const InviteScreen(),
    const QuizScreen(),
  ];
  static const List<BottomNavigationBarItem> _deployNavigationItems = [
    BottomNavigationBarItem(icon: Icon(Icons.mail_outline, size: 20), label: '초대장'),
    BottomNavigationBarItem(icon: Icon(Icons.event_note_outlined, size: 20), label: '예식 안내'),
    BottomNavigationBarItem(icon: Icon(Icons.emoji_events_outlined, size: 20), label: 'Quiz'),
  ];

  void _showAppInstallDialog(BuildContext context) {
    if (!kIsWeb) return;  // 웹이 아니면 다이얼로그를 보여주지 않음

    final platform = getPlatformInWeb();

    // 모바일 플랫폼이 아닌 경우 팝업 표시하지 않음
    if (platform != 'Android' && platform != 'iOS') return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('앱으로 보기'),
        content: const Text('더 나은 경험을 위해 앱으로 보시는 것을 추천드립니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('나중에'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              launchAppStoreInWeb(platform);
            },
            style: TextButton.styleFrom(
              foregroundColor: primaryColor,
            ),
            child: const Text('앱 설치하기'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mainViewModelProvider);

    final screens = state.isDeploy ? _deployScreens : _screens;
    final navItems = state.isDeploy ? (kIsWeb ? _navigationItems: _deployNavigationItems) : _navigationItems;

    useEffect(() {
      Future.microtask(() {
        if (kIsWeb) {
          _showAppInstallDialog(context);
        }
        if (!state.isWriteGreeting) {
          Navigator.of(context).push(SlideUpRoute(page: const GreetingScreen()));
        }
      });
      return null;
    }, [state.isWriteGreeting]);

    useEffect(() {
      if (initialTab != null) {
        ref.read(mainViewModelProvider.notifier).updateIndex(initialTab!);
      }
      return null;
    }, []);

    final currentIndex = state.currentIndex;

    return WillPopScope(
      onWillPop: () async {
        final now = DateTime.now();

        if (_lastPressed == null || now.difference(_lastPressed!) > const Duration(seconds: 2)) {
          _lastPressed = now;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('뒤로가기를 한번 더 누르면 종료됩니다.'),
              duration: Duration(seconds: 2),
            ),
          );
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: SafeArea(
            child: IndexedStack(
          index: currentIndex,
          children: screens,
        )),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedIconTheme: const IconThemeData(
            size: 24,
          ),
          unselectedIconTheme: const IconThemeData(
            size: 20,
          ),
          selectedFontSize: 14,
          unselectedFontSize: 12,
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.black,
          backgroundColor: Colors.white,
          elevation: 10,
          currentIndex: currentIndex,
          onTap: (index) => ref.read(mainViewModelProvider.notifier).updateIndex(index),
          items: navItems,
        ),
      ),
    );
  }
}
