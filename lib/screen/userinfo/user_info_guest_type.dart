enum GuestType {
  BOTH('둘 다'),
  GROOM('신랑'),
  BRIDE('신부');

  final String title;

  const GuestType(this.title);

  static GuestType? fromString(String? value) {
    if (value == null) return null;
    
    final upperValue = value.toUpperCase();
    for (var type in GuestType.values) {
      if (type.name == upperValue) {
        return type;
      }
    }
    return GuestType.BOTH;
  }
}