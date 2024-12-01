import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wedding/screen/di_viewmodel.dart';

import '../main/main_screen.dart';

enum GuestType {
  both('둘 다'),
  groom('신랑'),
  bride('신부');

  final String title;

  const GuestType(this.title);

  // String으로부터 GuestType을 얻기 위한 메서드
  static GuestType? fromString(String? value) {
    if (value == null) return null;
    return GuestType.values.firstWhere(
      (type) => type.name == value.toLowerCase(),
      orElse: () => GuestType.both,
    );
  }
}

class UserInfoScreen extends ConsumerStatefulWidget {
  const UserInfoScreen({super.key});

  @override
  ConsumerState<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends ConsumerState<UserInfoScreen> {
  bool? _willAttend;
  GuestType? _guestType;
  bool? _hasCompanion;
  int? _companionCount;
  bool? _willEat;

  final List<int> _companionCounts = List.generate(10, (i) => i + 1);

  void _submit() async {
    if (_willAttend == null ||
        _guestType == null ||
        _hasCompanion == null ||
        (_hasCompanion == true && _companionCount == null) ||
        _willEat == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('모든 항목을 선택해주세요')),
      );
      return;
    }

    final viewModel = ref.read(userInfoViewModelProvider.notifier);
    final success = await viewModel.updateUserInfo(
      guestType: _guestType!.name,
      isAttendance: _willAttend!,
      isCompanion: _hasCompanion!,
      companionCount: _hasCompanion! ? _companionCount : 0,
      isMeal: _willEat!,
    );

    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userInfoViewModelProvider);

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.error!)),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('하객 정보')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              '참석 여부',
              Row(
                children: [
                  Radio<bool>(
                    value: true,
                    groupValue: _willAttend,
                    onChanged: (value) => setState(() => _willAttend = value),
                  ),
                  const Text('참석'),
                  Radio<bool>(
                    value: false,
                    groupValue: _willAttend,
                    onChanged: (value) => setState(() => _willAttend = value),
                  ),
                  const Text('불참'),
                ],
              ),
            ),
            _buildSection(
              '하객 종류',
              DropdownButton<GuestType>(
                value: _guestType,
                hint: const Text('선택해주세요'),
                isExpanded: true,
                items: GuestType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.title),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _guestType = value),
              ),
            ),
            _buildSection(
              '동행인 여부',
              Row(
                children: [
                  Radio<bool>(
                    value: true,
                    groupValue: _hasCompanion,
                    onChanged: (value) => setState(() => _hasCompanion = value),
                  ),
                  const Text('있음'),
                  Radio<bool>(
                    value: false,
                    groupValue: _hasCompanion,
                    onChanged: (value) => setState(() => _hasCompanion = value),
                  ),
                  const Text('없음'),
                ],
              ),
            ),
            if (_hasCompanion == true)
              _buildSection(
                '동행인 수',
                DropdownButton<int>(
                  value: _companionCount,
                  hint: const Text('선택해주세요'),
                  isExpanded: true,
                  items: _companionCounts.map((count) {
                    return DropdownMenuItem(
                      value: count,
                      child: Text('$count명'),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _companionCount = value),
                ),
              ),
            _buildSection(
              '식사 여부',
              Row(
                children: [
                  Radio<bool>(
                    value: true,
                    groupValue: _willEat,
                    onChanged: (value) => setState(() => _willEat = value),
                  ),
                  const Text('예'),
                  Radio<bool>(
                    value: false,
                    groupValue: _willEat,
                    onChanged: (value) => setState(() => _willEat = value),
                  ),
                  const Text('아니오'),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: _submit,
                child: const Text('완료'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        child,
        const SizedBox(height: 24),
      ],
    );
  }
}
