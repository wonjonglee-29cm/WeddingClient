import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wedding/data/raw/quiz_raw.dart';
import 'package:wedding/design/component/ds_bottom_button.dart';
import 'package:wedding/design/ds_foundation.dart';
import 'package:wedding/screen/di_viewmodel.dart';
import 'package:wedding/screen/quiz/quiz_viewmodel.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreen();
}

class _QuizScreen extends ConsumerState<QuizScreen> {
  PageController? _pageController;
  InAppWebViewController? webViewController;
  final Map<int, int> _selectedAnswers = {};

  @override
  void initState() {
    super.initState();
    final state = ref.read(quizViewModelProvider);
    if (state case Success(:final currentPage)) {
      _pageController = PageController(initialPage: currentPage);
    }
  }

  Future<bool> _onWillPop() async {
    if (await webViewController?.canGoBack() ?? false) {
      await webViewController?.goBack();
      return false;
    }
    return true;
  }

  Future<void> _submitAnswer(int quizId, int selectedAnswer) async {
    try {
      final isAllDone = await ref.read(quizViewModelProvider.notifier).postQuizAnswer(quizId, selectedAnswer);

      if (isAllDone) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('모든 문제를 풀었습니다')),
          );
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
        backgroundColor: tertiaryColor,
        title: const Text('Quiz', style: appBarStyle),
      ),
      body: Consumer(
        builder: (context, ref, _) {
          final state = ref.watch(quizViewModelProvider);
          return WillPopScope(
            onWillPop: _onWillPop,
            child: Scaffold(
                body: switch (state) {
              Loading() => const Center(child: CircularProgressIndicator()),
              Success(
                items: final items,
                currentPage: final currentPage,
              ) =>
                _buildQuizContent(items, currentPage),
              Done() => buildWebView(),
            }),
          );
        },
      ),
    );
  }

  Widget buildWebView() {
    const uri = 'https://captainwonjong.notion.site/LeeWonJong-Android-Dev-a6e27f81420f4b0bad7b0271a3d5366f';

    if (kIsWeb) {
      return Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: bottomButtonWidget(
            onPressed: () async {
              final url = Uri.parse(uri);
              if (await canLaunchUrl(url)) {
                await launchUrl(
                  url,
                  mode: LaunchMode.externalApplication,
                );
              }
            },
            text: '정답 확인하기',
          ),
        ),
      );
    } else {
      return InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri(uri),
        ),
      );
    }
  }

  Widget _buildQuizContent(List<QuizRaw> items, int currentPage) {
    _pageController ??= PageController(initialPage: currentPage);

    return Column(
      children: [
        LinearProgressIndicator(
          value: (currentPage + 1) / items.length,
          backgroundColor: Colors.grey[200],
          valueColor: const AlwaysStoppedAnimation<Color>(primaryColor),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            '${currentPage + 1} / ${items.length}',
            style: titleStyle2,
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
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        quiz.question,
                        style: titleStyle1,
                      )
                    ),
                    itemsGap,
                    ...List.generate(quiz.options.length, (optionIndex) => radioItemWidget(quiz, optionIndex)),
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: bottomButtonWidget(
            onPressed: () => _submitAnswer(items[currentPage].id, _selectedAnswers[items[currentPage].id]!),
            text: currentPage == items.length - 1 ? '완료' : '다음',
            isEnabled: _selectedAnswers.containsKey(items[currentPage].id),
          ),
        ),
      ],
    );
  }

  Widget radioItemWidget(QuizRaw quiz, int optionIndex) => InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: quiz.isDone
            ? null
            : () {
                setState(() {
                  _selectedAnswers[quiz.id] = optionIndex;
                });
              },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _selectedAnswers[quiz.id] == optionIndex
                        ? primaryColor // 선택된 상태 색상
                        : secondaryColor, // 기본 상태 색상
                    width: 2,
                  ),
                ),
                child: _selectedAnswers[quiz.id] == optionIndex
                    ? Center(
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: primaryColor, // 선택된 상태의 내부 원 색상
                          ),
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  quiz.options[optionIndex],
                  style: TextStyle(
                    fontSize: bodyStyle1.fontSize,
                    color: quiz.isDone ? Colors.grey : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }
}
