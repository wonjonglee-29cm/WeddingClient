import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wedding/data/raw/event_raw.dart';
import 'package:wedding/data/raw/home_raw.dart';

class EventRepository {
  final FirebaseFirestore _firestore;
  static const String COLLECTION_NAME = 'wedding';
  static const String DOC_NAME = 'event';

  EventRepository(this._firestore);

  Future<EventRaw> getEventItems() async {
    final items = await _firestore.collection(COLLECTION_NAME).doc(DOC_NAME).get();

    return convertFirebaseData(items.data() ?? {});
  }

  EventRaw convertFirebaseData(Map<String, dynamic> data) {
    List<EventItemRaw> items = [];

    final timestamp = data['endDate'] as Timestamp;

    if (data['greeting'] != null) {
      final greeting = data['greeting'] as Map<String, dynamic>;
      items.add(EventItemRaw(
        title: greeting['title'] as String,
        index: greeting['index'] as int,
        imageUrl: greeting['imageUrl'] as String,
        type: 'greeting'
      ));
    }
    if (data['picture'] != null) {
      final picture = data['picture'] as Map<String, dynamic>;
      items.add(EventItemRaw(
        title: picture['title'] as String,
        index: picture['index'] as int,
        imageUrl: picture['imageUrl'] as String,
          type: 'picture'
      ));
    }
    if (data['quiz'] != null) {
      final quiz = data['quiz'] as Map<String, dynamic>;
      items.add(EventItemRaw(
        title: quiz['title'] as String,
        index: quiz['index'] as int,
        imageUrl: quiz['imageUrl'] as String,
          type: 'quiz'
      ));
    }
    items.sort((a, b) => a.index.compareTo(b.index));
    final difference = timestamp.toDate().difference(DateTime.now());
    return EventRaw(timestamp, items, difference.isNegative);
  }
}
