import 'package:hive/hive.dart';
import 'package:loke_task_2/core/services/local_storage.dart';

class LocalStorageImpl extends LocalStorage {
  final Box box;

  LocalStorageImpl(this.box);

  @override
  Future<void> put(dynamic key, dynamic value) {
    return box.put(key, value);
  }

  @override
  dynamic get<T>(String key) {
    return box.get(key);
  }

  @override
  Future<void> delete(value) {
    return box.delete(value);
  }

  @override
  Future<int> clear() {
    return box.clear();
  }
}
