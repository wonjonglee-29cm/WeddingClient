import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wedding/data/di_preference.dart';
import 'package:wedding/design/ds_foundation.dart';
import 'package:wedding/screen/intro/intro_screen.dart';
import 'package:wedding/screen/main/main_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: tertiaryColor,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
    ),
  );

  final container = ProviderContainer();
  await container.read(sharedPreferencesProvider.future);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
      initialRoute: '/',
      routes: {
        '/': (context) => const IntroScreen(),
        '/home': (context) => const MainScreen(),
        '/event': (context) => const MainScreen(initialTab: 1)
      },
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: mainMaterialColor,
            brightness: Brightness.light,
          ),
          fontFamily: 'NotoSans',
      ),
    );
  }
}
