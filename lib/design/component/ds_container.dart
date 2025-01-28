import 'package:flutter/material.dart';
import 'package:wedding/data/raw/component_raw.dart';
import 'package:wedding/design/component/ds_banner.dart';
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
            GateRaw gate => gateWidget(gate.text, gate.imageType, gate.link, horizontalPadding),
            SpaceRaw space => spaceWidget(space),
            LineRaw line => lineWidget(line, horizontalPadding),
            TextRaw text => textWidget(text, horizontalPadding),
            ImageRaw image => imageWidget(image, horizontalPadding),
            _ => const SizedBox.shrink(),
          };
        }).toList(),
      ),
    ),
  );
}
