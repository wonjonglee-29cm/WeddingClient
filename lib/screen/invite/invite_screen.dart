import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wedding/design/component/ds_container.dart';
import 'package:wedding/design/ds_foundation.dart';
import 'package:wedding/design/error/ds_error.dart';
import 'package:wedding/design/loading/ds_loading.dart';
import 'package:wedding/screen/di_viewmodel.dart';

class InviteScreen extends HookConsumerWidget {
  const InviteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const horizontalPadding = 20.0;
    final state = ref.watch(inviteViewModelProvider);

    return state.when(
      loading: () => loadingWidget(),
      error: (error, _) => errorWidget(onRetry: () => ref.read(homeViewModelProvider.notifier).loadItems()),
      data: (items) => Scaffold(
        appBar: AppBar(
          backgroundColor: tertiaryColor,
          title: const Text('에식 안내', style: appBarStyle),
        ),
        backgroundColor: const Color(0x00fefefd),
        body: componentsContainerWidget(items, horizontalPadding: horizontalPadding),
      ),
    );
  }
}
