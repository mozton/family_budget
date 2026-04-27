import '../../domain/entities/dream_entity.dart';
import '../../domain/repositories/dream_repository.dart';
import '../datasources/dream_local_data_source.dart';
import '../models/dream_model.dart';

class DreamRepositoryImpl implements DreamRepository {
  final DreamLocalDataSource localDataSource;

  DreamRepositoryImpl({required this.localDataSource});

  @override
  Future<List<DreamEntity>> getDreams() async {
    return await localDataSource.getDreams();
  }

  @override
  Future<void> addDream(DreamEntity dream) async {
    final dreamModel = DreamModel(
      id: dream.id,
      title: dream.title,
      targetAmount: dream.targetAmount,
      currentAmount: dream.currentAmount,
      emoji: dream.emoji,
      gradientColors: dream.gradientColors,
    );
    await localDataSource.cacheDream(dreamModel);
  }

  @override
  Future<void> updateDreamProgress(String id, double addedAmount) async {
    await localDataSource.updateDreamProgress(id, addedAmount);
  }
}
