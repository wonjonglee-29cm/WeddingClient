import 'package:flutter/material.dart';
import 'package:wedding/design/ds_foundation.dart';

Widget errorWidget({
  required VoidCallback onRetry,
}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('알 수 없는 에러가 발생했습니다.'),
        itemsGap,
        ElevatedButton(
          onPressed: onRetry,
          child: const Text('다시 시도해보기'),
        ),
      ],
    ),
  );
}