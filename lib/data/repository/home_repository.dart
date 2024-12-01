import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wedding/data/raw/home_raw.dart';

class HomeRepository {
  final FirebaseFirestore _firestore;
  static const String COLLECTION_NAME = 'wedding';
  static const String DOC_NAME = 'home';

  HomeRepository(this._firestore);

  Future<List<HomeRaw>> getHomeItems() async {
    final items = await _firestore.collection(COLLECTION_NAME).doc(DOC_NAME).get();

    return convertFirebaseData(items.data() ?? {});
  }

  List<HomeRaw> convertFirebaseData(Map<String, dynamic> data) {
    List<HomeRaw> items = [];

    // Date 변환
    if (data['date'] != null) {
      final dateData = data['date'] as Map<String, dynamic>;
      final timestamp = dateData['time'] as Timestamp;
      final dateTime = timestamp.toDate();
      items.add(DateRaw(
        index: dateData['index'] as int,
        time: "${dateTime.year}년 ${dateTime.month}월 ${dateTime.day}일 ${dateTime.hour}시 ${dateTime.minute}분",
        title: dateData['title'] as String,
      ));
    }

    // DressCode 변환
    if (data['banner'] != null) {
      final bannerData = data['banner'] as Map<String, dynamic>;
      items.add(BannerRaw(
        index: bannerData['index'] as int,
        imageUrl: bannerData['imageUrl'] as String,
        title: bannerData['title'] as String,
      ));
    }

    // DressCode 변환
    if (data['dresscode'] != null) {
      final dressCodeData = data['dresscode'] as Map<String, dynamic>;
      items.add(DressCodeRaw(
        index: dressCodeData['index'] as int,
        title: dressCodeData['title'] as String,
        colors: List<String>.from(dressCodeData['colors']),
      ));
    }

    // Money 변환
    if (data['money'] != null) {
      final moneyData = data['money'] as Map<String, dynamic>;
      final List<MarriedCoupleRaw> couples = [];

      // 신랑
      if (moneyData['groom'] != null) {
        final groom = moneyData['groom'] as Map<String, dynamic>;
        couples.add(MarriedCoupleRaw(
          account: groom['account'] as String,
          index: groom['index'] as int,
          name: groom['name'] as String,
        ));
      }

      // 신부
      if (moneyData['bride'] != null) {
        final bride = moneyData['bride'] as Map<String, dynamic>;
        couples.add(MarriedCoupleRaw(
          account: bride['account'] as String,
          index: bride['index'] as int,
          name: bride['name'] as String,
        ));
      }

      // 신랑 부모님
      if (moneyData['groomParent'] != null) {
        final groomParent = moneyData['groomParent'] as Map<String, dynamic>;
        couples.add(MarriedCoupleRaw(
          account: groomParent['account'] as String,
          index: groomParent['index'] as int,
          name: groomParent['name'] as String,
        ));
      }

      // 신부 부모님
      if (moneyData['brideParent'] != null) {
        final brideParent = moneyData['brideParent'] as Map<String, dynamic>;
        couples.add(MarriedCoupleRaw(
          account: brideParent['account'] as String,
          index: brideParent['index'] as int,
          name: brideParent['name'] as String,
        ));
      }

      couples.sort((a, b) => a.index.compareTo(b.index));

      items.add(MoneyRaw(
        index: moneyData['index'] as int,
        title: moneyData['title'] as String,
        couples: couples,
      ));
    }

    // Parking 변환
    if (data['parking'] != null) {
      final parkingData = data['parking'] as Map<String, dynamic>;
      final geoPoint = parkingData['geo'] as GeoPoint;
      items.add(ParkingRaw(
        index: parkingData['index'] as int,
        lat: geoPoint.latitude,
        lon: geoPoint.longitude,
        hall: parkingData['hall'] as String,
        title: parkingData['title'] as String,
        snippet: parkingData['snippet'] as String,
      ));
    }

    // Place 변환
    if (data['place'] != null) {
      final placeData = data['place'] as Map<String, dynamic>;
      items.add(PlaceRaw(
        index: placeData['index'] as int,
        address: placeData['address'] as String,
        hall: placeData['hall'] as String,
        title: placeData['title'] as String,
      ));
    }

    // index 기준으로 정렬
    items.sort((a, b) => a.index.compareTo(b.index));

    return items;
  }
}
