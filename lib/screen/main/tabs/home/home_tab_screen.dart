import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wedding/data/raw/home_raw.dart';
import 'package:wedding/screen/di_viewmodel.dart';
import 'package:wedding/screen/main/tabs/home/home_tab_viewmodel.dart';

class HomeTabScreen extends ConsumerStatefulWidget {
  const HomeTabScreen({super.key});

  @override
  ConsumerState<HomeTabScreen> createState() => _HomeTabScreen();
}

class _HomeTabScreen extends ConsumerState<HomeTabScreen> {
  @override
  void initState() {
    super.initState();
  }

  SizedBox smallGap = const SizedBox(height: 4);
  SizedBox defaultGap = const SizedBox(height: 8);
  SizedBox itemsGap = const SizedBox(height: 24);

  final TextStyle largeBoldTitleStyle = const TextStyle(fontSize: 32, fontWeight: FontWeight.bold);
  final TextStyle titleStyle = const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  final TextStyle descriptionStyle = const TextStyle(fontSize: 12);
  final TextStyle boldDescriptionStyle = const TextStyle(fontSize: 12, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeViewModelProvider);

    return switch (state) {
      Loading() => loading(),
      Success() => Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: state.items
                    .map((item) => switch (item) {
                          BannerRaw(:final title, :final imageUrl) => bannerWidget(imageUrl, title),
                          DateRaw(:final time, :final title) => titleWidget(
                              title,
                              descriptionWidget(time),
                            ),
                          DressCodeRaw(:final title, :final colors) => titleWidget(title, colorWidget(colors)),
                          MoneyRaw(:final title, :final couples) => titleWidget(
                              title,
                              Column(crossAxisAlignment: CrossAxisAlignment.start, children: couples.map((couple) => budgetWidget(couple)).toList()),
                            ),
                          ParkingRaw(:final title) => titleWidget(
                              title,
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 300,
                                  child: mapWidget(item),
                                )),
                              ),
                          PlaceRaw(:final address, :final hall, :final title) => titleWidget(
                              title,
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(hall, style: boldDescriptionStyle),
                                  const SizedBox(width: 8),
                                  Text(address, style: descriptionStyle),
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

  Widget loading() => Scaffold(
        body: Builder(
            builder: (context) => const Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(100),
                      child: Text('로딩중입니다...'),
                    )
                  ],
                )),
      );

  Widget titleWidget(String title, Widget child) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: titleStyle),
          defaultGap,
          child,
          itemsGap,
        ],
      ),
    );
  }

  Widget bannerWidget(String imageUrl, String title) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            imageUrl,
            fit: BoxFit.fitWidth,
            alignment: Alignment.center,
          ),
        ),
        defaultGap,
        Text(title, style: largeBoldTitleStyle),
        itemsGap,
      ],
    );
  }

  Widget colorWidget(List<String> colors) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: colors
          .map((color) => Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Color(int.parse(color.substring(1), radix: 16) + 0xFF000000),
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
          children: [
            Expanded(
              child: Text(couple.account, style: descriptionStyle),
            ),
            IconButton(
              icon: const Icon(Icons.copy, size: 20),
              onPressed: () {
                // 클립보드에 계좌번호 복사
                Clipboard.setData(ClipboardData(text: couple.account));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('계좌번호가 복사되었습니다')),
                );
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
}
