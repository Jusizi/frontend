// ignore_for_file: file_names

import 'package:shared_preferences/shared_preferences.dart';

import 'IStorageServiceInterface.dart';

class SharedPreferenceStorageServiceImplementation
    implements IStorageServiceInterface {
  @override
  Future<void> delete(String item) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(item);
  }

  @override
  Future<String> read(String item) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(item) ?? '';
  }

  @override
  Future<void> save(String item, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(item, value);
  }

  @override
  Future<void> deleteAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
