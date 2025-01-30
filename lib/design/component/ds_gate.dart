import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wedding/data/raw/component_raw.dart';
import 'package:wedding/design/ds_foundation.dart';

Widget gateWidget(GateRaw gate, double? horizontalPadding) {
  return Column(
    children: [
      Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding ?? 20.0),
          child: InkWell(
              onTap: () async {
                final url = Uri.parse(gate.link);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Icon(
                          gate.imageType == 'video'
                              ? Icons.videocam_outlined
                              : gate.imageType == 'image'
                                  ? Icons.image
                                  : Icons.videocam_outlined,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              gate.text,
                              style: titleStyle2,
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 20),
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
