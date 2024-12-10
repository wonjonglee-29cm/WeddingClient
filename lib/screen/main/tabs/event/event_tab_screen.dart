import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wedding/design/ds_foundation.dart';
import 'package:wedding/screen/di_viewmodel.dart';
import 'package:wedding/screen/main/tabs/event/event_tab_viewmodel.dart';

class EventTabScreen extends ConsumerStatefulWidget {
  const EventTabScreen({super.key});

  @override
  ConsumerState<EventTabScreen> createState() => _EventTabScreen();
}

class _EventTabScreen extends ConsumerState<EventTabScreen> {
  @override
  Widget build(BuildContext context) {
    final eventState = ref.watch(eventTabViewModelProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1.0,
        title: const Text('이벤트', style: appBarStyle),
      ),
      body: switch (eventState) {
        Loading() => loading(),
        Success() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              timerBanner(eventState.event.getTimeRemaining()),
              Expanded(
                child: ListView.builder(
                  itemCount: eventState.event.items.length,
                  itemBuilder: (context, index) {
                    final item = eventState.event.items[index];
                    return ListTile(
                      title: Text(item.title),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        switch (item.type) {
                          case 'greeting':
                            ;
                          case 'quiz':
                            ;
                          case 'picture':
                            ;
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          )
      },
    );
  }

  Widget loading() => Scaffold(
        body: Builder(
            builder: (context) => const Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(100),
                      child: Text('로딩중입니다...'),
                    )
                  ],
                )),
      );

  Widget timerBanner(String timerText) => Container(
        width: double.infinity,
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            defaultGap,
            const Text('경품 응모까지 남은 시간', style: whiteDescriptionStyle),
            smallGap,
            Text(
              timerText,
              style: whiteTitleStyle,
            ),
            defaultGap,
          ],
        ),
      );
}
