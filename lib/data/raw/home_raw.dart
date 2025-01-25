

sealed class HomeRaw {
  final int index;

  const HomeRaw({required this.index});
}

class BannerRaw extends HomeRaw {
  final List<String> imageUrls;
  final String title;

  const BannerRaw({
    required super.index,
    required this.imageUrls,
    required this.title,
  });
}

class DateRaw extends HomeRaw {
  final String time;
  final String title;

  const DateRaw({
    required super.index,
    required this.time,
    required this.title,
  });
}

class DressCodeRaw extends HomeRaw {
  final String title;
  final List<String> colors;

  const DressCodeRaw({
    required super.index,
    required this.title,
    required this.colors,
  });
}

class MoneyRaw extends HomeRaw {
  final String title;
  final List<MarriedCoupleRaw> couples;

  const MoneyRaw({
    required super.index,
    required this.title,
    required this.couples,
  });
}

class MarriedCoupleRaw {
  final String account;
  final int index;
  final String name;

  const MarriedCoupleRaw({
    required this.account,
    required this.index,
    required this.name,
  });
}

class ParkingRaw extends HomeRaw {
  final String title;
  final String hall;
  final String snippet;
  final double lat;
  final double lon;

  const ParkingRaw({
    required super.index,
    required this.title,
    required this.hall,
    required this.snippet,
    required this.lat,
    required this.lon,
  });
}

class PlaceRaw extends HomeRaw {
  final String address;
  final String hall;
  final String title;

  const PlaceRaw({
    required super.index,
    required this.address,
    required this.hall,
    required this.title,
  });
}
