import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wedding/data/raw/component_raw.dart';
import 'package:wedding/design/ds_foundation.dart';
import 'package:wedding/utils//color_utils.dart';

Widget bannerWidget(PageController pageController, BannerRaw raw) {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [raw.bgColor.toColor(), Colors.white],
      ),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        itemsGap,
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            AspectRatio(
              aspectRatio: 4 / 5,
              child: PageView.builder(
                scrollDirection: Axis.horizontal,
                controller: pageController,
                pageSnapping: true,
                allowImplicitScrolling: true,
                itemCount: raw.imageUrls.length + 1,
                // 추가 버튼을 위해 +1
                itemBuilder: (context, index) {
                  // 마지막 페이지는 더 보기 버튼
                  if (index == raw.imageUrls.length) {
                    return GestureDetector(
                      onTap: () async {
                        final url = Uri.parse(raw.moreLink);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url, mode: LaunchMode.externalApplication);
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.black.withOpacity(0.5),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.add_circle_outline, color: Colors.white, size: 50),
                              const SizedBox(height: 10),
                              Text(
                                raw.moreText,
                                style: whiteTitleStyle2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  return AnimatedBuilder(
                    animation: pageController,
                    builder: (context, child) {
                      double scale = index == 0 ? 1.0 : 0.9; // 초기 상태
                      if (pageController.position.hasContentDimensions) {
                        final value = pageController.page! - index;
                        scale = (1 - (value.abs() * 0.1)).clamp(0.9, 1.0);
                      }
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 0),
                        child: Transform.scale(
                          scale: scale,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: CachedNetworkImage(
                              imageUrl: raw.imageUrls[index],
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.grey[200],
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey[200],
                                child: const Icon(Icons.error_outline_rounded),
                              ),
                              cacheManager: CacheManager(
                                Config(
                                  'imageCache',
                                  stalePeriod: const Duration(days: 30),
                                  maxNrOfCacheObjects: 100,
                                ),
                              ),
                              useOldImageOnUrlChange: true,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Positioned(
              bottom: 0,
              child: Column(
                children: [
                  defaultGap,
                  Text(raw.title, style: whiteTitleStyle1),
                  itemsGap,
                ],
              ),
            ),
          ],
        ),
        itemsGap,
      ],
    ),
  );
}
