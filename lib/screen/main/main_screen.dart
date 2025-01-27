import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wedding/design/component/ds_appbar.dart';
import 'package:wedding/screen/di_viewmodel.dart';
import 'package:wedding/screen/greeting/greeting_screen.dart';
import 'package:wedding/screen/home/home_screen.dart';
import 'package:wedding/screen/main/tabs/my/my_tab_screen.dart';
import 'package:wedding/screen/quiz/quiz_screen.dart';

class MainScreen extends HookConsumerWidget {
  final int? initialTab;
  static DateTime? _lastPressed;

  const MainScreen({this.initialTab, super.key});

  static final List<Widget> _screens = [
    const HomeScreen(),
    const QuizScreen(),
    const MyTabScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mainViewModelProvider);

    useEffect(() {
      Future.microtask(() {
        if (!state.isWriteGreeting) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            useRootNavigator: true,
            constraints: BoxConstraints(
              maxHeight: MediaQuery
                  .of(context)
                  .size
                  .height,
            ),
            builder: (context) => const GreetingScreen(),
          );
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

    return  WillPopScope(
      onWillPop: () async {
        final now = DateTime.now();

        if (_lastPressed == null ||
            now.difference(_lastPressed!) > const Duration(seconds: 2)) {
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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 0,
          systemOverlayStyle: systemStyle,
        ),
        body: SafeArea(
            child: IndexedStack(
              index: currentIndex,
              children: _screens,
            )),
        bottomNavigationBar: BottomNavigationBar(
          selectedIconTheme: const IconThemeData(
            size: 24,
          ),
          unselectedIconTheme: const IconThemeData(
            size: 22,
          ),
          selectedFontSize: 14,
          unselectedFontSize: 12,
          selectedItemColor: Colors.blueGrey,
          backgroundColor: Colors.white,
          elevation: 10,
          currentIndex: currentIndex,
          onTap: (index) => ref.read(mainViewModelProvider.notifier).updateIndex(index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined, size: 24), label: '홈'),
            BottomNavigationBarItem(icon: ImageIcon(AssetImage('assets/images/quiz.png'), size: 24), label: 'Quiz'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline, size: 24), label: '내 정보'),
          ],
        ),
      ),
    );
  }
}
