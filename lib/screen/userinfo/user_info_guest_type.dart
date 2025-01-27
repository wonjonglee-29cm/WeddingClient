
enum GuestType {
  both('둘 다'),
  groom('신랑'),
  bride('신부');

  final String title;

  const GuestType(this.title);

  // String으로부터 GuestType을 얻기 위한 메서드
  static GuestType? fromString(String? value) {
    if (value == null) return null;
    return GuestType.values.firstWhere(
          (type) => type.name == value.toLowerCase(),
      orElse: () => GuestType.both,
    );
  }
}