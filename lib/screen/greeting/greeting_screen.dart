import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wedding/design/component/ds_appbar.dart';
import 'package:wedding/design/component/ds_bottom_button.dart';
import 'package:wedding/design/component/ds_textfield.dart';
import 'package:wedding/design/ds_foundation.dart';
import 'package:wedding/screen/di_viewmodel.dart';

class GreetingScreen extends HookConsumerWidget {
  const GreetingScreen({super.key});

  Future<void> _submit(BuildContext context, WidgetRef ref, TextEditingController controller) async {
    try {
      await ref.read(greetingViewModelProvider.notifier).submitGreeting(controller.text);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('방명록 작성 중 오류가 발생했습니다')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(greetingViewModelProvider);
    final controller = useTextEditingController(text: ref.read(greetingViewModelProvider).value ?? '');

    useEffect(() {
      if (state case AsyncData(value: String? message)) {
        controller.text = message ?? '';
      }
      return null;
    }, [state]);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: closeAppBar(context, '축하의 말'),
      body: state.when(
        data: (_) => _buildContent(context, ref, controller),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('오류: $e')),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, TextEditingController controller) {
    final isValidLength = useState(false);

    useEffect(() {
      void listener() {
        final length = controller.text.length;
        isValidLength.value = length >= 10 && length <= 1000;
      }

      controller.addListener(listener);
      return () => controller.removeListener(listener);
    }, [controller]);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          title2Gap,
          const Text('신랑과 신부에게 축하의 말을 전해주세요.', style: titleStyle2),
          itemsGap,
          Expanded(
            child: TextField(
              controller: controller,
              maxLength: 1000,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              cursorColor: Colors.black87,
              decoration: defaultDecor(hint: '너희 두 사람의 결혼을 진심으로 축하해! 함께하는 모든 날들이 행복과 기쁨으로 넘쳐나기를 바라. 멋진 결혼 생활 시작되길 응원할게!'),
            ),
          ),
          itemsGap,
          bottomButtonWidget(
            onPressed: () async {
              _submit(context, ref, controller);
            },
            text: '전달하기',
            isEnabled: isValidLength.value,
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}
