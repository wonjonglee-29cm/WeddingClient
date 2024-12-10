import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wedding/design/ds_foundation.dart';

class PictureScreen extends ConsumerStatefulWidget {
  const PictureScreen({super.key});

  @override
  ConsumerState<PictureScreen> createState() => _PictureScreen();
}

class _PictureScreen extends ConsumerState<PictureScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          '콘테스트',
          style: appBarStyle,
        ),
      ),
      body: const Center(
        child: Text('사진 콘테스트 화면'),
      ),
    );
  }
}
