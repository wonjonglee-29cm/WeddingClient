import 'package:flutter/material.dart';
import 'package:wedding/data/raw/component_raw.dart';
import 'package:wedding/utils/color_utils.dart';

Widget lineWidget(LineRaw raw, double? horizontalPadding) {
  return Column(
    children: [
      Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding ?? 20.0),
          child: Container(
            height: 1, // 1px 두께
            color: raw.color?.toColor() ?? Colors.black,
          )),
    ],
  );
}
