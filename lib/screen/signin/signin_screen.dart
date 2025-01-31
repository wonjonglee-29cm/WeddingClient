import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wedding/design/component/ds_bottom_button.dart';
import 'package:wedding/design/component/ds_textfield.dart';
import 'package:wedding/design/ds_foundation.dart';
import 'package:wedding/screen/di_viewmodel.dart';
import 'package:wedding/screen/main/main_screen.dart';
import 'package:wedding/screen/signin/signin_viewmodel.dart';
import 'package:wedding/screen/userinfo/user_info_screen.dart';

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
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFieldWidget(
                      controller: _idController,
                      decoration: defaultDecor(hint: '홍길동', labelText: '이름을 입력해주세요.'),
                      maxLength: 6,
                      validator: (value) {
                        if (value?.isEmpty ?? true) return '이름을 입력해주세요.';
                        return null;
                      },
                    ).animate().fadeIn().slideY(begin: 1, end: 0),
                    itemsGap,
                    TextFieldWidget(
                      controller: _passwordController,
                      decoration: defaultDecor(hint: '0000', labelText: '전화번호 뒷자리를 입력해주세요 (4자리)'),
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      obscureText: true,
                      validator: (value) {
                        if (value?.isEmpty ?? true) return '전화번호 뒷자리를 입력해주세요';
                        if (value?.length != 4) return '4자리의 숫자를 입력해야 합니다';
                        return null;
                      },
                    ).animate().fadeIn().slideY(begin: 1, end: 0, delay: const Duration(milliseconds: 200)),
                  ],
                ),
              ),
              itemsGap,
              SizedBox(
                height: 40,
                child: Text(
                  state.error ?? '',
                  style: bodyStyle2.copyWith(color: Colors.red),
                ),
              ),
              const Spacer(),
              bottomButtonWidget(
                      onPressed: state.isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState?.validate() ?? false) {
                                await ref.read(signInViewModelProvider.notifier).signIn(_idController.text, _passwordController.text);
                              }
                            },
                      text: '로그인',
                      padding: EdgeInsets.zero)
                  .animate()
                  .fadeIn()
                  .slideY(begin: 1, end: 0, delay: const Duration(milliseconds: 400)),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration defaultDecor({String? hint, String? labelText}) => InputDecoration(
        hintText: hint,
        hintStyle: bodyStyle2.copyWith(color: Colors.grey[300]),
        labelText: labelText,
        labelStyle: bodyStyle2,
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: secondaryColor),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        fillColor: Colors.white,
        // 배경색
        filled: true,
      );
}
