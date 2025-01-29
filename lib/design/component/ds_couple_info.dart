import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wedding/design/ds_foundation.dart';
import 'package:wedding/utils/color_utils.dart';

Widget couplePhotoWidget(String groomImageUrl, String brideImageUrl) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
    child: Column(
      children: [
        // 부모님 이름
        const Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 150,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '이건식 · 김명옥',
                          style: titleStyle2,
                        ),
                        TextSpan(text: '의', style: bodyStyle1),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(width: 8),
                SizedBox(
                  width: 50, // 적절한 너비 설정
                  child: Text(
                    '아들',
                    style: bodyStyle1,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(width: 8),
                SizedBox(
                  width: 50, // 적절한 너비 설정
                  child: Text(
                    '원종',
                    style: titleStyle2,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 150,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '정홍원 · 정옥연',
                          style: titleStyle2,
                        ),
                        TextSpan(text: '의', style: bodyStyle1),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(width: 8),
                SizedBox(
                  width: 50,
                  child: Text(
                    '딸',
                    style: bodyStyle1,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(width: 8),
                SizedBox(
                  width: 50,
                  child: Text(
                    '민경',
                    style: titleStyle2,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 40),

        // 사진
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 신랑 사진
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(64),
                  child: CachedNetworkImage(
                    imageUrl: groomImageUrl,
                    width: 128,
                    height: 128,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 12),
                const Text('신랑 이원종', style: bodyStyle1),
              ],
            ),

            // 하트 아이콘
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Icon(Icons.favorite, color: '#E34358'.toColor(), size: 32),
            ),

            // 신부 사진
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(64),
                  child: CachedNetworkImage(
                    imageUrl: brideImageUrl,
                    width: 128,
                    height: 128,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 12),
                const Text('신부 정민경', style: bodyStyle1),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}
