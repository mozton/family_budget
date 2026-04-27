import '../entities/dream_entity.dart';
import '../repositories/dream_repository.dart';

class AddDream {
  final DreamRepository repository;

  AddDream(this.repository);

  Future<void> call(DreamEntity dream) async {
    return await repository.addDream(dream);
  }
}
