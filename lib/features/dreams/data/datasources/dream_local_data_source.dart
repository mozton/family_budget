import '../models/dream_model.dart';

abstract class DreamLocalDataSource {
  Future<List<DreamModel>> getDreams();
  Future<void> cacheDream(DreamModel dreamToCache);
  Future<void> updateDreamProgress(String id, double addedAmount);
}

class DreamLocalDataSourceImpl implements DreamLocalDataSource {
  final List<DreamModel> _mockDatabase = [];

  @override
  Future<List<DreamModel>> getDreams() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockDatabase;
  }

  @override
  Future<void> cacheDream(DreamModel dreamToCache) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _mockDatabase.add(dreamToCache);
  }

  @override
  Future<void> updateDreamProgress(String id, double addedAmount) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final index = _mockDatabase.indexWhere((d) => d.id == id);
    if (index != -1) {
      final currentDream = _mockDatabase[index];
      final newAmount = currentDream.currentAmount + addedAmount;
      
      _mockDatabase[index] = DreamModel(
        id: currentDream.id,
        title: currentDream.title,
        targetAmount: currentDream.targetAmount,
        currentAmount: newAmount,
        emoji: currentDream.emoji,
        gradientColors: currentDream.gradientColors,
      );
    }
  }
}
