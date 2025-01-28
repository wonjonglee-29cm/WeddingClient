sealed class ComponentRaw {
  final String type;

  const ComponentRaw({required this.type});
}

class BannerRaw extends ComponentRaw {
  final List<String> imageUrls;
  final String title;
  final String moreText;
  final String moreLink;
  final String bgColor;

  BannerRaw({
    required this.imageUrls,
    required this.title,
    required this.moreText,
    required this.moreLink,
    required this.bgColor,
    required super.type,
  });

  factory BannerRaw.fromJson(Map<String, dynamic> json) {
    return BannerRaw(
      type: json['type'],
      title: json['title'],
      imageUrls: List<String>.from(json['imageUrls']),
      moreText: json['moreText'] ?? '',
      moreLink: json['moreLink'] ?? '',
      bgColor: json['bgColor'] ?? '',
    );
  }
}

class GateRaw extends ComponentRaw {
  final String text;
  final String? imageType;
  final String link;

  GateRaw({required this.text, required this.imageType, required this.link, required super.type});

  factory GateRaw.fromJson(Map<String, dynamic> json) {
    return GateRaw(
      type: json['type'],
      text: json['text'],
      imageType: json['imageType'],
      link: json['link'],
    );
  }
}

class SpaceRaw extends ComponentRaw {
  final String? bgColor;
  final double? height;

  SpaceRaw({
    required super.type,
    this.bgColor,
    this.height,
  });

  factory SpaceRaw.fromJson(Map<String, dynamic> json) {
    return SpaceRaw(
      type: json['type'],
      bgColor: json['bgColor'],
      height: json['height']?.toDouble(),
    );
  }
}

class LineRaw extends ComponentRaw {
  final String? color;

  LineRaw({
    required super.type,
    this.color,
  });

  factory LineRaw.fromJson(Map<String, dynamic> json) {
    return LineRaw(
      type: json['type'],
      color: json['color'],
    );
  }
}

class TextRaw extends ComponentRaw {
  final String align;
  final String title;
  final String body;
  final String? bgColor;
  final String? iconType;

  TextRaw({
    required this.align,
    required this.title,
    required this.body,
    this.bgColor,
    this.iconType,
    required super.type,
  });

  factory TextRaw.fromJson(Map<String, dynamic> json) {
    return TextRaw(
      type: json['type'],
      align: json['align'],
      title: json['title'],
      body: json['body'],
      bgColor: json['bgColor'],
      iconType: json['iconType'],
    );
  }
}

class CoupleInfoRaw extends ComponentRaw {
  final String brideImageUrl;
  final String groomImageUrl;

  CoupleInfoRaw({
    required this.brideImageUrl,
    required this.groomImageUrl,
    required super.type,
  });

  factory CoupleInfoRaw.fromJson(Map<String, dynamic> json) {
    return CoupleInfoRaw(
      type: json['type'],
      brideImageUrl: json['brideImageUrl'],
      groomImageUrl: json['groomImageUrl'],
    );
  }
}

class ImageRaw extends ComponentRaw {
  final String imageUrl;
  final String? title;
  final String? bgColor;

  ImageRaw({
    required this.imageUrl,
    this.title,
    this.bgColor,
    required super.type,
  });

  factory ImageRaw.fromJson(Map<String, dynamic> json) {
    return ImageRaw(
      type: json['type'],
      imageUrl: json['imageUrl'],
      title: json['title'],
      bgColor: json['bgColor'],
    );
  }
}

class ButtonRaw extends ComponentRaw {
  final String text;
  final String? copyText;
  final String? bgColor;
  final bool hasArrow;
  final String? link;

  ButtonRaw({
    required this.text,
    this.copyText,
    this.bgColor,
    required this.hasArrow,
    this.link,
    required super.type,
  });

  factory ButtonRaw.fromJson(Map<String, dynamic> json) {
    return ButtonRaw(
      type: json['type'],
      text: json['text'],
      copyText: json['copyText'],
      bgColor: json['bgColor'],
      hasArrow: json['hasArrow'] ?? false,
      link: json['link'],
    );
  }
}

class AccountItemRaw {
  final String name;
  final String accountNumber;

  AccountItemRaw({
    required this.name,
    required this.accountNumber,
  });

  factory AccountItemRaw.fromJson(Map<String, dynamic> json) {
    return AccountItemRaw(
      name: json['name'],
      accountNumber: json['accountNumber'],
    );
  }
}

class AccountRaw extends ComponentRaw {
  final String? bgColor;
  final List<AccountItemRaw> account;

  AccountRaw({
    this.bgColor,
    required this.account,
    required super.type,
  });

  factory AccountRaw.fromJson(Map<String, dynamic> json) {
    return AccountRaw(
      type: json['type'],
      bgColor: json['bgColor'],
      account: (json['account'] as List).map((item) => AccountItemRaw.fromJson(item)).toList(),
    );
  }
}
