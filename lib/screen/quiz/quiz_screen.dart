import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wedding/data/raw/quiz_raw.dart';
import 'package:wedding/design/ds_foundation.dart';
import 'package:wedding/screen/di_viewmodel.dart';
import 'package:wedding/screen/quiz/quiz_viewmodel.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreen();
}
class _QuizScreen extends ConsumerState<QuizScreen> {
  PageController? _pageController;  // nullable로 변경
  Map<int, int> _selectedAnswers = {};

  @override
  void initState() {
    super.initState();
    // 초기 상태 확인 및 PageController 초기화
    final state = ref.read(quizViewModelProvider);
    if (state case Success(:final currentPage)) {
      _pageController = PageController(initialPage: currentPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(quizViewModelProvider);

        return switch (state) {
          Loading() => const Center(child: CircularProgressIndicator()),
          Success(
          count: final count,
          items: final items,
          currentPage: final currentPage,
          ) => _buildQuizContent(items, currentPage),
        };
      },
    );
  }

  Widget _buildQuizContent(List<QuizRaw> items, int currentPage) {
    // PageController가 아직 초기화되지 않았다면 초기화
    _pageController ??= PageController(initialPage: currentPage);

    return Scaffold(
      appBar: AppBar(
        title: const Text('웨딩 퀴즈'),
      ),
      body: Column(
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
              onPageChanged: (page) {
                ref.read(quizViewModelProvider.notifier).updateCurrentPage(page);
              },
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
                if (currentPage == items.length - 1)
                  ElevatedButton(
                    onPressed: _selectedAnswers.containsKey(items[currentPage].id)
                        ? () {
                      // TODO: 답안 제출 로직 구현
                      Navigator.of(context).pop();
                    }
                        : null,
                    child: const Text('완료'),
                  )
                else
                  ElevatedButton(
                    onPressed: _selectedAnswers.containsKey(items[currentPage].id)
                        ? () {
                      final nextPage = currentPage + 1;
                      _pageController?.jumpToPage(nextPage);
                    }
                        : null,
                    child: const Text('다음'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }
}