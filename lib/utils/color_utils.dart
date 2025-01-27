import 'dart:ui';

import 'package:flutter/material.dart';

extension HexColor on String {
  Color toColor() {
    try {
      final hexString = this;
      final buffer = StringBuffer();

      // # 제거하고 대문자로 변환
      String hex = hexString.replaceFirst('#', '').toUpperCase();

      // 유효한 hex 문자열인지 검증
      if (!RegExp(r'^[0-9A-F]{6}$').hasMatch(hex)) {
        return Colors.white; // 또는 기본 색상
      }

      buffer.write('FF'); // alpha 값
      buffer.write(hex);

      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (e) {
      return Colors.white; // 에러 발생시 기본 색상 반환
    }
  }
}