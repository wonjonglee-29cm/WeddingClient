import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wedding/data/raw/component_raw.dart';
import 'package:wedding/data/repository/components_repository.dart';

class HomeViewModel extends StateNotifier<AsyncValue<List<ComponentRaw>>> {
  final ComponentsRepository _repository;

  HomeViewModel(this._repository) : super(const AsyncValue.loading()) {
    loadItems();
  }

  Future<void> loadItems() async {
    try {
      state = await AsyncValue.guard(() => _repository.getHomeItems());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}
