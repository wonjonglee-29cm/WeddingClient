import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wedding/data/raw/component_raw.dart';
import 'package:wedding/design/ds_foundation.dart';
import 'package:wedding/utils/clipboard_utils.dart';
import 'package:wedding/utils/color_utils.dart';

Widget buttonWidget(BuildContext? context, ButtonRaw raw, double? horizontalPadding) {
  return Container(
      color: raw.bgColor?.toColor(),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding ?? 20.0),
            child: InkWell(
              onTap: () async {
                if (raw.link != null) {
                  final uri = Uri.parse(raw.link!);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  }
                } else if (raw.copyText != null) {
                  ClipboardUtils.copy(context, text: raw.copyText!, snackBarMessage: '복사가 완료되었습니다.');
                }
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        raw.text,
                        textAlign: TextAlign.center,
                        style: bodyStyle1,
                      ),
                      if (raw.hasArrow)
                        const Positioned(
                          right: 0,
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.black,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          itemsGap,
        ],
      )
  );
}
