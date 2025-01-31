import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wedding/design/component/ds_appbar.dart';
import 'package:wedding/design/component/ds_bottom_button.dart';
import 'package:wedding/design/ds_foundation.dart';
import 'package:wedding/screen/di_viewmodel.dart';
import 'package:wedding/screen/main/main_screen.dart';
import 'package:wedding/screen/userinfo/user_info_guest_type.dart';


enum UserInfoScreenType {
  init,
  update
}

class UserInfoScreen extends HookConsumerWidget {
  final UserInfoScreenType screenType;

  const UserInfoScreen({
    super.key,
    this.screenType = UserInfoScreenType.init
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(userInfoScreenTypeProvider.notifier).state = screenType;
      });
      return null;
    }, const []);

    final state = ref.watch(userInfoViewModelProvider);
    final viewModel = ref.read(userInfoViewModelProvider.notifier);

    final companionCounts = List.generate(10, (i) => i + 1);

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    useEffect(() {
      if (state.error != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!)),
          );
        });
      }
      return null;
    }, [state.error]);

    return Scaffold(
      appBar: closeAppBar(context, '참석여부를 선택해주세요'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildSection(
                      '참석 여부',
                      Row(
                        children: [
                          Radio<bool>(
                            value: true,
                            groupValue: state.willAttend,
                            onChanged: (value) => viewModel.updateWillAttend(value),
                          ),
                          const Text('참석'),
                          Radio<bool>(
                            value: false,
                            groupValue: state.willAttend,
                            onChanged: (value) => viewModel.updateWillAttend(value),
                          ),
                          const Text('불참'),
                        ],
                      ),
                    ),
                    buildSection(
                      '하객 종류',
                      DropdownButton<GuestType>(
                        value: state.guestType,
                        hint: const Text('선택해주세요'),
                        isExpanded: true,
                        items: GuestType.values.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type.title),
                          );
                        }).toList(),
                        onChanged: (value) => viewModel.updateGuestType(value),
                      ),
                    ),
                    buildSection(
                      '동행인 여부',
                      Row(
                        children: [
                          Radio<bool>(
                            value: true,
                            groupValue: state.hasCompanion,
                            onChanged: (value) => viewModel.updateHasCompanion(value),
                          ),
                          const Text('있음'),
                          Radio<bool>(
                            value: false,
                            groupValue: state.hasCompanion,
                            onChanged: (value) => viewModel.updateHasCompanion(value),
                          ),
                          const Text('없음'),
                        ],
                      ),
                    ),
                    if (state.hasCompanion == true)
                      buildSection(
                        '동행인 수',
                        DropdownButton<int?>(
                          value: state.companionCount,
                          hint: const Text('선택해주세요'),
                          isExpanded: true,
                          items: companionCounts.map((count) {
                            return DropdownMenuItem<int?>(  // nullable로 변경
                              value: count,
                              child: Text('$count명'),
                            );
                          }).toList(),
                          onChanged: (value) => viewModel.updateCompanionCount(value),
                        ),
                      ),
                    buildSection(
                      '식사 여부',
                      Row(
                        children: [
                          Radio<bool>(
                            value: true,
                            groupValue: state.willEat,
                            onChanged: (value) => viewModel.updateWillEat(value),
                          ),
                          const Text('예'),
                          Radio<bool>(
                            value: false,
                            groupValue: state.willEat,
                            onChanged: (value) => viewModel.updateWillEat(value),
                          ),
                          const Text('아니오'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: bottomButtonWidget(
                onPressed: state.isFormValid
                    ? () async {
                  final success = await viewModel.submit();
                  if (success && context.mounted) {
                    switch (screenType) {
                      case UserInfoScreenType.init:
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const MainScreen()),
                        );
                        break;
                      case UserInfoScreenType.update:
                        Navigator.pop(context);
                        break;
                    }
                  }
                }
                    : null,
                text: '완료',
                isEnabled: state.isFormValid,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSection(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: titleStyle2),
        title2Gap,
        child,
        itemsGap,
      ],
    );
  }
}