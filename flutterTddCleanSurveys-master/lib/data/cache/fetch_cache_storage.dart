abstract class CacheStorage {
  Future<dynamic> fetch(String key);
  Future<void> validate(String key);
}
