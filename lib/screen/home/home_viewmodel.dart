import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wedding/data/raw/home_raw.dart';
import 'package:wedding/data/repository/home_repository.dart';

sealed class HomeTabState {
  const HomeTabState();
}

class Loading extends HomeTabState {
  const Loading();
}

class Success extends HomeTabState {
  final List<HomeRaw> items;

  Success({required this.items});
}

class HomeViewModel extends StateNotifier<HomeTabState> {
  final HomeRepository _repository;
  HomeViewModel(this._repository) : super(const Loading()) {
    loadItems();
  }

  Future<void> loadItems() async {
    state = const Loading();
    try {
      // Firebase나 다른 데이터 소스에서 데이터를 가져오는 로직
      final items = await _repository.getHomeItems();
      state = Success(items: items);
    } catch (e) {
      // 에러 처리
      debugPrint(e.toString());
    }
  }
}
