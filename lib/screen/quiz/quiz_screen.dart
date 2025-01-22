import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wedding/data/raw/quiz_raw.dart';
import 'package:wedding/screen/quiz/quiz_viewmodel.dart';
import 'package:wedding/screen/di_viewmodel.dart';

import '../../design/ds_foundation.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreen();
}

class _QuizScreen extends ConsumerState<QuizScreen> {
  PageController? _pageController;
  final Map<int, int> _selectedAnswers = {};

  @override
  void initState() {
    super.initState();
    final state = ref.read(quizViewModelProvider);
    if (state case Success(:final currentPage)) {
      _pageController = PageController(initialPage: currentPage);
    }
  }

  Future<void> _submitAnswer(int quizId, int selectedAnswer) async {
    try {
      final isAllDone = await ref.read(quizViewModelProvider.notifier)
          .postQuizAnswer(quizId, selectedAnswer);

      if (isAllDone) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('모든 문제를 풀었습니다')),
          );
          Navigator.of(context).pop();
        }
      } else {
        final state = ref.read(quizViewModelProvider);
        if (state case Success s) {
          _pageController?.jumpToPage(s.currentPage);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('답변 제출 중 오류가 발생하였습니다')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1.0,
        title: const Text('Quiz', style: appBarStyle),
      ),
      body: Consumer(
        builder: (context, ref, _) {
          final state = ref.watch(quizViewModelProvider);

          return switch (state) {
            Loading() => const Center(child: CircularProgressIndicator()),
            Success(
              items: final items,
              currentPage: final currentPage,
            ) =>
              _buildQuizContent(items, currentPage),
            Done() => const Center(child: Text('모든 퀴즈를 풀었습니다')),
          };
        },
      ),
    );
  }

  Widget _buildQuizContent(List<QuizRaw> items, int currentPage) {
    _pageController ??= PageController(initialPage: currentPage);

    return Column(
      children: [
        LinearProgressIndicator(
          value: (currentPage + 1) / items.length,
          backgroundColor: Colors.grey[200],
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            '${currentPage + 1} / ${items.length}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final quiz = items[index];
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quiz.question,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ...List.generate(
                      quiz.options.length,
                      (optionIndex) => RadioListTile<int>(
                        title: Text(quiz.options[optionIndex]),
                        value: optionIndex,
                        groupValue: _selectedAnswers[quiz.id],
                        onChanged: quiz.isDone
                            ? null
                            : (value) {
                                setState(() {
                                  _selectedAnswers[quiz.id] = value!;
                                });
                              },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _selectedAnswers.containsKey(items[currentPage].id)
                    ? () => _submitAnswer(items[currentPage].id, _selectedAnswers[items[currentPage].id]!)
                    : null,
                child: Text(currentPage == items.length - 1 ? '완료' : '다음'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }
}
