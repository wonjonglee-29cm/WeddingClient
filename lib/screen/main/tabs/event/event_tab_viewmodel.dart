import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wedding/data/raw/event_raw.dart';
import 'package:wedding/data/repository/event_repository.dart';

sealed class EventTabState {
  const EventTabState();
}

class Loading extends EventTabState {
  const Loading();
}

class Success extends EventTabState {
  final EventRaw event;

  Success({required this.event});
}

class EventTabViewModel extends StateNotifier<EventTabState> {
  final EventRepository _repository;
  late Timestamp _endDate;
  late Timer _timer;
  late List<EventItemRaw> _items;

  EventTabViewModel(this._repository) : super(const Loading()) {
    loadItems();
  }

  Future<void> loadItems() async {
    state = const Loading();
    try {
      final eventRaw = await _repository.getEventItems();
      _endDate = eventRaw.endDate;
      _items = eventRaw.items;
      state = Success(event: eventRaw);
      startTimer();
    } catch (e) {
      // 에러 처리
    }
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      updateTimeRemaining();
    });
  }

  void updateTimeRemaining() {
    final now = DateTime.now();
    final difference = _endDate.toDate().difference(now);

    if (difference.isNegative) {
      _timer.cancel();
      // 이벤트 종료 메시지 표시
    } else {
      final days = difference.inDays;
      final hours = (difference.inHours - days * 24).toInt();
      final minutes = (difference.inMinutes - days * 24 * 60 - hours * 60).toInt();
      final seconds = (difference.inSeconds - days * 24 * 60 * 60 - hours * 60 * 60 - minutes * 60).toInt();

      state = Success(event: EventRaw(
        _endDate,
        _items,
      ));
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
