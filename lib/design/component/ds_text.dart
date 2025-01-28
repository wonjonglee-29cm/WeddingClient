import 'package:flutter/material.dart';
import 'package:wedding/data/raw/component_raw.dart';
import 'package:wedding/design/ds_foundation.dart';
import 'package:wedding/utils/color_utils.dart';

Widget textWidget(TextRaw raw) {
  // 정렬 방향 설정
  final alignment = raw.align == 'center' ? MainAxisAlignment.center : MainAxisAlignment.start;

  // 텍스트 정렬 설정
  final textAlign = raw.align == 'center' ? TextAlign.center : TextAlign.start;

  final titleStyle = raw.align == 'center' ? titleStyle1.copyWith(height: 3) : titleStyle2;
  final bodyStyle = raw.align == 'center' ? bodyStyle1.copyWith(height: 2.2) : bodyStyle2.copyWith(height: 1.75);

  // 아이콘 매핑
  IconData? icon;
  switch (raw.iconType) {
    case 'map':
      icon = Icons.location_on_outlined;
    case 'parking':
      icon = Icons.local_parking_outlined;
    case 'clothes':
      icon = Icons.checkroom_outlined;
    default:
      icon = null;
  }

  return Container(
    width: double.infinity,
    color: raw.bgColor?.toColor(),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    child: Column(
      crossAxisAlignment: raw.align == 'center' ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: raw.align == 'center' ? MainAxisAlignment.center : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null) ...[Icon(icon, size: 20), const SizedBox(width: 8)],
            Expanded(
              // Expanded 추가
              child: Text(
                raw.title,
                style: titleStyle,
                textAlign: textAlign,
              ),
            )
          ],
        ),
        SizedBox(height: raw.align == 'center' ? 4 : 10),
        Text(
          raw.body,
          style: bodyStyle,
          textAlign: textAlign,
        ),
      ],
    ),
  );
}
