import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wedding/design/anim/ds_slide_route.dart';
import 'package:wedding/design/ds_foundation.dart';
import 'package:wedding/screen/greeting/greeting_screen.dart';

class MyTabScreen extends HookConsumerWidget {
  // static final로 변경
  static final _items = [
    const _Item(key: 'info', icon: Icons.directions_run, text: '방문여부 수정하기'),
    const _Item(key: 'greeting', icon: Icons.mail_outline, text: '방명록 수정하기'),
  ];

  const MyTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1.0,
          title: const Text('이벤트', style: appBarStyle),
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return ListTile(
                  leading: Icon(item.icon),
                  title: Text(item.text),
                  onTap: () {
                    switch (item.key) {
                      case 'greeting':
                        Navigator.of(context).push(
                            SlideUpRoute(page: const GreetingScreen())
                        );
                      case 'info':

                    }
                  },
                );
              },
            ),
          )
        ]));
  }
}

// private class로 변경
class _Item {
  final String key;
  final IconData icon;
  final String text;

  const _Item({required this.key, required this.icon, required this.text});
}