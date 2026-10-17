import 'package:flutterfooddiscovery_streetbite/core/data_source.dart/data_source_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dartz/dartz.dart';

class LocalDataSource implements DataSourceInterface {
  late final SharedPreferences _sharedPreferences;

  LocalDataSource._() {
    await loadSharedPreferences();
  }

  Future<void> loadSharedPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }
  static LocalDataSource get instance => LocalDataSource._();

  @override
  Future<Either<List<Map<String, dynamic>>, String>> getList(String url, {Map<String, dynamic>? queryParams, Map<String, dynamic>? headers}) async {
    try {
      final response = await _sharedPreferences.getString(url);
      if (response != null) {
        List<Map<String, dynamic>> data = jsonDecode(response);
        return Left(data);
      } else {
        return Right('no data found');
      }
    } catch (e) {
      return Right('unknown error');
    }
  }

  @override
  Future<Either<Map<String, dynamic>, String>> getEntity(String url, String id, {String key = 'id', Map<String, dynamic>? queryParams, Map<String, dynamic>? headers}) async {
    try {
      final response = await _sharedPreferences.getString(url);
      if (response != null) {
        List<Map<String, dynamic>> data = jsonDecode(response);
        Map<String, dynamic> entity = data.firstWhere((element) => element[key] == id);
        return Left(entity);
      } else {
        return Right('no data found');
      }
    } catch (e) {
      return Right('unknown error');
    }
  }

  @override
  Future<Either<Map<String, dynamic>, String>> post(String url, dynamic data, {Map<String, dynamic>? queryParams, Map<String, dynamic>? headers}) async {
    try {
      Either<List<Map<String, dynamic>>, String> storedData = await getList(url);
      storedData.fold((l){
        final id = data[key] ?? l.length + 1;
        data[key] = id;
        l.add(data);
        await _sharedPreferences.setString(url, jsonEncode(l));
        return Left(l);
      }, (r){
        data[key] = 1;
        final list = [data];
        await _sharedPreferences.setString(url, jsonEncode(list));
        return Left(list);
      });
    } catch (e) {
      return Right('unknown error');
    }
  }

  @override
  Future<Either<Map<String, dynamic>, String>> put(String url, String id, dynamic data, {String key = 'id', Map<String, dynamic>? queryParams, Map<String, dynamic>? headers}) async {
    try {
      Either<List<Map<String, dynamic>>, String> storedData = await getList(url);
      storedData.fold((l){
        final entity = l.firstWhere((element) => element[key] == id);
        if (entity == null) {
          return Right('no data found');
        }
        l.remove(entity);
        entity.addAll(data);
        l.add(entity);
        await _sharedPreferences.setString(url, jsonEncode(l));
        return Left(entity);
      }, (r){
        return Right('no data found');
      });
    } catch (e) {
      return Right('unknown error');
    }
  }

  @override
  Future<Either<bool, String>> delete(String url, String id, {String key = 'id', Map<String, dynamic>? queryParams, Map<String, dynamic>? headers}) async {
    try {
      Either<List<Map<String, dynamic>>, String> storedData = await getList(url);
      storedData.fold((l){
        l.removeWhere((element) => element[key] == id);
        await _sharedPreferences.setString(url, jsonEncode(l));
        return Left(true);
      }, (r){
        return Left(false);
      });
    } catch (e) {
      return Right('unknown error');
    }
  }
}