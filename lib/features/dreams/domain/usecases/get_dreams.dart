import '../entities/dream_entity.dart';
import '../repositories/dream_repository.dart';

class GetDreams {
  final DreamRepository repository;

  GetDreams(this.repository);

  Future<List<DreamEntity>> call() async {
    return await repository.getDreams();
  }
}
