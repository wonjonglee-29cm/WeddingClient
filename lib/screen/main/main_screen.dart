import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wedding/screen/di_viewmodel.dart';
import 'package:wedding/screen/main/tabs/event/event_tab_screen.dart';
import 'package:wedding/screen/main/tabs/home/home_tab_screen.dart';
import 'package:wedding/screen/main/tabs/my/my_tab_screen.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  final List<Widget> _screens = const [
    HomeTabScreen(),
    EventTabScreen(),
    MyTabScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(mainViewModelProvider).currentIndex;

    return Scaffold(
      body: SafeArea(child: _screens[currentIndex]),
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
