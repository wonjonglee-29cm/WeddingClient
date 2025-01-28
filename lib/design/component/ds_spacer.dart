import 'package:flutter/material.dart';
import 'package:wedding/data/raw/component_raw.dart';
import 'package:wedding/utils/color_utils.dart';

Widget spaceWidget(SpaceRaw raw) {
  return Container(
    height: raw.height ?? 0,
    color: raw.bgColor?.toColor() ?? Colors.transparent,
    width: double.infinity,
  );
}