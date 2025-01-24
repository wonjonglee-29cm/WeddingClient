import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wedding/screen/di_viewmodel.dart';
import 'package:wedding/screen/main/main_screen.dart';
import 'package:wedding/screen/signin/signin_viewmodel.dart';
import 'package:wedding/screen/userinfo/user_info_screen.dart';
import 'package:wedding/ui/wedding_textfield.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignScreenState();
}

class _SignScreenState extends ConsumerState<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  InputDecoration weddingTextFieldDecoration({required String labelText}) => InputDecoration(
    labelText: labelText,
    border: const OutlineInputBorder(),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black87),
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signInViewModelProvider);

    ref.listen<SignInState>(signInViewModelProvider, (prev, next) {
      if (next.isSignedIn) {
        if (next.hasInfo) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UserInfoScreen()),
          );
        }
      }
    });

    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              WeddingTextField(
                controller: _idController,
                decoration: weddingTextFieldDecoration(labelText: '이름을 입력해주세요.'),
                maxLength: 6,
                validator: (value) {
                  if (value?.isEmpty ?? true) return '이름을 입력해주세요.';
                  return null;
                },
              ).animate().fadeIn().slideY(begin: 1, end: 0),
              const SizedBox(height: 24),
              WeddingTextField(
                controller: _passwordController,
                decoration: weddingTextFieldDecoration(labelText: '전화번호 뒷자리를 입력해주세요 (4자리)'),
                keyboardType: TextInputType.number,
                maxLength: 4,
                obscureText: true,
                validator: (value) {
                  if (value?.isEmpty ?? true) return '전화번호 뒷자리를 입력해주세요';
                  if (value?.length != 4) return '4자리의 숫자를 입력해야 합니다';
                  return null;
                },
              ).animate().fadeIn().slideY(begin: 1, end: 0, delay: const Duration(milliseconds: 200)),
              const SizedBox(height: 24),
              if (state.error != null)
                Text(
                  state.error!,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: state.isLoading
                    ? null
                    : () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          await ref.read(signInViewModelProvider.notifier).signIn(_idController.text, _passwordController.text);
                        }
                      },
                child: state.isLoading ? const CircularProgressIndicator() : const Text('로그인'),
              ).animate().fadeIn().slideY(begin: 1, end: 0, delay: const Duration(milliseconds: 400)),
            ],
          ),
        ),
      )),
    );
  }
}
