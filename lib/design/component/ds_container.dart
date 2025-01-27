import 'package:flutter/material.dart';
import 'package:wedding/data/raw/component_raw.dart';
import 'package:wedding/design/component/ds_banner.dart';
import 'package:wedding/design/component/ds_gate.dart';

Widget componentsContainerWidget(List<ComponentRaw> items, {PageController? pageController}) {
  return Scaffold(
    backgroundColor: const Color(0x00fefefd),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 29),
        child: Column(
          children: items.map((item) {  // 여기서 map 메서드를 사용하므로 const가 불가능
            return switch (item) {
              BannerRaw banner => pageController == null
                  ? const SizedBox.shrink()
                  : bannerWidget(pageController, banner),

              GateRaw gate => gateWidget(gate.text, gate.imageType, gate.link),

              _ => const SizedBox.shrink(),
            };
          }).toList(),
        ),
      ),
    ),
  );
}