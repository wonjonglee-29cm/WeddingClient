import 'package:flutter/material.dart';
import 'package:wedding/design/ds_foundation.dart';

Widget titleWidget(String title, Widget child) {
  return SizedBox(
    width: double.infinity,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: titleStyle2),
          title2Gap,
          child,
          itemsGap,
        ],
      ),
    ),
  );
}
