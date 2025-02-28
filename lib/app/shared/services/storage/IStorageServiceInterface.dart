// ignore_for_file: file_names

abstract class IStorageServiceInterface {
  Future<void> delete(String item);
  Future<void> save(String item, String value);
  Future<String> read(String item);
  Future<void> deleteAll();
}
