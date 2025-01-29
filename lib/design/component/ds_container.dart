import 'package:flutter/material.dart';
import 'package:wedding/data/raw/component_raw.dart';
import 'package:wedding/design/component/ds_banner.dart';
import 'package:wedding/design/component/ds_couple_info.dart';
import 'package:wedding/design/component/ds_gate.dart';
import 'package:wedding/design/component/ds_image.dart';
import 'package:wedding/design/component/ds_line.dart';
import 'package:wedding/design/component/ds_spacer.dart';
import 'package:wedding/design/component/ds_text.dart';

Widget componentsContainerWidget(List<ComponentRaw> items, {PageController? pageController, double? horizontalPadding}) {
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Column(
        children: items.map((item) {
          return switch (item) {
            BannerRaw banner => pageController == null ? const SizedBox.shrink() : bannerWidget(pageController, banner),
            GateRaw raw => gateWidget(raw.text, raw.imageType, raw.link, horizontalPadding),
            SpaceRaw raw => spaceWidget(raw),
            LineRaw raw => lineWidget(raw, horizontalPadding),
            TextRaw raw => textWidget(raw, horizontalPadding),
            ImageRaw raw => imageWidget(raw, horizontalPadding),
            CoupleInfoRaw raw => couplePhotoWidget(raw.groomImageUrl, raw.brideImageUrl),
            ButtonRaw raw => const SizedBox.shrink(),
            AccountItemRaw raw => const SizedBox.shrink(),

            _ => const SizedBox.shrink(),
          };
        }).toList(),
      ),
    ),
  );
}
