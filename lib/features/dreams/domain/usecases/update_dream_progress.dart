import '../repositories/dream_repository.dart';

class UpdateDreamProgress {
  final DreamRepository repository;

  UpdateDreamProgress(this.repository);

  Future<void> call(String id, double addedAmount) async {
    return await repository.updateDreamProgress(id, addedAmount);
  }
}
