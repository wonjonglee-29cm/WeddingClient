import 'package:flutter/material.dart';

extension HexColor on String {
  Color toColor() {
    try {
      final hexString = this;

      // # 제거하고 대문자로 변환
      String hex = hexString.replaceFirst('#', '').toUpperCase();

      // 유효한 hex 문자열인지 검증 (6자리 또는 8자리)
      if (!RegExp(r'^[0-9A-F]{6}$|^[0-9A-F]{8}$').hasMatch(hex)) {
        return Colors.white; // 또는 기본 색상
      }

      // 6자리인 경우 alpha 값 추가
      if (hex.length == 6) {
        hex = 'FF$hex';
      }

      return Color(int.parse(hex, radix: 16));
    } catch (e) {
      return Colors.white; // 에러 발생시 기본 색상 반환
    }
  }
}