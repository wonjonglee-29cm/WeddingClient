import 'package:cloud_firestore/cloud_firestore.dart';

class EventRaw {
  final Timestamp endDate;
  final List<EventItemRaw> items;

  const EventRaw(this.endDate, this.items);

  String getTimeRemaining() {
    final now = DateTime.now();
    final difference = endDate.toDate().difference(now);

    final days = difference.inDays;
    final hours = difference.inHours - days * 24;
    final minutes = difference.inMinutes - days * 24 * 60 - hours * 60;
    final seconds = difference.inSeconds - days * 24 * 60 * 60 - hours * 60 * 60 - minutes * 60;

    return 'D-$days ${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

class EventItemRaw {
  final String imageUrl;
  final int index;
  final String title;
  final String type;

  const EventItemRaw({
    required this.imageUrl,
    required this.index,
    required this.title,
    required this.type,
  });
}
