import 'package:flutter/material.dart';
import 'package:wedding/data/raw/component_raw.dart';
import 'package:wedding/utils/color_utils.dart';

Widget lineWidget(LineRaw raw, double? horizontalPadding) {
  return Column(
    children: [
      Padding(
          padding: EdgeInsets.only(
            left: horizontalPadding ?? 20.0,
            right: horizontalPadding ?? 20.0,
            top: raw.paddingTop ?? 0,
            bottom: raw.paddingBottom ?? 0
          ),
          child: Container(
            height: 1,  // 1px 두께
            color: raw.color?.toColor() ?? Colors.black,
          )
      ),
    ],
  );
}
