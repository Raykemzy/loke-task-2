abstract class LocalStorage {
  Future<void> put(dynamic key, dynamic value);
  dynamic get<T>(String key);
  Future<int> clear();
  Future<void> delete(dynamic value);
}