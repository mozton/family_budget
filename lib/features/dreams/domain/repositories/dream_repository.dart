import '../entities/dream_entity.dart';

abstract class DreamRepository {
  Future<List<DreamEntity>> getDreams();
  Future<void> addDream(DreamEntity dream);
  Future<void> updateDreamProgress(String id, double addedAmount);
}
