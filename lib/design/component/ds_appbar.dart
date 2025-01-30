import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wedding/design/ds_foundation.dart';

AppBar backAppBar(String title) => AppBar(
      backgroundColor: Colors.white,
      elevation: 1.0,
      centerTitle: true,
      title: Text(title, style: appBarStyle),
      systemOverlayStyle: systemStyle,
    );

AppBar closeAppBar(BuildContext context, String title) => AppBar(backgroundColor: Colors.white, systemOverlayStyle: systemStyle, automaticallyImplyLeading: false, elevation: 1.0, centerTitle: true, title: Text(title, style: appBarStyle), actions: [
      IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => Navigator.pop(context),
      ),
    ]);

SystemUiOverlayStyle systemStyle = const SystemUiOverlayStyle(
  statusBarColor: tertiaryColor,
  statusBarIconBrightness: Brightness.dark,
  statusBarBrightness: Brightness.light,
);
