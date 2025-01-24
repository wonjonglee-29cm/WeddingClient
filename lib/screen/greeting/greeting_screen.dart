import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wedding/screen/di_viewmodel.dart';

class GreetingScreen extends ConsumerWidget {
  GreetingScreen({super.key});

  final TextEditingController _controller = TextEditingController();

  Future<void> _submit(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(greetingViewModelProvider.notifier).submitGreeting(_controller.text);
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('방명록'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: state.when(
        data: (_) => _buildContent(context, ref),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('오류: $e')),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('축하인사를 작성해주세요'),
          Expanded(
            child: TextField(
              controller: _controller,
              maxLength: 1000,
              maxLines: null,
              expands: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => _submit(context, ref),
            child: const Text('전달하기'),
          ),
        ],
      ),
    );
  }
}