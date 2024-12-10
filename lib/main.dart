import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wedding/data/di_preference.dart';
import 'package:wedding/screen/intro/intro_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  await container.read(sharedPreferencesProvider.future);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (!kIsWeb) {
    await NaverMapSdk.instance.initialize(
      clientId: 'mk93958mhn',
      onAuthFailed: (ex) {
        debugPrint("********* 네이버맵 인증오류 : $ex *********");
      },
    );
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const WeddingApp(),
    ),
  );
}

class WeddingApp extends StatelessWidget {
  const WeddingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wedding Invitation',
      theme: ThemeData(
        primaryColor: Colors.white70,
        primarySwatch: Colors.blueGrey,
        fontFamily: 'NotoSans',
      ),
      home: const IntroScreen(),
    );
  }
}
