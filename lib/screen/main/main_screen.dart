import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:wedding/screen/di_viewmodel.dart';
import 'package:wedding/screen/greeting/greeting_screen.dart';
import 'package:wedding/screen/main/tabs/event/event_tab_screen.dart';
import 'package:wedding/screen/main/tabs/home/home_tab_screen.dart';
import 'package:wedding/screen/main/tabs/my/my_tab_screen.dart';
import 'package:wedding/screen/picture/picture_screen.dart';
import 'package:wedding/screen/quiz/quiz_screen.dart';

class MainScreen extends HookConsumerWidget {
  final int? initialTab;

  const MainScreen({this.initialTab, super.key});

  static final List<Widget> _screens = [
    const HomeTabScreen(),
    Navigator(
      key: const ValueKey('event-navigator'),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/picture':
            return MaterialPageRoute(
              builder: (context) => const PictureScreen(),
            );
          case '/quiz':
            return MaterialPageRoute(
              builder: (context) => const QuizScreen(),
            );
          default:
            return MaterialPageRoute(builder: (context) => const EventTabScreen());
        }
      },
    ),
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
              maxHeight: MediaQuery.of(context).size.height,
            ),
            builder: (context) => GreetingScreen(),
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

    return Scaffold(
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: '이벤트'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '내 정보'),
        ],
      ),
    );
  }
}
