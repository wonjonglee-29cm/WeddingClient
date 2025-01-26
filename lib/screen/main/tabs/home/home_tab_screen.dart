import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wedding/data/raw/home_raw.dart';
import 'package:wedding/design/ds_foundation.dart';
import 'package:wedding/screen/di_viewmodel.dart';
import 'package:wedding/screen/main/tabs/home/home_tab_viewmodel.dart';

class HomeTabScreen extends ConsumerStatefulWidget {
  const HomeTabScreen({super.key});

  @override
  ConsumerState<HomeTabScreen> createState() => _HomeTabScreen();
}

class _HomeTabScreen extends ConsumerState<HomeTabScreen> {
  late final PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(viewportFraction: 0.85, initialPage: 0);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeTabViewModelProvider);

    return switch (state) {
      Loading() => loading(),
      Success() =>
          Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: state.items
                      .map((item) =>
                  switch (item) {
                    BannerRaw(:final title, :final imageUrls) =>
                        bannerWidget(imageUrls, title),
                    GateRaw(:final text, :final imageType, :final link) =>
                        gateWidget(text, imageType, link),
                    DateRaw(:final time, :final title) =>
                        titleWidget(
                          title,
                          descriptionWidget(time),
                        ),
                    DressCodeRaw(:final title, :final colors) =>
                        titleWidget(title, colorWidget(colors)),
                    MoneyRaw(:final title, :final couples) =>
                        titleWidget(
                          title,
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: couples
                                  .map((couple) => budgetWidget(couple))
                                  .toList()),
                        ),
                    ParkingRaw(:final title) =>
                        titleWidget(
                          title,
                          ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: SizedBox(
                                width: double.infinity,
                                height: 300,
                                child: mapWidget(item),
                              )),
                        ),
                    PlaceRaw(:final address, :final hall, :final title) =>
                        titleWidget(
                            title,
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Text(hall,
                                          style: boldDescriptionStyle),
                                      const SizedBox(width: 8),
                                      Text(address,
                                          style: descriptionStyle),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.copy, size: 20),
                                  onPressed: () {
                                    copyClipboard(
                                        context, address, '주소가 복사되었습니다');
                                  },
                                ),
                              ],
                            )),
                  })
                      .toList(),
                ),
              ),
            ),
          ),
    };
  }

  Widget loading() =>
      Scaffold(
          backgroundColor: Colors.white,
          body: Builder(
              builder: (context) =>
              const Center(child: CircularProgressIndicator())));

  Widget titleWidget(String title, Widget child) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: titleStyle),
            defaultGap,
            child,
            itemsGap,
          ],
        ),
      ),
    );
  }

  Widget bannerWidget(List<String> imageUrls, String title) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.grey[500]!, Colors.white],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          AspectRatio(
            aspectRatio: 4 / 5,
            child: PageView.builder(
              scrollDirection: Axis.horizontal,
              controller: pageController,
              pageSnapping: true,
              allowImplicitScrolling: true,
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
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
                            imageUrl: imageUrls[index],
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                Container(
                                  color: Colors.grey[200],
                                ),
                            errorWidget: (context, url, error) =>
                                Container(
                                  color: Colors.grey[200],
                                  child: const Icon(
                                      Icons.error_outline_rounded),
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
          defaultGap,
          Text(title, style: largeBoldTitleStyle),
          itemsGap,
        ],
      ),
    );
  }

  Widget gateWidget(String text, String? imageType, String link) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                    padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Icon(
                            imageType == 'video' ? Icons.videocam_outlined :
                            imageType == 'image' ? Icons.image :
                            Icons.videocam_outlined,
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
                                style: titleStyle,
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

  Widget colorWidget(List<String> colors) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: colors
          .map((color) =>
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Color(
                  int.parse(color.substring(1), radix: 16) + 0xFF000000),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
          ))
          .toList(),
    );
  }

  Widget descriptionWidget(String description) {
    return Text(description, style: descriptionStyle);
  }

  Widget budgetWidget(MarriedCoupleRaw couple) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(couple.name, style: boldDescriptionStyle),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(couple.account, style: descriptionStyle),
            ),
            IconButton(
              icon: const Icon(Icons.copy, size: 20),
              onPressed: () {
                copyClipboard(context, couple.account, '계좌번호가 복사되었습니다');
              },
            ),
          ],
        ),
        smallGap
      ],
    );
  }

  Widget mapWidget(ParkingRaw item) {
    if (kIsWeb) {
      return GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(item.lat, item.lon),
          zoom: 15,
        ),
        gestureRecognizers: {
          Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
        },
        zoomGesturesEnabled: false,
        minMaxZoomPreference: const MinMaxZoomPreference(17.0, 17.0),
        markers: {
          Marker(
            markerId: MarkerId(item.hall),
            position: LatLng(item.lat, item.lon),
            infoWindow: InfoWindow(
              title: item.hall,
              snippet: item.snippet,
            ),
          ),
        },
        liteModeEnabled: true,
      );
    } else {
      return NaverMap(
        options: NaverMapViewOptions(
            initialCameraPosition: NCameraPosition(
              target: NLatLng(item.lat, item.lon),
              zoom: 15,
            ),
            zoomGesturesEnable: false,
            stopGesturesEnable: false,
            tiltGesturesEnable: false,
            rotationGesturesEnable: false),
        onMapReady: (controller) {
          controller.addOverlay(
            NMarker(
              id: item.hall,
              position: NLatLng(item.lat, item.lon),
              caption: NOverlayCaption(text: item.hall),
              subCaption: NOverlayCaption(text: item.snippet),
            ),
          );
        },
      );
    }
  }

  void copyClipboard(BuildContext context, String copyText,
      String snackBarText) {
    // 클립보드에 계좌번호 복사
    Clipboard.setData(ClipboardData(text: copyText));

    // 스낵바 표시
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(snackBarText),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
