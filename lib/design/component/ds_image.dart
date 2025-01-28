import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:wedding/data/raw/component_raw.dart';
import 'package:wedding/design/ds_foundation.dart';
import 'package:wedding/utils/color_utils.dart';

Widget imageWidget(ImageRaw raw, double? horizontalPadding) {
  return Container(
    width: double.infinity,
    color: raw.bgColor?.toColor(),
    padding: EdgeInsets.symmetric(horizontal: horizontalPadding ?? 20.0),
    child: Column(
      children: [
        if (raw.title != null) ...[
          Text(
            raw.title!,
            style: titleStyle2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
        ],
        CachedNetworkImage(
          imageUrl: raw.imageUrl,
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
        itemsGap
      ],
    ),
  );
}