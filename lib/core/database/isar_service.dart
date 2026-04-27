import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

// Aquí importarás tus Schemas de Isar una vez que los generes
// import '../../features/transactions/data/models/transaction_collection.dart';

class IsarService {
  // Patrón Singleton
  static final IsarService _instance = IsarService._internal();

  factory IsarService() {
    return _instance;
  }

  IsarService._internal();

  Isar? _isar;

  Future<Isar> get database async {
    if (_isar != null) return _isar!;
    _isar = await _initDB();
    return _isar!;
  }

  Future<Isar> _initDB() async {
    final dir = await getApplicationDocumentsDirectory();

    // Si Isar ya fue inicializado (ej. hot restart), lo recuperamos
    if (Isar.instanceNames.isNotEmpty) {
      return Isar.getInstance()!;
    }

    return await Isar.open([
      // Añade aquí los schemas de tus colecciones, por ejemplo:
      // TransactionCollectionSchema,
      // DreamCollectionSchema,
    ], directory: dir.path);
  }
}
