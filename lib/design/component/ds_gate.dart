import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wedding/design/ds_foundation.dart';

Widget gateWidget(String text, String? imageType, String link, double? horizontalPadding) {
  return Column(
    children: [
      Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding ?? 20.0),
          child: InkWell(
              onTap: () async {
                final url = Uri.parse(link);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Icon(
                          imageType == 'video'
                              ? Icons.videocam_outlined
                              : imageType == 'image'
                                  ? Icons.image
                                  : Icons.videocam_outlined,
                          size: 40,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              text,
                              style: titleStyle2,
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                ),
              )
          )
      ),
      itemsGap,
    ],
  );
}
