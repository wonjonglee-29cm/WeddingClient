import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wedding/design/component/ds_appbar.dart';
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
      appBar: closeAppBar(context, '방명록'),
      body: state.when(
        data: (_) => _buildContent(context, ref, controller),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('오류: $e')),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          defaultGap,
          const Text('축하인사를 작성해주세요', style: titleStyle),
          defaultGap,
          Expanded(
              child: TextField(
            controller: controller,
            maxLength: 1000,
            maxLines: null,
            expands: true,
            textAlignVertical: TextAlignVertical.top,
            cursorColor: Colors.black87,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black87),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
          )),
          itemsGap,
          ElevatedButton(
            onPressed: () => _submit(context, ref, controller),
            child: const Text('전달하기'),
          ),
        ],
      ),
    );
  }
}
