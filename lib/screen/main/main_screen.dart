import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wedding/screen/di_viewmodel.dart';
import 'package:wedding/screen/main/tabs/event/event_tab_screen.dart';
import 'package:wedding/screen/main/tabs/home/home_tab_screen.dart';
import 'package:wedding/screen/main/tabs/my/my_tab_screen.dart';
import 'package:wedding/screen/picture/picture_screen.dart';

class MainScreen extends ConsumerWidget {
  final int? initialTab;
  const MainScreen({this.initialTab, super.key});

  static final List<Widget> _screens = [
    const HomeTabScreen(),
    Navigator(
      key: const ValueKey('event-navigator'),
      onGenerateRoute: (settings) {
        if (settings.name == '/picture') {
          return MaterialPageRoute(
            builder: (context) => const PictureScreen(),
          );
        }
        return MaterialPageRoute(builder: (context) => const EventTabScreen());
      },
    ),
    const MyTabScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    if (initialTab != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(mainViewModelProvider.notifier).updateIndex(initialTab!);
      });
    }

    final currentIndex = ref.watch(mainViewModelProvider).currentIndex;

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
